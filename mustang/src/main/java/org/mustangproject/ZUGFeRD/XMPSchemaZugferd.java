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
    public XMPSchemaZugferd(XMPMetadata metadata, String conformanceLevel) {
        super(metadata, "urn:ferd:pdfa:CrossIndustryDocument:invoice:1p0#", "zf", "ZUGFeRD Schema");

        setAboutAsSimple("");

        setTextPropertyValue("ConformanceLevel", conformanceLevel);
        setTextPropertyValue("DocumentType", "INVOICE");
        setTextPropertyValue("DocumentFileName", "ZUGFeRD-invoice.xml");
        setTextPropertyValue("Version", "1.0");
    }
}