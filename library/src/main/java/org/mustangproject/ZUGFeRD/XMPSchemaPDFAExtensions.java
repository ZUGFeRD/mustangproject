/** **********************************************************************
 *
 * Copyright 2018 Jochen Staerk
 *
 * Use is subject to license terms.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy
 * of the License at http://www.apache.org/licenses/LICENSE-2.0.
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 *********************************************************************** */
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
import org.mustangproject.EStandard;

/**
 * Additionally to adding a RDF namespace with a indication which file
 * attachment if Zugferd, this namespace has to be described in a PDFA Extension
 * Schema. I know there is a PDFAExtensionSchema in the context of PDFBox'
 * XMPBOX but I have been using PDFBox' JempBOX so far because I could not find
 * out how to write XMPBOX XMPMetadata to a PDF file. So this is my version of
 * PDFAExtensionSchema for PDFBox' jempbox XMPMetadata
 *
 * @author jstaerk
 */

@StructuredType(preferedPrefix = "pdfaExtension", namespace = "http://www.aiim.org/pdfa/ns/extension/")
public class XMPSchemaPDFAExtensions extends PDFAExtensionSchema {

	public final String xmlns_pdfaSchema = "http://www.aiim.org/pdfa/ns/schema#";
	public final String prefix_pdfaSchema = "pdfaSchema";
	public final String xmlns_pdfaProperty = "http://www.aiim.org/pdfa/ns/property#";
	public final String prefix_pdfaProperty = "pdfaProperty";
	public String namespace = null;
	public String prefix = null;

	protected IZUGFeRDExporter exporter;


	protected void setZUGFeRDVersion(int ver) {
		namespace = exporter.getNamespaceForVersion(ver);
		prefix = exporter.getPrefixForVersion(ver);
	}


	private DefinedStructuredType addProperty(ArrayProperty parent, String name, String type, String category,
											  String description) {
		XMPMetadata metadata = getMetadata();

		DefinedStructuredType li = new DefinedStructuredType(metadata, getNamespace(), getPrefix(),
				XmpConstants.LIST_NAME);
		li.setAttribute(new Attribute(getNamespace(), XmpConstants.PARSE_TYPE, XmpConstants.RESOURCE_NAME));

		ChoiceType pdfa2 = new ChoiceType(metadata, xmlns_pdfaProperty, prefix_pdfaProperty, PDFAPropertyType.NAME,
				name);
		li.addProperty(pdfa2);

		pdfa2 = new ChoiceType(metadata, xmlns_pdfaProperty, prefix_pdfaProperty, PDFAPropertyType.VALUETYPE, type);
		li.addProperty(pdfa2);

		pdfa2 = new ChoiceType(metadata, xmlns_pdfaProperty, prefix_pdfaProperty, PDFAPropertyType.CATEGORY, category);
		li.addProperty(pdfa2);

		pdfa2 = new ChoiceType(metadata, xmlns_pdfaProperty, prefix_pdfaProperty, PDFAPropertyType.DESCRIPTION,
				description);
		li.addProperty(pdfa2);

		parent.addProperty(li);

		return li;
	}

	public XMPSchemaPDFAExtensions(IZUGFeRDExporter ze, XMPMetadata metadata, int ZFVersion) {
		this(ze, metadata, ZFVersion, true);
	}

	public XMPSchemaPDFAExtensions(IZUGFeRDExporter ze, XMPMetadata metadata, int ZFVersion, boolean withZF) {
		this(ze, metadata, ZFVersion, withZF, null);
	}

	public XMPSchemaPDFAExtensions(IZUGFeRDExporter ze, XMPMetadata metadata, int ZFVersion, boolean withZF, EStandard eStandard) {
		super(metadata);
		exporter=ze;
		setZUGFeRDVersion(ZFVersion);
		attachExtensions(metadata, withZF, eStandard);
	}

	public void attachExtensions(XMPMetadata metadata, boolean withZF, EStandard eStandard) {

		addNamespace(xmlns_pdfaSchema, prefix_pdfaSchema);
		addNamespace(xmlns_pdfaProperty, prefix_pdfaProperty);

		ArrayProperty newBag = createArrayProperty(SCHEMAS, Cardinality.Bag);
		DefinedStructuredType li = new DefinedStructuredType(metadata, getNamespace(), getPrefix(),
				XmpConstants.LIST_NAME);
		li.setAttribute(new Attribute(getNamespace(), XmpConstants.PARSE_TYPE, XmpConstants.RESOURCE_NAME));
		newBag.addProperty(li);
		addProperty(newBag);
		if (withZF) {
			TextType pdfa1 = new TextType(metadata, xmlns_pdfaSchema, prefix_pdfaSchema, PDFASchemaType.SCHEMA,
					"Factur-X PDFA Extension Schema");
			li.addProperty(pdfa1);

			pdfa1 = new TextType(metadata, xmlns_pdfaSchema, prefix_pdfaSchema, PDFASchemaType.NAMESPACE_URI,
					namespace);
			li.addProperty(pdfa1);

			pdfa1 = new TextType(metadata, xmlns_pdfaSchema, prefix_pdfaSchema, PDFASchemaType.PREFIX, prefix);
			li.addProperty(pdfa1);

			ArrayProperty newSeq = new ArrayProperty(metadata, xmlns_pdfaSchema, prefix_pdfaSchema,
					PDFASchemaType.PROPERTY, Cardinality.Seq);
			li.addProperty(newSeq);

			if ((eStandard != null) && (eStandard == EStandard.orderx))
			{
				addProperty(newSeq, "DocumentFileName", "Text", "external", "Name of the embedded XML Order (or related) file");
				addProperty(newSeq, "DocumentType", "Text", "external", "ORDER, ORDER_RESPONSE, or ORDER_CHANGE");
				addProperty(newSeq, "Version", "Text", "external", "The actual version of the Order-X XML schema");
				addProperty(newSeq, "ConformanceLevel", "Text", "external",
								    "The selected Order-X profile completeness");
			} else if ((eStandard != null) && (eStandard == EStandard.despatchadvice))
			{
				// As of late 2022 the Delivery-X standard is not yet published. See specification:
				// Die digitale Ablösung des Papier-Lieferscheins, Version 1.1, April 2022
				// Chapter 7.1 XMP-Erweiterungsschema für PDF/A-3
				// http://docplayer.org/230301085-Der-digitale-lieferschein-dls.html
				addProperty(newSeq, "DocumentFileName", "Text", "external", "Name of the embedded XML despatch advice file");
				addProperty(newSeq, "DocumentType",     "Text", "external", "DESPATCHADVICE");
				addProperty(newSeq, "Version",          "Text", "external", "The actual version of the despatch advice dataset");
				addProperty(newSeq, "ConformanceLevel", "Text", "external", "The conformance level of the despatch advice dataset");
			} else
			{
				addProperty(newSeq, "DocumentFileName", "Text", "external", "name of the embedded XML invoice file");
				addProperty(newSeq, "DocumentType", "Text", "external", "INVOICE");
				addProperty(newSeq, "Version", "Text", "external", "The actual version of the ZUGFeRD XML schema");
				addProperty(newSeq, "ConformanceLevel", "Text", "external",
								    "The selected ZUGFeRD profile completeness");
			}
		}
	}
}
