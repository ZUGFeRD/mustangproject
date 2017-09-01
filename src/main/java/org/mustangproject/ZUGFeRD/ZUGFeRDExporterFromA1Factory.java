package org.mustangproject.ZUGFeRD;

import java.io.IOException;

import javax.xml.transform.TransformerException;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.xmpbox.type.BadFieldValueException;

public class ZUGFeRDExporterFromA1Factory  extends ZUGFeRDExporterFromA3Factory implements IExporterFactory {

	/**
	 * Make a PDF A/3 from the PDF A/1
	 */
	public void prepareDocument(PDDocument doc) throws IOException {
		super.prepareDocument(doc);
		/*
		 * // Mandatory: PDF/A3-a is tagged PDF which has to be expressed using a //
		 * MarkInfo dictionary (PDF A/3 Standard sec. 6.7.2.2) PDMarkInfo markinfo = new
		 * PDMarkInfo(); markinfo.setMarked(true);
		 * doc.getDocumentCatalog().setMarkInfo(markinfo);
		 */
		/*
		 *
		 * To be on the safe side, we use level B without Markinfo because we can not
		 * guarantee that the user correctly tagged the templates for the PDF.
		 */
		try {
			pdfaid.setConformance(conformanceLevel.getLetter());// $NON-NLS-1$ //$NON-NLS-1$
		} catch (BadFieldValueException ex) {
			// This should be impossible, because it would occur only if an illegal
			// conformance level is supplied,
			// however the enum enforces that the conformance level is valid.
			throw new Error(ex);
		}

		pdfaid.setPart(3);

		if (attachZugferdHeaders) {
			addXMP(xmp); /*
							 * this is the only line where we do something Zugferd-specific, i.e. add PDF
							 * metadata specifically for Zugferd, not generically for a embedded file
							 */

		}

		try {
			metadata.importXMPMetadata(serializeXmpMetadata(xmp));
		
		} catch (TransformerException e) {
			throw new ZUGFeRDExportException("Could not export XmpMetadata", e);
		}
	}

}
