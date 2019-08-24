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
 * ZUGFeRD importer
 * Licensed under the APLv2
 * @date 2014-07-07
 * @version 1.1.0
 * @author jstaerk
 * */

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentNameDictionary;
import org.apache.pdfbox.pdmodel.PDEmbeddedFilesNameTreeNode;
import org.apache.pdfbox.pdmodel.common.PDNameTreeNode;
import org.apache.pdfbox.pdmodel.common.filespecification.PDComplexFileSpecification;
import org.apache.pdfbox.pdmodel.common.filespecification.PDEmbeddedFile;
import org.w3c.dom.Document;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;
import java.io.*;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;
import java.util.*;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ZUGFeRDImporter {

	/**
	 * if metadata has been found
	 */
	private boolean containsMeta = false;
	/**
	 * map filenames of additional XML files to their contents
	 */
	private HashMap<String, byte[]> additionalXMLs = new HashMap<>();
	/**
	 * Raw XML form of the extracted data - may be directly obtained.
	 */
	private byte[] rawXML = null;
	/**
	 * XMP metadata
	 */
	private String xmpString = null; // XMP metadata
	/**
	 * parsed Document
	 */
	private Document document;

	public ZUGFeRDImporter(String pdfFilename) {
		try (InputStream bis = Files.newInputStream(Paths.get(pdfFilename), StandardOpenOption.READ)) {
			extractLowLevel(bis);
		} catch (IOException e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			throw new ZUGFeRDExportException(e);
		}
	}

	public ZUGFeRDImporter(InputStream pdfStream) {
		try {
			extractLowLevel(pdfStream);
		} catch (IOException e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			throw new ZUGFeRDExportException(e);
		}
	}

	/**
	 * Extracts a ZUGFeRD invoice from a PDF document represented by an input
	 * stream. Errors are reported via exception handling.
	 *
	 * @param pdfStream a inputstream of a pdf file
	 */
	private void extractLowLevel(InputStream pdfStream) throws IOException {
		try (PDDocument doc = PDDocument.load(pdfStream)) {
			// PDDocumentInformation info = doc.getDocumentInformation();
			PDDocumentNameDictionary names = new PDDocumentNameDictionary(doc.getDocumentCatalog());
			//start
			InputStream XMP = doc.getDocumentCatalog().getMetadata().exportXMPMetadata();

			xmpString = convertStreamToString(XMP);

			PDEmbeddedFilesNameTreeNode etn = names.getEmbeddedFiles();
			if (etn == null) {
				return;
			}

			Map<String, PDComplexFileSpecification> efMap = etn.getNames();
			// String filePath = "/tmp/";

			if (efMap != null) {
				extractFiles(efMap); // see
				// https://memorynotfound.com/apache-pdfbox-extract-embedded-file-pdf-document/
			} else {

				List<PDNameTreeNode<PDComplexFileSpecification>> kids = etn.getKids();
				for (PDNameTreeNode<PDComplexFileSpecification> node : kids) {
					Map<String, PDComplexFileSpecification> namesL = node.getNames();
					extractFiles(namesL);
				}
			}
		}
	}


	private void extractFiles(Map<String, PDComplexFileSpecification> names) throws IOException {
		for (String alias : names.keySet()) {

			PDComplexFileSpecification fileSpec = names.get(alias);
			String filename=fileSpec.getFilename();
			/**
			 * filenames for invoice data (ZUGFeRD v1 and v2, Factur-X)
			 */
			if ((filename.equals("ZUGFeRD-invoice.xml") || (filename.equals("zugferd-invoice.xml")) || filename.equals("factur-x.xml"))) { //$NON-NLS-1$
				containsMeta = true;

				PDEmbeddedFile embeddedFile = fileSpec.getEmbeddedFile();
				// String embeddedFilename = filePath + filename;
				// File file = new File(filePath + filename);
				// System.out.println("Writing " + embeddedFilename);
				// ByteArrayOutputStream fileBytes=new
				// ByteArrayOutputStream();
				// FileOutputStream fos = new FileOutputStream(file);

				setRawXML(embeddedFile.toByteArray());

				// fos.write(embeddedFile.getByteArray());
				// fos.close();
			}
			if (filename.startsWith("additional_data")) {
				PDEmbeddedFile embeddedFile = fileSpec.getEmbeddedFile();
				additionalXMLs.put(filename, embeddedFile.toByteArray());
			}
		}
	}

	private Document getDocument() { return document; }

	private void setDocument() throws ParserConfigurationException, IOException, SAXException {
		DocumentBuilderFactory xmlFact = DocumentBuilderFactory.newInstance();
		xmlFact.setNamespaceAware(false);
		DocumentBuilder builder = xmlFact.newDocumentBuilder();
		ByteArrayInputStream is = new ByteArrayInputStream(rawXML);
		is.skip(guessBOMSize(is));
		document = builder.parse(is);
	}

	public void setRawXML(byte[] rawXML) throws IOException {
		this.rawXML = rawXML;
		try {
			setDocument();
		} catch (ParserConfigurationException | SAXException e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			throw new ZUGFeRDExportException(e);
		}
	}

	/**
	 * Skips over a BOM at the beginning of the given ByteArrayInputStream, if one exists.
	 * @param is the ByteArrayInputStream used
	 * @throws IOException if can not be read from is
	 * @see <a href="https://www.w3.org/TR/xml/#sec-guessing">Autodetection of Character Encodings</a>
	 */
	private int guessBOMSize(ByteArrayInputStream is) throws IOException {
		byte[] pad = new byte[4];
		is.read(pad);
		is.reset();
		int test2 = ((pad[0] & 0xFF) << 8) | (pad[1] & 0xFF);
		int test3 = ((test2 & 0xFFFF) << 8) | (pad[2] & 0xFF);
		int test4 = ((test3 & 0xFFFFFF) << 8) | (pad[3] & 0xFF);
		//
		if (test4 == 0x0000FEFF || test4 == 0xFFFE0000 || test4 == 0x0000FFFE || test4 == 0xFEFF0000) {
			// UCS-4: BOM takes 4 bytes
			return 4;
		} else if (test3 == 0xEFBBFF) {
			// UTF-8: BOM takes 3 bytes
			return 3;
		} else if (test2 == 0xFEFF || test2 == 0xFFFE) {
			// UTF-16: BOM takes 2 bytes
			return 2;
		}
		return 0;
	}

	private String extractString(String xpathStr) {
		if (!containsMeta) {
			throw new ZUGFeRDExportException("No suitable data/ZUGFeRD file could be found.");
		}
		String result;
		try {
			Document document = getDocument();
			XPathFactory xpathFact = XPathFactory.newInstance();
			XPath xpath = xpathFact.newXPath();
			result = xpath.evaluate(xpathStr, document);
		} catch (XPathExpressionException e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			throw new ZUGFeRDExportException(e);
		}
		return result;
	}

	/**
	 * @return the reference (purpose) the sender specified for this invoice
	 */
	public String getForeignReference() {
		String result = extractString("//ApplicableHeaderTradeSettlement/PaymentReference");
		if(result == null || result.isEmpty())
			result = extractString("//ApplicableSupplyChainTradeSettlement/PaymentReference");
		return result;
	}

	/**
	 * @return the document code
	 */
	public String getDocumentCode() {
		return extractString("//HeaderExchangedDocument/TypeCode");
	}

	/**
	 * @return the referred document
	 */
	public String getReference() {
		return extractString("//ApplicableHeaderTradeAgreement/BuyerReference");
	}

	/**
	 * @return the sender's bank's BLZ code
	 * @deprecated use BIC and IBAN instead of BLZ and KTO
	 */
	@Deprecated
	public String getBLZ() {
		return extractString("//PayeeSpecifiedCreditorFinancialInstitution/GermanBankleitzahlID");
	}

	/**
	 * @return the sender's account number
	 * @deprecated use BIC and IBAN instead of BLZ and KTO
	 */
	@Deprecated
	public String getKTO() {
		return extractString("//PayeePartyCreditorFinancialAccount/ProprietaryID");
	}

	/**
	 * @return the sender's bank's BIC code
	 */
	public String getBIC() {
		return extractString("//PayeeSpecifiedCreditorFinancialInstitution/BICID");
	}


	/**
	 * @return the sender's bank name
	 */
	public String getBankName() {
		return extractString("//PayeeSpecifiedCreditorFinancialInstitution/Name");
	}

	/**
	 * @return the sender's account IBAN code
	 */
	public String getIBAN() {
		return extractString("//PayeePartyCreditorFinancialAccount/IBANID");
	}

	public String getHolder() {
		return extractString("//SellerTradeParty/Name");
	}

	/**
	 * @return the total payable amount
	 */
	public String getAmount() {
		String result = extractString("//SpecifiedTradeSettlementHeaderMonetarySummation/DuePayableAmount");
		if(result == null || result.isEmpty())
			result = extractString("//SpecifiedTradeSettlementMonetarySummation/GrandTotalAmount");
		return result;
	}

	/**
	 * @return when the payment is due
	 */
	public String getDueDate() {
		return extractString("//SpecifiedTradePaymentTerms/DueDateDateTime/DateTimeString");
	}

	public HashMap<String, byte[]> getAdditionalData() {
		return additionalXMLs;
	}

	/**
	 * get xmp metadata of the PDF, null if not available
	 *
	 * @return string
	 */
	public String getXMP() {
		return xmpString;
	}


	/**
	 * @return if export found parseable ZUGFeRD data
	 */
	public boolean containsMeta() {
		return containsMeta;
	}

	/**
	 * @param meta raw XML to be set
	 * @throws IOException if raw can not be set
	 */
	public void setMeta(String meta) throws IOException {
		setRawXML(meta.getBytes());
	}

	/**
	 * @return raw XML of the invoice
	 */
	public String getMeta() {
		if (rawXML == null) {
			return null;
		}

		return new String(rawXML);
	}


	public int getVersion() throws Exception {
		if (!containsMeta) throw new Exception("Not yet parsed");
		if (getUTF8().contains("<rsm:CrossIndustryDocument")) {
			return 1;
		} else if (getUTF8().contains("<rsm:CrossIndustryInvoice")) {
			return 2;
		}
		throw new Exception("ZUGFeRD version could not be determined");
	}
	
	/**
	 * @return return UTF8 XML (without BOM) of the invoice
	 */
	public String getUTF8() {
		if (rawXML == null) {
			return null;
		}
		if (rawXML.length < 3) {
			return new String(rawXML);
		}


		byte[] bomlessData;

		if ((rawXML[0] == (byte) 0xEF)
				&& (rawXML[1] == (byte) 0xBB)
				&& (rawXML[2] == (byte) 0xBF)) {
			// I don't like BOMs, lets remove it
			bomlessData = new byte[rawXML.length - 3];
			System.arraycopy(rawXML, 3, bomlessData, 0,
					rawXML.length - 3);
		} else {
			bomlessData = rawXML;
		}

		return new String(bomlessData);
	}

	/**
	 * Returns the raw XML data as extracted from the ZUGFeRD PDF file.
	 * @return the raw ZUGFeRD XML data
	 */
	public byte[] getRawXML() {
		return rawXML;
	}

	/**
	 * will return true if the metadata (just extract-ed or set with setMeta)
	 * contains ZUGFeRD XML
	 *
	 * @return true if the invoice contains ZUGFeRD XML
	 */
	public boolean canParse() {

		// SpecifiedExchangedDocumentContext is in the schema, so a relatively good
		// indication if zugferd is present - better than just invoice
		String meta = getMeta();
		return (meta != null) && (meta.length() > 0) && ((meta.contains("SpecifiedExchangedDocumentContext") //$NON-NLS-1$
				/* ZF1 */ || meta.contains("ExchangedDocumentContext") /* ZF2 */));
	}

	static String convertStreamToString(java.io.InputStream is) {
		// source https://stackoverflow.com/questions/309424/how-do-i-read-convert-an-inputstream-into-a-string-in-java referring to
		// https://community.oracle.com/blogs/pat/2004/10/23/stupid-scanner-tricks
		Scanner s = new Scanner(is, "UTF-8").useDelimiter("\\A");
		return s.hasNext() ? s.next() : "";
	}

}
