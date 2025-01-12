<?xml version="1.0" encoding="UTF-8"?>
<pattern xmlns="http://purl.oclc.org/dsdl/schematron" id="variable-pattern">
    <!-- This pattern solely serves for declaring global variables (in XSLT speak) -->
    
    <let name="XR-MAJOR-MINOR-VERSION" value="'2.1'"/>
    <let name="XR-CIUS-ID" value="concat('urn:cen.eu:en16931:2017#compliant#urn:xoev-de:kosit:standard:xrechnung_', $XR-MAJOR-MINOR-VERSION )"/>
    <let name="XR-EXTENSION-ID" value="concat($XR-CIUS-ID, '#conformant#urn:xoev-de:kosit:extension:xrechnung_' ,$XR-MAJOR-MINOR-VERSION )"/>
    <let name="XR-SKONTO-REGEX"  value="'#(SKONTO|VERZUG)#TAGE=([0-9]+#PROZENT=[0-9]+\.[0-9]{2})(#BASISBETRAG=-?[0-9]+\.[0-9]{2})?#$'" />
    <let name="BT-81" value="'rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeSettlement/ram:SpecifiedTradeSettlementPaymentMeans/ram:TypeCode'"/>
</pattern>
