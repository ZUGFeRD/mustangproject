package org.mustangproject.ZUGFeRD;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.ByteArrayOutputStream;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.PDResources;
import org.apache.pdfbox.pdmodel.common.PDMetadata;
import org.apache.xmpbox.XMPMetadata;
import org.apache.xmpbox.schema.AdobePDFSchema;
import org.apache.xmpbox.schema.DublinCoreSchema;
import org.apache.xmpbox.schema.XMPBasicSchema;
import org.apache.xmpbox.xml.DomXmpParser;
import org.apache.xmpbox.xml.XmpSerializer;
import org.junit.jupiter.api.Test;

public class ZUGFeRDExporterFromA3Test {

	private static final String PRESET_DESCRIPTION = "DescriptionTest";
    private static final String PRESET_SUBJECT = "SubjectTest";
    private static final String PRESET_LABEL = "LabelTest";
    private static final String PRESET_ADOBE_KEYWORDS = "AdobeKeywordsTest";

	@Test
	public void testPrepareDocumentPreservesUntouchedMetadata() throws Exception {
		byte[] pdfBytes = createPdfWithPresetMetadata();

        try (ZUGFeRDExporterFromA3 exporter = new ZUGFeRDExporterFromA3())
        {
            exporter.load(pdfBytes);
            // test override behaviour
            exporter.overwrite = false;
            exporter.prepareDocument();

            PDMetadata meta = exporter.doc.getDocumentCatalog().getMetadata();
            XMPMetadata xmp = new DomXmpParser().parse(meta.toByteArray());

            DublinCoreSchema dc = xmp.getDublinCoreSchema();
            assertEquals(PRESET_DESCRIPTION, dc.getDescription());
            assertTrue(dc.getSubjects().contains(PRESET_SUBJECT));

            XMPBasicSchema xsb = xmp.getXMPBasicSchema();
            assertEquals(PRESET_LABEL, xsb.getLabel());

            AdobePDFSchema adobePdf = xmp.getAdobePDFSchema();
            assertEquals(PRESET_ADOBE_KEYWORDS, adobePdf.getKeywords());
        }
	}

	private byte[] createPdfWithPresetMetadata() throws Exception {
		try (PDDocument doc = new PDDocument()) {
			PDPage page = new PDPage();
			page.setResources(new PDResources());
			doc.addPage(page);

			XMPMetadata xmp = XMPMetadata.createXMPMetadata();

			DublinCoreSchema dc = xmp.createAndAddDublinCoreSchema();
			dc.setDescription(PRESET_DESCRIPTION);
			dc.addSubject(PRESET_SUBJECT);

			XMPBasicSchema xsb = xmp.createAndAddXMPBasicSchema();
			xsb.setLabel(PRESET_LABEL);

			AdobePDFSchema adobePdf = xmp.createAndAddAdobePDFSchema();
			adobePdf.setKeywords(PRESET_ADOBE_KEYWORDS);

			ByteArrayOutputStream xmpBytes = new ByteArrayOutputStream();
			new XmpSerializer().serialize(xmp, xmpBytes, true);

			PDMetadata metadata = new PDMetadata(doc);
			metadata.importXMPMetadata(xmpBytes.toByteArray());
			doc.getDocumentCatalog().setMetadata(metadata);

			ByteArrayOutputStream pdfBytes = new ByteArrayOutputStream();
			doc.save(pdfBytes);
			return pdfBytes.toByteArray();
		}
	}

}
