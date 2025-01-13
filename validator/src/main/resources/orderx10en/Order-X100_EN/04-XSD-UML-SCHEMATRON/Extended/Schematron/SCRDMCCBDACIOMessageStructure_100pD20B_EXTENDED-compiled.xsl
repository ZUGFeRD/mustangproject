<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xhtml="http://www.w3.org/1999/xhtml"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:oxy="http://www.oxygenxml.com/schematron/validation"
                xmlns:saxon="http://saxon.sf.net/"
                xmlns:clm60133="urn:un:unece:uncefact:codelist:standard:6:0133:40106"
                xmlns:clm210AccountingE704="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccessRightsType:D11A"
                xmlns:clm210AccountingE602="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingAccountBalanceReopeningType:D11A"
                xmlns:clm210AccountingE902="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingAccountClassification:D11A"
                xmlns:clm210AccountingE502="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingAccountNatureType:D11A"
                xmlns:clm210AccountingE305="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingAccountStatus:D11A"
                xmlns:clm210AccountingE501="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingAccountType:D11A"
                xmlns:clm210AccountingE603="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingAmountQualifierType:D11A"
                xmlns:clm210AccountingE601="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingAmountType:D11A"
                xmlns:clm210AccountingE023="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingContact:D11A"
                xmlns:clm210AccountingE006="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingDocumentType:D11A"
                xmlns:clm210AccountingE202="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingEntryCategory:D11A"
                xmlns:clm210AccountingE203="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingEntryLineCategory:D11A"
                xmlns:clm210AccountingE302="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingEntryLineSource:D11A"
                xmlns:clm210AccountingE201="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingEntryProcessing:D11A"
                xmlns:clm210AccountingE012="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingJournal:D11A"
                xmlns:clm210AccountingE013="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingJournalCategory:D11A"
                xmlns:clm210AccountingE703="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingPeriodFunctionType:D11A"
                xmlns:clm210AccountingE021="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingPerquisite:D11A"
                xmlns:clm210AccountingE101="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AccountingVoucherMedium:D11A"
                xmlns:clm210AccountingE904="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AdditionalPostponement:D11A"
                xmlns:clm210AccountingE011="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AddressFormatType:D11A"
                xmlns:clm210AccountingE304="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AlternateCurrencyAmount:D11A"
                xmlns:clm210AccountingE204="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AmortizationMethod:D11A"
                xmlns:clm210AccountingE702="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:AmountWeightType:D11A"
                xmlns:clm210AccountingE004="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:CertificateType:D11A"
                xmlns:clm210AccountingE016="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:FinancialAccountType:D11A"
                xmlns:clm210AccountingE015="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:FinancialInstitutionRole:D11A"
                xmlns:clm210LifetimeEndCostE206="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:LifetimeEndCost:D11A"
                xmlns:clm210OrganizationFunctionTypeE706="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:OrganizationFunctionType:D11A"
                xmlns:clm210PartyTypeE705="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:PartyType:D11A"
                xmlns:clm210RefundMethodE022="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:RefundMethod:D11A"
                xmlns:clm210ScenarioTypeE018="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:ScenarioType:D11A"
                xmlns:clm210SoftwareUserTypeE019="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:SoftwareUserType:D11A"
                xmlns:clm210AccountingE307="urn:un:unece:uncefact:codelist:standard:EDIFICAS-EU:TaxExemptionReason:D11A"
                xmlns:clmIANACharacterSetCode="urn:un:unece:uncefact:codelist:standard:IANA:CharacterSetCode:2013-01-23"
                xmlns:clm5ISO63912A="urn:un:unece:uncefact:codelist:standard:ISO:ISO2AlphaLanguageCode:2006-10-27"
                xmlns:clm5ISO42173A="urn:un:unece:uncefact:codelist:standard:ISO:ISO3AlphaCurrencyCode:2012-08-31"
                xmlns:clm61229LineStatusCode="urn:un:unece:uncefact:codelist:standard:UNECE:ActionCode:D20A"
                xmlns:clm63131="urn:un:unece:uncefact:codelist:standard:UNECE:AddressType:D20A"
                xmlns:clm64465="urn:un:unece:uncefact:codelist:standard:UNECE:AdjustmentReasonDescriptionCode:D20A"
                xmlns:clm64465AdjustmentReasonCodeFinancial="urn:un:unece:uncefact:codelist:standard:UNECE:AdjustmentReasonDescriptionCode_Financial:D20A"
                xmlns:clm63055="urn:un:unece:uncefact:codelist:standard:UNECE:AgencyIdentificationCode:D20A"
                xmlns:clm65189AllowanceChargeID="urn:un:unece:uncefact:codelist:standard:UNECE:AllowanceChargeIdentificationCode:D20A"
                xmlns:clm64465AllowanceChargeReasonCode="urn:un:unece:uncefact:codelist:standard:UNECE:AllowanceChargeReasonCode:D20A"
                xmlns:clm67233AutomaticDataCaptureMethodCode="urn:un:unece:uncefact:codelist:standard:UNECE:AutomaticDataCaptureMethodCode:D20A"
                xmlns:clm67085b="urn:un:unece:uncefact:codelist:standard:UNECE:CargoOperationalCategoryCode:D20A"
                xmlns:clm67085="urn:un:unece:uncefact:codelist:standard:UNECE:CargoTypeClassificationCode:D20A"
                xmlns:clm6Recommendation21AnnexI="urn:un:unece:uncefact:codelist:standard:UNECE:CargoTypeCode:1996Rev2Final"
                xmlns:clm67357="urn:un:unece:uncefact:codelist:standard:UNECE:CommodityIdentificationCode:D19B"
                xmlns:clm63155CommunicationChannelCode="urn:un:unece:uncefact:codelist:standard:UNECE:CommunicationMeansTypeCode:D20A"
                xmlns:clm63139ContactTypeCode="urn:un:unece:uncefact:codelist:standard:UNECE:ContactFunctionCode:D20A"
                xmlns:clm69651="urn:un:unece:uncefact:codelist:standard:UNECE:ContractTypeCode:D10B"
                xmlns:clm6ContractorType="urn:un:unece:uncefact:codelist:standard:UNECE:ContractorType:D10B"
                xmlns:clm69653="urn:un:unece:uncefact:codelist:standard:UNECE:CostManagementCode:D10B"
                xmlns:clm69655="urn:un:unece:uncefact:codelist:standard:UNECE:CostReportingCode:D10B"
                xmlns:clm69213="urn:un:unece:uncefact:codelist:standard:UNECE:CustomsDutyRegimeTypeCode:D20A"
                xmlns:clm68339="urn:un:unece:uncefact:codelist:standard:UNECE:DangerousGoodsPackingCode:D20A"
                xmlns:clm68273="urn:un:unece:uncefact:codelist:standard:UNECE:DangerousGoodsRegulationCode:D20A"
                xmlns:clm62005DateTimePeriodFunctionCode="urn:un:unece:uncefact:codelist:standard:UNECE:DateTimePeriodFunctionCode:D20A"
                xmlns:clm64017CommitmentLevelCode="urn:un:unece:uncefact:codelist:standard:UNECE:DeliveryPlanCommitmentLevelCode:D20A"
                xmlns:clm64053="urn:un:unece:uncefact:codelist:standard:UNECE:DeliveryTermsCode:2010"
                xmlns:clm64055DeliveryTermsFunctionCode="urn:un:unece:uncefact:codelist:standard:UNECE:DeliveryTermsFunctionCode:D20A"
                xmlns:clm66145="urn:un:unece:uncefact:codelist:standard:UNECE:DimensionTypeCode:D20A"
                xmlns:clm61001="urn:un:unece:uncefact:codelist:standard:UNECE:DocumentNameCode:D20A"
                xmlns:clm61001Accounting="urn:un:unece:uncefact:codelist:standard:UNECE:DocumentNameCode_Accounting:D20A"
                xmlns:clm61001Billing="urn:un:unece:uncefact:codelist:standard:UNECE:DocumentNameCode_Billing:D20A"
                xmlns:clm61001Invoice="urn:un:unece:uncefact:codelist:standard:UNECE:DocumentNameCode_Invoice:D20A"
                xmlns:clm61001DocumentTypeCodeQuotation="urn:un:unece:uncefact:codelist:standard:UNECE:DocumentNameCode_Quotation:D20A"
                xmlns:clm61001DocumentTypeCodeRemittance="urn:un:unece:uncefact:codelist:standard:UNECE:DocumentNameCode_Remittance:D20A"
                xmlns:clm61001DocumentTypeCodeScheduling="urn:un:unece:uncefact:codelist:standard:UNECE:DocumentNameCode_Scheduling:D20A"
                xmlns:clm61373="urn:un:unece:uncefact:codelist:standard:UNECE:DocumentStatusCode:D20A"
                xmlns:clm65153="urn:un:unece:uncefact:codelist:standard:UNECE:DutyTaxFeeTypeCode:D20A"
                xmlns:clm65305="urn:un:unece:uncefact:codelist:standard:UNECE:DutyorTaxorFeeCategoryCode:D20A"
                xmlns:clm69657="urn:un:unece:uncefact:codelist:standard:UNECE:EarnedValueCalculationMethod:D10B"
                xmlns:clm68155="urn:un:unece:uncefact:codelist:standard:UNECE:EquipmentSizeTypeDescriptionCode:D20A"
                xmlns:clm68077="urn:un:unece:uncefact:codelist:standard:UNECE:EquipmentSupplierCode:D20A"
                xmlns:clm62475="urn:un:unece:uncefact:codelist:standard:UNECE:EventTimeReferenceCode:D20A"
                xmlns:clm62475PaymentTermsEvent="urn:un:unece:uncefact:codelist:standard:UNECE:EventTimeReferenceCodePaymentTermsEvent:D20A"
                xmlns:clm66131="urn:un:unece:uncefact:codelist:standard:UNECE:FreightChargeQuantityUnitBasisCode:D19B"
                xmlns:clm65243="urn:un:unece:uncefact:codelist:standard:UNECE:FreightChargeTariffCode:D20A"
                xmlns:clm69659="urn:un:unece:uncefact:codelist:standard:UNECE:FundingTypeCode:D10B"
                xmlns:clm6TDED7357="urn:un:unece:uncefact:codelist:standard:UNECE:GoodsTypeCode:D19B"
                xmlns:clm6TDED7361="urn:un:unece:uncefact:codelist:standard:UNECE:GoodsTypeExtensionCode:D19B"
                xmlns:clm69417="urn:un:unece:uncefact:codelist:standard:UNECE:GovernmentActionCode:D20A"
                xmlns:clm69661="urn:un:unece:uncefact:codelist:standard:UNECE:HierarchicalStructureTypeCode:D10B"
                xmlns:clm63227="urn:un:unece:uncefact:codelist:standard:UNECE:LocationFunctionCode:D20A"
                xmlns:clm64233="urn:un:unece:uncefact:codelist:standard:UNECE:MarkingInstructionCode:D20A"
                xmlns:clm66313="urn:un:unece:uncefact:codelist:standard:UNECE:MeasuredAttributeCode:D20A"
                xmlns:clm6Recommendation20Duration="urn:un:unece:uncefact:codelist:standard:UNECE:MeasurementUnitCommonCodeDuration:4"
                xmlns:clm6Recommendation20Linear="urn:un:unece:uncefact:codelist:standard:UNECE:MeasurementUnitCommonCodeLinear:4"
                xmlns:clm6Recommendation20Temperature="urn:un:unece:uncefact:codelist:standard:UNECE:MeasurementUnitCommonCodeTemperature:4"
                xmlns:clm6Recommendation20Volume="urn:un:unece:uncefact:codelist:standard:UNECE:MeasurementUnitCommonCodeVolume:4"
                xmlns:clm6Recommendation20Weight="urn:un:unece:uncefact:codelist:standard:UNECE:MeasurementUnitCommonCodeWeight:4"
                xmlns:clm6Recommendation20Airflow="urn:un:unece:uncefact:codelist:standard:UNECE:MeasurementUnitCommonCode_Airflow:4"
                xmlns:clm6Recommendation20FileSize="urn:un:unece:uncefact:codelist:standard:UNECE:MeasurementUnitCommonCode_FileSize:4"
                xmlns:clm61225MessageFunctionTypeCode="urn:un:unece:uncefact:codelist:standard:UNECE:MessageFunctionCode:D20A"
                xmlns:clm61225Acknowledgement="urn:un:unece:uncefact:codelist:standard:UNECE:MessageFunctionCode_Acknowledgement:D20A"
                xmlns:clm64377="urn:un:unece:uncefact:codelist:standard:UNECE:ObligationGuaranteeCode:D19B"
                xmlns:clm67065="urn:un:unece:uncefact:codelist:standard:UNECE:PackageTypeCode:2006"
                xmlns:clm67075="urn:un:unece:uncefact:codelist:standard:UNECE:PackagingLevelCode:D20A"
                xmlns:clm67233PackagingMarkingCode="urn:un:unece:uncefact:codelist:standard:UNECE:PackagingMarkingCode:D20A"
                xmlns:clm63035="urn:un:unece:uncefact:codelist:standard:UNECE:PartyRoleCode:D20A"
                xmlns:clm63035ChargePaying="urn:un:unece:uncefact:codelist:standard:UNECE:PartyRoleCode_ChargePaying:D20A"
                xmlns:clm64431="urn:un:unece:uncefact:codelist:standard:UNECE:PaymentGuaranteeMeansCode:D20A"
                xmlns:clm64435="urn:un:unece:uncefact:codelist:standard:UNECE:PaymentMeansChannelCode:D20A"
                xmlns:clm64461="urn:un:unece:uncefact:codelist:standard:UNECE:PaymentMeansCode:D20A"
                xmlns:clm64439="urn:un:unece:uncefact:codelist:standard:UNECE:PaymentMethodCode:D20A"
                xmlns:clm64279="urn:un:unece:uncefact:codelist:standard:UNECE:PaymentTermsTypeCode:D20A"
                xmlns:clm6PlanningLevel="urn:un:unece:uncefact:codelist:standard:UNECE:PlanningLevel:D10B"
                xmlns:clm65375="urn:un:unece:uncefact:codelist:standard:UNECE:PriceTypeCode:D20A"
                xmlns:clm64037PriorityDescriptionCode="urn:un:unece:uncefact:codelist:standard:UNECE:PriorityDescriptionCode:D20A"
                xmlns:clm67187="urn:un:unece:uncefact:codelist:standard:UNECE:ProcessTypeCode:D20A"
                xmlns:clm69665="urn:un:unece:uncefact:codelist:standard:UNECE:ProjectTypeCode:D10B"
                xmlns:clm61153ReferenceTypeCode="urn:un:unece:uncefact:codelist:standard:UNECE:ReferenceTypeCode:D20A"
                xmlns:clm69667="urn:un:unece:uncefact:codelist:standard:UNECE:ReportingThresholdTriggerType:D10B"
                xmlns:clm69669="urn:un:unece:uncefact:codelist:standard:UNECE:ResourceCostCategory:D10B"
                xmlns:clm69671="urn:un:unece:uncefact:codelist:standard:UNECE:ResourcePlanMeasureType:D10B"
                xmlns:clm64343ResponseTypeCode="urn:un:unece:uncefact:codelist:standard:UNECE:ResponseTypeCode:D20A"
                xmlns:clm69415ResponsibleAgencyCode="urn:un:unece:uncefact:codelist:standard:UNECE:ResponsibleAgencyCode:D20A"
                xmlns:clm69411ResponsibleAgencyInvolvementCode="urn:un:unece:uncefact:codelist:standard:UNECE:ResponsibleAgencyInvolvementCode:D20A"
                xmlns:clm69673="urn:un:unece:uncefact:codelist:standard:UNECE:ScheduleTaskRelationshipType:D10B"
                xmlns:clm69675="urn:un:unece:uncefact:codelist:standard:UNECE:ScheduleTaskType:D10B"
                xmlns:clm6ScheduleTypeCode="urn:un:unece:uncefact:codelist:standard:UNECE:ScheduleTypeCode:D10B"
                xmlns:clm64517="urn:un:unece:uncefact:codelist:standard:UNECE:SealConditionCode:D20A"
                xmlns:clm6SealTypeCode="urn:un:unece:uncefact:codelist:standard:UNECE:SealTypeCode:D14A"
                xmlns:clm69303="urn:un:unece:uncefact:codelist:standard:UNECE:SealingPartyRoleCode:D20A"
                xmlns:clm69677="urn:un:unece:uncefact:codelist:standard:UNECE:SecurityClassificationType:D10B"
                xmlns:clm64405="urn:un:unece:uncefact:codelist:standard:UNECE:StatusCode:D20A"
                xmlns:clm64405AccountingDebitCredit="urn:un:unece:uncefact:codelist:standard:UNECE:StatusDescriptionCode_AccountingDebitCredit:D20A"
                xmlns:clm64405StatusCodeWorkflow="urn:un:unece:uncefact:codelist:standard:UNECE:StatusDescriptionCode_Workflow:D20A"
                xmlns:clm66245="urn:un:unece:uncefact:codelist:standard:UNECE:TemperatureTypeCode:D20A"
                xmlns:clm62379timeonly="urn:un:unece:uncefact:codelist:standard:UNECE:TimeOnlyFormatCode:D19B"
                xmlns:clm62379="urn:un:unece:uncefact:codelist:standard:UNECE:TimePointFormatCode:D19B"
                xmlns:clm68053="urn:un:unece:uncefact:codelist:standard:UNECE:TransportEquipmentCategoryCode:D20A"
                xmlns:clm68169="urn:un:unece:uncefact:codelist:standard:UNECE:TransportEquipmentFullnessCode:D20A"
                xmlns:clm68341="urn:un:unece:uncefact:codelist:standard:UNECE:TransportEquipmentHaulageArrangementsCode:D20A"
                xmlns:clm68249c="urn:un:unece:uncefact:codelist:standard:UNECE:TransportEquipmentMovementLegalStatusCode:D20A"
                xmlns:clm68249a="urn:un:unece:uncefact:codelist:standard:UNECE:TransportEquipmentMovementStatusCode:D20A"
                xmlns:clm68249b="urn:un:unece:uncefact:codelist:standard:UNECE:TransportEquipmentOperationalStatusCode:D20A"
                xmlns:clm68101="urn:un:unece:uncefact:codelist:standard:UNECE:TransportMeansDirectionCode:D20A"
                xmlns:clm6Recommendation28="urn:un:unece:uncefact:codelist:standard:UNECE:TransportMeansTypeCode:2007"
                xmlns:clm6Recommendation19="urn:un:unece:uncefact:codelist:standard:UNECE:TransportModeCode:2"
                xmlns:clm68051="urn:un:unece:uncefact:codelist:standard:UNECE:TransportMovementStageCode:D20A"
                xmlns:clm68323TransportMovementTypeCode="urn:un:unece:uncefact:codelist:standard:UNECE:TransportMovementTypeCode:D20A"
                xmlns:clm64237TransportPaymentArrangementCode="urn:un:unece:uncefact:codelist:standard:UNECE:TransportPaymentArrangementCode:D20A"
                xmlns:clm65237TransportServiceCategoryCode="urn:un:unece:uncefact:codelist:standard:UNECE:TransportServiceCategoryCode:D20A"
                xmlns:clm64065TransportServiceConditionCode="urn:un:unece:uncefact:codelist:standard:UNECE:TransportServiceConditionCode:D20A"
                xmlns:clm64219TransportServicePriorityCode="urn:un:unece:uncefact:codelist:standard:UNECE:TransportServicePriorityCode:D20A"
                xmlns:clm67273TransportServiceRequirementCode="urn:un:unece:uncefact:codelist:standard:UNECE:TransportServiceRequirementCode:D20A"
                xmlns:clm6Recommendation24="urn:un:unece:uncefact:codelist:standard:UNECE:TransportStatusCode:4"
                xmlns:rsm="urn:un:unece:uncefact:data:SCRDMCCBDACIOMessageStructure:100"
                xmlns:qdt="urn:un:unece:uncefact:data:standard:QualifiedDataType:128"
                xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:128"
                xmlns:udt="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:128"
                xmlns:ccts="urn:un:unece:uncefact:documentation:standard:CoreComponentsTechnicalSpecification:2"
                xmlns:ids5ISO6391A2="urn:un:unece:uncefact:identifierlist:standard:ISO:ISOAlpha2LanguageCode:2006-10-27"
                xmlns:ids5ISO316612A="urn:un:unece:uncefact:identifierlist:standard:ISO:ISOTwo-letterCountryCode:SecondEdition2006"
                xmlns:ids6Recommendation23="urn:un:unece:uncefact:identifierlist:standard:UNECE:FreightCostCode:4"
                xmlns:ids64277="urn:un:unece:uncefact:identifierlist:standard:UNECE:PaymentTermsDescriptionIdentifier:D20A"
                version="1.0"><!--Implementers: please note that overriding process-prolog or process-root is 
    the preferred method for meta-stylesheets to use where possible. -->
   <xsl:param name="archiveDirParameter"/>
   <xsl:param name="archiveNameParameter"/>
   <xsl:param name="fileNameParameter"/>
   <xsl:param name="fileDirParameter"/>
   <xsl:variable name="document-uri"/>
   <!--PHASES-->
   <!--PROLOG-->
   <xsl:output xmlns:iso="http://purl.oclc.org/dsdl/schematron" method="xml"/>
   <!--XSD TYPES FOR XSLT2-->
   <!--KEYS AND FUNCTIONS-->
   <!--DEFAULT RULES-->
   <!--MODE: SCHEMATRON-SELECT-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-select-full-path">
      <xsl:apply-templates select="." mode="schematron-get-full-path"/>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-->
   <!--This mode can be used to generate an ugly though full XPath for locators-->
   <xsl:template match="*" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">
            <xsl:value-of select="name()"/>
            <xsl:variable name="p_1"
                          select="1+        count(preceding-sibling::*[name()=name(current())])"/>
            <xsl:if test="$p_1&gt;1 or following-sibling::*[name()=name(current())]">[<xsl:value-of select="$p_1"/>]</xsl:if>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>']</xsl:text>
            <xsl:variable name="p_2"
                          select="1+        count(preceding-sibling::*[local-name()=local-name(current())])"/>
            <xsl:if test="$p_2&gt;1 or following-sibling::*[local-name()=local-name(current())]">[<xsl:value-of select="$p_2"/>]</xsl:if>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="@*" mode="schematron-get-full-path">
      <xsl:text>/</xsl:text>
      <xsl:choose>
         <xsl:when test="namespace-uri()=''">@<xsl:value-of select="name()"/>
         </xsl:when>
         <xsl:otherwise>
            <xsl:text>@*[local-name()='</xsl:text>
            <xsl:value-of select="local-name()"/>
            <xsl:text>' and namespace-uri()='</xsl:text>
            <xsl:value-of select="namespace-uri()"/>
            <xsl:text>']</xsl:text>
         </xsl:otherwise>
      </xsl:choose>
   </xsl:template>
   <xsl:template match="text()" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:text>text()</xsl:text>
      <xsl:variable name="preceding" select="count(preceding-sibling::text())"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="comment()" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:text>comment()</xsl:text>
      <xsl:variable name="preceding" select="count(preceding-sibling::comment())"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="schematron-get-full-path">
      <xsl:apply-templates select="parent::*" mode="schematron-get-full-path"/>
      <xsl:text>/</xsl:text>
      <xsl:text>processing-instruction()</xsl:text>
      <xsl:variable name="preceding"
                    select="count(preceding-sibling::processing-instruction())"/>
      <xsl:text>[</xsl:text>
      <xsl:value-of select="1+ $preceding"/>
      <xsl:text>]</xsl:text>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-2-->
   <!--This mode can be used to generate prefixed XPath for humans-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-2">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="preceding-sibling::*[name(.)=name(current())]">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: SCHEMATRON-FULL-PATH-3-->
   <!--This mode can be used to generate prefixed XPath for humans 
	(Top-level element has index)-->
   <xsl:template match="node() | @*" mode="schematron-get-full-path-3">
      <xsl:for-each select="ancestor-or-self::*">
         <xsl:text>/</xsl:text>
         <xsl:value-of select="name(.)"/>
         <xsl:if test="parent::*">
            <xsl:text>[</xsl:text>
            <xsl:value-of select="count(preceding-sibling::*[name(.)=name(current())])+1"/>
            <xsl:text>]</xsl:text>
         </xsl:if>
      </xsl:for-each>
      <xsl:if test="not(self::*)">
         <xsl:text/>/@<xsl:value-of select="name(.)"/>
      </xsl:if>
   </xsl:template>
   <!--MODE: GENERATE-ID-FROM-PATH -->
   <xsl:template match="/" mode="generate-id-from-path"/>
   <xsl:template match="text()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.text-', 1+count(preceding-sibling::text()), '-')"/>
   </xsl:template>
   <xsl:template match="comment()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.comment-', 1+count(preceding-sibling::comment()), '-')"/>
   </xsl:template>
   <xsl:template match="processing-instruction()" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.processing-instruction-', 1+count(preceding-sibling::processing-instruction()), '-')"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-from-path">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:value-of select="concat('.@', name())"/>
   </xsl:template>
   <xsl:template match="*" mode="generate-id-from-path" priority="-0.5">
      <xsl:apply-templates select="parent::*" mode="generate-id-from-path"/>
      <xsl:text>.</xsl:text>
      <xsl:value-of select="concat('.',name(),'-',1+count(preceding-sibling::*[name()=name(current())]),'-')"/>
   </xsl:template>
   <!--MODE: GENERATE-ID-2 -->
   <xsl:template match="/" mode="generate-id-2">U</xsl:template>
   <xsl:template match="*" mode="generate-id-2" priority="2">
      <xsl:text>U</xsl:text>
      <xsl:number level="multiple" count="*"/>
   </xsl:template>
   <xsl:template match="node()" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>n</xsl:text>
      <xsl:number count="node()"/>
   </xsl:template>
   <xsl:template match="@*" mode="generate-id-2">
      <xsl:text>U.</xsl:text>
      <xsl:number level="multiple" count="*"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="string-length(local-name(.))"/>
      <xsl:text>_</xsl:text>
      <xsl:value-of select="translate(name(),':','.')"/>
   </xsl:template>
   <!--Strip characters-->
   <xsl:template match="text()" priority="-1"/>
   <!--SCHEMA SETUP-->
   <xsl:template match="/">
      <xsl:apply-templates select="/" mode="M161"/>
      <xsl:apply-templates select="/" mode="M162"/>
      <xsl:apply-templates select="/" mode="M163"/>
      <xsl:apply-templates select="/" mode="M164"/>
      <xsl:apply-templates select="/" mode="M165"/>
      <xsl:apply-templates select="/" mode="M166"/>
      <xsl:apply-templates select="/" mode="M167"/>
      <xsl:apply-templates select="/" mode="M168"/>
      <xsl:apply-templates select="/" mode="M169"/>
      <xsl:apply-templates select="/" mode="M170"/>
      <xsl:apply-templates select="/" mode="M171"/>
      <xsl:apply-templates select="/" mode="M172"/>
      <xsl:apply-templates select="/" mode="M173"/>
      <xsl:apply-templates select="/" mode="M174"/>
      <xsl:apply-templates select="/" mode="M175"/>
      <xsl:apply-templates select="/" mode="M176"/>
      <xsl:apply-templates select="/" mode="M177"/>
      <xsl:apply-templates select="/" mode="M178"/>
      <xsl:apply-templates select="/" mode="M179"/>
      <xsl:apply-templates select="/" mode="M180"/>
      <xsl:apply-templates select="/" mode="M181"/>
      <xsl:apply-templates select="/" mode="M182"/>
      <xsl:apply-templates select="/" mode="M183"/>
      <xsl:apply-templates select="/" mode="M184"/>
      <xsl:apply-templates select="/" mode="M185"/>
      <xsl:apply-templates select="/" mode="M186"/>
      <xsl:apply-templates select="/" mode="M187"/>
      <xsl:apply-templates select="/" mode="M188"/>
      <xsl:apply-templates select="/" mode="M189"/>
      <xsl:apply-templates select="/" mode="M190"/>
      <xsl:apply-templates select="/" mode="M191"/>
      <xsl:apply-templates select="/" mode="M192"/>
      <xsl:apply-templates select="/" mode="M193"/>
      <xsl:apply-templates select="/" mode="M194"/>
      <xsl:apply-templates select="/" mode="M195"/>
      <xsl:apply-templates select="/" mode="M196"/>
      <xsl:apply-templates select="/" mode="M197"/>
      <xsl:apply-templates select="/" mode="M198"/>
      <xsl:apply-templates select="/" mode="M199"/>
      <xsl:apply-templates select="/" mode="M200"/>
      <xsl:apply-templates select="/" mode="M201"/>
      <xsl:apply-templates select="/" mode="M202"/>
      <xsl:apply-templates select="/" mode="M203"/>
      <xsl:apply-templates select="/" mode="M204"/>
      <xsl:apply-templates select="/" mode="M205"/>
      <xsl:apply-templates select="/" mode="M206"/>
      <xsl:apply-templates select="/" mode="M207"/>
      <xsl:apply-templates select="/" mode="M208"/>
      <xsl:apply-templates select="/" mode="M209"/>
      <xsl:apply-templates select="/" mode="M210"/>
      <xsl:apply-templates select="/" mode="M211"/>
      <xsl:apply-templates select="/" mode="M212"/>
      <xsl:apply-templates select="/" mode="M213"/>
      <xsl:apply-templates select="/" mode="M214"/>
      <xsl:apply-templates select="/" mode="M215"/>
      <xsl:apply-templates select="/" mode="M216"/>
      <xsl:apply-templates select="/" mode="M217"/>
      <xsl:apply-templates select="/" mode="M218"/>
      <xsl:apply-templates select="/" mode="M219"/>
      <xsl:apply-templates select="/" mode="M220"/>
      <xsl:apply-templates select="/" mode="M221"/>
      <xsl:apply-templates select="/" mode="M222"/>
      <xsl:apply-templates select="/" mode="M223"/>
      <xsl:apply-templates select="/" mode="M224"/>
      <xsl:apply-templates select="/" mode="M225"/>
      <xsl:apply-templates select="/" mode="M226"/>
      <xsl:apply-templates select="/" mode="M227"/>
      <xsl:apply-templates select="/" mode="M228"/>
      <xsl:apply-templates select="/" mode="M229"/>
      <xsl:apply-templates select="/" mode="M230"/>
      <xsl:apply-templates select="/" mode="M231"/>
      <xsl:apply-templates select="/" mode="M232"/>
      <xsl:apply-templates select="/" mode="M233"/>
      <xsl:apply-templates select="/" mode="M234"/>
      <xsl:apply-templates select="/" mode="M235"/>
      <xsl:apply-templates select="/" mode="M236"/>
      <xsl:apply-templates select="/" mode="M237"/>
      <xsl:apply-templates select="/" mode="M238"/>
      <xsl:apply-templates select="/" mode="M239"/>
      <xsl:apply-templates select="/" mode="M240"/>
      <xsl:apply-templates select="/" mode="M241"/>
      <xsl:apply-templates select="/" mode="M242"/>
      <xsl:apply-templates select="/" mode="M243"/>
      <xsl:apply-templates select="/" mode="M244"/>
      <xsl:apply-templates select="/" mode="M245"/>
      <xsl:apply-templates select="/" mode="M246"/>
      <xsl:apply-templates select="/" mode="M247"/>
      <xsl:apply-templates select="/" mode="M248"/>
      <xsl:apply-templates select="/" mode="M249"/>
      <xsl:apply-templates select="/" mode="M250"/>
      <xsl:apply-templates select="/" mode="M251"/>
      <xsl:apply-templates select="/" mode="M252"/>
      <xsl:apply-templates select="/" mode="M253"/>
      <xsl:apply-templates select="/" mode="M254"/>
      <xsl:apply-templates select="/" mode="M255"/>
      <xsl:apply-templates select="/" mode="M256"/>
      <xsl:apply-templates select="/" mode="M257"/>
      <xsl:apply-templates select="/" mode="M258"/>
      <xsl:apply-templates select="/" mode="M259"/>
      <xsl:apply-templates select="/" mode="M260"/>
      <xsl:apply-templates select="/" mode="M261"/>
      <xsl:apply-templates select="/" mode="M262"/>
      <xsl:apply-templates select="/" mode="M263"/>
      <xsl:apply-templates select="/" mode="M264"/>
      <xsl:apply-templates select="/" mode="M265"/>
      <xsl:apply-templates select="/" mode="M266"/>
      <xsl:apply-templates select="/" mode="M267"/>
      <xsl:apply-templates select="/" mode="M268"/>
      <xsl:apply-templates select="/" mode="M269"/>
      <xsl:apply-templates select="/" mode="M270"/>
      <xsl:apply-templates select="/" mode="M271"/>
      <xsl:apply-templates select="/" mode="M272"/>
      <xsl:apply-templates select="/" mode="M273"/>
      <xsl:apply-templates select="/" mode="M274"/>
      <xsl:apply-templates select="/" mode="M275"/>
      <xsl:apply-templates select="/" mode="M276"/>
      <xsl:apply-templates select="/" mode="M277"/>
      <xsl:apply-templates select="/" mode="M278"/>
      <xsl:apply-templates select="/" mode="M279"/>
      <xsl:apply-templates select="/" mode="M280"/>
      <xsl:apply-templates select="/" mode="M281"/>
      <xsl:apply-templates select="/" mode="M282"/>
      <xsl:apply-templates select="/" mode="M283"/>
      <xsl:apply-templates select="/" mode="M284"/>
      <xsl:apply-templates select="/" mode="M285"/>
      <xsl:apply-templates select="/" mode="M286"/>
      <xsl:apply-templates select="/" mode="M287"/>
      <xsl:apply-templates select="/" mode="M288"/>
      <xsl:apply-templates select="/" mode="M289"/>
      <xsl:apply-templates select="/" mode="M290"/>
      <xsl:apply-templates select="/" mode="M291"/>
      <xsl:apply-templates select="/" mode="M292"/>
      <xsl:apply-templates select="/" mode="M293"/>
      <xsl:apply-templates select="/" mode="M294"/>
      <xsl:apply-templates select="/" mode="M295"/>
      <xsl:apply-templates select="/" mode="M296"/>
      <xsl:apply-templates select="/" mode="M297"/>
      <xsl:apply-templates select="/" mode="M298"/>
      <xsl:apply-templates select="/" mode="M299"/>
      <xsl:apply-templates select="/" mode="M300"/>
      <xsl:apply-templates select="/" mode="M301"/>
      <xsl:apply-templates select="/" mode="M302"/>
      <xsl:apply-templates select="/" mode="M303"/>
      <xsl:apply-templates select="/" mode="M304"/>
      <xsl:apply-templates select="/" mode="M305"/>
      <xsl:apply-templates select="/" mode="M306"/>
      <xsl:apply-templates select="/" mode="M307"/>
      <xsl:apply-templates select="/" mode="M308"/>
      <xsl:apply-templates select="/" mode="M309"/>
      <xsl:apply-templates select="/" mode="M310"/>
      <xsl:apply-templates select="/" mode="M311"/>
      <xsl:apply-templates select="/" mode="M312"/>
      <xsl:apply-templates select="/" mode="M313"/>
      <xsl:apply-templates select="/" mode="M314"/>
      <xsl:apply-templates select="/" mode="M315"/>
      <xsl:apply-templates select="/" mode="M316"/>
      <xsl:apply-templates select="/" mode="M317"/>
      <xsl:apply-templates select="/" mode="M318"/>
      <xsl:apply-templates select="/" mode="M319"/>
      <xsl:apply-templates select="/" mode="M320"/>
      <xsl:apply-templates select="/" mode="M321"/>
      <xsl:apply-templates select="/" mode="M322"/>
      <xsl:apply-templates select="/" mode="M323"/>
      <xsl:apply-templates select="/" mode="M324"/>
      <xsl:apply-templates select="/" mode="M325"/>
      <xsl:apply-templates select="/" mode="M326"/>
      <xsl:apply-templates select="/" mode="M327"/>
      <xsl:apply-templates select="/" mode="M328"/>
      <xsl:apply-templates select="/" mode="M329"/>
      <xsl:apply-templates select="/" mode="M330"/>
      <xsl:apply-templates select="/" mode="M331"/>
      <xsl:apply-templates select="/" mode="M332"/>
      <xsl:apply-templates select="/" mode="M333"/>
   </xsl:template>
   <!--SCHEMATRON PATTERNS-->
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:ExchangedDocument/ram:EffectiveSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString"
                 priority="1000"
                 mode="M161">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M161"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M161"/>
   <xsl:template match="@*|node()" priority="-2" mode="M161">
      <xsl:apply-templates select="*" mode="M161"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:ExchangedDocument/ram:EffectiveSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString"
                 priority="1000"
                 mode="M162">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M162"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M162"/>
   <xsl:template match="@*|node()" priority="-2" mode="M162">
      <xsl:apply-templates select="*" mode="M162"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString"
                 priority="1000"
                 mode="M163">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M163"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M163"/>
   <xsl:template match="@*|node()" priority="-2" mode="M163">
      <xsl:apply-templates select="*" mode="M163"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter"
                 priority="1000"
                 mode="M164">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:ID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:ID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M164"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M164"/>
   <xsl:template match="@*|node()" priority="-2" mode="M164">
      <xsl:apply-templates select="*" mode="M164"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter"
                 priority="1000"
                 mode="M165">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:ID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:ID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M165"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M165"/>
   <xsl:template match="@*|node()" priority="-2" mode="M165">
      <xsl:apply-templates select="*" mode="M165"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement"
                 priority="1000"
                 mode="M166">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CatalogueReferencedDocument)&lt;=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CatalogueReferencedDocument' may occur at maximum 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M166"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M166"/>
   <xsl:template match="@*|node()" priority="-2" mode="M166">
      <xsl:apply-templates select="*" mode="M166"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument"
                 priority="1000"
                 mode="M167">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:Name)&lt;=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:Name' may occur at maximum 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M167"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M167"/>
   <xsl:template match="@*|node()" priority="-2" mode="M167">
      <xsl:apply-templates select="*" mode="M167"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument/ram:AttachmentBinaryObject"
                 priority="1000"
                 mode="M168">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@mimeCode"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@mimeCode' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@filename"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@filename' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M168"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M168"/>
   <xsl:template match="@*|node()" priority="-2" mode="M168">
      <xsl:apply-templates select="*" mode="M168"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString"
                 priority="1000"
                 mode="M169">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M169"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M169"/>
   <xsl:template match="@*|node()" priority="-2" mode="M169">
      <xsl:apply-templates select="*" mode="M169"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BlanketOrderReferencedDocument"
                 priority="1000"
                 mode="M170">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:IssuerAssignedID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:IssuerAssignedID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M170"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M170"/>
   <xsl:template match="@*|node()" priority="-2" mode="M170">
      <xsl:apply-templates select="*" mode="M170"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BlanketOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString"
                 priority="1000"
                 mode="M171">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M171"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M171"/>
   <xsl:template match="@*|node()" priority="-2" mode="M171">
      <xsl:apply-templates select="*" mode="M171"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication"
                 priority="1000"
                 mode="M172">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M172"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M172"/>
   <xsl:template match="@*|node()" priority="-2" mode="M172">
      <xsl:apply-templates select="*" mode="M172"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication"
                 priority="1000"
                 mode="M173">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M173"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M173"/>
   <xsl:template match="@*|node()" priority="-2" mode="M173">
      <xsl:apply-templates select="*" mode="M173"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication"
                 priority="1000"
                 mode="M174">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M174"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M174"/>
   <xsl:template match="@*|node()" priority="-2" mode="M174">
      <xsl:apply-templates select="*" mode="M174"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:GlobalID"
                 priority="1000"
                 mode="M175">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M175"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M175"/>
   <xsl:template match="@*|node()" priority="-2" mode="M175">
      <xsl:apply-templates select="*" mode="M175"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:SpecifiedTaxRegistration/ram:ID"
                 priority="1000"
                 mode="M176">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M176"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M176"/>
   <xsl:template match="@*|node()" priority="-2" mode="M176">
      <xsl:apply-templates select="*" mode="M176"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty/ram:URIUniversalCommunication"
                 priority="1000"
                 mode="M177">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M177"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M177"/>
   <xsl:template match="@*|node()" priority="-2" mode="M177">
      <xsl:apply-templates select="*" mode="M177"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument"
                 priority="1000"
                 mode="M178">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:IssuerAssignedID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:IssuerAssignedID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M178"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M178"/>
   <xsl:template match="@*|node()" priority="-2" mode="M178">
      <xsl:apply-templates select="*" mode="M178"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString"
                 priority="1000"
                 mode="M179">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M179"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M179"/>
   <xsl:template match="@*|node()" priority="-2" mode="M179">
      <xsl:apply-templates select="*" mode="M179"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerRequisitionerTradeParty"
                 priority="1000"
                 mode="M180">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:DefinedTradeContact)&lt;=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:DefinedTradeContact' may occur at maximum 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M180"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M180"/>
   <xsl:template match="@*|node()" priority="-2" mode="M180">
      <xsl:apply-templates select="*" mode="M180"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication"
                 priority="1000"
                 mode="M181">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M181"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M181"/>
   <xsl:template match="@*|node()" priority="-2" mode="M181">
      <xsl:apply-templates select="*" mode="M181"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication"
                 priority="1000"
                 mode="M182">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M182"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M182"/>
   <xsl:template match="@*|node()" priority="-2" mode="M182">
      <xsl:apply-templates select="*" mode="M182"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication"
                 priority="1000"
                 mode="M183">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M183"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M183"/>
   <xsl:template match="@*|node()" priority="-2" mode="M183">
      <xsl:apply-templates select="*" mode="M183"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:GlobalID"
                 priority="1000"
                 mode="M184">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M184"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M184"/>
   <xsl:template match="@*|node()" priority="-2" mode="M184">
      <xsl:apply-templates select="*" mode="M184"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:SpecifiedTaxRegistration/ram:ID"
                 priority="1000"
                 mode="M185">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M185"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M185"/>
   <xsl:template match="@*|node()" priority="-2" mode="M185">
      <xsl:apply-templates select="*" mode="M185"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:URIUniversalCommunication"
                 priority="1000"
                 mode="M186">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M186"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M186"/>
   <xsl:template match="@*|node()" priority="-2" mode="M186">
      <xsl:apply-templates select="*" mode="M186"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty"
                 priority="1000"
                 mode="M187">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:Name)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:Name' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:PostalTradeAddress)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:PostalTradeAddress' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M187"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M187"/>
   <xsl:template match="@*|node()" priority="-2" mode="M187">
      <xsl:apply-templates select="*" mode="M187"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication"
                 priority="1000"
                 mode="M188">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M188"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M188"/>
   <xsl:template match="@*|node()" priority="-2" mode="M188">
      <xsl:apply-templates select="*" mode="M188"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication"
                 priority="1000"
                 mode="M189">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M189"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M189"/>
   <xsl:template match="@*|node()" priority="-2" mode="M189">
      <xsl:apply-templates select="*" mode="M189"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication"
                 priority="1000"
                 mode="M190">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M190"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M190"/>
   <xsl:template match="@*|node()" priority="-2" mode="M190">
      <xsl:apply-templates select="*" mode="M190"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID"
                 priority="1000"
                 mode="M191">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M191"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M191"/>
   <xsl:template match="@*|node()" priority="-2" mode="M191">
      <xsl:apply-templates select="*" mode="M191"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration/ram:ID"
                 priority="1000"
                 mode="M192">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M192"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M192"/>
   <xsl:template match="@*|node()" priority="-2" mode="M192">
      <xsl:apply-templates select="*" mode="M192"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication"
                 priority="1000"
                 mode="M193">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M193"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M193"/>
   <xsl:template match="@*|node()" priority="-2" mode="M193">
      <xsl:apply-templates select="*" mode="M193"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:CatalogueReferencedDocument"
                 priority="1000"
                 mode="M194">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:IssuerAssignedID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:IssuerAssignedID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M194"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M194"/>
   <xsl:template match="@*|node()" priority="-2" mode="M194">
      <xsl:apply-templates select="*" mode="M194"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:CatalogueReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString"
                 priority="1000"
                 mode="M195">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M195"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M195"/>
   <xsl:template match="@*|node()" priority="-2" mode="M195">
      <xsl:apply-templates select="*" mode="M195"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument"
                 priority="1000"
                 mode="M196">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:IssuerAssignedID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:IssuerAssignedID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M196"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M196"/>
   <xsl:template match="@*|node()" priority="-2" mode="M196">
      <xsl:apply-templates select="*" mode="M196"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString"
                 priority="1000"
                 mode="M197">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M197"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M197"/>
   <xsl:template match="@*|node()" priority="-2" mode="M197">
      <xsl:apply-templates select="*" mode="M197"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:PreviousOrderChangeReferencedDocument"
                 priority="1000"
                 mode="M198">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:IssuerAssignedID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:IssuerAssignedID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M198"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M198"/>
   <xsl:template match="@*|node()" priority="-2" mode="M198">
      <xsl:apply-templates select="*" mode="M198"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:PreviousOrderChangeReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString"
                 priority="1000"
                 mode="M199">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M199"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M199"/>
   <xsl:template match="@*|node()" priority="-2" mode="M199">
      <xsl:apply-templates select="*" mode="M199"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:PreviousOrderReferencedDocument"
                 priority="1000"
                 mode="M200">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:IssuerAssignedID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:IssuerAssignedID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M200"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M200"/>
   <xsl:template match="@*|node()" priority="-2" mode="M200">
      <xsl:apply-templates select="*" mode="M200"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:PreviousOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString"
                 priority="1000"
                 mode="M201">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M201"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M201"/>
   <xsl:template match="@*|node()" priority="-2" mode="M201">
      <xsl:apply-templates select="*" mode="M201"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:PreviousOrderResponseReferencedDocument"
                 priority="1000"
                 mode="M202">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:IssuerAssignedID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:IssuerAssignedID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M202"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M202"/>
   <xsl:template match="@*|node()" priority="-2" mode="M202">
      <xsl:apply-templates select="*" mode="M202"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:PreviousOrderResponseReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString"
                 priority="1000"
                 mode="M203">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M203"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M203"/>
   <xsl:template match="@*|node()" priority="-2" mode="M203">
      <xsl:apply-templates select="*" mode="M203"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication"
                 priority="1000"
                 mode="M204">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M204"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M204"/>
   <xsl:template match="@*|node()" priority="-2" mode="M204">
      <xsl:apply-templates select="*" mode="M204"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication"
                 priority="1000"
                 mode="M205">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M205"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M205"/>
   <xsl:template match="@*|node()" priority="-2" mode="M205">
      <xsl:apply-templates select="*" mode="M205"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication"
                 priority="1000"
                 mode="M206">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M206"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M206"/>
   <xsl:template match="@*|node()" priority="-2" mode="M206">
      <xsl:apply-templates select="*" mode="M206"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:GlobalID"
                 priority="1000"
                 mode="M207">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M207"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M207"/>
   <xsl:template match="@*|node()" priority="-2" mode="M207">
      <xsl:apply-templates select="*" mode="M207"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:SpecifiedTaxRegistration/ram:ID"
                 priority="1000"
                 mode="M208">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M208"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M208"/>
   <xsl:template match="@*|node()" priority="-2" mode="M208">
      <xsl:apply-templates select="*" mode="M208"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty/ram:URIUniversalCommunication"
                 priority="1000"
                 mode="M209">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M209"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M209"/>
   <xsl:template match="@*|node()" priority="-2" mode="M209">
      <xsl:apply-templates select="*" mode="M209"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument"
                 priority="1000"
                 mode="M210">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:IssuerAssignedID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:IssuerAssignedID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M210"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M210"/>
   <xsl:template match="@*|node()" priority="-2" mode="M210">
      <xsl:apply-templates select="*" mode="M210"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString"
                 priority="1000"
                 mode="M211">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M211"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M211"/>
   <xsl:template match="@*|node()" priority="-2" mode="M211">
      <xsl:apply-templates select="*" mode="M211"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:RequisitionReferencedDocument"
                 priority="1000"
                 mode="M212">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:IssuerAssignedID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:IssuerAssignedID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M212"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M212"/>
   <xsl:template match="@*|node()" priority="-2" mode="M212">
      <xsl:apply-templates select="*" mode="M212"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:RequisitionReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString"
                 priority="1000"
                 mode="M213">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M213"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M213"/>
   <xsl:template match="@*|node()" priority="-2" mode="M213">
      <xsl:apply-templates select="*" mode="M213"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument"
                 priority="1000"
                 mode="M214">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:IssuerAssignedID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:IssuerAssignedID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M214"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M214"/>
   <xsl:template match="@*|node()" priority="-2" mode="M214">
      <xsl:apply-templates select="*" mode="M214"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString"
                 priority="1000"
                 mode="M215">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M215"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M215"/>
   <xsl:template match="@*|node()" priority="-2" mode="M215">
      <xsl:apply-templates select="*" mode="M215"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty"
                 priority="1000"
                 mode="M216">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:Name)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:Name' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M216"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M216"/>
   <xsl:template match="@*|node()" priority="-2" mode="M216">
      <xsl:apply-templates select="*" mode="M216"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication"
                 priority="1000"
                 mode="M217">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M217"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M217"/>
   <xsl:template match="@*|node()" priority="-2" mode="M217">
      <xsl:apply-templates select="*" mode="M217"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication"
                 priority="1000"
                 mode="M218">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M218"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M218"/>
   <xsl:template match="@*|node()" priority="-2" mode="M218">
      <xsl:apply-templates select="*" mode="M218"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication"
                 priority="1000"
                 mode="M219">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M219"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M219"/>
   <xsl:template match="@*|node()" priority="-2" mode="M219">
      <xsl:apply-templates select="*" mode="M219"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID"
                 priority="1000"
                 mode="M220">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M220"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M220"/>
   <xsl:template match="@*|node()" priority="-2" mode="M220">
      <xsl:apply-templates select="*" mode="M220"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID"
                 priority="1000"
                 mode="M221">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M221"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M221"/>
   <xsl:template match="@*|node()" priority="-2" mode="M221">
      <xsl:apply-templates select="*" mode="M221"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication"
                 priority="1000"
                 mode="M222">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M222"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M222"/>
   <xsl:template match="@*|node()" priority="-2" mode="M222">
      <xsl:apply-templates select="*" mode="M222"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument"
                 priority="1000"
                 mode="M223">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:IssuerAssignedID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:IssuerAssignedID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M223"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M223"/>
   <xsl:template match="@*|node()" priority="-2" mode="M223">
      <xsl:apply-templates select="*" mode="M223"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString"
                 priority="1000"
                 mode="M224">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M224"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M224"/>
   <xsl:template match="@*|node()" priority="-2" mode="M224">
      <xsl:apply-templates select="*" mode="M224"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery"
                 priority="1000"
                 mode="M225">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:PlannedDespatchSupplyChainEvent)&lt;=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:PlannedDespatchSupplyChainEvent' may occur at maximum 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:PlannedDeliverySupplyChainEvent)&lt;=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:PlannedDeliverySupplyChainEvent' may occur at maximum 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M225"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M225"/>
   <xsl:template match="@*|node()" priority="-2" mode="M225">
      <xsl:apply-templates select="*" mode="M225"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:RequestedDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString"
                 priority="1000"
                 mode="M226">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M226"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M226"/>
   <xsl:template match="@*|node()" priority="-2" mode="M226">
      <xsl:apply-templates select="*" mode="M226"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:RequestedDeliverySupplyChainEvent/ram:OccurrenceSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString"
                 priority="1000"
                 mode="M227">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M227"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M227"/>
   <xsl:template match="@*|node()" priority="-2" mode="M227">
      <xsl:apply-templates select="*" mode="M227"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:RequestedDeliverySupplyChainEvent/ram:OccurrenceSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString"
                 priority="1000"
                 mode="M228">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M228"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M228"/>
   <xsl:template match="@*|node()" priority="-2" mode="M228">
      <xsl:apply-templates select="*" mode="M228"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:RequestedDespatchSupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString"
                 priority="1000"
                 mode="M229">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M229"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M229"/>
   <xsl:template match="@*|node()" priority="-2" mode="M229">
      <xsl:apply-templates select="*" mode="M229"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:RequestedDespatchSupplyChainEvent/ram:OccurrenceSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString"
                 priority="1000"
                 mode="M230">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M230"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M230"/>
   <xsl:template match="@*|node()" priority="-2" mode="M230">
      <xsl:apply-templates select="*" mode="M230"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:RequestedDespatchSupplyChainEvent/ram:OccurrenceSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString"
                 priority="1000"
                 mode="M231">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M231"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M231"/>
   <xsl:template match="@*|node()" priority="-2" mode="M231">
      <xsl:apply-templates select="*" mode="M231"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty"
                 priority="1000"
                 mode="M232">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:Name)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:Name' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M232"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M232"/>
   <xsl:template match="@*|node()" priority="-2" mode="M232">
      <xsl:apply-templates select="*" mode="M232"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication"
                 priority="1000"
                 mode="M233">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M233"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M233"/>
   <xsl:template match="@*|node()" priority="-2" mode="M233">
      <xsl:apply-templates select="*" mode="M233"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication"
                 priority="1000"
                 mode="M234">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M234"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M234"/>
   <xsl:template match="@*|node()" priority="-2" mode="M234">
      <xsl:apply-templates select="*" mode="M234"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication"
                 priority="1000"
                 mode="M235">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M235"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M235"/>
   <xsl:template match="@*|node()" priority="-2" mode="M235">
      <xsl:apply-templates select="*" mode="M235"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:GlobalID"
                 priority="1000"
                 mode="M236">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M236"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M236"/>
   <xsl:template match="@*|node()" priority="-2" mode="M236">
      <xsl:apply-templates select="*" mode="M236"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:SpecifiedTaxRegistration/ram:ID"
                 priority="1000"
                 mode="M237">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M237"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M237"/>
   <xsl:template match="@*|node()" priority="-2" mode="M237">
      <xsl:apply-templates select="*" mode="M237"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty/ram:URIUniversalCommunication"
                 priority="1000"
                 mode="M238">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M238"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M238"/>
   <xsl:template match="@*|node()" priority="-2" mode="M238">
      <xsl:apply-templates select="*" mode="M238"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty"
                 priority="1000"
                 mode="M239">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:Name)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:Name' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:PostalTradeAddress)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:PostalTradeAddress' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M239"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M239"/>
   <xsl:template match="@*|node()" priority="-2" mode="M239">
      <xsl:apply-templates select="*" mode="M239"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication"
                 priority="1000"
                 mode="M240">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M240"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M240"/>
   <xsl:template match="@*|node()" priority="-2" mode="M240">
      <xsl:apply-templates select="*" mode="M240"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication"
                 priority="1000"
                 mode="M241">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M241"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M241"/>
   <xsl:template match="@*|node()" priority="-2" mode="M241">
      <xsl:apply-templates select="*" mode="M241"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication"
                 priority="1000"
                 mode="M242">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M242"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M242"/>
   <xsl:template match="@*|node()" priority="-2" mode="M242">
      <xsl:apply-templates select="*" mode="M242"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:GlobalID"
                 priority="1000"
                 mode="M243">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M243"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M243"/>
   <xsl:template match="@*|node()" priority="-2" mode="M243">
      <xsl:apply-templates select="*" mode="M243"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedTaxRegistration/ram:ID"
                 priority="1000"
                 mode="M244">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M244"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M244"/>
   <xsl:template match="@*|node()" priority="-2" mode="M244">
      <xsl:apply-templates select="*" mode="M244"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication"
                 priority="1000"
                 mode="M245">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M245"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M245"/>
   <xsl:template match="@*|node()" priority="-2" mode="M245">
      <xsl:apply-templates select="*" mode="M245"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty"
                 priority="1000"
                 mode="M246">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:Name)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:Name' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M246"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M246"/>
   <xsl:template match="@*|node()" priority="-2" mode="M246">
      <xsl:apply-templates select="*" mode="M246"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication"
                 priority="1000"
                 mode="M247">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M247"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M247"/>
   <xsl:template match="@*|node()" priority="-2" mode="M247">
      <xsl:apply-templates select="*" mode="M247"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication"
                 priority="1000"
                 mode="M248">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M248"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M248"/>
   <xsl:template match="@*|node()" priority="-2" mode="M248">
      <xsl:apply-templates select="*" mode="M248"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication"
                 priority="1000"
                 mode="M249">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M249"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M249"/>
   <xsl:template match="@*|node()" priority="-2" mode="M249">
      <xsl:apply-templates select="*" mode="M249"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:GlobalID"
                 priority="1000"
                 mode="M250">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M250"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M250"/>
   <xsl:template match="@*|node()" priority="-2" mode="M250">
      <xsl:apply-templates select="*" mode="M250"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedTaxRegistration/ram:ID"
                 priority="1000"
                 mode="M251">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M251"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M251"/>
   <xsl:template match="@*|node()" priority="-2" mode="M251">
      <xsl:apply-templates select="*" mode="M251"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty/ram:URIUniversalCommunication"
                 priority="1000"
                 mode="M252">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M252"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M252"/>
   <xsl:template match="@*|node()" priority="-2" mode="M252">
      <xsl:apply-templates select="*" mode="M252"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement"
                 priority="1000"
                 mode="M253">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:PurchaseSpecifiedTradeAccountingAccount)&lt;=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:PurchaseSpecifiedTradeAccountingAccount' may occur at maximum 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M253"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M253"/>
   <xsl:template match="@*|node()" priority="-2" mode="M253">
      <xsl:apply-templates select="*" mode="M253"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax"
                 priority="1000"
                 mode="M254">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CalculatedAmount)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CalculatedAmount' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:BasisAmount)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:BasisAmount' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M254"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M254"/>
   <xsl:template match="@*|node()" priority="-2" mode="M254">
      <xsl:apply-templates select="*" mode="M254"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty"
                 priority="1000"
                 mode="M255">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:Name)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:Name' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M255"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M255"/>
   <xsl:template match="@*|node()" priority="-2" mode="M255">
      <xsl:apply-templates select="*" mode="M255"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication"
                 priority="1000"
                 mode="M256">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M256"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M256"/>
   <xsl:template match="@*|node()" priority="-2" mode="M256">
      <xsl:apply-templates select="*" mode="M256"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication"
                 priority="1000"
                 mode="M257">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M257"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M257"/>
   <xsl:template match="@*|node()" priority="-2" mode="M257">
      <xsl:apply-templates select="*" mode="M257"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication"
                 priority="1000"
                 mode="M258">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M258"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M258"/>
   <xsl:template match="@*|node()" priority="-2" mode="M258">
      <xsl:apply-templates select="*" mode="M258"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:GlobalID"
                 priority="1000"
                 mode="M259">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M259"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M259"/>
   <xsl:template match="@*|node()" priority="-2" mode="M259">
      <xsl:apply-templates select="*" mode="M259"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:SpecifiedTaxRegistration/ram:ID"
                 priority="1000"
                 mode="M260">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M260"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M260"/>
   <xsl:template match="@*|node()" priority="-2" mode="M260">
      <xsl:apply-templates select="*" mode="M260"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty/ram:URIUniversalCommunication"
                 priority="1000"
                 mode="M261">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M261"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M261"/>
   <xsl:template match="@*|node()" priority="-2" mode="M261">
      <xsl:apply-templates select="*" mode="M261"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty"
                 priority="1000"
                 mode="M262">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:Name)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:Name' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M262"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M262"/>
   <xsl:template match="@*|node()" priority="-2" mode="M262">
      <xsl:apply-templates select="*" mode="M262"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication"
                 priority="1000"
                 mode="M263">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M263"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M263"/>
   <xsl:template match="@*|node()" priority="-2" mode="M263">
      <xsl:apply-templates select="*" mode="M263"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication"
                 priority="1000"
                 mode="M264">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M264"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M264"/>
   <xsl:template match="@*|node()" priority="-2" mode="M264">
      <xsl:apply-templates select="*" mode="M264"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication"
                 priority="1000"
                 mode="M265">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M265"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M265"/>
   <xsl:template match="@*|node()" priority="-2" mode="M265">
      <xsl:apply-templates select="*" mode="M265"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:GlobalID"
                 priority="1000"
                 mode="M266">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M266"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M266"/>
   <xsl:template match="@*|node()" priority="-2" mode="M266">
      <xsl:apply-templates select="*" mode="M266"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:SpecifiedTaxRegistration/ram:ID"
                 priority="1000"
                 mode="M267">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M267"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M267"/>
   <xsl:template match="@*|node()" priority="-2" mode="M267">
      <xsl:apply-templates select="*" mode="M267"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty/ram:URIUniversalCommunication"
                 priority="1000"
                 mode="M268">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M268"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M268"/>
   <xsl:template match="@*|node()" priority="-2" mode="M268">
      <xsl:apply-templates select="*" mode="M268"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms"
                 priority="1000"
                 mode="M269">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:Description)&gt;=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:Description' must occur at least 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M269"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M269"/>
   <xsl:template match="@*|node()" priority="-2" mode="M269">
      <xsl:apply-templates select="*" mode="M269"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount"
                 priority="1000"
                 mode="M270">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@currencyID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@currencyID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M270"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M270"/>
   <xsl:template match="@*|node()" priority="-2" mode="M270">
      <xsl:apply-templates select="*" mode="M270"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement"
                 priority="1000"
                 mode="M271">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:BuyerReference)&lt;=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:BuyerReference' may occur at maximum 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:RequisitionReferencedDocument)&lt;=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:RequisitionReferencedDocument' may occur at maximum 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:GrossPriceProductTradePrice)&lt;=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:GrossPriceProductTradePrice' may occur at maximum 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M271"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M271"/>
   <xsl:template match="@*|node()" priority="-2" mode="M271">
      <xsl:apply-templates select="*" mode="M271"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument"
                 priority="1000"
                 mode="M272">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:Name)&lt;=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:Name' may occur at maximum 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M272"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M272"/>
   <xsl:template match="@*|node()" priority="-2" mode="M272">
      <xsl:apply-templates select="*" mode="M272"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument/ram:AttachmentBinaryObject"
                 priority="1000"
                 mode="M273">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@mimeCode"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@mimeCode' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@filename"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@filename' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M273"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M273"/>
   <xsl:template match="@*|node()" priority="-2" mode="M273">
      <xsl:apply-templates select="*" mode="M273"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:AdditionalReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString"
                 priority="1000"
                 mode="M274">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M274"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M274"/>
   <xsl:template match="@*|node()" priority="-2" mode="M274">
      <xsl:apply-templates select="*" mode="M274"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BlanketOrderReferencedDocument"
                 priority="1000"
                 mode="M275">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:LineID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:LineID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M275"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M275"/>
   <xsl:template match="@*|node()" priority="-2" mode="M275">
      <xsl:apply-templates select="*" mode="M275"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerOrderReferencedDocument"
                 priority="1000"
                 mode="M276">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:LineID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:LineID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M276"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M276"/>
   <xsl:template match="@*|node()" priority="-2" mode="M276">
      <xsl:apply-templates select="*" mode="M276"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerRequisitionerTradeParty"
                 priority="1000"
                 mode="M277">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:DefinedTradeContact)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:DefinedTradeContact' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M277"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M277"/>
   <xsl:template match="@*|node()" priority="-2" mode="M277">
      <xsl:apply-templates select="*" mode="M277"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication"
                 priority="1000"
                 mode="M278">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M278"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M278"/>
   <xsl:template match="@*|node()" priority="-2" mode="M278">
      <xsl:apply-templates select="*" mode="M278"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication"
                 priority="1000"
                 mode="M279">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M279"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M279"/>
   <xsl:template match="@*|node()" priority="-2" mode="M279">
      <xsl:apply-templates select="*" mode="M279"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication"
                 priority="1000"
                 mode="M280">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M280"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M280"/>
   <xsl:template match="@*|node()" priority="-2" mode="M280">
      <xsl:apply-templates select="*" mode="M280"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:BuyerRequisitionerTradeParty/ram:GlobalID"
                 priority="1000"
                 mode="M281">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M281"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M281"/>
   <xsl:template match="@*|node()" priority="-2" mode="M281">
      <xsl:apply-templates select="*" mode="M281"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:CatalogueReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString"
                 priority="1000"
                 mode="M282">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M282"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M282"/>
   <xsl:template match="@*|node()" priority="-2" mode="M282">
      <xsl:apply-templates select="*" mode="M282"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ContractReferencedDocument"
                 priority="1000"
                 mode="M283">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:IssuerAssignedID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:IssuerAssignedID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M283"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M283"/>
   <xsl:template match="@*|node()" priority="-2" mode="M283">
      <xsl:apply-templates select="*" mode="M283"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:ContractReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString"
                 priority="1000"
                 mode="M284">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M284"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M284"/>
   <xsl:template match="@*|node()" priority="-2" mode="M284">
      <xsl:apply-templates select="*" mode="M284"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:NetPriceProductTradePrice/ram:BasisQuantity"
                 priority="1000"
                 mode="M285">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@unitCode"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@unitCode' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M285"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M285"/>
   <xsl:template match="@*|node()" priority="-2" mode="M285">
      <xsl:apply-templates select="*" mode="M285"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:QuotationReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString"
                 priority="1000"
                 mode="M286">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M286"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M286"/>
   <xsl:template match="@*|node()" priority="-2" mode="M286">
      <xsl:apply-templates select="*" mode="M286"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeAgreement/ram:UltimateCustomerOrderReferencedDocument/ram:FormattedIssueDateTime/qdt:DateTimeString"
                 priority="1000"
                 mode="M287">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M287"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M287"/>
   <xsl:template match="@*|node()" priority="-2" mode="M287">
      <xsl:apply-templates select="*" mode="M287"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:AgreedQuantity"
                 priority="1000"
                 mode="M288">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@unitCode"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@unitCode' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M288"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M288"/>
   <xsl:template match="@*|node()" priority="-2" mode="M288">
      <xsl:apply-templates select="*" mode="M288"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString"
                 priority="1000"
                 mode="M289">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M289"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M289"/>
   <xsl:template match="@*|node()" priority="-2" mode="M289">
      <xsl:apply-templates select="*" mode="M289"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedDeliverySupplyChainEvent/ram:OccurrenceSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString"
                 priority="1000"
                 mode="M290">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M290"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M290"/>
   <xsl:template match="@*|node()" priority="-2" mode="M290">
      <xsl:apply-templates select="*" mode="M290"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedDeliverySupplyChainEvent/ram:OccurrenceSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString"
                 priority="1000"
                 mode="M291">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M291"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M291"/>
   <xsl:template match="@*|node()" priority="-2" mode="M291">
      <xsl:apply-templates select="*" mode="M291"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedDeliverySupplyChainEvent/ram:UnitQuantity"
                 priority="1000"
                 mode="M292">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@unitCode"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@unitCode' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M292"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M292"/>
   <xsl:template match="@*|node()" priority="-2" mode="M292">
      <xsl:apply-templates select="*" mode="M292"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedDespatchSupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString"
                 priority="1000"
                 mode="M293">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M293"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M293"/>
   <xsl:template match="@*|node()" priority="-2" mode="M293">
      <xsl:apply-templates select="*" mode="M293"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedDespatchSupplyChainEvent/ram:OccurrenceSpecifiedPeriod/ram:EndDateTime/udt:DateTimeString"
                 priority="1000"
                 mode="M294">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M294"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M294"/>
   <xsl:template match="@*|node()" priority="-2" mode="M294">
      <xsl:apply-templates select="*" mode="M294"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedDespatchSupplyChainEvent/ram:OccurrenceSpecifiedPeriod/ram:StartDateTime/udt:DateTimeString"
                 priority="1000"
                 mode="M295">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@format"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@format' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M295"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M295"/>
   <xsl:template match="@*|node()" priority="-2" mode="M295">
      <xsl:apply-templates select="*" mode="M295"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedDespatchSupplyChainEvent/ram:UnitQuantity"
                 priority="1000"
                 mode="M296">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@unitCode"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@unitCode' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M296"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M296"/>
   <xsl:template match="@*|node()" priority="-2" mode="M296">
      <xsl:apply-templates select="*" mode="M296"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:RequestedQuantity"
                 priority="1000"
                 mode="M297">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@unitCode"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@unitCode' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M297"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M297"/>
   <xsl:template match="@*|node()" priority="-2" mode="M297">
      <xsl:apply-templates select="*" mode="M297"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipFromTradeParty"
                 priority="1000"
                 mode="M298">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:Name)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:Name' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M298"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M298"/>
   <xsl:template match="@*|node()" priority="-2" mode="M298">
      <xsl:apply-templates select="*" mode="M298"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication"
                 priority="1000"
                 mode="M299">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M299"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M299"/>
   <xsl:template match="@*|node()" priority="-2" mode="M299">
      <xsl:apply-templates select="*" mode="M299"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication"
                 priority="1000"
                 mode="M300">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M300"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M300"/>
   <xsl:template match="@*|node()" priority="-2" mode="M300">
      <xsl:apply-templates select="*" mode="M300"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipFromTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication"
                 priority="1000"
                 mode="M301">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M301"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M301"/>
   <xsl:template match="@*|node()" priority="-2" mode="M301">
      <xsl:apply-templates select="*" mode="M301"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipFromTradeParty/ram:GlobalID"
                 priority="1000"
                 mode="M302">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M302"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M302"/>
   <xsl:template match="@*|node()" priority="-2" mode="M302">
      <xsl:apply-templates select="*" mode="M302"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipFromTradeParty/ram:SpecifiedTaxRegistration/ram:ID"
                 priority="1000"
                 mode="M303">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M303"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M303"/>
   <xsl:template match="@*|node()" priority="-2" mode="M303">
      <xsl:apply-templates select="*" mode="M303"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipFromTradeParty/ram:URIUniversalCommunication"
                 priority="1000"
                 mode="M304">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M304"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M304"/>
   <xsl:template match="@*|node()" priority="-2" mode="M304">
      <xsl:apply-templates select="*" mode="M304"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty"
                 priority="1000"
                 mode="M305">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:Name)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:Name' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M305"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M305"/>
   <xsl:template match="@*|node()" priority="-2" mode="M305">
      <xsl:apply-templates select="*" mode="M305"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication"
                 priority="1000"
                 mode="M306">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M306"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M306"/>
   <xsl:template match="@*|node()" priority="-2" mode="M306">
      <xsl:apply-templates select="*" mode="M306"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication"
                 priority="1000"
                 mode="M307">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M307"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M307"/>
   <xsl:template match="@*|node()" priority="-2" mode="M307">
      <xsl:apply-templates select="*" mode="M307"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication"
                 priority="1000"
                 mode="M308">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M308"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M308"/>
   <xsl:template match="@*|node()" priority="-2" mode="M308">
      <xsl:apply-templates select="*" mode="M308"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:GlobalID"
                 priority="1000"
                 mode="M309">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M309"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M309"/>
   <xsl:template match="@*|node()" priority="-2" mode="M309">
      <xsl:apply-templates select="*" mode="M309"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:SpecifiedTaxRegistration/ram:ID"
                 priority="1000"
                 mode="M310">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M310"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M310"/>
   <xsl:template match="@*|node()" priority="-2" mode="M310">
      <xsl:apply-templates select="*" mode="M310"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:ShipToTradeParty/ram:URIUniversalCommunication"
                 priority="1000"
                 mode="M311">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M311"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M311"/>
   <xsl:template match="@*|node()" priority="-2" mode="M311">
      <xsl:apply-templates select="*" mode="M311"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty"
                 priority="1000"
                 mode="M312">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:Name)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:Name' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:PostalTradeAddress)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:PostalTradeAddress' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M312"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M312"/>
   <xsl:template match="@*|node()" priority="-2" mode="M312">
      <xsl:apply-templates select="*" mode="M312"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:EmailURIUniversalCommunication"
                 priority="1000"
                 mode="M313">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M313"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M313"/>
   <xsl:template match="@*|node()" priority="-2" mode="M313">
      <xsl:apply-templates select="*" mode="M313"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:FaxUniversalCommunication"
                 priority="1000"
                 mode="M314">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M314"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M314"/>
   <xsl:template match="@*|node()" priority="-2" mode="M314">
      <xsl:apply-templates select="*" mode="M314"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:DefinedTradeContact/ram:TelephoneUniversalCommunication"
                 priority="1000"
                 mode="M315">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:CompleteNumber)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:CompleteNumber' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M315"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M315"/>
   <xsl:template match="@*|node()" priority="-2" mode="M315">
      <xsl:apply-templates select="*" mode="M315"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:GlobalID"
                 priority="1000"
                 mode="M316">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M316"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M316"/>
   <xsl:template match="@*|node()" priority="-2" mode="M316">
      <xsl:apply-templates select="*" mode="M316"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:SpecifiedTaxRegistration/ram:ID"
                 priority="1000"
                 mode="M317">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M317"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M317"/>
   <xsl:template match="@*|node()" priority="-2" mode="M317">
      <xsl:apply-templates select="*" mode="M317"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeDelivery/ram:UltimateShipToTradeParty/ram:URIUniversalCommunication"
                 priority="1000"
                 mode="M318">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:URIID)=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:URIID' must occur exactly 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M318"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M318"/>
   <xsl:template match="@*|node()" priority="-2" mode="M318">
      <xsl:apply-templates select="*" mode="M318"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedLineTradeSettlement"
                 priority="1000"
                 mode="M319">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:ApplicableTradeTax)&lt;=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:ApplicableTradeTax' may occur at maximum 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M319"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M319"/>
   <xsl:template match="@*|node()" priority="-2" mode="M319">
      <xsl:apply-templates select="*" mode="M319"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct"
                 priority="1000"
                 mode="M320">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:ManufacturerAssignedID)&lt;=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:ManufacturerAssignedID' may occur at maximum 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:GrossWeightMeasure)&lt;=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:GrossWeightMeasure' may occur at maximum 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:ApplicableSupplyChainPackaging)&lt;=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:ApplicableSupplyChainPackaging' may occur at maximum 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:OriginTradeCountry)&lt;=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:OriginTradeCountry' may occur at maximum 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:LinearSpatialDimension)&lt;=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:LinearSpatialDimension' may occur at maximum 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:MinimumLinearSpatialDimension)&lt;=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:MinimumLinearSpatialDimension' may occur at maximum 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:MaximumLinearSpatialDimension)&lt;=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:MaximumLinearSpatialDimension' may occur at maximum 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:ManufacturerTradeParty)&lt;=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:ManufacturerTradeParty' may occur at maximum 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:MSDSReferenceReferencedDocument)&lt;=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:MSDSReferenceReferencedDocument' may occur at maximum 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M320"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M320"/>
   <xsl:template match="@*|node()" priority="-2" mode="M320">
      <xsl:apply-templates select="*" mode="M320"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:AdditionalReferenceReferencedDocument"
                 priority="1000"
                 mode="M321">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:Name)&lt;=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:Name' may occur at maximum 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M321"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M321"/>
   <xsl:template match="@*|node()" priority="-2" mode="M321">
      <xsl:apply-templates select="*" mode="M321"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:AdditionalReferenceReferencedDocument/ram:AttachmentBinaryObject"
                 priority="1000"
                 mode="M322">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@mimeCode"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@mimeCode' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@filename"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@filename' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M322"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M322"/>
   <xsl:template match="@*|node()" priority="-2" mode="M322">
      <xsl:apply-templates select="*" mode="M322"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableSupplyChainPackaging/ram:LinearSpatialDimension/ram:HeightMeasure"
                 priority="1000"
                 mode="M323">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@unitCode"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@unitCode' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M323"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M323"/>
   <xsl:template match="@*|node()" priority="-2" mode="M323">
      <xsl:apply-templates select="*" mode="M323"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableSupplyChainPackaging/ram:LinearSpatialDimension/ram:LengthMeasure"
                 priority="1000"
                 mode="M324">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@unitCode"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@unitCode' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M324"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M324"/>
   <xsl:template match="@*|node()" priority="-2" mode="M324">
      <xsl:apply-templates select="*" mode="M324"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:ApplicableSupplyChainPackaging/ram:LinearSpatialDimension/ram:WidthMeasure"
                 priority="1000"
                 mode="M325">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@unitCode"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@unitCode' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M325"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M325"/>
   <xsl:template match="@*|node()" priority="-2" mode="M325">
      <xsl:apply-templates select="*" mode="M325"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:DesignatedProductClassification/ram:ClassCode"
                 priority="1000"
                 mode="M326">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@listID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@listID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M326"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M326"/>
   <xsl:template match="@*|node()" priority="-2" mode="M326">
      <xsl:apply-templates select="*" mode="M326"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:GlobalID"
                 priority="1000"
                 mode="M327">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M327"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M327"/>
   <xsl:template match="@*|node()" priority="-2" mode="M327">
      <xsl:apply-templates select="*" mode="M327"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IncludedReferencedProduct/ram:GlobalID"
                 priority="1000"
                 mode="M328">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M328"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M328"/>
   <xsl:template match="@*|node()" priority="-2" mode="M328">
      <xsl:apply-templates select="*" mode="M328"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SpecifiedTradeProduct/ram:IncludedReferencedProduct/ram:UnitQuantity"
                 priority="1000"
                 mode="M329">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@unitCode"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@unitCode' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M329"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M329"/>
   <xsl:template match="@*|node()" priority="-2" mode="M329">
      <xsl:apply-templates select="*" mode="M329"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SubstitutedReferencedProduct"
                 priority="1000"
                 mode="M330">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="count(ram:ManufacturerAssignedID)&lt;=1"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Element 'ram:ManufacturerAssignedID' may occur at maximum 1 times.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M330"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M330"/>
   <xsl:template match="@*|node()" priority="-2" mode="M330">
      <xsl:apply-templates select="*" mode="M330"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="/rsm:SCRDMCCBDACIOMessageStructure/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem/ram:SubstitutedReferencedProduct/ram:GlobalID"
                 priority="1000"
                 mode="M331">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="@schemeID"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Attribute '@schemeID' is required in this context.</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M331"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M331"/>
   <xsl:template match="@*|node()" priority="-2" mode="M331">
      <xsl:apply-templates select="*" mode="M331"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="ram:SpecifiedTradeAllowanceCharge/ram:ReasonCode"
                 priority="1000"
                 mode="M332">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="((../ram:ChargeIndicator/udt:Indicator = 'true') or ((../ram:ChargeIndicator/udt:Indicator = 'false') and (not(contains(normalize-space(.), ' ')) and contains(' 41 42 60 62 63 64 65 66 67 68 70 71 88 95 100 102 103 104 ', concat(' ', normalize-space(.), ' ')))))"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Coded allowance reasons MUST belong to the UNCL 5189 code list</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="((../ram:ChargeIndicator/udt:Indicator = 'false') or ((../ram:ChargeIndicator/udt:Indicator = 'true') and (not(contains(normalize-space(.), ' ')) and contains(' AA AAA AAC AAD AAE AAF AAH AAI AAS AAT AAV AAY AAZ ABA ABB ABC ABD ABF ABK ABL ABN ABR ABS ABT ABU ACF ACG ACH ACI ACJ ACK ACL ACM ACS ADC ADE ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADT ADW ADY ADZ AEA AEB AEC AED AEF AEH AEI AEJ AEK AEL AEM AEN AEO AEP AES AET AEU AEV AEW AEX AEY AEZ AJ AU CA CAB CAD CAE CAF CAI CAJ CAK CAL CAM CAN CAO CAP CAQ CAR CAS CAT CAU CAV CAW CAX CAY CAZ CD CG CS CT DAB DAD DAC DAF DAG DAH DAI DAJ DAK DAL DAM DAN DAO DAP DAQ DL EG EP ER FAA FAB FAC FC FH FI GAA HAA HD HH IAA IAB ID IF IR IS KO L1 LA LAA LAB LF MAE MI ML NAA OA PA PAA PC PL RAB RAC RAD RAF RE RF RH RV SA SAA SAD SAE SAI SG SH SM SU TAB TAC TT TV V1 V2 WH XAA YY ZZZ ', concat(' ', normalize-space(.), ' ')))))"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Coded charge reasons MUST belong to the UNCL 7161 code list</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M332"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M332"/>
   <xsl:template match="@*|node()" priority="-2" mode="M332">
      <xsl:apply-templates select="*" mode="M332"/>
   </xsl:template>
   <!--PATTERN -->
   <!--RULE -->
   <xsl:template match="ram:AppliedTradeAllowanceCharge/ram:ReasonCode"
                 priority="1000"
                 mode="M333">

		<!--ASSERT -->
      <xsl:choose>
         <xsl:when test="((../ram:ChargeIndicator/udt:Indicator = 'true') or ((../ram:ChargeIndicator/udt:Indicator = 'false') and (not(contains(normalize-space(.), ' ')) and contains(' 41 42 60 62 63 64 65 66 67 68 70 71 88 95 100 102 103 104 ', concat(' ', normalize-space(.), ' ')))))"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Coded allowance reasons MUST belong to the UNCL 5189 code list</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <!--ASSERT -->
      <xsl:choose>
         <xsl:when test="((../ram:ChargeIndicator/udt:Indicator = 'false') or ((../ram:ChargeIndicator/udt:Indicator = 'true') and (not(contains(normalize-space(.), ' ')) and contains(' AA AAA AAC AAD AAE AAF AAH AAI AAS AAT AAV AAY AAZ ABA ABB ABC ABD ABF ABK ABL ABN ABR ABS ABT ABU ACF ACG ACH ACI ACJ ACK ACL ACM ACS ADC ADE ADJ ADK ADL ADM ADN ADO ADP ADQ ADR ADT ADW ADY ADZ AEA AEB AEC AED AEF AEH AEI AEJ AEK AEL AEM AEN AEO AEP AES AET AEU AEV AEW AEX AEY AEZ AJ AU CA CAB CAD CAE CAF CAI CAJ CAK CAL CAM CAN CAO CAP CAQ CAR CAS CAT CAU CAV CAW CAX CAY CAZ CD CG CS CT DAB DAD DAC DAF DAG DAH DAI DAJ DAK DAL DAM DAN DAO DAP DAQ DL EG EP ER FAA FAB FAC FC FH FI GAA HAA HD HH IAA IAB ID IF IR IS KO L1 LA LAA LAB LF MAE MI ML NAA OA PA PAA PC PL RAB RAC RAD RAF RE RF RH RV SA SAA SAD SAE SAI SG SH SM SU TAB TAC TT TV V1 V2 WH XAA YY ZZZ ', concat(' ', normalize-space(.), ' ')))))"/>
         <xsl:otherwise>
            <xsl:message xmlns:iso="http://purl.oclc.org/dsdl/schematron">
               <xsl:text> Coded charge reasons MUST belong to the UNCL 7161 code list</xsl:text>
            </xsl:message>
         </xsl:otherwise>
      </xsl:choose>
      <xsl:apply-templates select="*" mode="M333"/>
   </xsl:template>
   <xsl:template match="text()" priority="-1" mode="M333"/>
   <xsl:template match="@*|node()" priority="-2" mode="M333">
      <xsl:apply-templates select="*" mode="M333"/>
   </xsl:template>
</xsl:stylesheet>
