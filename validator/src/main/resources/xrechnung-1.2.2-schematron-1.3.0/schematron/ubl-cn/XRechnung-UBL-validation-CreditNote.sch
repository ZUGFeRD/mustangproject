<?xml version="1.0" encoding="UTF-8"?>

<schema xmlns="http://purl.oclc.org/dsdl/schematron"
    xmlns:cbc="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2"
    xmlns:cac="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2"
    queryBinding="xslt2">
    <title>Schematron Version 1.3.0 - XRechnung 1.2.2 compatible - UBL - CreditNote</title>
    <ns prefix="cbc"
        uri="urn:oasis:names:specification:ubl:schema:xsd:CommonBasicComponents-2" />
    <ns prefix="cac"
        uri="urn:oasis:names:specification:ubl:schema:xsd:CommonAggregateComponents-2" />
    <ns prefix="ext"
        uri="urn:oasis:names:specification:ubl:schema:xsd:CommonExtensionComponents-2" />
    <ns prefix="ubl"
        uri="urn:oasis:names:specification:ubl:schema:xsd:CreditNote-2" />
    <ns prefix="xs" uri="http://www.w3.org/2001/XMLSchema" />
    
    <phase id="XRechnung_model">
        <active pattern="UBL-model" />
    </phase>

    <!-- Abstract CEN BII patterns -->
    <!-- ========================= -->
    <include href="abstract/XRechnung-model.sch" />

    <!-- Data Binding parameters -->
    <!-- ======================= -->
    <include href="UBL/XRechnung-UBL-model.sch" />

</schema>
