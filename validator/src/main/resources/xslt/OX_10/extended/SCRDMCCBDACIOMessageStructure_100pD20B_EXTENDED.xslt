<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<xsl:stylesheet xmlns:svrl="http://purl.oclc.org/dsdl/svrl" xmlns:ccts="urn:un:unece:uncefact:documentation:standard:CoreComponentsTechnicalSpecification:2" xmlns:clm210AccountingE004="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:CertificateType:D11A" xmlns:clm210AccountingE006="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingDocumentType:D11A" xmlns:clm210AccountingE011="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AddressFormatType:D11A" xmlns:clm210AccountingE012="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingJournal:D11A" xmlns:clm210AccountingE013="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingJournalCategory:D11A" xmlns:clm210AccountingE015="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:FinancialInstitutionRole:D11A" xmlns:clm210AccountingE016="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:FinancialAccountType:D11A" xmlns:clm210AccountingE021="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingPerquisite:D11A" xmlns:clm210AccountingE023="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingContact:D11A" xmlns:clm210AccountingE101="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingVoucherMedium:D11A" xmlns:clm210AccountingE201="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingEntryProcessing:D11A" xmlns:clm210AccountingE202="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingEntryCategory:D11A" xmlns:clm210AccountingE203="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingEntryLineCategory:D11A" xmlns:clm210AccountingE204="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AmortizationMethod:D11A" xmlns:clm210AccountingE302="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingEntryLineSource:D11A" xmlns:clm210AccountingE304="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AlternateCurrencyAmount:D11A" xmlns:clm210AccountingE305="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingAccountStatus:D11A" xmlns:clm210AccountingE307="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:TaxExemptionReason:D11A" xmlns:clm210AccountingE501="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingAccountType:D11A" xmlns:clm210AccountingE502="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingAccountNatureType:D11A" xmlns:clm210AccountingE601="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingAmountType:D11A" xmlns:clm210AccountingE602="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingAccountBalanceReopeningType:D11A" xmlns:clm210AccountingE603="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingAmountQualifierType:D11A" xmlns:clm210AccountingE702="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AmountWeightType:D11A" xmlns:clm210AccountingE703="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingPeriodFunctionType:D11A" xmlns:clm210AccountingE704="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccessRightsType:D11A" xmlns:clm210AccountingE902="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingAccountClassification:D11A" xmlns:clm210AccountingE904="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AdditionalPostponement:D11A" xmlns:clm210LifetimeEndCostE206="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:LifetimeEndCost:D11A" xmlns:clm210OrganizationFunctionTypeE706="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:OrganizationFunctionType:D11A" xmlns:clm210PartyTypeE705="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:PartyType:D11A" xmlns:clm210RefundMethodE022="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:RefundMethod:D11A" xmlns:clm210ScenarioTypeE018="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:ScenarioType:D11A" xmlns:clm210SoftwareUserTypeE019="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:SoftwareUserType:D11A" xmlns:clm5ISO42173A="urn:un:unece:uncefact:codelist:standard:ISO:ISO3AlphaCurrencyCode:2012-08-31" xmlns:clm5ISO63912A="urn:un:unece:uncefact:codelist:standard:ISO:ISO2AlphaLanguageCode:2006-10-27" xmlns:clm60133="urn:un:unece:uncefact:codelist:standard:6:0133:40106" xmlns:clm61001="urn:un:unece:uncefact:codelist:standard:UNECE:DocumentNameCode:D20A" xmlns:clm61001Accounting="urn:un:unece:uncefact:codelist:standard:UNECE:DocumentNameCode_Accounting:D20A" xmlns:clm61001Billing="urn:un:unece:uncefact:codelist:standard:UNECE:DocumentNameCode_Billing:D20A" xmlns:clm61001DocumentTypeCodeQuotation="urn:un:unece:uncefact:codelist:standard:UNECE:DocumentNameCode_Quotation:D20A" xmlns:clm61001DocumentTypeCodeRemittance="urn:un:unece:uncefact:codelist:standard:UNECE:DocumentNameCode_Remittance:D20A" xmlns:clm61001DocumentTypeCodeScheduling="urn:un:unece:uncefact:codelist:standard:UNECE:DocumentNameCode_Scheduling:D20A" xmlns:clm61001Invoice="urn:un:unece:uncefact:codelist:standard:UNECE:DocumentNameCode_Invoice:D20A" xmlns:clm61153ReferenceTypeCode="urn:un:unece:uncefact:codelist:standard:UNECE:ReferenceTypeCode:D20A" xmlns:clm61225Acknowledgement="urn:un:unece:uncefact:codelist:standard:UNECE:MessageFunctionCode_Acknowledgement:D20A" xmlns:clm61225MessageFunctionTypeCode="urn:un:unece:uncefact:codelist:standard:UNECE:MessageFunctionCode:D20A" xmlns:clm61229LineStatusCode="urn:un:unece:uncefact:codelist:standard:UNECE:ActionCode:D20A" xmlns:clm61373="urn:un:unece:uncefact:codelist:standard:UNECE:DocumentStatusCode:D20A" xmlns:clm62005DateTimePeriodFunctionCode="urn:un:unece:uncefact:codelist:standard:UNECE:DateTimePeriodFunctionCode:D20A" xmlns:clm62379="urn:un:unece:uncefact:codelist:standard:UNECE:TimePointFormatCode:D19B" xmlns:clm62379timeonly="urn:un:unece:uncefact:codelist:standard:UNECE:TimeOnlyFormatCode:D19B" xmlns:clm62475="urn:un:unece:uncefact:codelist:standard:UNECE:EventTimeReferenceCode:D20A" xmlns:clm62475PaymentTermsEvent="urn:un:unece:uncefact:codelist:standard:UNECE:EventTimeReferenceCodePaymentTermsEvent:D20A" xmlns:clm63035="urn:un:unece:uncefact:codelist:standard:UNECE:PartyRoleCode:D20A" xmlns:clm63035ChargePaying="urn:un:unece:uncefact:codelist:standard:UNECE:PartyRoleCode_ChargePaying:D20A" xmlns:clm63055="urn:un:unece:uncefact:codelist:standard:UNECE:AgencyIdentificationCode:D20A" xmlns:clm63131="urn:un:unece:uncefact:codelist:standard:UNECE:AddressType:D20A" xmlns:clm63139ContactTypeCode="urn:un:unece:uncefact:codelist:standard:UNECE:ContactFunctionCode:D20A" xmlns:clm63155CommunicationChannelCode="urn:un:unece:uncefact:codelist:standard:UNECE:CommunicationMeansTypeCode:D20A" xmlns:clm63227="urn:un:unece:uncefact:codelist:standard:UNECE:LocationFunctionCode:D20A" xmlns:clm64017CommitmentLevelCode="urn:un:unece:uncefact:codelist:standard:UNECE:DeliveryPlanCommitmentLevelCode:D20A" xmlns:clm64037PriorityDescriptionCode="urn:un:unece:uncefact:codelist:standard:UNECE:PriorityDescriptionCode:D20A" xmlns:clm64053="urn:un:unece:uncefact:codelist:standard:UNECE:DeliveryTermsCode:2010" xmlns:clm64055DeliveryTermsFunctionCode="urn:un:unece:uncefact:codelist:standard:UNECE:DeliveryTermsFunctionCode:D20A" xmlns:clm64065TransportServiceConditionCode="urn:un:unece:uncefact:codelist:standard:UNECE:TransportServiceConditionCode:D20A" xmlns:clm64219TransportServicePriorityCode="urn:un:unece:uncefact:codelist:standard:UNECE:TransportServicePriorityCode:D20A" xmlns:clm64233="urn:un:unece:uncefact:codelist:standard:UNECE:MarkingInstructionCode:D20A" xmlns:clm64237TransportPaymentArrangementCode="urn:un:unece:uncefact:codelist:standard:UNECE:TransportPaymentArrangementCode:D20A" xmlns:clm64279="urn:un:unece:uncefact:codelist:standard:UNECE:PaymentTermsTypeCode:D20A" xmlns:clm64343ResponseTypeCode="urn:un:unece:uncefact:codelist:standard:UNECE:ResponseTypeCode:D20A" xmlns:clm64377="urn:un:unece:uncefact:codelist:standard:UNECE:ObligationGuaranteeCode:D19B" xmlns:clm64405="urn:un:unece:uncefact:codelist:standard:UNECE:StatusCode:D20A" xmlns:clm64405AccountingDebitCredit="urn:un:unece:uncefact:codelist:standard:UNECE:StatusDescriptionCode_AccountingDebitCredit:D20A" xmlns:clm64405StatusCodeWorkflow="urn:un:unece:uncefact:codelist:standard:UNECE:StatusDescriptionCode_Workflow:D20A" xmlns:clm64431="urn:un:unece:uncefact:codelist:standard:UNECE:PaymentGuaranteeMeansCode:D20A" xmlns:clm64435="urn:un:unece:uncefact:codelist:standard:UNECE:PaymentMeansChannelCode:D20A" xmlns:clm64439="urn:un:unece:uncefact:codelist:standard:UNECE:PaymentMethodCode:D20A" xmlns:clm64461="urn:un:unece:uncefact:codelist:standard:UNECE:PaymentMeansCode:D20A" xmlns:clm64465="urn:un:unece:uncefact:codelist:standard:UNECE:AdjustmentReasonDescriptionCode:D20A" xmlns:clm64465AdjustmentReasonCodeFinancial="urn:un:unece:uncefact:codelist:standard:UNECE:AdjustmentReasonDescriptionCode_Financial:D20A" xmlns:clm64465AllowanceChargeReasonCode="urn:un:unece:uncefact:codelist:standard:UNECE:AllowanceChargeReasonCode:D20A" xmlns:clm64517="urn:un:unece:uncefact:codelist:standard:UNECE:SealConditionCode:D20A" xmlns:clm65153="urn:un:unece:uncefact:codelist:standard:UNECE:DutyTaxFeeTypeCode:D20A" xmlns:clm65189AllowanceChargeID="urn:un:unece:uncefact:codelist:standard:UNECE:AllowanceChargeIdentificationCode:D20A" xmlns:clm65237TransportServiceCategoryCode="urn:un:unece:uncefact:codelist:standard:UNECE:TransportServiceCategoryCode:D20A" xmlns:clm65243="urn:un:unece:uncefact:codelist:standard:UNECE:FreightChargeTariffCode:D20A" xmlns:clm65305="urn:un:unece:uncefact:codelist:standard:UNECE:DutyorTaxorFeeCategoryCode:D20A" xmlns:clm65375="urn:un:unece:uncefact:codelist:standard:UNECE:PriceTypeCode:D20A" xmlns:clm66131="urn:un:unece:uncefact:codelist:standard:UNECE:FreightChargeQuantityUnitBasisCode:D19B" xmlns:clm66145="urn:un:unece:uncefact:codelist:standard:UNECE:DimensionTypeCode:D20A" xmlns:clm66245="urn:un:unece:uncefact:codelist:standard:UNECE:TemperatureTypeCode:D20A" xmlns:clm66313="urn:un:unece:uncefact:codelist:standard:UNECE:MeasuredAttributeCode:D20A" xmlns:clm67065="urn:un:unece:uncefact:codelist:standard:UNECE:PackageTypeCode:2006" xmlns:clm67075="urn:un:unece:uncefact:codelist:standard:UNECE:PackagingLevelCode:D20A" xmlns:clm67085="urn:un:unece:uncefact:codelist:standard:UNECE:CargoTypeClassificationCode:D20A" xmlns:clm67085b="urn:un:unece:uncefact:codelist:standard:UNECE:CargoOperationalCategoryCode:D20A" xmlns:clm67187="urn:un:unece:uncefact:codelist:standard:UNECE:ProcessTypeCode:D20A" xmlns:clm67233AutomaticDataCaptureMethodCode="urn:un:unece:uncefact:codelist:standard:UNECE:AutomaticDataCaptureMethodCode:D20A" xmlns:clm67233PackagingMarkingCode="urn:un:unece:uncefact:codelist:standard:UNECE:PackagingMarkingCode:D20A" xmlns:clm67273TransportServiceRequirementCode="urn:un:unece:uncefact:codelist:standard:UNECE:TransportServiceRequirementCode:D20A" xmlns:clm67357="urn:un:unece:uncefact:codelist:standard:UNECE:CommodityIdentificationCode:D19B" xmlns:clm68051="urn:un:unece:uncefact:codelist:standard:UNECE:TransportMovementStageCode:D20A" xmlns:clm68053="urn:un:unece:uncefact:codelist:standard:UNECE:TransportEquipmentCategoryCode:D20A" xmlns:clm68077="urn:un:unece:uncefact:codelist:standard:UNECE:EquipmentSupplierCode:D20A" xmlns:clm68101="urn:un:unece:uncefact:codelist:standard:UNECE:TransportMeansDirectionCode:D20A" xmlns:clm68155="urn:un:unece:uncefact:codelist:standard:UNECE:EquipmentSizeTypeDescriptionCode:D20A" xmlns:clm68169="urn:un:unece:uncefact:codelist:standard:UNECE:TransportEquipmentFullnessCode:D20A" xmlns:clm68249a="urn:un:unece:uncefact:codelist:standard:UNECE:TransportEquipmentMovementStatusCode:D20A" xmlns:clm68249b="urn:un:unece:uncefact:codelist:standard:UNECE:TransportEquipmentOperationalStatusCode:D20A" xmlns:clm68249c="urn:un:unece:uncefact:codelist:standard:UNECE:TransportEquipmentMovementLegalStatusCode:D20A" xmlns:clm68273="urn:un:unece:uncefact:codelist:standard:UNECE:DangerousGoodsRegulationCode:D20A" xmlns:clm68323TransportMovementTypeCode="urn:un:unece:uncefact:codelist:standard:UNECE:TransportMovementTypeCode:D20A" xmlns:clm68339="urn:un:unece:uncefact:codelist:standard:UNECE:DangerousGoodsPackingCode:D20A" xmlns:clm68341="urn:un:unece:uncefact:codelist:standard:UNECE:TransportEquipmentHaulageArrangementsCode:D20A" xmlns:clm69213="urn:un:unece:uncefact:codelist:standard:UNECE:CustomsDutyRegimeTypeCode:D20A" xmlns:clm69303="urn:un:unece:uncefact:codelist:standard:UNECE:SealingPartyRoleCode:D20A" xmlns:clm69411ResponsibleAgencyInvolvementCode="urn:un:unece:uncefact:codelist:standard:UNECE:ResponsibleAgencyInvolvementCode:D20A" xmlns:clm69415ResponsibleAgencyCode="urn:un:unece:uncefact:codelist:standard:UNECE:ResponsibleAgencyCode:D20A" xmlns:clm69417="urn:un:unece:uncefact:codelist:standard:UNECE:GovernmentActionCode:D20A" xmlns:clm69651="urn:un:unece:uncefact:codelist:standard:UNECE:ContractTypeCode:D10B" xmlns:clm69653="urn:un:unece:uncefact:codelist:standard:UNECE:CostManagementCode:D10B" xmlns:clm69655="urn:un:unece:uncefact:codelist:standard:UNECE:CostReportingCode:D10B" xmlns:clm69657="urn:un:unece:uncefact:codelist:standard:UNECE:EarnedValueCalculationMethod:D10B" xmlns:clm69659="urn:un:unece:uncefact:codelist:standard:UNECE:FundingTypeCode:D10B" xmlns:clm69661="urn:un:unece:uncefact:codelist:standard:UNECE:HierarchicalStructureTypeCode:D10B" xmlns:clm69665="urn:un:unece:uncefact:codelist:standard:UNECE:ProjectTypeCode:D10B" xmlns:clm69667="urn:un:unece:uncefact:codelist:standard:UNECE:ReportingThresholdTriggerType:D10B" xmlns:clm69669="urn:un:unece:uncefact:codelist:standard:UNECE:ResourceCostCategory:D10B" xmlns:clm69671="urn:un:unece:uncefact:codelist:standard:UNECE:ResourcePlanMeasureType:D10B" xmlns:clm69673="urn:un:unece:uncefact:codelist:standard:UNECE:ScheduleTaskRelationshipType:D10B" xmlns:clm69675="urn:un:unece:uncefact:codelist:standard:UNECE:ScheduleTaskType:D10B" xmlns:clm69677="urn:un:unece:uncefact:codelist:standard:UNECE:SecurityClassificationType:D10B" xmlns:clm6ContractorType="urn:un:unece:uncefact:codelist:standard:UNECE:ContractorType:D10B" xmlns:clm6PlanningLevel="urn:un:unece:uncefact:codelist:standard:UNECE:PlanningLevel:D10B" xmlns:clm6Recommendation19="urn:un:unece:uncefact:codelist:standard:UNECE:TransportModeCode:2" xmlns:clm6Recommendation20Airflow="urn:un:unece:uncefact:codelist:standard:UNECE:MeasurementUnitCommonCode_Airflow:4" xmlns:clm6Recommendation20Duration="urn:un:unece:uncefact:codelist:standard:UNECE:MeasurementUnitCommonCodeDuration:4" xmlns:clm6Recommendation20FileSize="urn:un:unece:uncefact:codelist:standard:UNECE:MeasurementUnitCommonCode_FileSize:4" xmlns:clm6Recommendation20Linear="urn:un:unece:uncefact:codelist:standard:UNECE:MeasurementUnitCommonCodeLinear:4" xmlns:clm6Recommendation20Temperature="urn:un:unece:uncefact:codelist:standard:UNECE:MeasurementUnitCommonCodeTemperature:4" xmlns:clm6Recommendation20Volume="urn:un:unece:uncefact:codelist:standard:UNECE:MeasurementUnitCommonCodeVolume:4" xmlns:clm6Recommendation20Weight="urn:un:unece:uncefact:codelist:standard:UNECE:MeasurementUnitCommonCodeWeight:4" xmlns:clm6Recommendation21AnnexI="urn:un:unece:uncefact:codelist:standard:UNECE:CargoTypeCode:1996Rev2Final" xmlns:clm6Recommendation24="urn:un:unece:uncefact:codelist:standard:UNECE:TransportStatusCode:4" xmlns:clm6Recommendation28="urn:un:unece:uncefact:codelist:standard:UNECE:TransportMeansTypeCode:2007" xmlns:clm6ScheduleTypeCode="urn:un:unece:uncefact:codelist:standard:UNECE:ScheduleTypeCode:D10B" xmlns:clm6SealTypeCode="urn:un:unece:uncefact:codelist:standard:UNECE:SealTypeCode:D14A" xmlns:clm6TDED7357="urn:un:unece:uncefact:codelist:standard:UNECE:GoodsTypeCode:D19B" xmlns:clm6TDED7361="urn:un:unece:uncefact:codelist:standard:UNECE:GoodsTypeExtensionCode:D19B" xmlns:clmIANACharacterSetCode="urn:un:unece:uncefact:codelist:standard:IANA:CharacterSetCode:2013-01-23" xmlns:ids5ISO316612A="urn:un:unece:uncefact:identifierlist:standard:ISO:ISOTwo-letterCountryCode:SecondEdition2006" xmlns:ids5ISO6391A2="urn:un:unece:uncefact:identifierlist:standard:ISO:ISOAlpha2LanguageCode:2006-10-27" xmlns:ids64277="urn:un:unece:uncefact:identifierlist:standard:UNECE:PaymentTermsDescriptionIdentifier:D20A" xmlns:ids6Recommendation23="urn:un:unece:uncefact:identifierlist:standard:UNECE:FreightCostCode:4" xmlns:iso="http://purl.oclc.org/dsdl/schematron" xmlns:qdt="urn:un:unece:uncefact:data:standard:QualifiedDataType:128" xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:128" xmlns:rsm="urn:un:unece:uncefact:data:SCRDMCCBDACIOMessageStructure:100" xmlns:schold="http://www.ascc.net/xml/schematron" xmlns:udt="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:128" xmlns:xhtml="http://www.w3.org/1999/xhtml" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">
<!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->

<xsl:param name="archiveDirParameter" />
  <xsl:param name="archiveNameParameter" />
  <xsl:param name="fileNameParameter" />
  <xsl:param name="fileDirParameter" />
  <xsl:variable name="document-uri">
    <xsl:value-of select="document-uri(/)" />
  </xsl:variable>

<!--PHASES-->


<!--PROLOG-->
<xsl:output indent="yes" method="xml" omit-xml-declaration="no" standalone="yes" />

<!--XSD TYPES FOR XSLT2-->


<!--KEYS AND FUNCTIONS-->


<!--DEFAULT RULES-->


<!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-select-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="." />
  </xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-->
<!--This mode can be used to generate an ugly though full XPath for locators-->
<xsl:template match="*" mode="schematron-get-full-path">
    <xsl:apply-templates mode="schematron-get-full-path" select="parent::*" />
    <xsl:text>/</xsl:text>
    <xsl:choose>
      <xsl:when test="namespace-uri()=''">
        <xsl:value-of select="name()" />
        <xsl:variable name="p_1" select="1+    count(preceding-sibling::*[name()=name(current())])" />
        <xsl:if test="$p_1>1 or following-sibling::*[name()=name(current())]">[<xsl:value-of select="$p_1" />]</xsl:if>
      </xsl:when>
      <xsl:otherwise>
        <xsl:text>*[local-name()='</xsl:text>
        <xsl:value-of select="local-name()" />
        <xsl:text>']</xsl:text>
        <xsl:variable name="p_2" select="1+   count(preceding-sibling::*[local-name()=local-name(current())])" />
        <xsl:if test="$p_2>1 or following-sibling::*[local-name()=local-name(current())]">[<xsl:value-of select="$p_2" />]</xsl:if>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  <xsl:template match="@*" mode="schematron-get-full-path">
    <xsl:text>/</xsl:text>
    <xsl:choose>
      <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()" />
</xsl:when>
      <xsl:otherwise>
        <xsl:text>@*[local-name()='</xsl:text>
        <xsl:value-of select="local-name()" />
        <xsl:text>' and namespace-uri()='</xsl:text>
        <xsl:value-of select="namespace-uri()" />
        <xsl:text>']</xsl:text>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

<!--MODE: SCHEMATRON-FULL-PATH-2-->
<!--This mode can be used to generate prefixed XPath for humans-->
<xsl:template match="node() | @*" mode="schematron-get-full-path-2">
    <xsl:for-each select="ancestor-or-self::*">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="name(.)" />
      <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />
        <xsl:text>]</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="not(self::*)">
      <xsl:text />/@<xsl:value-of select="name(.)" />
    </xsl:if>
  </xsl:template>
<!--MODE: SCHEMATRON-FULL-PATH-3-->
<!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->

<xsl:template match="node() | @*" mode="schematron-get-full-path-3">
    <xsl:for-each select="ancestor-or-self::*">
      <xsl:text>/</xsl:text>
      <xsl:value-of select="name(.)" />
      <xsl:if test="parent::*">
        <xsl:text>[</xsl:text>
        <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1" />
        <xsl:text>]</xsl:text>
      </xsl:if>
    </xsl:for-each>
    <xsl:if test="not(self::*)">
      <xsl:text />/@<xsl:value-of select="name(.)" />
    </xsl:if>
  </xsl:template>

<!--MODE: GENERATE-ID-FROM-PATH -->
<xsl:template match="/" mode="generate-id-from-path" />
  <xsl:template match="text()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')" />
  </xsl:template>
  <xsl:template match="comment()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')" />
  </xsl:template>
  <xsl:template match="processing-instruction()" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')" />
  </xsl:template>
  <xsl:template match="@*" mode="generate-id-from-path">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:value-of select="concat('.@', name())" />
  </xsl:template>
  <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
    <xsl:apply-templates mode="generate-id-from-path" select="parent::*" />
    <xsl:text>.</xsl:text>
    <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')" />
  </xsl:template>

<!--MODE: GENERATE-ID-2 -->
<xsl:template match="/" mode="generate-id-2">U</xsl:template>
  <xsl:template match="*" mode="generate-id-2" priority="2">
    <xsl:text>U</xsl:text>
    <xsl:number count="*" level="multiple" />
  </xsl:template>
  <xsl:template match="node()" mode="generate-id-2">
    <xsl:text>U.</xsl:text>
    <xsl:number count="*" level="multiple" />
    <xsl:text>n</xsl:text>
    <xsl:number count="node()" />
  </xsl:template>
  <xsl:template match="@*" mode="generate-id-2">
    <xsl:text>U.</xsl:text>
    <xsl:number count="*" level="multiple" />
    <xsl:text>_</xsl:text>
    <xsl:value-of select="string-length(local-name(.))" />
    <xsl:text>_</xsl:text>
    <xsl:value-of select="translate(name(),':','.')" />
  </xsl:template>
<!--Strip characters-->  <xsl:template match="text()" priority="-1" />

<!--SCHEMA SETUP-->
<xsl:template match="/">
    <svrl:schematron-output schemaVersion="iso" title="Schema for SCRDMCCBDACIOMessageStructure_100pD20B; D20B; Extended">
      <xsl:comment>
        <xsl:value-of select="$archiveDirParameter" />   
		 <xsl:value-of select="$archiveNameParameter" />  
		 <xsl:value-of select="$fileNameParameter" />  
		 <xsl:value-of select="$fileDirParameter" />
      </xsl:comment>
      <svrl:ns-prefix-in-attribute-values prefix="clm60133" uri="urn:un:unece:uncefact:codelist:standard:6:0133:40106" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE704" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccessRightsType:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE602" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingAccountBalanceReopeningType:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE902" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingAccountClassification:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE502" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingAccountNatureType:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE305" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingAccountStatus:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE501" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingAccountType:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE603" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingAmountQualifierType:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE601" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingAmountType:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE023" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingContact:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE006" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingDocumentType:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE202" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingEntryCategory:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE203" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingEntryLineCategory:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE302" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingEntryLineSource:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE201" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingEntryProcessing:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE012" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingJournal:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE013" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingJournalCategory:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE703" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingPeriodFunctionType:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE021" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingPerquisite:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE101" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingVoucherMedium:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE904" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AdditionalPostponement:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE011" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AddressFormatType:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE304" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AlternateCurrencyAmount:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE204" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AmortizationMethod:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE702" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AmountWeightType:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE004" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:CertificateType:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE016" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:FinancialAccountType:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE015" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:FinancialInstitutionRole:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210LifetimeEndCostE206" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:LifetimeEndCost:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210OrganizationFunctionTypeE706" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:OrganizationFunctionType:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210PartyTypeE705" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:PartyType:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210RefundMethodE022" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:RefundMethod:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210ScenarioTypeE018" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:ScenarioType:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210SoftwareUserTypeE019" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:SoftwareUserType:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm210AccountingE307" uri="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:TaxExemptionReason:D11A" />
      <svrl:ns-prefix-in-attribute-values prefix="clmIANACharacterSetCode" uri="urn:un:unece:uncefact:codelist:standard:IANA:CharacterSetCode:2013-01-23" />
      <svrl:ns-prefix-in-attribute-values prefix="clm5ISO63912A" uri="urn:un:unece:uncefact:codelist:standard:ISO:ISO2AlphaLanguageCode:2006-10-27" />
      <svrl:ns-prefix-in-attribute-values prefix="clm5ISO42173A" uri="urn:un:unece:uncefact:codelist:standard:ISO:ISO3AlphaCurrencyCode:2012-08-31" />
      <svrl:ns-prefix-in-attribute-values prefix="clm61229LineStatusCode" uri="urn:un:unece:uncefact:codelist:standard:UNECE:ActionCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm63131" uri="urn:un:unece:uncefact:codelist:standard:UNECE:AddressType:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm64465" uri="urn:un:unece:uncefact:codelist:standard:UNECE:AdjustmentReasonDescriptionCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm64465AdjustmentReasonCodeFinancial" uri="urn:un:unece:uncefact:codelist:standard:UNECE:AdjustmentReasonDescriptionCode_Financial:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm63055" uri="urn:un:unece:uncefact:codelist:standard:UNECE:AgencyIdentificationCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm65189AllowanceChargeID" uri="urn:un:unece:uncefact:codelist:standard:UNECE:AllowanceChargeIdentificationCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm64465AllowanceChargeReasonCode" uri="urn:un:unece:uncefact:codelist:standard:UNECE:AllowanceChargeReasonCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm67233AutomaticDataCaptureMethodCode" uri="urn:un:unece:uncefact:codelist:standard:UNECE:AutomaticDataCaptureMethodCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm67085b" uri="urn:un:unece:uncefact:codelist:standard:UNECE:CargoOperationalCategoryCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm67085" uri="urn:un:unece:uncefact:codelist:standard:UNECE:CargoTypeClassificationCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm6Recommendation21AnnexI" uri="urn:un:unece:uncefact:codelist:standard:UNECE:CargoTypeCode:1996Rev2Final" />
      <svrl:ns-prefix-in-attribute-values prefix="clm67357" uri="urn:un:unece:uncefact:codelist:standard:UNECE:CommodityIdentificationCode:D19B" />
      <svrl:ns-prefix-in-attribute-values prefix="clm63155CommunicationChannelCode" uri="urn:un:unece:uncefact:codelist:standard:UNECE:CommunicationMeansTypeCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm63139ContactTypeCode" uri="urn:un:unece:uncefact:codelist:standard:UNECE:ContactFunctionCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm69651" uri="urn:un:unece:uncefact:codelist:standard:UNECE:ContractTypeCode:D10B" />
      <svrl:ns-prefix-in-attribute-values prefix="clm6ContractorType" uri="urn:un:unece:uncefact:codelist:standard:UNECE:ContractorType:D10B" />
      <svrl:ns-prefix-in-attribute-values prefix="clm69653" uri="urn:un:unece:uncefact:codelist:standard:UNECE:CostManagementCode:D10B" />
      <svrl:ns-prefix-in-attribute-values prefix="clm69655" uri="urn:un:unece:uncefact:codelist:standard:UNECE:CostReportingCode:D10B" />
      <svrl:ns-prefix-in-attribute-values prefix="clm69213" uri="urn:un:unece:uncefact:codelist:standard:UNECE:CustomsDutyRegimeTypeCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm68339" uri="urn:un:unece:uncefact:codelist:standard:UNECE:DangerousGoodsPackingCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm68273" uri="urn:un:unece:uncefact:codelist:standard:UNECE:DangerousGoodsRegulationCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm62005DateTimePeriodFunctionCode" uri="urn:un:unece:uncefact:codelist:standard:UNECE:DateTimePeriodFunctionCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm64017CommitmentLevelCode" uri="urn:un:unece:uncefact:codelist:standard:UNECE:DeliveryPlanCommitmentLevelCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm64053" uri="urn:un:unece:uncefact:codelist:standard:UNECE:DeliveryTermsCode:2010" />
      <svrl:ns-prefix-in-attribute-values prefix="clm64055DeliveryTermsFunctionCode" uri="urn:un:unece:uncefact:codelist:standard:UNECE:DeliveryTermsFunctionCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm66145" uri="urn:un:unece:uncefact:codelist:standard:UNECE:DimensionTypeCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm61001" uri="urn:un:unece:uncefact:codelist:standard:UNECE:DocumentNameCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm61001Accounting" uri="urn:un:unece:uncefact:codelist:standard:UNECE:DocumentNameCode_Accounting:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm61001Billing" uri="urn:un:unece:uncefact:codelist:standard:UNECE:DocumentNameCode_Billing:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm61001Invoice" uri="urn:un:unece:uncefact:codelist:standard:UNECE:DocumentNameCode_Invoice:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm61001DocumentTypeCodeQuotation" uri="urn:un:unece:uncefact:codelist:standard:UNECE:DocumentNameCode_Quotation:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm61001DocumentTypeCodeRemittance" uri="urn:un:unece:uncefact:codelist:standard:UNECE:DocumentNameCode_Remittance:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm61001DocumentTypeCodeScheduling" uri="urn:un:unece:uncefact:codelist:standard:UNECE:DocumentNameCode_Scheduling:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm61373" uri="urn:un:unece:uncefact:codelist:standard:UNECE:DocumentStatusCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm65153" uri="urn:un:unece:uncefact:codelist:standard:UNECE:DutyTaxFeeTypeCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm65305" uri="urn:un:unece:uncefact:codelist:standard:UNECE:DutyorTaxorFeeCategoryCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm69657" uri="urn:un:unece:uncefact:codelist:standard:UNECE:EarnedValueCalculationMethod:D10B" />
      <svrl:ns-prefix-in-attribute-values prefix="clm68155" uri="urn:un:unece:uncefact:codelist:standard:UNECE:EquipmentSizeTypeDescriptionCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm68077" uri="urn:un:unece:uncefact:codelist:standard:UNECE:EquipmentSupplierCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm62475" uri="urn:un:unece:uncefact:codelist:standard:UNECE:EventTimeReferenceCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm62475PaymentTermsEvent" uri="urn:un:unece:uncefact:codelist:standard:UNECE:EventTimeReferenceCodePaymentTermsEvent:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm66131" uri="urn:un:unece:uncefact:codelist:standard:UNECE:FreightChargeQuantityUnitBasisCode:D19B" />
      <svrl:ns-prefix-in-attribute-values prefix="clm65243" uri="urn:un:unece:uncefact:codelist:standard:UNECE:FreightChargeTariffCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm69659" uri="urn:un:unece:uncefact:codelist:standard:UNECE:FundingTypeCode:D10B" />
      <svrl:ns-prefix-in-attribute-values prefix="clm6TDED7357" uri="urn:un:unece:uncefact:codelist:standard:UNECE:GoodsTypeCode:D19B" />
      <svrl:ns-prefix-in-attribute-values prefix="clm6TDED7361" uri="urn:un:unece:uncefact:codelist:standard:UNECE:GoodsTypeExtensionCode:D19B" />
      <svrl:ns-prefix-in-attribute-values prefix="clm69417" uri="urn:un:unece:uncefact:codelist:standard:UNECE:GovernmentActionCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm69661" uri="urn:un:unece:uncefact:codelist:standard:UNECE:HierarchicalStructureTypeCode:D10B" />
      <svrl:ns-prefix-in-attribute-values prefix="clm63227" uri="urn:un:unece:uncefact:codelist:standard:UNECE:LocationFunctionCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm64233" uri="urn:un:unece:uncefact:codelist:standard:UNECE:MarkingInstructionCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm66313" uri="urn:un:unece:uncefact:codelist:standard:UNECE:MeasuredAttributeCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm6Recommendation20Duration" uri="urn:un:unece:uncefact:codelist:standard:UNECE:MeasurementUnitCommonCodeDuration:4" />
      <svrl:ns-prefix-in-attribute-values prefix="clm6Recommendation20Linear" uri="urn:un:unece:uncefact:codelist:standard:UNECE:MeasurementUnitCommonCodeLinear:4" />
      <svrl:ns-prefix-in-attribute-values prefix="clm6Recommendation20Temperature" uri="urn:un:unece:uncefact:codelist:standard:UNECE:MeasurementUnitCommonCodeTemperature:4" />
      <svrl:ns-prefix-in-attribute-values prefix="clm6Recommendation20Volume" uri="urn:un:unece:uncefact:codelist:standard:UNECE:MeasurementUnitCommonCodeVolume:4" />
      <svrl:ns-prefix-in-attribute-values prefix="clm6Recommendation20Weight" uri="urn:un:unece:uncefact:codelist:standard:UNECE:MeasurementUnitCommonCodeWeight:4" />
      <svrl:ns-prefix-in-attribute-values prefix="clm6Recommendation20Airflow" uri="urn:un:unece:uncefact:codelist:standard:UNECE:MeasurementUnitCommonCode_Airflow:4" />
      <svrl:ns-prefix-in-attribute-values prefix="clm6Recommendation20FileSize" uri="urn:un:unece:uncefact:codelist:standard:UNECE:MeasurementUnitCommonCode_FileSize:4" />
      <svrl:ns-prefix-in-attribute-values prefix="clm61225MessageFunctionTypeCode" uri="urn:un:unece:uncefact:codelist:standard:UNECE:MessageFunctionCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm61225Acknowledgement" uri="urn:un:unece:uncefact:codelist:standard:UNECE:MessageFunctionCode_Acknowledgement:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm64377" uri="urn:un:unece:uncefact:codelist:standard:UNECE:ObligationGuaranteeCode:D19B" />
      <svrl:ns-prefix-in-attribute-values prefix="clm67065" uri="urn:un:unece:uncefact:codelist:standard:UNECE:PackageTypeCode:2006" />
      <svrl:ns-prefix-in-attribute-values prefix="clm67075" uri="urn:un:unece:uncefact:codelist:standard:UNECE:PackagingLevelCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm67233PackagingMarkingCode" uri="urn:un:unece:uncefact:codelist:standard:UNECE:PackagingMarkingCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm63035" uri="urn:un:unece:uncefact:codelist:standard:UNECE:PartyRoleCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm63035ChargePaying" uri="urn:un:unece:uncefact:codelist:standard:UNECE:PartyRoleCode_ChargePaying:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm64431" uri="urn:un:unece:uncefact:codelist:standard:UNECE:PaymentGuaranteeMeansCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm64435" uri="urn:un:unece:uncefact:codelist:standard:UNECE:PaymentMeansChannelCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm64461" uri="urn:un:unece:uncefact:codelist:standard:UNECE:PaymentMeansCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm64439" uri="urn:un:unece:uncefact:codelist:standard:UNECE:PaymentMethodCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm64279" uri="urn:un:unece:uncefact:codelist:standard:UNECE:PaymentTermsTypeCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm6PlanningLevel" uri="urn:un:unece:uncefact:codelist:standard:UNECE:PlanningLevel:D10B" />
      <svrl:ns-prefix-in-attribute-values prefix="clm65375" uri="urn:un:unece:uncefact:codelist:standard:UNECE:PriceTypeCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm64037PriorityDescriptionCode" uri="urn:un:unece:uncefact:codelist:standard:UNECE:PriorityDescriptionCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm67187" uri="urn:un:unece:uncefact:codelist:standard:UNECE:ProcessTypeCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm69665" uri="urn:un:unece:uncefact:codelist:standard:UNECE:ProjectTypeCode:D10B" />
      <svrl:ns-prefix-in-attribute-values prefix="clm61153ReferenceTypeCode" uri="urn:un:unece:uncefact:codelist:standard:UNECE:ReferenceTypeCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm69667" uri="urn:un:unece:uncefact:codelist:standard:UNECE:ReportingThresholdTriggerType:D10B" />
      <svrl:ns-prefix-in-attribute-values prefix="clm69669" uri="urn:un:unece:uncefact:codelist:standard:UNECE:ResourceCostCategory:D10B" />
      <svrl:ns-prefix-in-attribute-values prefix="clm69671" uri="urn:un:unece:uncefact:codelist:standard:UNECE:ResourcePlanMeasureType:D10B" />
      <svrl:ns-prefix-in-attribute-values prefix="clm64343ResponseTypeCode" uri="urn:un:unece:uncefact:codelist:standard:UNECE:ResponseTypeCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm69415ResponsibleAgencyCode" uri="urn:un:unece:uncefact:codelist:standard:UNECE:ResponsibleAgencyCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm69411ResponsibleAgencyInvolvementCode" uri="urn:un:unece:uncefact:codelist:standard:UNECE:ResponsibleAgencyInvolvementCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm69673" uri="urn:un:unece:uncefact:codelist:standard:UNECE:ScheduleTaskRelationshipType:D10B" />
      <svrl:ns-prefix-in-attribute-values prefix="clm69675" uri="urn:un:unece:uncefact:codelist:standard:UNECE:ScheduleTaskType:D10B" />
      <svrl:ns-prefix-in-attribute-values prefix="clm6ScheduleTypeCode" uri="urn:un:unece:uncefact:codelist:standard:UNECE:ScheduleTypeCode:D10B" />
      <svrl:ns-prefix-in-attribute-values prefix="clm64517" uri="urn:un:unece:uncefact:codelist:standard:UNECE:SealConditionCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm6SealTypeCode" uri="urn:un:unece:uncefact:codelist:standard:UNECE:SealTypeCode:D14A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm69303" uri="urn:un:unece:uncefact:codelist:standard:UNECE:SealingPartyRoleCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm69677" uri="urn:un:unece:uncefact:codelist:standard:UNECE:SecurityClassificationType:D10B" />
      <svrl:ns-prefix-in-attribute-values prefix="clm64405" uri="urn:un:unece:uncefact:codelist:standard:UNECE:StatusCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm64405AccountingDebitCredit" uri="urn:un:unece:uncefact:codelist:standard:UNECE:StatusDescriptionCode_AccountingDebitCredit:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm64405StatusCodeWorkflow" uri="urn:un:unece:uncefact:codelist:standard:UNECE:StatusDescriptionCode_Workflow:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm66245" uri="urn:un:unece:uncefact:codelist:standard:UNECE:TemperatureTypeCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm62379timeonly" uri="urn:un:unece:uncefact:codelist:standard:UNECE:TimeOnlyFormatCode:D19B" />
      <svrl:ns-prefix-in-attribute-values prefix="clm62379" uri="urn:un:unece:uncefact:codelist:standard:UNECE:TimePointFormatCode:D19B" />
      <svrl:ns-prefix-in-attribute-values prefix="clm68053" uri="urn:un:unece:uncefact:codelist:standard:UNECE:TransportEquipmentCategoryCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm68169" uri="urn:un:unece:uncefact:codelist:standard:UNECE:TransportEquipmentFullnessCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm68341" uri="urn:un:unece:uncefact:codelist:standard:UNECE:TransportEquipmentHaulageArrangementsCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm68249c" uri="urn:un:unece:uncefact:codelist:standard:UNECE:TransportEquipmentMovementLegalStatusCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm68249a" uri="urn:un:unece:uncefact:codelist:standard:UNECE:TransportEquipmentMovementStatusCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm68249b" uri="urn:un:unece:uncefact:codelist:standard:UNECE:TransportEquipmentOperationalStatusCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm68101" uri="urn:un:unece:uncefact:codelist:standard:UNECE:TransportMeansDirectionCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm6Recommendation28" uri="urn:un:unece:uncefact:codelist:standard:UNECE:TransportMeansTypeCode:2007" />
      <svrl:ns-prefix-in-attribute-values prefix="clm6Recommendation19" uri="urn:un:unece:uncefact:codelist:standard:UNECE:TransportModeCode:2" />
      <svrl:ns-prefix-in-attribute-values prefix="clm68051" uri="urn:un:unece:uncefact:codelist:standard:UNECE:TransportMovementStageCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm68323TransportMovementTypeCode" uri="urn:un:unece:uncefact:codelist:standard:UNECE:TransportMovementTypeCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm64237TransportPaymentArrangementCode" uri="urn:un:unece:uncefact:codelist:standard:UNECE:TransportPaymentArrangementCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm65237TransportServiceCategoryCode" uri="urn:un:unece:uncefact:codelist:standard:UNECE:TransportServiceCategoryCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm64065TransportServiceConditionCode" uri="urn:un:unece:uncefact:codelist:standard:UNECE:TransportServiceConditionCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm64219TransportServicePriorityCode" uri="urn:un:unece:uncefact:codelist:standard:UNECE:TransportServicePriorityCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm67273TransportServiceRequirementCode" uri="urn:un:unece:uncefact:codelist:standard:UNECE:TransportServiceRequirementCode:D20A" />
      <svrl:ns-prefix-in-attribute-values prefix="clm6Recommendation24" uri="urn:un:unece:uncefact:codelist:standard:UNECE:TransportStatusCode:4" />
      <svrl:ns-prefix-in-attribute-values prefix="rsm" uri="urn:un:unece:uncefact:data:SCRDMCCBDACIOMessageStructure:100" />
      <svrl:ns-prefix-in-attribute-values prefix="qdt" uri="urn:un:unece:uncefact:data:standard:QualifiedDataType:128" />
      <svrl:ns-prefix-in-attribute-values prefix="ram" uri="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:128" />
      <svrl:ns-prefix-in-attribute-values prefix="udt" uri="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:128" />
      <svrl:ns-prefix-in-attribute-values prefix="ccts" uri="urn:un:unece:uncefact:documentation:standard:CoreComponentsTechnicalSpecification:2" />
      <svrl:ns-prefix-in-attribute-values prefix="ids5ISO6391A2" uri="urn:un:unece:uncefact:identifierlist:standard:ISO:ISOAlpha2LanguageCode:2006-10-27" />
      <svrl:ns-prefix-in-attribute-values prefix="ids5ISO316612A" uri="urn:un:unece:uncefact:identifierlist:standard:ISO:ISOTwo-letterCountryCode:SecondEdition2006" />
      <svrl:ns-prefix-in-attribute-values prefix="ids6Recommendation23" uri="urn:un:unece:uncefact:identifierlist:standard:UNECE:FreightCostCode:4" />
      <svrl:ns-prefix-in-attribute-values prefix="ids64277" uri="urn:un:unece:uncefact:identifierlist:standard:UNECE:PaymentTermsDescriptionIdentifier:D20A" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M161" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M162" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M163" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M164" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M165" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M166" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M167" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M168" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M169" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M170" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M171" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M172" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M173" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M174" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M175" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M176" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M177" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M178" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M179" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M180" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M181" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M182" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M183" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M184" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M185" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M186" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M187" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M188" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M189" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M190" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M191" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M192" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M193" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M194" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M195" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M196" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M197" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M198" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M199" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M200" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M201" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M202" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M203" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M204" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M205" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M206" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M207" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M208" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M209" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M210" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M211" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M212" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M213" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M214" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M215" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M216" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M217" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M218" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M219" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M220" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M221" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M222" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M223" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M224" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M225" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M226" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M227" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M228" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M229" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M230" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M231" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M232" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M233" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M234" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M235" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M236" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M237" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M238" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M239" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M240" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M241" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M242" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M243" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M244" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M245" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M246" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M247" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M248" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M249" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M250" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M251" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M252" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M253" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M254" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M255" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M256" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M257" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M258" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M259" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M260" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M261" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M262" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M263" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M264" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M265" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M266" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M267" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M268" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M269" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M270" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M271" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M272" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M273" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M274" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M275" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M276" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M277" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M278" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M279" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M280" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M281" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M282" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M283" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M284" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M285" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M286" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M287" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M288" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M289" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M290" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M291" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M292" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M293" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M294" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M295" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M296" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M297" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M298" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M299" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M300" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M301" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M302" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M303" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M304" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M305" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M306" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M307" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M308" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M309" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M310" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M311" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M312" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M313" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M314" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M315" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M316" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M317" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M318" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M319" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M320" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M321" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M322" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M323" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M324" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M325" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M326" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M327" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M328" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M329" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M330" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M331" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M332" select="/" />
      <svrl:active-pattern>
        <xsl:attribute name="document">
          <xsl:value-of select="document-uri(/)" />
        </xsl:attribute>
        <xsl:apply-templates />
      </svrl:active-pattern>
      <xsl:apply-templates mode="M333" select="/" />
    </svrl:schematron-output>
  </xsl:template>

<!--SCHEMATRON PATTERNS-->
<svrl:text>Schema for SCRDMCCBDACIOMessageStructure_100pD20B; D20B; Extended</svrl:text>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:ExchangedDocument/ram:EffectiveSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString" mode="M161" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:ExchangedDocument/ram:EffectiveSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M161" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M161" priority="-1" />
  <xsl:template match="@*|node()" mode="M161" priority="-2">
    <xsl:apply-templates mode="M161" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:ExchangedDocument/ram:EffectiveSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString" mode="M162" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:ExchangedDocument/ram:EffectiveSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M162" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M162" priority="-1" />
  <xsl:template match="@*|node()" mode="M162" priority="-2">
    <xsl:apply-templates mode="M162" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString" mode="M163" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M163" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M163" priority="-1" />
  <xsl:template match="@*|node()" mode="M163" priority="-2">
    <xsl:apply-templates mode="M163" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter" mode="M164" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M164" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M164" priority="-1" />
  <xsl:template match="@*|node()" mode="M164" priority="-2">
    <xsl:apply-templates mode="M164" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter" mode="M165" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M165" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M165" priority="-1" />
  <xsl:template match="@*|node()" mode="M165" priority="-2">
    <xsl:apply-templates mode="M165" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement" mode="M166" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CatalogueReferencedDocument)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CatalogueReferencedDocument)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CatalogueReferencedDocument' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M166" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M166" priority="-1" />
  <xsl:template match="@*|node()" mode="M166" priority="-2">
    <xsl:apply-templates mode="M166" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument" mode="M167" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Name)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Name)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Name' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M167" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M167" priority="-1" />
  <xsl:template match="@*|node()" mode="M167" priority="-2">
    <xsl:apply-templates mode="M167" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument/ram:AttachmentBinaryObject" mode="M168" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument/ram:AttachmentBinaryObject" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@mimeCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@mimeCode">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@mimeCode' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@filename" />
      <xsl:otherwise>
        <svrl:failed-assert test="@filename">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@filename' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M168" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M168" priority="-1" />
  <xsl:template match="@*|node()" mode="M168" priority="-2">
    <xsl:apply-templates mode="M168" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" mode="M169" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M169" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M169" priority="-1" />
  <xsl:template match="@*|node()" mode="M169" priority="-2">
    <xsl:apply-templates mode="M169" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BlanketOrderReferencedDocument" mode="M170" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BlanketOrderReferencedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:IssuerAssignedID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:IssuerAssignedID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M170" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M170" priority="-1" />
  <xsl:template match="@*|node()" mode="M170" priority="-2">
    <xsl:apply-templates mode="M170" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BlanketOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" mode="M171" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BlanketOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M171" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M171" priority="-1" />
  <xsl:template match="@*|node()" mode="M171" priority="-2">
    <xsl:apply-templates mode="M171" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" mode="M172" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M172" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M172" priority="-1" />
  <xsl:template match="@*|node()" mode="M172" priority="-2">
    <xsl:apply-templates mode="M172" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" mode="M173" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M173" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M173" priority="-1" />
  <xsl:template match="@*|node()" mode="M173" priority="-2">
    <xsl:apply-templates mode="M173" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" mode="M174" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M174" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M174" priority="-1" />
  <xsl:template match="@*|node()" mode="M174" priority="-2">
    <xsl:apply-templates mode="M174" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:GlobalID" mode="M175" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:GlobalID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M175" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M175" priority="-1" />
  <xsl:template match="@*|node()" mode="M175" priority="-2">
    <xsl:apply-templates mode="M175" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:SpecifiedTaxRegistration/ram:ID" mode="M176" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:SpecifiedTaxRegistration/ram:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M176" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M176" priority="-1" />
  <xsl:template match="@*|node()" mode="M176" priority="-2">
    <xsl:apply-templates mode="M176" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:URIUniversalCommunication" mode="M177" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:URIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M177" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M177" priority="-1" />
  <xsl:template match="@*|node()" mode="M177" priority="-2">
    <xsl:apply-templates mode="M177" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument" mode="M178" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:IssuerAssignedID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:IssuerAssignedID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M178" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M178" priority="-1" />
  <xsl:template match="@*|node()" mode="M178" priority="-2">
    <xsl:apply-templates mode="M178" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" mode="M179" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M179" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M179" priority="-1" />
  <xsl:template match="@*|node()" mode="M179" priority="-2">
    <xsl:apply-templates mode="M179" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerRequisitionerTradeParty" mode="M180" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerRequisitionerTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:DefinedTradeContact)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:DefinedTradeContact)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:DefinedTradeContact' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M180" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M180" priority="-1" />
  <xsl:template match="@*|node()" mode="M180" priority="-2">
    <xsl:apply-templates mode="M180" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" mode="M181" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M181" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M181" priority="-1" />
  <xsl:template match="@*|node()" mode="M181" priority="-2">
    <xsl:apply-templates mode="M181" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" mode="M182" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M182" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M182" priority="-1" />
  <xsl:template match="@*|node()" mode="M182" priority="-2">
    <xsl:apply-templates mode="M182" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" mode="M183" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M183" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M183" priority="-1" />
  <xsl:template match="@*|node()" mode="M183" priority="-2">
    <xsl:apply-templates mode="M183" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:GlobalID" mode="M184" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:GlobalID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M184" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M184" priority="-1" />
  <xsl:template match="@*|node()" mode="M184" priority="-2">
    <xsl:apply-templates mode="M184" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:SpecifiedTaxRegistration/ram:ID" mode="M185" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:SpecifiedTaxRegistration/ram:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M185" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M185" priority="-1" />
  <xsl:template match="@*|node()" mode="M185" priority="-2">
    <xsl:apply-templates mode="M185" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:URIUniversalCommunication" mode="M186" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:URIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M186" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M186" priority="-1" />
  <xsl:template match="@*|node()" mode="M186" priority="-2">
    <xsl:apply-templates mode="M186" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty" mode="M187" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Name' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:PostalTradeAddress)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:PostalTradeAddress)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:PostalTradeAddress' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M187" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M187" priority="-1" />
  <xsl:template match="@*|node()" mode="M187" priority="-2">
    <xsl:apply-templates mode="M187" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" mode="M188" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M188" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M188" priority="-1" />
  <xsl:template match="@*|node()" mode="M188" priority="-2">
    <xsl:apply-templates mode="M188" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" mode="M189" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M189" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M189" priority="-1" />
  <xsl:template match="@*|node()" mode="M189" priority="-2">
    <xsl:apply-templates mode="M189" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" mode="M190" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M190" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M190" priority="-1" />
  <xsl:template match="@*|node()" mode="M190" priority="-2">
    <xsl:apply-templates mode="M190" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID" mode="M191" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M191" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M191" priority="-1" />
  <xsl:template match="@*|node()" mode="M191" priority="-2">
    <xsl:apply-templates mode="M191" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID" mode="M192" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M192" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M192" priority="-1" />
  <xsl:template match="@*|node()" mode="M192" priority="-2">
    <xsl:apply-templates mode="M192" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication" mode="M193" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M193" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M193" priority="-1" />
  <xsl:template match="@*|node()" mode="M193" priority="-2">
    <xsl:apply-templates mode="M193" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:CatalogueReferencedDocument" mode="M194" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:CatalogueReferencedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:IssuerAssignedID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:IssuerAssignedID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M194" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M194" priority="-1" />
  <xsl:template match="@*|node()" mode="M194" priority="-2">
    <xsl:apply-templates mode="M194" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:CatalogueReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" mode="M195" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:CatalogueReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M195" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M195" priority="-1" />
  <xsl:template match="@*|node()" mode="M195" priority="-2">
    <xsl:apply-templates mode="M195" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument" mode="M196" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:IssuerAssignedID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:IssuerAssignedID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M196" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M196" priority="-1" />
  <xsl:template match="@*|node()" mode="M196" priority="-2">
    <xsl:apply-templates mode="M196" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" mode="M197" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M197" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M197" priority="-1" />
  <xsl:template match="@*|node()" mode="M197" priority="-2">
    <xsl:apply-templates mode="M197" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:PreviousOrderChangeReferencedDocument" mode="M198" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:PreviousOrderChangeReferencedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:IssuerAssignedID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:IssuerAssignedID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M198" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M198" priority="-1" />
  <xsl:template match="@*|node()" mode="M198" priority="-2">
    <xsl:apply-templates mode="M198" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:PreviousOrderChangeReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" mode="M199" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:PreviousOrderChangeReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M199" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M199" priority="-1" />
  <xsl:template match="@*|node()" mode="M199" priority="-2">
    <xsl:apply-templates mode="M199" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:PreviousOrderReferencedDocument" mode="M200" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:PreviousOrderReferencedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:IssuerAssignedID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:IssuerAssignedID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M200" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M200" priority="-1" />
  <xsl:template match="@*|node()" mode="M200" priority="-2">
    <xsl:apply-templates mode="M200" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:PreviousOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" mode="M201" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:PreviousOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M201" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M201" priority="-1" />
  <xsl:template match="@*|node()" mode="M201" priority="-2">
    <xsl:apply-templates mode="M201" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:PreviousOrderResponseReferencedDocument" mode="M202" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:PreviousOrderResponseReferencedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:IssuerAssignedID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:IssuerAssignedID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M202" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M202" priority="-1" />
  <xsl:template match="@*|node()" mode="M202" priority="-2">
    <xsl:apply-templates mode="M202" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:PreviousOrderResponseReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" mode="M203" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:PreviousOrderResponseReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M203" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M203" priority="-1" />
  <xsl:template match="@*|node()" mode="M203" priority="-2">
    <xsl:apply-templates mode="M203" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" mode="M204" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M204" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M204" priority="-1" />
  <xsl:template match="@*|node()" mode="M204" priority="-2">
    <xsl:apply-templates mode="M204" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" mode="M205" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M205" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M205" priority="-1" />
  <xsl:template match="@*|node()" mode="M205" priority="-2">
    <xsl:apply-templates mode="M205" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" mode="M206" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M206" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M206" priority="-1" />
  <xsl:template match="@*|node()" mode="M206" priority="-2">
    <xsl:apply-templates mode="M206" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:GlobalID" mode="M207" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:GlobalID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M207" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M207" priority="-1" />
  <xsl:template match="@*|node()" mode="M207" priority="-2">
    <xsl:apply-templates mode="M207" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:SpecifiedTaxRegistration/ram:ID" mode="M208" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:SpecifiedTaxRegistration/ram:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M208" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M208" priority="-1" />
  <xsl:template match="@*|node()" mode="M208" priority="-2">
    <xsl:apply-templates mode="M208" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:URIUniversalCommunication" mode="M209" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:URIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M209" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M209" priority="-1" />
  <xsl:template match="@*|node()" mode="M209" priority="-2">
    <xsl:apply-templates mode="M209" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument" mode="M210" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:IssuerAssignedID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:IssuerAssignedID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M210" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M210" priority="-1" />
  <xsl:template match="@*|node()" mode="M210" priority="-2">
    <xsl:apply-templates mode="M210" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" mode="M211" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M211" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M211" priority="-1" />
  <xsl:template match="@*|node()" mode="M211" priority="-2">
    <xsl:apply-templates mode="M211" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:RequisitionReferencedDocument" mode="M212" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:RequisitionReferencedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:IssuerAssignedID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:IssuerAssignedID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M212" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M212" priority="-1" />
  <xsl:template match="@*|node()" mode="M212" priority="-2">
    <xsl:apply-templates mode="M212" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:RequisitionReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" mode="M213" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:RequisitionReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M213" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M213" priority="-1" />
  <xsl:template match="@*|node()" mode="M213" priority="-2">
    <xsl:apply-templates mode="M213" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument" mode="M214" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:IssuerAssignedID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:IssuerAssignedID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M214" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M214" priority="-1" />
  <xsl:template match="@*|node()" mode="M214" priority="-2">
    <xsl:apply-templates mode="M214" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" mode="M215" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M215" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M215" priority="-1" />
  <xsl:template match="@*|node()" mode="M215" priority="-2">
    <xsl:apply-templates mode="M215" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty" mode="M216" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Name' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M216" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M216" priority="-1" />
  <xsl:template match="@*|node()" mode="M216" priority="-2">
    <xsl:apply-templates mode="M216" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" mode="M217" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M217" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M217" priority="-1" />
  <xsl:template match="@*|node()" mode="M217" priority="-2">
    <xsl:apply-templates mode="M217" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" mode="M218" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M218" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M218" priority="-1" />
  <xsl:template match="@*|node()" mode="M218" priority="-2">
    <xsl:apply-templates mode="M218" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" mode="M219" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M219" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M219" priority="-1" />
  <xsl:template match="@*|node()" mode="M219" priority="-2">
    <xsl:apply-templates mode="M219" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID" mode="M220" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M220" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M220" priority="-1" />
  <xsl:template match="@*|node()" mode="M220" priority="-2">
    <xsl:apply-templates mode="M220" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID" mode="M221" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M221" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M221" priority="-1" />
  <xsl:template match="@*|node()" mode="M221" priority="-2">
    <xsl:apply-templates mode="M221" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication" mode="M222" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M222" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M222" priority="-1" />
  <xsl:template match="@*|node()" mode="M222" priority="-2">
    <xsl:apply-templates mode="M222" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument" mode="M223" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:IssuerAssignedID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:IssuerAssignedID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M223" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M223" priority="-1" />
  <xsl:template match="@*|node()" mode="M223" priority="-2">
    <xsl:apply-templates mode="M223" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" mode="M224" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M224" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M224" priority="-1" />
  <xsl:template match="@*|node()" mode="M224" priority="-2">
    <xsl:apply-templates mode="M224" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery" mode="M225" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:PlannedDespatchSupplyChainEvent)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:PlannedDespatchSupplyChainEvent)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:PlannedDespatchSupplyChainEvent' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:PlannedDeliverySupplyChainEvent)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:PlannedDeliverySupplyChainEvent)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:PlannedDeliverySupplyChainEvent' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M225" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M225" priority="-1" />
  <xsl:template match="@*|node()" mode="M225" priority="-2">
    <xsl:apply-templates mode="M225" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:RequestedDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString" mode="M226" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:RequestedDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M226" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M226" priority="-1" />
  <xsl:template match="@*|node()" mode="M226" priority="-2">
    <xsl:apply-templates mode="M226" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:RequestedDeliverySupplyChainEvent/ram:OccurrenceSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString" mode="M227" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:RequestedDeliverySupplyChainEvent/ram:OccurrenceSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M227" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M227" priority="-1" />
  <xsl:template match="@*|node()" mode="M227" priority="-2">
    <xsl:apply-templates mode="M227" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:RequestedDeliverySupplyChainEvent/ram:OccurrenceSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString" mode="M228" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:RequestedDeliverySupplyChainEvent/ram:OccurrenceSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M228" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M228" priority="-1" />
  <xsl:template match="@*|node()" mode="M228" priority="-2">
    <xsl:apply-templates mode="M228" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:RequestedDespatchSupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString" mode="M229" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:RequestedDespatchSupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M229" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M229" priority="-1" />
  <xsl:template match="@*|node()" mode="M229" priority="-2">
    <xsl:apply-templates mode="M229" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:RequestedDespatchSupplyChainEvent/ram:OccurrenceSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString" mode="M230" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:RequestedDespatchSupplyChainEvent/ram:OccurrenceSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M230" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M230" priority="-1" />
  <xsl:template match="@*|node()" mode="M230" priority="-2">
    <xsl:apply-templates mode="M230" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:RequestedDespatchSupplyChainEvent/ram:OccurrenceSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString" mode="M231" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:RequestedDespatchSupplyChainEvent/ram:OccurrenceSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M231" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M231" priority="-1" />
  <xsl:template match="@*|node()" mode="M231" priority="-2">
    <xsl:apply-templates mode="M231" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty" mode="M232" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Name' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M232" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M232" priority="-1" />
  <xsl:template match="@*|node()" mode="M232" priority="-2">
    <xsl:apply-templates mode="M232" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" mode="M233" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M233" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M233" priority="-1" />
  <xsl:template match="@*|node()" mode="M233" priority="-2">
    <xsl:apply-templates mode="M233" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" mode="M234" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M234" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M234" priority="-1" />
  <xsl:template match="@*|node()" mode="M234" priority="-2">
    <xsl:apply-templates mode="M234" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" mode="M235" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M235" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M235" priority="-1" />
  <xsl:template match="@*|node()" mode="M235" priority="-2">
    <xsl:apply-templates mode="M235" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:GlobalID" mode="M236" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:GlobalID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M236" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M236" priority="-1" />
  <xsl:template match="@*|node()" mode="M236" priority="-2">
    <xsl:apply-templates mode="M236" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:SpecifiedTaxRegistration/ram:ID" mode="M237" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:SpecifiedTaxRegistration/ram:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M237" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M237" priority="-1" />
  <xsl:template match="@*|node()" mode="M237" priority="-2">
    <xsl:apply-templates mode="M237" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:URIUniversalCommunication" mode="M238" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:URIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M238" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M238" priority="-1" />
  <xsl:template match="@*|node()" mode="M238" priority="-2">
    <xsl:apply-templates mode="M238" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty" mode="M239" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Name' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:PostalTradeAddress)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:PostalTradeAddress)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:PostalTradeAddress' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M239" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M239" priority="-1" />
  <xsl:template match="@*|node()" mode="M239" priority="-2">
    <xsl:apply-templates mode="M239" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" mode="M240" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M240" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M240" priority="-1" />
  <xsl:template match="@*|node()" mode="M240" priority="-2">
    <xsl:apply-templates mode="M240" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" mode="M241" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M241" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M241" priority="-1" />
  <xsl:template match="@*|node()" mode="M241" priority="-2">
    <xsl:apply-templates mode="M241" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" mode="M242" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M242" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M242" priority="-1" />
  <xsl:template match="@*|node()" mode="M242" priority="-2">
    <xsl:apply-templates mode="M242" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:GlobalID" mode="M243" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:GlobalID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M243" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M243" priority="-1" />
  <xsl:template match="@*|node()" mode="M243" priority="-2">
    <xsl:apply-templates mode="M243" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedTaxRegistration/ram:ID" mode="M244" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedTaxRegistration/ram:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M244" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M244" priority="-1" />
  <xsl:template match="@*|node()" mode="M244" priority="-2">
    <xsl:apply-templates mode="M244" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication" mode="M245" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M245" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M245" priority="-1" />
  <xsl:template match="@*|node()" mode="M245" priority="-2">
    <xsl:apply-templates mode="M245" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty" mode="M246" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Name' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M246" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M246" priority="-1" />
  <xsl:template match="@*|node()" mode="M246" priority="-2">
    <xsl:apply-templates mode="M246" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" mode="M247" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M247" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M247" priority="-1" />
  <xsl:template match="@*|node()" mode="M247" priority="-2">
    <xsl:apply-templates mode="M247" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" mode="M248" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M248" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M248" priority="-1" />
  <xsl:template match="@*|node()" mode="M248" priority="-2">
    <xsl:apply-templates mode="M248" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" mode="M249" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M249" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M249" priority="-1" />
  <xsl:template match="@*|node()" mode="M249" priority="-2">
    <xsl:apply-templates mode="M249" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:GlobalID" mode="M250" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:GlobalID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M250" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M250" priority="-1" />
  <xsl:template match="@*|node()" mode="M250" priority="-2">
    <xsl:apply-templates mode="M250" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedTaxRegistration/ram:ID" mode="M251" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedTaxRegistration/ram:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M251" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M251" priority="-1" />
  <xsl:template match="@*|node()" mode="M251" priority="-2">
    <xsl:apply-templates mode="M251" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:URIUniversalCommunication" mode="M252" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:URIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M252" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M252" priority="-1" />
  <xsl:template match="@*|node()" mode="M252" priority="-2">
    <xsl:apply-templates mode="M252" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement" mode="M253" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:PurchaseSpecifiedTradeAccountingAccount)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:PurchaseSpecifiedTradeAccountingAccount)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:PurchaseSpecifiedTradeAccountingAccount' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M253" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M253" priority="-1" />
  <xsl:template match="@*|node()" mode="M253" priority="-2">
    <xsl:apply-templates mode="M253" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax" mode="M254" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CalculatedAmount)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CalculatedAmount)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CalculatedAmount' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:BasisAmount)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:BasisAmount)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:BasisAmount' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M254" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M254" priority="-1" />
  <xsl:template match="@*|node()" mode="M254" priority="-2">
    <xsl:apply-templates mode="M254" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty" mode="M255" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Name' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M255" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M255" priority="-1" />
  <xsl:template match="@*|node()" mode="M255" priority="-2">
    <xsl:apply-templates mode="M255" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" mode="M256" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M256" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M256" priority="-1" />
  <xsl:template match="@*|node()" mode="M256" priority="-2">
    <xsl:apply-templates mode="M256" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" mode="M257" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M257" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M257" priority="-1" />
  <xsl:template match="@*|node()" mode="M257" priority="-2">
    <xsl:apply-templates mode="M257" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" mode="M258" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M258" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M258" priority="-1" />
  <xsl:template match="@*|node()" mode="M258" priority="-2">
    <xsl:apply-templates mode="M258" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:GlobalID" mode="M259" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:GlobalID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M259" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M259" priority="-1" />
  <xsl:template match="@*|node()" mode="M259" priority="-2">
    <xsl:apply-templates mode="M259" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:SpecifiedTaxRegistration/ram:ID" mode="M260" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:SpecifiedTaxRegistration/ram:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M260" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M260" priority="-1" />
  <xsl:template match="@*|node()" mode="M260" priority="-2">
    <xsl:apply-templates mode="M260" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:URIUniversalCommunication" mode="M261" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:URIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M261" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M261" priority="-1" />
  <xsl:template match="@*|node()" mode="M261" priority="-2">
    <xsl:apply-templates mode="M261" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty" mode="M262" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Name' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M262" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M262" priority="-1" />
  <xsl:template match="@*|node()" mode="M262" priority="-2">
    <xsl:apply-templates mode="M262" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" mode="M263" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M263" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M263" priority="-1" />
  <xsl:template match="@*|node()" mode="M263" priority="-2">
    <xsl:apply-templates mode="M263" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" mode="M264" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M264" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M264" priority="-1" />
  <xsl:template match="@*|node()" mode="M264" priority="-2">
    <xsl:apply-templates mode="M264" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" mode="M265" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M265" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M265" priority="-1" />
  <xsl:template match="@*|node()" mode="M265" priority="-2">
    <xsl:apply-templates mode="M265" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:GlobalID" mode="M266" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:GlobalID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M266" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M266" priority="-1" />
  <xsl:template match="@*|node()" mode="M266" priority="-2">
    <xsl:apply-templates mode="M266" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:SpecifiedTaxRegistration/ram:ID" mode="M267" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:SpecifiedTaxRegistration/ram:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M267" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M267" priority="-1" />
  <xsl:template match="@*|node()" mode="M267" priority="-2">
    <xsl:apply-templates mode="M267" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:URIUniversalCommunication" mode="M268" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:URIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M268" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M268" priority="-1" />
  <xsl:template match="@*|node()" mode="M268" priority="-2">
    <xsl:apply-templates mode="M268" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms" mode="M269" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Description)>=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Description)>=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Description' must occur at least 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M269" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M269" priority="-1" />
  <xsl:template match="@*|node()" mode="M269" priority="-2">
    <xsl:apply-templates mode="M269" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount" mode="M270" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@currencyID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@currencyID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@currencyID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M270" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M270" priority="-1" />
  <xsl:template match="@*|node()" mode="M270" priority="-2">
    <xsl:apply-templates mode="M270" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement" mode="M271" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:BuyerReference)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:BuyerReference)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:BuyerReference' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:RequisitionReferencedDocument)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:RequisitionReferencedDocument)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:RequisitionReferencedDocument' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:GrossPriceProductTradePrice)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:GrossPriceProductTradePrice)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:GrossPriceProductTradePrice' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M271" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M271" priority="-1" />
  <xsl:template match="@*|node()" mode="M271" priority="-2">
    <xsl:apply-templates mode="M271" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument" mode="M272" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Name)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Name)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Name' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M272" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M272" priority="-1" />
  <xsl:template match="@*|node()" mode="M272" priority="-2">
    <xsl:apply-templates mode="M272" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument/ram:AttachmentBinaryObject" mode="M273" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument/ram:AttachmentBinaryObject" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@mimeCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@mimeCode">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@mimeCode' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@filename" />
      <xsl:otherwise>
        <svrl:failed-assert test="@filename">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@filename' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M273" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M273" priority="-1" />
  <xsl:template match="@*|node()" mode="M273" priority="-2">
    <xsl:apply-templates mode="M273" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" mode="M274" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M274" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M274" priority="-1" />
  <xsl:template match="@*|node()" mode="M274" priority="-2">
    <xsl:apply-templates mode="M274" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BlanketOrderReferencedDocument" mode="M275" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BlanketOrderReferencedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:LineID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:LineID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:LineID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M275" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M275" priority="-1" />
  <xsl:template match="@*|node()" mode="M275" priority="-2">
    <xsl:apply-templates mode="M275" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument" mode="M276" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:LineID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:LineID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:LineID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M276" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M276" priority="-1" />
  <xsl:template match="@*|node()" mode="M276" priority="-2">
    <xsl:apply-templates mode="M276" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerRequisitionerTradeParty" mode="M277" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerRequisitionerTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:DefinedTradeContact)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:DefinedTradeContact)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:DefinedTradeContact' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M277" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M277" priority="-1" />
  <xsl:template match="@*|node()" mode="M277" priority="-2">
    <xsl:apply-templates mode="M277" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" mode="M278" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M278" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M278" priority="-1" />
  <xsl:template match="@*|node()" mode="M278" priority="-2">
    <xsl:apply-templates mode="M278" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" mode="M279" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M279" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M279" priority="-1" />
  <xsl:template match="@*|node()" mode="M279" priority="-2">
    <xsl:apply-templates mode="M279" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" mode="M280" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M280" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M280" priority="-1" />
  <xsl:template match="@*|node()" mode="M280" priority="-2">
    <xsl:apply-templates mode="M280" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:GlobalID" mode="M281" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:GlobalID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M281" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M281" priority="-1" />
  <xsl:template match="@*|node()" mode="M281" priority="-2">
    <xsl:apply-templates mode="M281" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:CatalogueReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" mode="M282" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:CatalogueReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M282" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M282" priority="-1" />
  <xsl:template match="@*|node()" mode="M282" priority="-2">
    <xsl:apply-templates mode="M282" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ContractReferencedDocument" mode="M283" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ContractReferencedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:IssuerAssignedID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:IssuerAssignedID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M283" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M283" priority="-1" />
  <xsl:template match="@*|node()" mode="M283" priority="-2">
    <xsl:apply-templates mode="M283" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ContractReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" mode="M284" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ContractReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M284" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M284" priority="-1" />
  <xsl:template match="@*|node()" mode="M284" priority="-2">
    <xsl:apply-templates mode="M284" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:BasisQuantity" mode="M285" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:BasisQuantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@unitCode' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M285" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M285" priority="-1" />
  <xsl:template match="@*|node()" mode="M285" priority="-2">
    <xsl:apply-templates mode="M285" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:QuotationReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" mode="M286" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:QuotationReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M286" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M286" priority="-1" />
  <xsl:template match="@*|node()" mode="M286" priority="-2">
    <xsl:apply-templates mode="M286" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" mode="M287" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M287" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M287" priority="-1" />
  <xsl:template match="@*|node()" mode="M287" priority="-2">
    <xsl:apply-templates mode="M287" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:AgreedQuantity" mode="M288" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:AgreedQuantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@unitCode' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M288" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M288" priority="-1" />
  <xsl:template match="@*|node()" mode="M288" priority="-2">
    <xsl:apply-templates mode="M288" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString" mode="M289" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M289" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M289" priority="-1" />
  <xsl:template match="@*|node()" mode="M289" priority="-2">
    <xsl:apply-templates mode="M289" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedDeliverySupplyChainEvent/ram:OccurrenceSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString" mode="M290" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedDeliverySupplyChainEvent/ram:OccurrenceSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M290" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M290" priority="-1" />
  <xsl:template match="@*|node()" mode="M290" priority="-2">
    <xsl:apply-templates mode="M290" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedDeliverySupplyChainEvent/ram:OccurrenceSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString" mode="M291" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedDeliverySupplyChainEvent/ram:OccurrenceSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M291" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M291" priority="-1" />
  <xsl:template match="@*|node()" mode="M291" priority="-2">
    <xsl:apply-templates mode="M291" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedDeliverySupplyChainEvent/ram:UnitQuantity" mode="M292" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedDeliverySupplyChainEvent/ram:UnitQuantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@unitCode' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M292" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M292" priority="-1" />
  <xsl:template match="@*|node()" mode="M292" priority="-2">
    <xsl:apply-templates mode="M292" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedDespatchSupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString" mode="M293" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedDespatchSupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M293" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M293" priority="-1" />
  <xsl:template match="@*|node()" mode="M293" priority="-2">
    <xsl:apply-templates mode="M293" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedDespatchSupplyChainEvent/ram:OccurrenceSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString" mode="M294" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedDespatchSupplyChainEvent/ram:OccurrenceSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M294" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M294" priority="-1" />
  <xsl:template match="@*|node()" mode="M294" priority="-2">
    <xsl:apply-templates mode="M294" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedDespatchSupplyChainEvent/ram:OccurrenceSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString" mode="M295" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedDespatchSupplyChainEvent/ram:OccurrenceSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@format" />
      <xsl:otherwise>
        <svrl:failed-assert test="@format">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@format' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M295" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M295" priority="-1" />
  <xsl:template match="@*|node()" mode="M295" priority="-2">
    <xsl:apply-templates mode="M295" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedDespatchSupplyChainEvent/ram:UnitQuantity" mode="M296" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedDespatchSupplyChainEvent/ram:UnitQuantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@unitCode' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M296" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M296" priority="-1" />
  <xsl:template match="@*|node()" mode="M296" priority="-2">
    <xsl:apply-templates mode="M296" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedQuantity" mode="M297" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedQuantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@unitCode' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M297" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M297" priority="-1" />
  <xsl:template match="@*|node()" mode="M297" priority="-2">
    <xsl:apply-templates mode="M297" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipFromTradeParty" mode="M298" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipFromTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Name' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M298" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M298" priority="-1" />
  <xsl:template match="@*|node()" mode="M298" priority="-2">
    <xsl:apply-templates mode="M298" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" mode="M299" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M299" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M299" priority="-1" />
  <xsl:template match="@*|node()" mode="M299" priority="-2">
    <xsl:apply-templates mode="M299" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" mode="M300" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M300" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M300" priority="-1" />
  <xsl:template match="@*|node()" mode="M300" priority="-2">
    <xsl:apply-templates mode="M300" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" mode="M301" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M301" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M301" priority="-1" />
  <xsl:template match="@*|node()" mode="M301" priority="-2">
    <xsl:apply-templates mode="M301" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipFromTradeParty/ram:GlobalID" mode="M302" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipFromTradeParty/ram:GlobalID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M302" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M302" priority="-1" />
  <xsl:template match="@*|node()" mode="M302" priority="-2">
    <xsl:apply-templates mode="M302" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipFromTradeParty/ram:SpecifiedTaxRegistration/ram:ID" mode="M303" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipFromTradeParty/ram:SpecifiedTaxRegistration/ram:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M303" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M303" priority="-1" />
  <xsl:template match="@*|node()" mode="M303" priority="-2">
    <xsl:apply-templates mode="M303" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipFromTradeParty/ram:URIUniversalCommunication" mode="M304" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipFromTradeParty/ram:URIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M304" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M304" priority="-1" />
  <xsl:template match="@*|node()" mode="M304" priority="-2">
    <xsl:apply-templates mode="M304" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty" mode="M305" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Name' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M305" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M305" priority="-1" />
  <xsl:template match="@*|node()" mode="M305" priority="-2">
    <xsl:apply-templates mode="M305" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" mode="M306" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M306" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M306" priority="-1" />
  <xsl:template match="@*|node()" mode="M306" priority="-2">
    <xsl:apply-templates mode="M306" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" mode="M307" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M307" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M307" priority="-1" />
  <xsl:template match="@*|node()" mode="M307" priority="-2">
    <xsl:apply-templates mode="M307" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" mode="M308" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M308" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M308" priority="-1" />
  <xsl:template match="@*|node()" mode="M308" priority="-2">
    <xsl:apply-templates mode="M308" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:GlobalID" mode="M309" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:GlobalID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M309" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M309" priority="-1" />
  <xsl:template match="@*|node()" mode="M309" priority="-2">
    <xsl:apply-templates mode="M309" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedTaxRegistration/ram:ID" mode="M310" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedTaxRegistration/ram:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M310" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M310" priority="-1" />
  <xsl:template match="@*|node()" mode="M310" priority="-2">
    <xsl:apply-templates mode="M310" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication" mode="M311" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M311" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M311" priority="-1" />
  <xsl:template match="@*|node()" mode="M311" priority="-2">
    <xsl:apply-templates mode="M311" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty" mode="M312" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Name)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Name)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Name' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:PostalTradeAddress)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:PostalTradeAddress)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:PostalTradeAddress' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M312" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M312" priority="-1" />
  <xsl:template match="@*|node()" mode="M312" priority="-2">
    <xsl:apply-templates mode="M312" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" mode="M313" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M313" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M313" priority="-1" />
  <xsl:template match="@*|node()" mode="M313" priority="-2">
    <xsl:apply-templates mode="M313" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" mode="M314" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M314" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M314" priority="-1" />
  <xsl:template match="@*|node()" mode="M314" priority="-2">
    <xsl:apply-templates mode="M314" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" mode="M315" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:CompleteNumber)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:CompleteNumber)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:CompleteNumber' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M315" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M315" priority="-1" />
  <xsl:template match="@*|node()" mode="M315" priority="-2">
    <xsl:apply-templates mode="M315" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:GlobalID" mode="M316" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:GlobalID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M316" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M316" priority="-1" />
  <xsl:template match="@*|node()" mode="M316" priority="-2">
    <xsl:apply-templates mode="M316" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedTaxRegistration/ram:ID" mode="M317" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedTaxRegistration/ram:ID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M317" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M317" priority="-1" />
  <xsl:template match="@*|node()" mode="M317" priority="-2">
    <xsl:apply-templates mode="M317" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:URIUniversalCommunication" mode="M318" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:URIUniversalCommunication" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:URIID)=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:URIID)=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:URIID' must occur exactly 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M318" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M318" priority="-1" />
  <xsl:template match="@*|node()" mode="M318" priority="-2">
    <xsl:apply-templates mode="M318" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement" mode="M319" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ApplicableTradeTax)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ApplicableTradeTax)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ApplicableTradeTax' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M319" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M319" priority="-1" />
  <xsl:template match="@*|node()" mode="M319" priority="-2">
    <xsl:apply-templates mode="M319" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct" mode="M320" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ManufacturerAssignedID)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ManufacturerAssignedID)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ManufacturerAssignedID' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:GrossWeightMeasure)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:GrossWeightMeasure)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:GrossWeightMeasure' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ApplicableSupplyChainPackaging)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ApplicableSupplyChainPackaging)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ApplicableSupplyChainPackaging' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:OriginTradeCountry)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:OriginTradeCountry)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:OriginTradeCountry' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:LinearSpatialDimension)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:LinearSpatialDimension)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:LinearSpatialDimension' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:MinimumLinearSpatialDimension)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:MinimumLinearSpatialDimension)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:MinimumLinearSpatialDimension' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:MaximumLinearSpatialDimension)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:MaximumLinearSpatialDimension)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:MaximumLinearSpatialDimension' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ManufacturerTradeParty)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ManufacturerTradeParty)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ManufacturerTradeParty' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:MSDSReferenceReferencedDocument)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:MSDSReferenceReferencedDocument)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:MSDSReferenceReferencedDocument' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M320" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M320" priority="-1" />
  <xsl:template match="@*|node()" mode="M320" priority="-2">
    <xsl:apply-templates mode="M320" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:AdditionalReferenceReferencedDocument" mode="M321" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:AdditionalReferenceReferencedDocument" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:Name)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:Name)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:Name' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M321" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M321" priority="-1" />
  <xsl:template match="@*|node()" mode="M321" priority="-2">
    <xsl:apply-templates mode="M321" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:AdditionalReferenceReferencedDocument/ram:AttachmentBinaryObject" mode="M322" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:AdditionalReferenceReferencedDocument/ram:AttachmentBinaryObject" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@mimeCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@mimeCode">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@mimeCode' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@filename" />
      <xsl:otherwise>
        <svrl:failed-assert test="@filename">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@filename' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M322" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M322" priority="-1" />
  <xsl:template match="@*|node()" mode="M322" priority="-2">
    <xsl:apply-templates mode="M322" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableSupplyChainPackaging/ram:LinearSpatialDimension/ram:HeightMeasure" mode="M323" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableSupplyChainPackaging/ram:LinearSpatialDimension/ram:HeightMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@unitCode' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M323" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M323" priority="-1" />
  <xsl:template match="@*|node()" mode="M323" priority="-2">
    <xsl:apply-templates mode="M323" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableSupplyChainPackaging/ram:LinearSpatialDimension/ram:LengthMeasure" mode="M324" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableSupplyChainPackaging/ram:LinearSpatialDimension/ram:LengthMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@unitCode' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M324" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M324" priority="-1" />
  <xsl:template match="@*|node()" mode="M324" priority="-2">
    <xsl:apply-templates mode="M324" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableSupplyChainPackaging/ram:LinearSpatialDimension/ram:WidthMeasure" mode="M325" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableSupplyChainPackaging/ram:LinearSpatialDimension/ram:WidthMeasure" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@unitCode' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M325" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M325" priority="-1" />
  <xsl:template match="@*|node()" mode="M325" priority="-2">
    <xsl:apply-templates mode="M325" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:DesignatedProductClassification/ram:ClassCode" mode="M326" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:DesignatedProductClassification/ram:ClassCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@listID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@listID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@listID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M326" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M326" priority="-1" />
  <xsl:template match="@*|node()" mode="M326" priority="-2">
    <xsl:apply-templates mode="M326" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:GlobalID" mode="M327" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:GlobalID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M327" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M327" priority="-1" />
  <xsl:template match="@*|node()" mode="M327" priority="-2">
    <xsl:apply-templates mode="M327" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IncludedReferencedProduct/ram:GlobalID" mode="M328" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IncludedReferencedProduct/ram:GlobalID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M328" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M328" priority="-1" />
  <xsl:template match="@*|node()" mode="M328" priority="-2">
    <xsl:apply-templates mode="M328" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IncludedReferencedProduct/ram:UnitQuantity" mode="M329" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IncludedReferencedProduct/ram:UnitQuantity" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@unitCode" />
      <xsl:otherwise>
        <svrl:failed-assert test="@unitCode">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@unitCode' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M329" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M329" priority="-1" />
  <xsl:template match="@*|node()" mode="M329" priority="-2">
    <xsl:apply-templates mode="M329" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SubstitutedReferencedProduct" mode="M330" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SubstitutedReferencedProduct" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="count(ram:ManufacturerAssignedID)&lt;=1" />
      <xsl:otherwise>
        <svrl:failed-assert test="count(ram:ManufacturerAssignedID)&lt;=1">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Element 'ram:ManufacturerAssignedID' may occur at maximum 1 times.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M330" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M330" priority="-1" />
  <xsl:template match="@*|node()" mode="M330" priority="-2">
    <xsl:apply-templates mode="M330" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SubstitutedReferencedProduct/ram:GlobalID" mode="M331" priority="1000">
    <svrl:fired-rule context="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SubstitutedReferencedProduct/ram:GlobalID" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="@schemeID" />
      <xsl:otherwise>
        <svrl:failed-assert test="@schemeID">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
	Attribute '@schemeID' is required in this context.</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M331" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M331" priority="-1" />
  <xsl:template match="@*|node()" mode="M331" priority="-2">
    <xsl:apply-templates mode="M331" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="ram:SpecifiedTradeAllowanceCharge/ram:ReasonCode" mode="M332" priority="1000">
    <svrl:fired-rule context="ram:SpecifiedTradeAllowanceCharge/ram:ReasonCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((../ram:ChargeIndicator/udt:Indicator = 'true') or ((../ram:ChargeIndicator/udt:Indicator = 'false') and (not(contains(normalize-space(.), ' ')) and contains(' 41 42 60 62 63 64 65 66 67 68 70 71 88 95 100 102 103 104 ', concat(' ', normalize-space(.), ' ')))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((../ram:ChargeIndicator/udt:Indicator = 'true') or ((../ram:ChargeIndicator/udt:Indicator = 'false') and (not(contains(normalize-space(.), ' ')) and contains(' 41 42 60 62 63 64 65 66 67 68 70 71 88 95 100 102 103 104 ', concat(' ', normalize-space(.), ' ')))))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        Coded allowance reasons MUST belong to the UNCL 5189 code list</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((../ram:ChargeIndicator/udt:Indicator = 'false') or ((../ram:ChargeIndicator/udt:Indicator = 'true') and (not(contains(normalize-space(.), ' ')) and contains(' AA AAA AAC AAD AAE AAF AAH AAI AAS AAT AAV AAY AAZ ABA ABB ABC ABD ABF ABK ABL ABN ABR ABS ABT ABU ACF ACG ACH ACI ACJ ACK ACL ACM ACS ADC ADE ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADT ADW ADY ADZ AEA AEB AEC AED AEF AEH AEI AEJ AEK AEL AEM AEN AEO AEP AES AET AEU AEV AEW AEX AEY AEZ AJ AU CA CAB CAD CAE CAF CAI CAJ CAK CAL CAM CAN CAO CAP CAQ CAR CAS CAT CAU CAV CAW CAX CAY CAZ CD CG CS CT DAB DAD DAC DAF DAG DAH DAI DAJ DAK DAL DAM DAN DAO DAP DAQ DL EG EP ER FAA FAB FAC FC FH FI GAA HAA HD HH IAA IAB ID IF IR IS KO L1 LA LAA LAB LF MAE MI ML NAA OA PA PAA PC PL RAB RAC RAD RAF RE RF RH RV SA SAA SAD SAE SAI SG SH SM SU TAB TAC TT TV V1 V2 WH XAA YY ZZZ ', concat(' ', normalize-space(.), ' ')))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((../ram:ChargeIndicator/udt:Indicator = 'false') or ((../ram:ChargeIndicator/udt:Indicator = 'true') and (not(contains(normalize-space(.), ' ')) and contains(' AA AAA AAC AAD AAE AAF AAH AAI AAS AAT AAV AAY AAZ ABA ABB ABC ABD ABF ABK ABL ABN ABR ABS ABT ABU ACF ACG ACH ACI ACJ ACK ACL ACM ACS ADC ADE ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADT ADW ADY ADZ AEA AEB AEC AED AEF AEH AEI AEJ AEK AEL AEM AEN AEO AEP AES AET AEU AEV AEW AEX AEY AEZ AJ AU CA CAB CAD CAE CAF CAI CAJ CAK CAL CAM CAN CAO CAP CAQ CAR CAS CAT CAU CAV CAW CAX CAY CAZ CD CG CS CT DAB DAD DAC DAF DAG DAH DAI DAJ DAK DAL DAM DAN DAO DAP DAQ DL EG EP ER FAA FAB FAC FC FH FI GAA HAA HD HH IAA IAB ID IF IR IS KO L1 LA LAA LAB LF MAE MI ML NAA OA PA PAA PC PL RAB RAC RAD RAF RE RF RH RV SA SAA SAD SAE SAI SG SH SM SU TAB TAC TT TV V1 V2 WH XAA YY ZZZ ', concat(' ', normalize-space(.), ' ')))))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        Coded charge reasons MUST belong to the UNCL 7161 code list</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M332" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M332" priority="-1" />
  <xsl:template match="@*|node()" mode="M332" priority="-2">
    <xsl:apply-templates mode="M332" select="*|comment()|processing-instruction()" />
  </xsl:template>

<!--PATTERN -->


	<!--RULE -->
<xsl:template match="ram:AppliedTradeAllowanceCharge/ram:ReasonCode" mode="M333" priority="1000">
    <svrl:fired-rule context="ram:AppliedTradeAllowanceCharge/ram:ReasonCode" />

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((../ram:ChargeIndicator/udt:Indicator = 'true') or ((../ram:ChargeIndicator/udt:Indicator = 'false') and (not(contains(normalize-space(.), ' ')) and contains(' 41 42 60 62 63 64 65 66 67 68 70 71 88 95 100 102 103 104 ', concat(' ', normalize-space(.), ' ')))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((../ram:ChargeIndicator/udt:Indicator = 'true') or ((../ram:ChargeIndicator/udt:Indicator = 'false') and (not(contains(normalize-space(.), ' ')) and contains(' 41 42 60 62 63 64 65 66 67 68 70 71 88 95 100 102 103 104 ', concat(' ', normalize-space(.), ' ')))))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        Coded allowance reasons MUST belong to the UNCL 5189 code list</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>

		<!--ASSERT -->
<xsl:choose>
      <xsl:when test="((../ram:ChargeIndicator/udt:Indicator = 'false') or ((../ram:ChargeIndicator/udt:Indicator = 'true') and (not(contains(normalize-space(.), ' ')) and contains(' AA AAA AAC AAD AAE AAF AAH AAI AAS AAT AAV AAY AAZ ABA ABB ABC ABD ABF ABK ABL ABN ABR ABS ABT ABU ACF ACG ACH ACI ACJ ACK ACL ACM ACS ADC ADE ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADT ADW ADY ADZ AEA AEB AEC AED AEF AEH AEI AEJ AEK AEL AEM AEN AEO AEP AES AET AEU AEV AEW AEX AEY AEZ AJ AU CA CAB CAD CAE CAF CAI CAJ CAK CAL CAM CAN CAO CAP CAQ CAR CAS CAT CAU CAV CAW CAX CAY CAZ CD CG CS CT DAB DAD DAC DAF DAG DAH DAI DAJ DAK DAL DAM DAN DAO DAP DAQ DL EG EP ER FAA FAB FAC FC FH FI GAA HAA HD HH IAA IAB ID IF IR IS KO L1 LA LAA LAB LF MAE MI ML NAA OA PA PAA PC PL RAB RAC RAD RAF RE RF RH RV SA SAA SAD SAE SAI SG SH SM SU TAB TAC TT TV V1 V2 WH XAA YY ZZZ ', concat(' ', normalize-space(.), ' ')))))" />
      <xsl:otherwise>
        <svrl:failed-assert test="((../ram:ChargeIndicator/udt:Indicator = 'false') or ((../ram:ChargeIndicator/udt:Indicator = 'true') and (not(contains(normalize-space(.), ' ')) and contains(' AA AAA AAC AAD AAE AAF AAH AAI AAS AAT AAV AAY AAZ ABA ABB ABC ABD ABF ABK ABL ABN ABR ABS ABT ABU ACF ACG ACH ACI ACJ ACK ACL ACM ACS ADC ADE ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADT ADW ADY ADZ AEA AEB AEC AED AEF AEH AEI AEJ AEK AEL AEM AEN AEO AEP AES AET AEU AEV AEW AEX AEY AEZ AJ AU CA CAB CAD CAE CAF CAI CAJ CAK CAL CAM CAN CAO CAP CAQ CAR CAS CAT CAU CAV CAW CAX CAY CAZ CD CG CS CT DAB DAD DAC DAF DAG DAH DAI DAJ DAK DAL DAM DAN DAO DAP DAQ DL EG EP ER FAA FAB FAC FC FH FI GAA HAA HD HH IAA IAB ID IF IR IS KO L1 LA LAA LAB LF MAE MI ML NAA OA PA PAA PC PL RAB RAC RAD RAF RE RF RH RV SA SAA SAD SAE SAI SG SH SM SU TAB TAC TT TV V1 V2 WH XAA YY ZZZ ', concat(' ', normalize-space(.), ' ')))))">
          <xsl:attribute name="location">
            <xsl:apply-templates mode="schematron-select-full-path" select="." />
          </xsl:attribute>
          <svrl:text>
        Coded charge reasons MUST belong to the UNCL 7161 code list</svrl:text>
        </svrl:failed-assert>
      </xsl:otherwise>
    </xsl:choose>
    <xsl:apply-templates mode="M333" select="*|comment()|processing-instruction()" />
  </xsl:template>
  <xsl:template match="text()" mode="M333" priority="-1" />
  <xsl:template match="@*|node()" mode="M333" priority="-2">
    <xsl:apply-templates mode="M333" select="*|comment()|processing-instruction()" />
  </xsl:template>
</xsl:stylesheet>
