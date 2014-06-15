package org.mustangproject.ZUGFeRD;
/**
 * Mustangproject's ZUGFeRD implementation
 * ZUGFeRD importer
 * Licensed under the APLv2
 * @date 2014-05-10
 * @version 1.0
 * @author jstaerk
 * */

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Map;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentNameDictionary;
import org.apache.pdfbox.pdmodel.PDEmbeddedFilesNameTreeNode;
import org.apache.pdfbox.pdmodel.common.COSObjectable;
import org.apache.pdfbox.pdmodel.common.filespecification.PDComplexFileSpecification;
import org.apache.pdfbox.pdmodel.common.filespecification.PDEmbeddedFile;
import org.w3c.dom.Document;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

public class ZUGFeRDImporter {
	/*
	call extract(importFilename). 
	containsMeta() will return if ZUGFeRD data has been found, 
	afterwards you can call getBIC(), getIBAN() etc.

*/
	
	/**@var if metadata has been found	 */
	private boolean containsMeta=false;
	/**@var the reference (i.e. invoice number) of the sender */
	private String foreignReference;
	private String BIC;
	private String IBAN;
	private String holder;
	private String amount;
	private String meta;
	private String bankName;
	private boolean amountFound;
	
	
	

	public void extract(String pdfFilename) {
		PDDocument doc;
		try {
			doc = PDDocument.load(pdfFilename);
//			PDDocumentInformation info = doc.getDocumentInformation();
			PDEmbeddedFilesNameTreeNode etn;
			PDDocumentNameDictionary names = new PDDocumentNameDictionary(
					doc.getDocumentCatalog());
			etn = names.getEmbeddedFiles();
			Map<String, COSObjectable> efMap = etn.getNames();
			// String filePath = "/tmp/";
			if (efMap==null)  {
				return;
			}
			for (String filename : efMap.keySet()) {
				/**
				 * currently (in the release candidate of version 1) only one
				 * attached file with the name ZUGFeRD-invoice.xml is allowed
				 * */
				if (filename.equals("ZUGFeRD-invoice.xml")) { //$NON-NLS-1$
					containsMeta = true;

					PDComplexFileSpecification fileSpec = (PDComplexFileSpecification) efMap
							.get(filename);
					PDEmbeddedFile embeddedFile = fileSpec.getEmbeddedFile();
					// String embeddedFilename = filePath + filename;
					// File file = new File(filePath + filename);
					// System.out.println("Writing " + embeddedFilename);
					// ByteArrayOutputStream fileBytes=new
					// ByteArrayOutputStream();
					// FileOutputStream fos = new FileOutputStream(file);

					setMeta(new String(embeddedFile.getByteArray()));
					// fos.write(embeddedFile.getByteArray());
					// fos.close();
				}
			}

		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

	}
	
	public void parse() {
		DocumentBuilderFactory factory = null;
		DocumentBuilder builder = null;
		Document document = null;

		factory = DocumentBuilderFactory.newInstance();
		try {
			builder = factory.newDocumentBuilder();
		} catch (ParserConfigurationException ex3) {
			// TODO Auto-generated catch block
			ex3.printStackTrace();
		}

		try {
			InputStream bais = new ByteArrayInputStream(meta.getBytes());
			document = builder.parse(bais);
		} catch (SAXException ex1) {
			ex1.printStackTrace();
		} catch (IOException ex2) {
			ex2.printStackTrace();
		}
		// rootNode = document.getDocumentElement();
		// ApplicableSupplyChainTradeSettlement
		NodeList ndList = document
				.getElementsByTagName("PaymentReference"); //$NON-NLS-1$
		for (int bookingIndex = 0; bookingIndex < ndList
				.getLength(); bookingIndex++) {
			Node booking = ndList.item(bookingIndex);
			// if there is a attribute in the tag number:value
			
			setForeignReference(booking.getTextContent());

		}
/*
		ndList = document
				.getElementsByTagName("GermanBankleitzahlID"); //$NON-NLS-1$

		for (int bookingIndex = 0; bookingIndex < ndList
				.getLength(); bookingIndex++) {
			Node booking = ndList.item(bookingIndex);
			// if there is a attribute in the tag number:value
			setBIC(booking.getTextContent());

		}

		ndList = document.getElementsByTagName("ProprietaryID"); //$NON-NLS-1$

		for (int bookingIndex = 0; bookingIndex < ndList
				.getLength(); bookingIndex++) {
			Node booking = ndList.item(bookingIndex);
			// if there is a attribute in the tag number:value
			setIBAN(booking.getTextContent());

		}
*/
		ndList = document.getElementsByTagName("PayeePartyCreditorFinancialAccount"); //$NON-NLS-1$

		for (int bookingIndex = 0; bookingIndex < ndList
				.getLength(); bookingIndex++) {
			Node booking = ndList.item(bookingIndex);
			// there are many "name" elements, so get the one below
			// SellerTradeParty
			NodeList bookingDetails = booking.getChildNodes();
			for (int detailIndex = 0; detailIndex < bookingDetails
					.getLength(); detailIndex++) {
				Node detail = bookingDetails.item(detailIndex);
				if (detail.getNodeName().equals("IBANID")) { //$NON-NLS-1$
					setIBAN(detail.getTextContent());
				}
			}

		}

		ndList = document.getElementsByTagName("PayeeSpecifiedCreditorFinancialInstitution"); //$NON-NLS-1$

		for (int bookingIndex = 0; bookingIndex < ndList
				.getLength(); bookingIndex++) {
			Node booking = ndList.item(bookingIndex);
			// there are many "name" elements, so get the one below
			// SellerTradeParty
			NodeList bookingDetails = booking.getChildNodes();
			for (int detailIndex = 0; detailIndex < bookingDetails
					.getLength(); detailIndex++) {
				Node detail = bookingDetails.item(detailIndex);
				if (detail.getNodeName().equals("BICID")) { //$NON-NLS-1$
					setBIC(detail.getTextContent());
				}
				if (detail.getNodeName().equals("Name")) { //$NON-NLS-1$
					setBankName(detail.getTextContent());
				}
			}

		}

		//
		ndList = document.getElementsByTagName("SellerTradeParty"); //$NON-NLS-1$

		for (int bookingIndex = 0; bookingIndex < ndList
				.getLength(); bookingIndex++) {
			Node booking = ndList.item(bookingIndex);
			// there are many "name" elements, so get the one below
			// SellerTradeParty
			NodeList bookingDetails = booking.getChildNodes();
			for (int detailIndex = 0; detailIndex < bookingDetails
					.getLength(); detailIndex++) {
				Node detail = bookingDetails.item(detailIndex);
				if (detail.getNodeName().equals("Name")) { //$NON-NLS-1$
					setHolder(detail.getTextContent());
				}
			}

		}

		ndList = document.getElementsByTagName("DuePayableAmount"); //$NON-NLS-1$

		for (int bookingIndex = 0; bookingIndex < ndList
				.getLength(); bookingIndex++) {
			Node booking = ndList.item(bookingIndex);
			// if there is a attribute in the tag number:value
			amountFound=true;
			setAmount(booking.getTextContent());

		}


		if  (!amountFound) {
			/* there is apparently no requirement to mention DuePayableAmount,, 
			 * if it's not there, check for GrandTotalAmount
			 */
			ndList = document.getElementsByTagName("GrandTotalAmount"); //$NON-NLS-1$
			for (int bookingIndex = 0; bookingIndex < ndList
					.getLength(); bookingIndex++) {
				Node booking = ndList.item(bookingIndex);
				// if there is a attribute in the tag number:value
				amountFound=true;
				setAmount(booking.getTextContent());

			}
			
		}
	

	}


	public boolean containsMeta() {
		return containsMeta;
	}

	public String getForeignReference() {
		return foreignReference;
	}



	public void setForeignReference(String foreignReference) {
		this.foreignReference = foreignReference;
	}



	public String getBIC() {
		return BIC;
	}



	private void setBIC(String bic) {
		this.BIC = bic;
	}


	private void setBankName(String bankname) {
		this.bankName = bankname;
	}



	public String getIBAN() {
		return IBAN;
	}


	public String getBankName() {
		return bankName;
	}



	public void setIBAN(String IBAN) {
		this.IBAN = IBAN;
	}



	public String getHolder() {
		return holder;
	}



	private void setHolder(String holder) {
		this.holder = holder;
	}



	public String getAmount() {
		return amount;
	}


	private void setAmount(String amount) {
		this.amount = amount;
	}

	public void setMeta(String meta) {
		this.meta=meta;
	}

	public String getMeta() {
		return meta;
	}

	/**
	 * will return true if the metadata (just extract-ed or set with setMeta) contains ZUGFeRD XML
	 * */
	public boolean canParse() {
		
		
		//SpecifiedExchangedDocumentContext is in the schema, so a relatively good indication if zugferd is present - better than just invoice
		return (meta!=null)&&( meta.length()>0)&&( meta.contains("SpecifiedExchangedDocumentContext")); //$NON-NLS-1$
	}
}
