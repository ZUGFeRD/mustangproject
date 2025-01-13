package org.mustangproject.validator;

import java.util.Collections;
import java.util.LinkedHashMap;
import java.util.Map;

public class ScriptsPerVersion {
	public static final Map<EVersion, String> mapOfScriptsPerVersion = createMapOfScriptsPerVersion();

	private ScriptsPerVersion() {
		throw new IllegalStateException("ScriptsPerVersion is an utility class.");
	}

	private static Map<EVersion, String> createMapOfScriptsPerVersion() {
		Map<EVersion, String> rv = new LinkedHashMap<>();
		rv.put(EVersion.EN16931_CII, "en16931-cii-1.3.13/xslt/EN16931-CII-validation.xslt");
		rv.put(EVersion.EN16931_UBL, "en16931-ubl-1.3.13/xslt/EN16931-UBL-validation.xslt");
		rv.put(EVersion.OX_10_BASIC, "orderx10en/Order-X100_EN/04-XSD-UML-SCHEMATRON/Basic/Schematron/SCRDMCCBDACIOMessageStructure_100pD20B_BASIC.xslt");
		rv.put(EVersion.OX_10_COMFORT, "orderx10en/Order-X100_EN/04-XSD-UML-SCHEMATRON/Comfort/Schematron/SCRDMCCBDACIOMessageStructure_100pD20B_COMFORT.xslt");
		rv.put(EVersion.OX_10_EXTENDED, "orderx10en/Order-X100_EN/04-XSD-UML-SCHEMATRON/Extended/Schematron/SCRDMCCBDACIOMessageStructure_100pD20B_EXTENDED.xslt");
		rv.put(EVersion.XR_12_CII, "xrechnung-1.2.2-schematron-1.3.0/schematron/cii/XRechnung-CII-validation.xslt");
		rv.put(EVersion.XR_12_UBL_CREDIT_NOTE, "xrechnung-1.2.2-schematron-1.3.0/schematron/ubl-cn/XRechnung-UBL-validation-CreditNote.xslt");
		rv.put(EVersion.XR_12_UBL_INVOICE, "xrechnung-1.2.2-schematron-1.3.0/schematron/ubl-inv/XRechnung-UBL-validation-Invoice.xslt");
		rv.put(EVersion.XR_20_CII, "xrechnung-2.0.1-schematron-1.5.0/schematron/cii/XRechnung-CII-validation.xslt");
		rv.put(EVersion.XR_20_UBL_CREDIT_NOTE, "xrechnung-2.0.1-schematron-1.5.0/schematron/ubl-cn/XRechnung-UBL-validation-CreditNote.xslt");
		rv.put(EVersion.XR_20_UBL_INVOICE, "xrechnung-2.0.1-schematron-1.5.0/schematron/ubl-inv/XRechnung-UBL-validation-Invoice.xslt");
		rv.put(EVersion.XR_21_CII, "xrechnung-2.1.1-schematron-1.6.1/schematron/cii/XRechnung-CII-validation.xslt");
		rv.put(EVersion.XR_21_UBL_CREDIT_NOTE, "xrechnung-2.1.1-schematron-1.6.1/schematron/ubl-cn/XRechnung-UBL-validation-CreditNote.xslt");
		rv.put(EVersion.XR_21_UBL_INVOICE, "xrechnung-2.1.1-schematron-1.6.1/schematron/ubl-inv/XRechnung-UBL-validation-Invoice.xslt");
		rv.put(EVersion.XR_22_CII, "xrechnung-2.2.0-schematron-1.7.3/schematron/cii/XRechnung-CII-validation.xslt");
		rv.put(EVersion.XR_22_UBL_CREDIT_NOTE, "xrechnung-2.2.0-schematron-1.7.3/schematron/ubl-cn/XRechnung-UBL-validation-CreditNote.xslt");
		rv.put(EVersion.XR_22_UBL_INVOICE, "xrechnung-2.2.0-schematron-1.7.3/schematron/ubl-inv/XRechnung-UBL-validation-Invoice.xslt");
		rv.put(EVersion.XR_23_CII, "xrechnung-2.3.1-schematron-1.8.2/schematron/cii/XRechnung-CII-validation.xslt");
		rv.put(EVersion.XR_23_UBL, "xrechnung-2.3.1-schematron-1.8.2/schematron/ubl/XRechnung-UBL-validation.xslt");
		rv.put(EVersion.XR_30_CII, "xrechnung-3.0.2-schematron-2.1.0/schematron/cii/XRechnung-CII-validation.xslt");
		rv.put(EVersion.XR_30_UBL, "xrechnung-3.0.2-schematron-2.1.0/schematron/ubl/XRechnung-UBL-validation.xslt");
		/* New (needs to be checked): */
		// rv.put(Versions.XR_30_CII, "xrechnung-3.0.2-schematron-2.2.0/schematron/cii/XRechnung-CII-validation.xslt")
		// rv.put(Versions.XR_30_UBL, "xrechnung-3.0.2-schematron-2.2.0/schematron/ubl/XRechnung-UBL-validation.xslt")
		rv.put(EVersion.ZF_10, "zugferd10-en/Schema/ZUGFeRD_1p0.xslt");
		rv.put(EVersion.ZF_23_MINIMUM, "ZF232_EN/Schema/0. Factur-X_1.07.2_MINIMUM/_XSLT_MINIMUM/FACTUR-X_MINIMUM.xslt");
		rv.put(EVersion.ZF_23_BASIC_WL, "ZF232_EN/Schema/1. Factur-X_1.07.2_BASICWL/_XSLT_BASIC-WL/FACTUR-X_BASIC-WL.xslt");
		rv.put(EVersion.ZF_23_BASIC, "ZF232_EN/Schema/2. Factur-X_1.07.2_BASIC/_XSLT_BASIC/FACTUR-X_BASIC.xslt");
		rv.put(EVersion.ZF_23_EN16931, "ZF232_EN/Schema/3. Factur-X_1.07.2_EN16931/_XSLT_EN16931/FACTUR-X_EN16931.xslt");
		rv.put(EVersion.ZF_23_EXTENDED, "ZF232_EN/Schema/4. Factur-X_1.07.2_EXTENDED/_XSLT_EXTENDED/FACTUR-X_EXTENDED.xslt");
		return Collections.unmodifiableMap(rv);
	}
}
