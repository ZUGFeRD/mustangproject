package org.mustangproject.ZUGFeRD;
/**
 * Mustangproject's ZUGFeRD implementation
 * ZUGFeRD exporter helper class
 * Licensed under the APLv2
 * @date 2014-05-10
 * @version 1.0
 * @author jstaerk
 * */
import org.apache.jempbox.impl.XMLUtil;
import org.apache.jempbox.xmp.XMPSchemaBasic;
import org.w3c.dom.Element;


public class XMPSchemaZugferd extends XMPSchemaBasic {

		/**
		 * This is what needs to be added to the RDF metadata - basically the name of the embedded
		 * Zugferd file
		 * */
		public XMPSchemaZugferd(org.apache.jempbox.xmp.XMPMetadata parent) {
			super(parent);

			schema.setAttributeNS(NS_NAMESPACE, "xmlns:zf", //$NON-NLS-1$
					"urn:ferd:pdfa:CrossIndustryDocument:invoice:1p0#"); //$NON-NLS-1$
// the superclass includes this two namespaces we don't need
			schema.removeAttributeNS(NS_NAMESPACE, "xapGImg"); //$NON-NLS-1$
			schema.removeAttributeNS(NS_NAMESPACE, "xmp"); //$NON-NLS-1$
			Element textNode = schema.getOwnerDocument().createElement(
					"zf:DocumentType"); //$NON-NLS-1$
			XMLUtil.setStringValue(textNode, "INVOICE"); //$NON-NLS-1$
			schema.appendChild(textNode);

			textNode = schema.getOwnerDocument().createElement(
					"zf:DocumentFileName"); //$NON-NLS-1$
			XMLUtil.setStringValue(textNode, "ZUGFeRD-invoice.xml"); //$NON-NLS-1$
			schema.appendChild(textNode);

			textNode = schema.getOwnerDocument().createElement("zf:Version"); //$NON-NLS-1$
			XMLUtil.setStringValue(textNode, "1.0"); //$NON-NLS-1$
			schema.appendChild(textNode);

			textNode = schema.getOwnerDocument().createElement(
					"zf:ConformanceLevel"); //$NON-NLS-1$
			XMLUtil.setStringValue(textNode, "COMFORT"); //$NON-NLS-1$
			schema.appendChild(textNode);

		}

	}