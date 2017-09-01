package org.mustangproject.ZUGFeRD;

import java.io.IOException;
import java.io.InputStream;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.xmpbox.XMPMetadata;

public interface IExporterFactory {
	public ZUGFeRDExporter load(String pdfFilename) throws IOException;
	/**
	 * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on the
	 * metadata level, this will not e.g. convert graphics to JPG-2000)
	 *
	 * @param pdfBinary
	 *            binary of a PDF/A1 compliant document
	 */
	public ZUGFeRDExporter load(byte[] pdfBinary) throws IOException;
	/**
	 * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on the
	 * metadata level, this will not e.g. convert graphics to JPG-2000)
	 *
	 * @param pdfSource
	 *            source to read a PDF/A1 compliant document from
	 * @throws IOException 
	 */
	public ZUGFeRDExporter load(InputStream pdfSource) throws IOException;
	public void prepareDocument(PDDocument doc) throws IOException;
	public void addXMP(XMPMetadata metadata);
	
	public IExporterFactory setCreator(String creator);
	public IExporterFactory setConformanceLevel(PDFAConformanceLevel newLevel);
	public IExporterFactory setProducer(String producer) ;
	public IExporterFactory ignorePDFAErrors();
	public IExporterFactory setZUGFeRDConformanceLevel(ZUGFeRDConformanceLevel zugferdConformanceLevel);
	public IExporterFactory setAttachZUGFeRDHeaders(final boolean attachZugferdHeaders);
				
}
