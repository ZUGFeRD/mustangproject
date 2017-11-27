package org.mustangproject.ZUGFeRD;
/**
 * Mustangproject's ZUGFeRD implementation
 * ZUGFeRD exporter helper class
 * Licensed under the APLv2
 * @date 2014-05-10
 * @version 1.2.0s
 * @author jstaerk
 * */
import org.apache.xmpbox.XMPMetadata;
import org.apache.xmpbox.schema.XMPSchema;

public class XMPSchemaZugferd extends XMPSchema {

    /**
     * This is what needs to be added to the RDF metadata - basically the name of the embedded Zugferd file
     */
    public XMPSchemaZugferd(XMPMetadata metadata, ZUGFeRDConformanceLevel conformanceLevel, String URN, String prefix, String filename) {
        super(metadata, URN, prefix, "ZUGFeRD Schema");

        setAboutAsSimple("");

        String conformanceLevelValue=conformanceLevel.name();
        if (conformanceLevelValue.equals("BASICWL")) {
        		conformanceLevelValue="BASIC WL";
        }
        setTextPropertyValue("ConformanceLevel", conformanceLevelValue);
        setTextPropertyValue("DocumentType", "INVOICE");
        setTextPropertyValue("DocumentFileName", filename);
        setTextPropertyValue("Version", "1.0");
    }
}
