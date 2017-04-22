package org.mustangproject.ZUGFeRD;
/**
 * Mustangproject's ZUGFeRD implementation
 * ZUGFeRD exporter helper class
 * Licensed under the APLv2
 * @date 2014-05-10
 * @version 1.2.0
 * @author jstaerk
 * */
import org.apache.xmpbox.XMPMetadata;
import org.apache.xmpbox.XmpConstants;
import org.apache.xmpbox.schema.PDFAExtensionSchema;
import org.apache.xmpbox.type.ArrayProperty;
import org.apache.xmpbox.type.Attribute;
import org.apache.xmpbox.type.Cardinality;
import org.apache.xmpbox.type.ChoiceType;
import org.apache.xmpbox.type.DefinedStructuredType;
import org.apache.xmpbox.type.PDFAPropertyType;
import org.apache.xmpbox.type.PDFASchemaType;
import org.apache.xmpbox.type.StructuredType;
import org.apache.xmpbox.type.TextType;


/**
 * Additionally to adding a RDF namespace with a indication which file attachment if Zugferd, this namespace has to be described in a PDFA Extension Schema. I
 * know there is a PDFAExtensionSchema in the context of PDFBox' XMPBOX but I have been using PDFBox' JempBOX so far because I could not find out how to write
 * XMPBOX XMPMetadata to a PDF file. So this is my version of PDFAExtensionSchema for PDFBox' jempbox XMPMetadata
 *
 * @author jstaerk
 */


@StructuredType(preferedPrefix = "pdfaExtension", namespace = "http://www.aiim.org/pdfa/ns/extension/")
    public class XMPSchemaPDFAExtensions extends PDFAExtensionSchema {

	public final String xmlns_pdfaSchema = "http://www.aiim.org/pdfa/ns/schema#";
	public final String prefix_pdfaSchema = "pdfaSchema";
	public final String xmlns_pdfaProperty = "http://www.aiim.org/pdfa/ns/property#";
	public final String prefix_pdfaProperty = "pdfaProperty";

	private DefinedStructuredType addProperty(ArrayProperty parent, String name, String type, String category, String description) {
		XMPMetadata metadata = getMetadata();

		DefinedStructuredType li = new DefinedStructuredType(metadata, getNamespace(), getPrefix(), XmpConstants.LIST_NAME);
		li.setAttribute(new Attribute(getNamespace(), XmpConstants.PARSE_TYPE, XmpConstants.RESOURCE_NAME));

		ChoiceType pdfa2 = new ChoiceType(metadata, xmlns_pdfaProperty, prefix_pdfaProperty, PDFAPropertyType.NAME, name);
		li.addProperty(pdfa2);

		pdfa2 = new ChoiceType(metadata, xmlns_pdfaProperty, prefix_pdfaProperty, PDFAPropertyType.VALUETYPE, type);
		li.addProperty(pdfa2);

		pdfa2 = new ChoiceType(metadata, xmlns_pdfaProperty, prefix_pdfaProperty, PDFAPropertyType.CATEGORY, category);
		li.addProperty(pdfa2);

		pdfa2 = new ChoiceType(metadata, xmlns_pdfaProperty, prefix_pdfaProperty, PDFAPropertyType.DESCRIPTION, description);
		li.addProperty(pdfa2);

		parent.addProperty(li);

		return li;
	}

	public XMPSchemaPDFAExtensions(XMPMetadata metadata) {

		super(metadata);

		addNamespace(xmlns_pdfaSchema, prefix_pdfaSchema);
		addNamespace(xmlns_pdfaProperty, prefix_pdfaProperty);

		ArrayProperty newBag = createArrayProperty(SCHEMAS, Cardinality.Bag);
		DefinedStructuredType li = new DefinedStructuredType(metadata, getNamespace(), getPrefix(), XmpConstants.LIST_NAME);
		li.setAttribute(new Attribute(getNamespace(), XmpConstants.PARSE_TYPE, XmpConstants.RESOURCE_NAME));
		newBag.addProperty(li);
		addProperty(newBag);

		TextType pdfa1 = new TextType(metadata, xmlns_pdfaSchema, prefix_pdfaSchema, PDFASchemaType.SCHEMA, "ZUGFeRD PDFA Extension Schema");
		li.addProperty(pdfa1);

		pdfa1 = new TextType(metadata, xmlns_pdfaSchema, prefix_pdfaSchema, PDFASchemaType.NAMESPACE_URI, "urn:ferd:pdfa:CrossIndustryDocument:invoice:1p0#");
		li.addProperty(pdfa1);

		pdfa1 = new TextType(metadata, xmlns_pdfaSchema, prefix_pdfaSchema, PDFASchemaType.PREFIX, "zf");
		li.addProperty(pdfa1);

		ArrayProperty newSeq = new ArrayProperty(metadata, xmlns_pdfaSchema, prefix_pdfaSchema, PDFASchemaType.PROPERTY, Cardinality.Seq);
		li.addProperty(newSeq);

		addProperty(newSeq, "DocumentFileName", "Text", "external", "name of the embedded XML invoice file");
		addProperty(newSeq, "DocumentType", "Text", "external", "INVOICE");
		addProperty(newSeq, "Version", "Text", "external", "The actual version of the ZUGFeRD XML schema");
		addProperty(newSeq, "ConformanceLevel", "Text", "external", "The conformance level of the embedded ZUGFeRD data");
	}
    }