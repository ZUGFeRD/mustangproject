<?xml version="1.0" encoding="UTF-8"?>

<schema xmlns="http://purl.oclc.org/dsdl/schematron"
    xmlns:rsm="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100"
    xmlns:ccts="urn:un:unece:uncefact:documentation:standard:CoreComponentsTechnicalSpecification:2"
    xmlns:udt="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100"
    xmlns:qdt="urn:un:unece:uncefact:data:standard:QualifiedDataType:100"
    xmlns:ram="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100"
    schemaVersion="2.0.0" queryBinding="xslt2">
    <title>Schematron Version 1.3.0 - XRechnung
        1.2.2 compatible - CII</title>
    <ns prefix="rsm"
        uri="urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100" />
    <ns prefix="ccts"
        uri="urn:un:unece:uncefact:documentation:standard:CoreComponentsTechnicalSpecification:2" />
    <ns prefix="udt"
        uri="urn:un:unece:uncefact:data:standard:UnqualifiedDataType:100" />
    <ns prefix="qdt"
        uri="urn:un:unece:uncefact:data:standard:QualifiedDataType:100" />
    <ns prefix="ram"
        uri="urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100" />
    
    <phase id="XRechnung_model">
        <active pattern="CII-model" />
    </phase>

    <!-- Abstract CEN BII patterns -->
    <!-- ========================= -->
    <!-- in the original these includes are mistakenly called .sch but that has to be changed manually
    since they are no complete schematrons which otherwise conflicts with ph-schematron -->
    <include href="abstract/XRechnung-model.part" />

    <!-- Data Binding parameters -->
    <!-- ======================= -->
    <include href="CII/XRechnung-CII-model.part" />


</schema>
