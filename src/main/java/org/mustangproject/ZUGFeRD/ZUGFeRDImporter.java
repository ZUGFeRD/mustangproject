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
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import java.io.*;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.logging.Logger;

//root.setNamespace(Namespace.getNamespace("http://www.energystar.gov/manageBldgs/req"));

public class ZUGFeRDImporter {
	/*
	 * call extract(importFilename). containsMeta() will return if ZUGFeRD data has
	 * been found, afterwards you can call getBIC(), getIBAN() etc.
	 *
	 */

	/** @var if metadata has been found */
	private boolean containsMeta = false;
	/** @var the reference (i.e. invoice number) of the sender */
	private String foreignReference;
    private String BLZ;
	private String BIC;
	private String IBAN;
	private String KTO;
	private String holder;
	private String amount;
	private String dueDate;
	private HashMap<String,byte[]> additionalXMLs=new HashMap<String,byte[]>();
	/** Raw XML form of the extracted data - may be directly obtained. */
	private byte[] rawXML = null;
	private String bankName;
	private boolean amountFound;
	private boolean extractAttempt = false;
	private boolean parsed = false;
	private String xmpString = null; // XMP metadata
	private static final Logger LOG = Logger.getLogger(ZUGFeRDImporter.class.getName());

	/**
	 * Extracts a ZUGFeRD invoice from a PDF document represented by a file name.
	 * Errors are just logged to STDOUT.
	 * 
	 * @param pdfFilename
	 *            the filename of the pdf
	 */
	public void extract(String pdfFilename) {
		try {
			BufferedInputStream bis = new BufferedInputStream(new FileInputStream(pdfFilename));

			extractLowLevel(bis);
			bis.close();
		} catch (IOException ioe) {
			ioe.printStackTrace();
		}
	}
	
	static String convertStreamToString(java.io.InputStream is) {
		// source https://stackoverflow.com/questions/309424/how-do-i-read-convert-an-inputstream-into-a-string-in-java referring to
		// https://community.oracle.com/blogs/pat/2004/10/23/stupid-scanner-tricks
	    java.util.Scanner s = new java.util.Scanner(is).useDelimiter("\\A");
	    return s.hasNext() ? s.next() : "";
	}
	
	/***
	 * get xmp metadata of the PDF, null if not available
	 * @return string
	 */
	public String getXMP() {
		return xmpString;
	}

	/**
	 * Extracts a ZUGFeRD invoice from a PDF document represented by an input
	 * stream. Errors are reported via exception handling.
	 * 
	 * @param pdfStream
	 *            a inputstream of a pdf file
	 */
	public void extractLowLevel(InputStream pdfStream) throws IOException {
		PDEmbeddedFilesNameTreeNode etn;
		extractAttempt = true;
		try (PDDocument doc = PDDocument.load(pdfStream)) {
			// PDDocumentInformation info = doc.getDocumentInformation();
			PDDocumentNameDictionary names = new PDDocumentNameDictionary(doc.getDocumentCatalog());
			//start
			InputStream XMP=doc.getDocumentCatalog().getMetadata().exportXMPMetadata();
			
			xmpString=convertStreamToString(XMP);
			etn = names.getEmbeddedFiles();
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
		for (String filename : names.keySet()) {
			/**
			 * currently (in the release candidate of version 1) only one attached file with
			 * the name ZUGFeRD-invoice.xml is allowed
			 */
			if ((filename.equals("ZUGFeRD-invoice.xml") || filename.equals("factur-x.xml"))) { //$NON-NLS-1$
				containsMeta = true;

				PDComplexFileSpecification fileSpec = names.get(filename);
				PDEmbeddedFile embeddedFile = fileSpec.getEmbeddedFile();
				// String embeddedFilename = filePath + filename;
				// File file = new File(filePath + filename);
				// System.out.println("Writing " + embeddedFilename);
				// ByteArrayOutputStream fileBytes=new
				// ByteArrayOutputStream();
				// FileOutputStream fos = new FileOutputStream(file);

				rawXML = embeddedFile.toByteArray();
				setMeta(new String(rawXML));

				// fos.write(embeddedFile.getByteArray());
				// fos.close();
			}
			if (filename.startsWith("additional_data")) {

				PDComplexFileSpecification fileSpec = names.get(filename);
				PDEmbeddedFile embeddedFile = fileSpec.getEmbeddedFile();
				additionalXMLs.put(filename, embeddedFile.toByteArray());

			}
		}
	}
	
	public HashMap<String, byte[]> getAdditionalData() {
		return additionalXMLs;
	}

	/**
	 * needs to be called to be able to call the getters
	 */
	public void parse() {
		DocumentBuilderFactory factory = null;
		DocumentBuilder builder = null;
		Document document = null;

		if (!extractAttempt) {
			throw new RuntimeException("extract() or extractLowLevel() must be used before parsing.");
		}
		if (!containsMeta) {
			throw new RuntimeException("No suitable data/ZUGFeRD file could be found.");
		}

		factory = DocumentBuilderFactory.newInstance();
		factory.setNamespaceAware(true); // otherwise we can not act namespace independently, i.e. use
											// document.getElementsByTagNameNS("*",...
		try {
			builder = factory.newDocumentBuilder();
		} catch (ParserConfigurationException ex3) {
			// TODO Auto-generated catch block
			ex3.printStackTrace();
		}

		try {
			InputStream bais = new ByteArrayInputStream(rawXML);
			document = builder.parse(bais);
		} catch (SAXException ex1) {
			ex1.printStackTrace();
		} catch (IOException ex2) {
			ex2.printStackTrace();
		}
		NodeList ndList;

		// rootNode = document.getDocumentElement();
		// ApplicableSupplyChainTradeSettlement
		ndList = document.getDocumentElement().getElementsByTagNameNS("*", "PaymentReference"); //$NON-NLS-1$

		for (int bookingIndex = 0; bookingIndex < ndList.getLength(); bookingIndex++) {
			Node booking = ndList.item(bookingIndex);
			// if there is a attribute in the tag number:value

			setForeignReference(booking.getTextContent());

		}
		/*
		 * ndList = document .getElementsByTagName("GermanBankleitzahlID");
		 * //$NON-NLS-1$
		 *
		 * for (int bookingIndex = 0; bookingIndex < ndList .getLength();
		 * bookingIndex++) { Node booking = ndList.item(bookingIndex); // if there is a
		 * attribute in the tag number:value setBIC(booking.getTextContent());
		 *
		 * }
		 *
		 * ndList = document.getElementsByTagName("ProprietaryID"); //$NON-NLS-1$
		 *
		 * for (int bookingIndex = 0; bookingIndex < ndList .getLength();
		 * bookingIndex++) { Node booking = ndList.item(bookingIndex); // if there is a
		 * attribute in the tag number:value setIBAN(booking.getTextContent());
		 *
		 * } <ram:PayeePartyCreditorFinancialAccount> <ram:IBANID>DE1234</ram:IBANID>
		 * </ram:PayeePartyCreditorFinancialAccount>
		 * <ram:PayeeSpecifiedCreditorFinancialInstitution>
		 * <ram:BICID>DE5656565</ram:BICID> <ram:Name>Commerzbank</ram:Name>
		 * </ram:PayeeSpecifiedCreditorFinancialInstitution>
		 *
		 */

		/***
		 * we should switch to xpath like this // Create XPathFactory object
		 * XPathFactory xpathFactory = XPathFactory.newInstance();
		 * 
		 * // Create XPath object XPath xpath = xpathFactory.newXPath(); XPathExpression
		 * expr =
		 * xpath.compile("//*[local-name()=\"GuidelineSpecifiedDocumentContextParameter\"]/[local-name()=\"ID\"]");
		 * //evaluate expression result on XML document ndList = (NodeList)
		 * expr.evaluate(doc, XPathConstants.NODESET);
		 * 
		 */

		ndList = document.getElementsByTagNameNS("*", "PayeePartyCreditorFinancialAccount"); //$NON-NLS-1$
		for (int bookingIndex = 0; bookingIndex < ndList.getLength(); bookingIndex++) {

			Node booking = ndList.item(bookingIndex);
			// there are many "name" elements, so get the one below
			// SellerTradeParty
			NodeList bookingDetails = booking.getChildNodes();

			for (int detailIndex = 0; detailIndex < bookingDetails.getLength(); detailIndex++) {
				Node detail = bookingDetails.item(detailIndex);
				if ((detail.getLocalName() != null) && (detail.getLocalName().equals("IBANID"))) { //$NON-NLS-1$
					setIBAN(detail.getTextContent());
				}
                if ((detail.getLocalName() != null) && (detail.getLocalName().equals("ProprietaryID"))) { //$NON-NLS-1$
                    setKTO(detail.getTextContent());

                }
            }

		}
		ndList = document.getElementsByTagNameNS("*", "PayeeSpecifiedCreditorFinancialInstitution");// ZF1 //$NON-NLS-1$
		for (int bookingIndex = 0; bookingIndex < ndList.getLength(); bookingIndex++) {
			Node booking = ndList.item(bookingIndex);
			// there are many "name" elements, so get the one below
			// SellerTradeParty
			NodeList bookingDetails = booking.getChildNodes();
			for (int detailIndex = 0; detailIndex < bookingDetails.getLength(); detailIndex++) {
				Node detail = bookingDetails.item(detailIndex);
				if ((detail.getLocalName() != null) && (detail.getLocalName().equals("BICID"))) { //$NON-NLS-1$
					setBIC(detail.getTextContent());
				}
                if ((detail.getLocalName() != null) && (detail.getLocalName().equals("GermanBankleitzahlID"))) { //$NON-NLS-1$
                    setBLZ(detail.getTextContent());
                }
				if ((detail.getLocalName() != null) && (detail.getLocalName().equals("Name"))) { //$NON-NLS-1$
					setBankName(detail.getTextContent());
				}
			}

		}

		ndList = document.getElementsByTagNameNS("*", "SellerTradeParty"); //$NON-NLS-1$

		for (int bookingIndex = 0; bookingIndex < ndList.getLength(); bookingIndex++) {
			Node booking = ndList.item(bookingIndex);
			// there are many "name" elements, so get the one below
			// SellerTradeParty
			NodeList bookingDetails = booking.getChildNodes();
			for (int detailIndex = 0; detailIndex < bookingDetails.getLength(); detailIndex++) {
				Node detail = bookingDetails.item(detailIndex);
				if ((detail.getLocalName() != null) && (detail.getLocalName().equals("Name"))) { //$NON-NLS-1$
					setHolder(detail.getTextContent());
				}
			}

		}

		ndList = document.getElementsByTagNameNS("*", "DuePayableAmount"); //$NON-NLS-1$

		for (int bookingIndex = 0; bookingIndex < ndList.getLength(); bookingIndex++) {
			Node booking = ndList.item(bookingIndex);
			// if there is a attribute in the tag number:value
			amountFound = true;
			setAmount(booking.getTextContent());

		}

		if (!amountFound) {
			/*
			 * there is apparently no requirement to mention DuePayableAmount,, if it's not
			 * there, check for GrandTotalAmount
			 */
			ndList = document.getElementsByTagNameNS("*", "GrandTotalAmount"); //$NON-NLS-1$
			for (int bookingIndex = 0; bookingIndex < ndList.getLength(); bookingIndex++) {
				Node booking = ndList.item(bookingIndex);
				// if there is a attribute in the tag number:value
				amountFound = true;
				setAmount(booking.getTextContent());

			}

		}

		ndList = document.getElementsByTagNameNS("*", "SpecifiedTradePaymentTerms"); //$NON-NLS-1$

		for (int bookingIndex = 0; bookingIndex < ndList.getLength(); bookingIndex++) {
			Node booking = ndList.item(bookingIndex);
			// there are many "name" elements, so get the one below
			// SellerTradeParty
			NodeList bookingDetails = booking.getChildNodes();
			for (int detailIndex = 0; detailIndex < bookingDetails.getLength(); detailIndex++) {
				Node detail = bookingDetails.item(detailIndex);
				if ((detail.getLocalName() != null) && (detail.getLocalName().equals("DueDateDateTime"))) { //$NON-NLS-1$
					setDueDate(detail.getTextContent().trim());
				}
			}

		}

		parsed = true;
	}

	/**
	 * 
	 * @return if export found parseable ZUGFeRD data
	 */
	public boolean containsMeta() {
		return containsMeta;
	}

	/**
	 * 
	 * @return the reference (purpose) the sender specified for this invoice
	 */
	public String getForeignReference() {
		if (!parsed) {
			throw new RuntimeException("use extract() before requesting a value");
		}
		if (foreignReference==null) {
			parse();
		}
		return foreignReference;
	}

	private void setForeignReference(String foreignReference) {
		this.foreignReference = foreignReference;
	}

    /**
     *
     * @return the sender's bank's BLZ code
     */
    public String getBLZ() {
        if (!parsed) {
            throw new RuntimeException("use extract() before requesting a value");
        }
        if (BLZ==null) {
            parse();
        }
        return BLZ;
    }

    private void setBLZ(String blz) {
        this.BLZ = blz;
    }

	/**
	 * 
	 * @return the sender's bank's BIC code
	 */
	public String getBIC() {
		if (!parsed) {
			throw new RuntimeException("use extract() before requesting a value");
		}
		if (BIC==null) {
			parse();
		}
		return BIC;
	}

	private void setBIC(String bic) {
		this.BIC = bic;
	}

	private void setDueDate(String dueDate) {
		this.dueDate = dueDate;
	}

	private void setBankName(String bankname) {
		this.bankName = bankname;
	}

	/**
	 * 
	 * @return the sender's IBAN
	 */
	public String getIBAN() {
		if (!parsed) {
			throw new RuntimeException("use extract() before requesting a value");
		}
		if (IBAN==null) {
			parse();
		}
		return IBAN;
	}

    /**
     *
     * @return the sender's KTO
     */
    public String getKTO() {
        if (!parsed) {
            throw new RuntimeException("use extract() before requesting a value");
        }
        if (KTO==null) {
            parse();
        }
        return KTO;
    }

    /**
	 * 
	 * @return the sender's bank name
	 */
	public String getBankName() {
		if (!parsed) {
			throw new RuntimeException("use extract() before requesting a value");
		}
		if (bankName==null) {
			parse();
		}
		return bankName;
	}

	private void setIBAN(String IBAN) {
		this.IBAN = IBAN;
	}

    private void setKTO(String KTO) {
        this.KTO = KTO;
    }

    /**
	 * 
	 * @return the name of the owner of the sender's bank account
	 */
	public String getHolder() {
		if (rawXML == null) {
			throw new RuntimeException("use extract() before requesting a value");
		}
		if (holder==null) {
			parse();
		}
		return holder;
	}

	private void setHolder(String holder) {
		this.holder = holder;
	}

	/**
	 * 
	 * @return the total payable amount
	 */
	public String getAmount() {
		if (rawXML == null) {
			throw new RuntimeException("use extract() before requesting a value");
		}
		if (amount==null) {
			parse();
		}
		return amount;
	}

	/**
	 * 
	 * @return when the payment is due
	 */
	public String getDueDate() {
		if (rawXML == null) {
			throw new RuntimeException("use extract() before requesting a value");
		}
		if (dueDate==null) {
			parse();
		}
		return dueDate;
	}

	private void setAmount(String amount) {
		this.amount = amount;
	}

	/**
	 * 
	 * @param meta
	 *            raw XML to be set
	 */
	public void setMeta(String meta) {
		this.rawXML = meta.getBytes();
	}

	/**
	 * 
	 * @return raw XML of the invoice
	 */
	public String getMeta() {
		if (rawXML == null) {
			return null;
		}

		return new String(rawXML);
	}

	
	/**
	 * 
	 * @return return UTF8 XML (without BOM) of the invoice
	 */
	public String getUTF8() {
		if (rawXML == null) {
			return null;
		}
		if (rawXML.length<3) {
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
}
