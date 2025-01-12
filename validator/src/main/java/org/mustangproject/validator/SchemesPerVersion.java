package org.mustangproject.validator;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;

public class SchemesPerVersion {
    protected static final Map<EVersion, String> mapOfSchemesPerVersion = createMapOfSchemesPerVersion();

    private SchemesPerVersion() {
        throw new IllegalStateException("SchemesPerVersion is an utility class.");
    }

    private static Map<EVersion, String> createMapOfSchemesPerVersion() {
        Map<EVersion, String> rv = new LinkedHashMap<>();
        rv.put(EVersion.OX_10_BASIC, "orderx10en/Order-X100_EN/04-XSD-UML-SCHEMATRON/Basic/XSD/SCRDMCCBDACIOMessageStructure_100pD20B.xsd");
        rv.put(EVersion.OX_10_COMFORT, "orderx10en/Order-X100_EN/04-XSD-UML-SCHEMATRON/Comfort/XSD/SCRDMCCBDACIOMessageStructure_100pD20B.xsd");
        rv.put(EVersion.OX_10_EXTENDED, "orderx10en/Order-X100_EN/04-XSD-UML-SCHEMATRON/Extended/XSD/SCRDMCCBDACIOMessageStructure_100pD20B.xsd");
        rv.put(EVersion.UBL_24_CREDIT_NOTE, "UBL-2.4/xsdrt/maindoc/UBL-CreditNote-2.4.xsd");
        rv.put(EVersion.UBL_24_INVOICE, "UBL-2.4/xsdrt/maindoc/UBL-Invoice-2.4.xsd");
        rv.put(EVersion.ZF_10, "zugferd10-en/Schema/ZUGFeRD1p0.xsd");
        rv.put(EVersion.ZF_23_MINIMUM, "ZF232_EN/Schema/0. Factur-X_1.07.2_MINIMUM/Factur-X_1.07.2_MINIMUM.xsd");
        rv.put(EVersion.ZF_23_BASIC_WL, "ZF232_EN/Schema/1. Factur-X_1.07.2_BASICWL/Factur-X_1.07.2_BASICWL.xsd");
        rv.put(EVersion.ZF_23_BASIC, "ZF232_EN/Schema/2. Factur-X_1.07.2_BASIC/Factur-X_1.07.2_BASIC.xsd");
        rv.put(EVersion.ZF_23_EN16931, "ZF232_EN/Schema/3. Factur-X_1.07.2_EN16931/Factur-X_1.07.2_EN16931.xsd");
        rv.put(EVersion.ZF_23_EXTENDED, "ZF232_EN/Schema/4. Factur-X_1.07.2_EXTENDED/Factur-X_1.07.2_EXTENDED.xsd");
        return Collections.unmodifiableMap(rv);
    }
}
