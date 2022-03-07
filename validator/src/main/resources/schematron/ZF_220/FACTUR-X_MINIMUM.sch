<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
    schemaVersion="iso">
  <title>Schema for FACTUR-X; 1.0; ACCOUNTING INFORMATION, No XML Invoice, (MINIMUM)</title>
  <ns uri="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100" prefix="rsm"/>
  <ns uri="urn:un:unece:uncefact:data:standard:QualifiedDataType:100" prefix="qdt"/>
  <ns uri="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100" prefix="ram"/>
  <ns uri="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100" prefix="udt"/>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument">
      <assert test="count(ram:TypeCode)=1">
	Element 'ram:TypeCode' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:CategoryCode">
      <report test="true()">
	Element 'ram:CategoryCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ControlRequirementIndicator">
      <report test="true()">
	Element 'ram:ControlRequirementIndicator' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:CopyIndicator">
      <report test="true()">
	Element 'ram:CopyIndicator' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:EffectiveSpecifiedPeriod">
      <report test="true()">
	Element 'ram:EffectiveSpecifiedPeriod' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:GlobalID">
      <report test="true()">
	Element 'ram:GlobalID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID[@schemeID]">
      <report test="true()">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:ID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IncludedNote">
      <report test="true()">
	Element 'ram:IncludedNote' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTime">
      <report test="true()">
	Element 'udt:DateTime' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IssueDateTime/udt:DateTimeString[@format]">
      <let name="codeValue2" value="@format"/>
      <assert test="document(&apos;FACTUR-X_MINIMUM_codedb.xml&apos;)//cl[@id=2]/enumeration[@value=$codeValue2]">
	Value of '@format' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:IssuerTradeParty">
      <report test="true()">
	Element 'ram:IssuerTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:LanguageID">
      <report test="true()">
	Element 'ram:LanguageID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:PreviousRevisionID">
      <report test="true()">
	Element 'ram:PreviousRevisionID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:Purpose">
      <report test="true()">
	Element 'ram:Purpose' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:PurposeCode">
      <report test="true()">
	Element 'ram:PurposeCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:RevisionDateTime">
      <report test="true()">
	Element 'ram:RevisionDateTime' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:RevisionID">
      <report test="true()">
	Element 'ram:RevisionID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode">
      <let name="codeValue1" value="."/>
      <assert test="document(&apos;FACTUR-X_MINIMUM_codedb.xml&apos;)//cl[@id=1]/enumeration[@value=$codeValue1]">
	Value of 'ram:TypeCode' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode[@listAgencyID]">
      <report test="true()">
	Attribute @listAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode[@listID]">
      <report test="true()">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode[@listURI]">
      <report test="true()">
	Attribute @listURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode[@listVersionID]">
      <report test="true()">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:TypeCode[@name]">
      <report test="true()">
	Attribute @name' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocument/ram:VersionID">
      <report test="true()">
	Element 'ram:VersionID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext">
      <assert test="count(ram:BusinessProcessSpecifiedDocumentContextParameter)&lt;=1">
	Element 'ram:BusinessProcessSpecifiedDocumentContextParameter' may occur at maximum 1 times.</assert>
      <assert test="count(ram:GuidelineSpecifiedDocumentContextParameter)=1">
	Element 'ram:GuidelineSpecifiedDocumentContextParameter' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:ApplicationSpecifiedDocumentContextParameter">
      <report test="true()">
	Element 'ram:ApplicationSpecifiedDocumentContextParameter' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BIMSpecifiedDocumentContextParameter">
      <report test="true()">
	Element 'ram:BIMSpecifiedDocumentContextParameter' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID[@schemeID]">
      <report test="true()">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:ID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:SpecifiedDocumentVersion">
      <report test="true()">
	Element 'ram:SpecifiedDocumentVersion' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:BusinessProcessSpecifiedDocumentContextParameter/ram:Value">
      <report test="true()">
	Element 'ram:Value' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID[@schemeID]">
      <report test="true()">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:ID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:SpecifiedDocumentVersion">
      <report test="true()">
	Element 'ram:SpecifiedDocumentVersion' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:GuidelineSpecifiedDocumentContextParameter/ram:Value">
      <report test="true()">
	Element 'ram:Value' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:MessageStandardSpecifiedDocumentContextParameter">
      <report test="true()">
	Element 'ram:MessageStandardSpecifiedDocumentContextParameter' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:ScenarioSpecifiedDocumentContextParameter">
      <report test="true()">
	Element 'ram:ScenarioSpecifiedDocumentContextParameter' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:SpecifiedTransactionID">
      <report test="true()">
	Element 'ram:SpecifiedTransactionID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:SubsetSpecifiedDocumentContextParameter">
      <report test="true()">
	Element 'ram:SubsetSpecifiedDocumentContextParameter' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ExchangedDocumentContext/ram:TestIndicator">
      <report test="true()">
	Element 'ram:TestIndicator' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement">
      <assert test="count(ram:SellerTradeParty)=1">
	Element 'ram:SellerTradeParty' must occur exactly 1 times.</assert>
      <assert test="count(ram:BuyerTradeParty)=1">
	Element 'ram:BuyerTradeParty' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:AdditionalReferencedDocument">
      <report test="true()">
	Element 'ram:AdditionalReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ApplicableTradeDeliveryTerms">
      <report test="true()">
	Element 'ram:ApplicableTradeDeliveryTerms' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAgentTradeParty">
      <report test="true()">
	Element 'ram:BuyerAgentTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerAssignedAccountantTradeParty">
      <report test="true()">
	Element 'ram:BuyerAssignedAccountantTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument">
      <assert test="count(ram:IssuerAssignedID)=1">
	Element 'ram:IssuerAssignedID' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:AttachedSpecifiedBinaryFile">
      <report test="true()">
	Element 'ram:AttachedSpecifiedBinaryFile' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:AttachmentBinaryObject">
      <report test="true()">
	Element 'ram:AttachmentBinaryObject' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:CopyIndicator">
      <report test="true()">
	Element 'ram:CopyIndicator' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:EffectiveSpecifiedPeriod">
      <report test="true()">
	Element 'ram:EffectiveSpecifiedPeriod' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:FormattedIssueDateTime">
      <report test="true()">
	Element 'ram:FormattedIssueDateTime' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:GlobalID">
      <report test="true()">
	Element 'ram:GlobalID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:Information">
      <report test="true()">
	Element 'ram:Information' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID[@schemeID]">
      <report test="true()">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerAssignedID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:IssuerTradeParty">
      <report test="true()">
	Element 'ram:IssuerTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:LineID">
      <report test="true()">
	Element 'ram:LineID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:PreviousRevisionID">
      <report test="true()">
	Element 'ram:PreviousRevisionID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:ReferenceTypeCode">
      <report test="true()">
	Element 'ram:ReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:RevisionID">
      <report test="true()">
	Element 'ram:RevisionID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:SectionName">
      <report test="true()">
	Element 'ram:SectionName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:StatusCode">
      <report test="true()">
	Element 'ram:StatusCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:TypeCode">
      <report test="true()">
	Element 'ram:TypeCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerOrderReferencedDocument/ram:URIID">
      <report test="true()">
	Element 'ram:URIID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerReference[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerReference[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerRequisitionerTradeParty">
      <report test="true()">
	Element 'ram:BuyerRequisitionerTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTaxRepresentativeTradeParty">
      <report test="true()">
	Element 'ram:BuyerTaxRepresentativeTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty">
      <assert test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:DefinedTradeContact">
      <report test="true()">
	Element 'ram:DefinedTradeContact' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:EndPointURIUniversalCommunication">
      <report test="true()">
	Element 'ram:EndPointURIUniversalCommunication' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:GlobalID">
      <report test="true()">
	Element 'ram:GlobalID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:ID">
      <report test="true()">
	Element 'ram:ID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:LogoAssociatedSpecifiedBinaryFile">
      <report test="true()">
	Element 'ram:LogoAssociatedSpecifiedBinaryFile' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:Name[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:Name[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:PostalTradeAddress">
      <report test="true()">
	Element 'ram:PostalTradeAddress' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:RoleCode">
      <report test="true()">
	Element 'ram:RoleCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:AuthorizedLegalRegistration">
      <report test="true()">
	Element 'ram:AuthorizedLegalRegistration' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeID]">
      <let name="codeValue5" value="@schemeID"/>
      <assert test="document(&apos;FACTUR-X_MINIMUM_codedb.xml&apos;)//cl[@id=5]/enumeration[@value=$codeValue5]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:LegalClassificationCode">
      <report test="true()">
	Element 'ram:LegalClassificationCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <report test="true()">
	Element 'ram:PostalTradeAddress' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedLegalOrganization/ram:TradingBusinessName">
      <report test="true()">
	Element 'ram:TradingBusinessName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:SpecifiedTaxRegistration">
      <report test="true()">
	Element 'ram:SpecifiedTaxRegistration' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:BuyerTradeParty/ram:URIUniversalCommunication">
      <report test="true()">
	Element 'ram:URIUniversalCommunication' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ContractReferencedDocument">
      <report test="true()">
	Element 'ram:ContractReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:DemandForecastReferencedDocument">
      <report test="true()">
	Element 'ram:DemandForecastReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:OrderResponseReferencedDocument">
      <report test="true()">
	Element 'ram:OrderResponseReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:PriceListReferencedDocument">
      <report test="true()">
	Element 'ram:PriceListReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:ProductEndUserTradeParty">
      <report test="true()">
	Element 'ram:ProductEndUserTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:PromotionalDealReferencedDocument">
      <report test="true()">
	Element 'ram:PromotionalDealReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:PurchaseConditionsReferencedDocument">
      <report test="true()">
	Element 'ram:PurchaseConditionsReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:QuotationReferencedDocument">
      <report test="true()">
	Element 'ram:QuotationReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:Reference">
      <report test="true()">
	Element 'ram:Reference' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:RequisitionerReferencedDocument">
      <report test="true()">
	Element 'ram:RequisitionerReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SalesAgentTradeParty">
      <report test="true()">
	Element 'ram:SalesAgentTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerAssignedAccountantTradeParty">
      <report test="true()">
	Element 'ram:SellerAssignedAccountantTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerOrderReferencedDocument">
      <report test="true()">
	Element 'ram:SellerOrderReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTaxRepresentativeTradeParty">
      <report test="true()">
	Element 'ram:SellerTaxRepresentativeTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty">
      <assert test="count(ram:Name)=1">
	Element 'ram:Name' must occur exactly 1 times.</assert>
      <assert test="count(ram:PostalTradeAddress)=1">
	Element 'ram:PostalTradeAddress' must occur exactly 1 times.</assert>
      <assert test="count(ram:SpecifiedTaxRegistration)&lt;=2">
	Element 'ram:SpecifiedTaxRegistration' may occur at maximum 2 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:DefinedTradeContact">
      <report test="true()">
	Element 'ram:DefinedTradeContact' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:Description">
      <report test="true()">
	Element 'ram:Description' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:EndPointURIUniversalCommunication">
      <report test="true()">
	Element 'ram:EndPointURIUniversalCommunication' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:GlobalID">
      <report test="true()">
	Element 'ram:GlobalID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:ID">
      <report test="true()">
	Element 'ram:ID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:LogoAssociatedSpecifiedBinaryFile">
      <report test="true()">
	Element 'ram:LogoAssociatedSpecifiedBinaryFile' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:Name[@languageID]">
      <report test="true()">
	Attribute @languageID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:Name[@languageLocaleID]">
      <report test="true()">
	Attribute @languageLocaleID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress">
      <assert test="count(ram:CountryID)=1">
	Element 'ram:CountryID' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:AdditionalStreetName">
      <report test="true()">
	Element 'ram:AdditionalStreetName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:AttentionOf">
      <report test="true()">
	Element 'ram:AttentionOf' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:BuildingName">
      <report test="true()">
	Element 'ram:BuildingName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:BuildingNumber">
      <report test="true()">
	Element 'ram:BuildingNumber' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CareOf">
      <report test="true()">
	Element 'ram:CareOf' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CityName">
      <report test="true()">
	Element 'ram:CityName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CitySubDivisionName">
      <report test="true()">
	Element 'ram:CitySubDivisionName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID[@schemeID]">
      <report test="true()">
	Attribute @schemeID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountryName">
      <report test="true()">
	Element 'ram:CountryName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountrySubDivisionID">
      <report test="true()">
	Element 'ram:CountrySubDivisionID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:CountrySubDivisionName">
      <report test="true()">
	Element 'ram:CountrySubDivisionName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:DepartmentName">
      <report test="true()">
	Element 'ram:DepartmentName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:ID">
      <report test="true()">
	Element 'ram:ID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:LineFive">
      <report test="true()">
	Element 'ram:LineFive' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:LineFour">
      <report test="true()">
	Element 'ram:LineFour' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:LineOne">
      <report test="true()">
	Element 'ram:LineOne' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:LineThree">
      <report test="true()">
	Element 'ram:LineThree' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:LineTwo">
      <report test="true()">
	Element 'ram:LineTwo' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:PostOfficeBox">
      <report test="true()">
	Element 'ram:PostOfficeBox' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:PostcodeCode">
      <report test="true()">
	Element 'ram:PostcodeCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:PostalTradeAddress/ram:StreetName">
      <report test="true()">
	Element 'ram:StreetName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:RoleCode">
      <report test="true()">
	Element 'ram:RoleCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:AuthorizedLegalRegistration">
      <report test="true()">
	Element 'ram:AuthorizedLegalRegistration' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeID]">
      <let name="codeValue3" value="@schemeID"/>
      <assert test="document(&apos;FACTUR-X_MINIMUM_codedb.xml&apos;)//cl[@id=3]/enumeration[@value=$codeValue3]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:ID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:LegalClassificationCode">
      <report test="true()">
	Element 'ram:LegalClassificationCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:Name">
      <report test="true()">
	Element 'ram:Name' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:PostalTradeAddress">
      <report test="true()">
	Element 'ram:PostalTradeAddress' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedLegalOrganization/ram:TradingBusinessName">
      <report test="true()">
	Element 'ram:TradingBusinessName' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration">
      <assert test="count(ram:ID)=1">
	Element 'ram:ID' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:AssociatedRegisteredTax">
      <report test="true()">
	Element 'ram:AssociatedRegisteredTax' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID">
      <assert test="@schemeID">
	Attribute '@schemeID' is required in this context.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeAgencyID]">
      <report test="true()">
	Attribute @schemeAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeAgencyName]">
      <report test="true()">
	Attribute @schemeAgencyName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeDataURI]">
      <report test="true()">
	Attribute @schemeDataURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeID]">
      <let name="codeValue4" value="@schemeID"/>
      <assert test="document(&apos;FACTUR-X_MINIMUM_codedb.xml&apos;)//cl[@id=4]/enumeration[@value=$codeValue4]">
	Value of '@schemeID' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeName]">
      <report test="true()">
	Attribute @schemeName' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeURI]">
      <report test="true()">
	Attribute @schemeURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:SpecifiedTaxRegistration/ram:ID[@schemeVersionID]">
      <report test="true()">
	Attribute @schemeVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SellerTradeParty/ram:URIUniversalCommunication">
      <report test="true()">
	Element 'ram:URIUniversalCommunication' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SpecifiedProcuringProject">
      <report test="true()">
	Element 'ram:SpecifiedProcuringProject' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:SupplyInstructionReferencedDocument">
      <report test="true()">
	Element 'ram:SupplyInstructionReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeAgreement/ram:UltimateCustomerOrderReferencedDocument">
      <report test="true()">
	Element 'ram:UltimateCustomerOrderReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent">
      <report test="true()">
	Element 'ram:ActualDeliverySupplyChainEvent' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDespatchSupplyChainEvent">
      <report test="true()">
	Element 'ram:ActualDespatchSupplyChainEvent' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualPickUpSupplyChainEvent">
      <report test="true()">
	Element 'ram:ActualPickUpSupplyChainEvent' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualReceiptSupplyChainEvent">
      <report test="true()">
	Element 'ram:ActualReceiptSupplyChainEvent' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:AdditionalReferencedDocument">
      <report test="true()">
	Element 'ram:AdditionalReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ConsumptionReportReferencedDocument">
      <report test="true()">
	Element 'ram:ConsumptionReportReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DeliveryNoteReferencedDocument">
      <report test="true()">
	Element 'ram:DeliveryNoteReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:DespatchAdviceReferencedDocument">
      <report test="true()">
	Element 'ram:DespatchAdviceReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:PackingListReferencedDocument">
      <report test="true()">
	Element 'ram:PackingListReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:PreviousDeliverySupplyChainEvent">
      <report test="true()">
	Element 'ram:PreviousDeliverySupplyChainEvent' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ReceivingAdviceReferencedDocument">
      <report test="true()">
	Element 'ram:ReceivingAdviceReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:RelatedSupplyChainConsignment">
      <report test="true()">
	Element 'ram:RelatedSupplyChainConsignment' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipFromTradeParty">
      <report test="true()">
	Element 'ram:ShipFromTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ShipToTradeParty">
      <report test="true()">
	Element 'ram:ShipToTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:UltimateShipToTradeParty">
      <report test="true()">
	Element 'ram:UltimateShipToTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement">
      <assert test="count(ram:InvoiceCurrencyCode)=1">
	Element 'ram:InvoiceCurrencyCode' must occur exactly 1 times.</assert>
      <assert test="count(ram:SpecifiedTradeSettlementHeaderMonetarySummation)=1">
	Element 'ram:SpecifiedTradeSettlementHeaderMonetarySummation' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ApplicableTradeTax">
      <report test="true()">
	Element 'ram:ApplicableTradeTax' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:BillingSpecifiedPeriod">
      <report test="true()">
	Element 'ram:BillingSpecifiedPeriod' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditReason">
      <report test="true()">
	Element 'ram:CreditReason' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditReasonCode">
      <report test="true()">
	Element 'ram:CreditReasonCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceID">
      <report test="true()">
	Element 'ram:CreditorReferenceID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceIssuerID">
      <report test="true()">
	Element 'ram:CreditorReferenceIssuerID' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceType">
      <report test="true()">
	Element 'ram:CreditorReferenceType' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:CreditorReferenceTypeCode">
      <report test="true()">
	Element 'ram:CreditorReferenceTypeCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:DuePayableAmount">
      <report test="true()">
	Element 'ram:DuePayableAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:FactoringAgreementReferencedDocument">
      <report test="true()">
	Element 'ram:FactoringAgreementReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:FactoringListReferencedDocument">
      <report test="true()">
	Element 'ram:FactoringListReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceApplicableTradeCurrencyExchange">
      <report test="true()">
	Element 'ram:InvoiceApplicableTradeCurrencyExchange' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode[@listAgencyID]">
      <report test="true()">
	Attribute @listAgencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode[@listID]">
      <report test="true()">
	Attribute @listID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode[@listURI]">
      <report test="true()">
	Attribute @listURI' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceCurrencyCode[@listVersionID]">
      <report test="true()">
	Attribute @listVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceDateTime">
      <report test="true()">
	Element 'ram:InvoiceDateTime' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceIssuerReference">
      <report test="true()">
	Element 'ram:InvoiceIssuerReference' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceReferencedDocument">
      <report test="true()">
	Element 'ram:InvoiceReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoiceeTradeParty">
      <report test="true()">
	Element 'ram:InvoiceeTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:InvoicerTradeParty">
      <report test="true()">
	Element 'ram:InvoicerTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:LetterOfCreditReferencedDocument">
      <report test="true()">
	Element 'ram:LetterOfCreditReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:NextInvoiceDateTime">
      <report test="true()">
	Element 'ram:NextInvoiceDateTime' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayableSpecifiedTradeAccountingAccount">
      <report test="true()">
	Element 'ram:PayableSpecifiedTradeAccountingAccount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayeeTradeParty">
      <report test="true()">
	Element 'ram:PayeeTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PayerTradeParty">
      <report test="true()">
	Element 'ram:PayerTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PaymentApplicableTradeCurrencyExchange">
      <report test="true()">
	Element 'ram:PaymentApplicableTradeCurrencyExchange' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PaymentCurrencyCode">
      <report test="true()">
	Element 'ram:PaymentCurrencyCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PaymentReference">
      <report test="true()">
	Element 'ram:PaymentReference' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ProFormaInvoiceReferencedDocument">
      <report test="true()">
	Element 'ram:ProFormaInvoiceReferencedDocument' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:PurchaseSpecifiedTradeAccountingAccount">
      <report test="true()">
	Element 'ram:PurchaseSpecifiedTradeAccountingAccount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:ReceivableSpecifiedTradeAccountingAccount">
      <report test="true()">
	Element 'ram:ReceivableSpecifiedTradeAccountingAccount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SalesSpecifiedTradeAccountingAccount">
      <report test="true()">
	Element 'ram:SalesSpecifiedTradeAccountingAccount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedAdvancePayment">
      <report test="true()">
	Element 'ram:SpecifiedAdvancePayment' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedFinancialAdjustment">
      <report test="true()">
	Element 'ram:SpecifiedFinancialAdjustment' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedLogisticsServiceCharge">
      <report test="true()">
	Element 'ram:SpecifiedLogisticsServiceCharge' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeAllowanceCharge">
      <report test="true()">
	Element 'ram:SpecifiedTradeAllowanceCharge' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradePaymentTerms">
      <report test="true()">
	Element 'ram:SpecifiedTradePaymentTerms' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementFinancialCard">
      <report test="true()">
	Element 'ram:SpecifiedTradeSettlementFinancialCard' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation">
      <assert test="count(ram:TaxBasisTotalAmount)=1">
	Element 'ram:TaxBasisTotalAmount' must occur exactly 1 times.</assert>
      <assert test="count(ram:TaxTotalAmount)&lt;=1">
	Element 'ram:TaxTotalAmount' may occur at maximum 1 times.</assert>
      <assert test="count(ram:GrandTotalAmount)=1">
	Element 'ram:GrandTotalAmount' must occur exactly 1 times.</assert>
      <assert test="count(ram:DuePayableAmount)=1">
	Element 'ram:DuePayableAmount' must occur exactly 1 times.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:AllowanceTotalAmount">
      <report test="true()">
	Element 'ram:AllowanceTotalAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:ChargeTotalAmount">
      <report test="true()">
	Element 'ram:ChargeTotalAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:DuePayableAmount[@currencyCodeListVersionID]">
      <report test="true()">
	Attribute @currencyCodeListVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:DuePayableAmount[@currencyID]">
      <report test="true()">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:GrandTotalAmount[@currencyCodeListVersionID]">
      <report test="true()">
	Attribute @currencyCodeListVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:GrandTotalAmount[@currencyID]">
      <report test="true()">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:GrossLineTotalAmount">
      <report test="true()">
	Element 'ram:GrossLineTotalAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:InformationAmount">
      <report test="true()">
	Element 'ram:InformationAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:LineTotalAmount">
      <report test="true()">
	Element 'ram:LineTotalAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:NetIncludingTaxesLineTotalAmount">
      <report test="true()">
	Element 'ram:NetIncludingTaxesLineTotalAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:NetLineTotalAmount">
      <report test="true()">
	Element 'ram:NetLineTotalAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:ProductValueExcludingTobaccoTaxInformationAmount">
      <report test="true()">
	Element 'ram:ProductValueExcludingTobaccoTaxInformationAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:RetailValueExcludingTaxInformationAmount">
      <report test="true()">
	Element 'ram:RetailValueExcludingTaxInformationAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:RoundingAmount">
      <report test="true()">
	Element 'ram:RoundingAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxBasisTotalAmount[@currencyCodeListVersionID]">
      <report test="true()">
	Attribute @currencyCodeListVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxBasisTotalAmount[@currencyID]">
      <report test="true()">
	Attribute @currencyID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyCodeListVersionID]">
      <report test="true()">
	Attribute @currencyCodeListVersionID' marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TaxTotalAmount[@currencyID]">
      <let name="codeValue6" value="@currencyID"/>
      <assert test="document(&apos;FACTUR-X_MINIMUM_codedb.xml&apos;)//cl[@id=6]/enumeration[@value=$codeValue6]">
	Value of '@currencyID' is not allowed.</assert>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TotalAllowanceChargeAmount">
      <report test="true()">
	Element 'ram:TotalAllowanceChargeAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TotalDepositFeeInformationAmount">
      <report test="true()">
	Element 'ram:TotalDepositFeeInformationAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TotalDiscountAmount">
      <report test="true()">
	Element 'ram:TotalDiscountAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TotalPrepaidAmount">
      <report test="true()">
	Element 'ram:TotalPrepaidAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementHeaderMonetarySummation/ram:TotalRetailValueInformationAmount">
      <report test="true()">
	Element 'ram:TotalRetailValueInformationAmount' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans">
      <report test="true()">
	Element 'ram:SpecifiedTradeSettlementPaymentMeans' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SubtotalCalculatedTradeTax">
      <report test="true()">
	Element 'ram:SubtotalCalculatedTradeTax' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxApplicableTradeCurrencyExchange">
      <report test="true()">
	Element 'ram:TaxApplicableTradeCurrencyExchange' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:TaxCurrencyCode">
      <report test="true()">
	Element 'ram:TaxCurrencyCode' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:UltimatePayeeTradeParty">
      <report test="true()">
	Element 'ram:UltimatePayeeTradeParty' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:IncludedSupplyChainTradeLineItem">
      <report test="true()">
	Element 'ram:IncludedSupplyChainTradeLineItem' is marked as not used in the given context.</report>
    </rule>
  </pattern>
  <pattern>
    <rule context="/rsm:CrossIndustryInvoice/rsm:ValuationBreakdownStatement">
      <report test="true()">
	Element 'rsm:ValuationBreakdownStatement' is marked as not used in the given context.</report>
    </rule>
  </pattern>
</schema>
