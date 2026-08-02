package org.mustangproject.CII;

import java.io.File;
import java.io.Serializable;

import com.helger.commons.error.list.ErrorList;
import com.helger.en16931.cii2ubl.CIIToUBL24Converter;
import com.helger.ubl24.UBL24Marshaller;

/***
 * converts a Cross Industry Invoice XML file to a UBL XML file
 * thanks to Philip Helger for his library
 */
public class CIIToUBL {
	/***
	 * performs the actual conversion
	 * @param input		the CII file to convert
	 * @param output	the UBL file to write to
	 */
	public void convert(File input, File output) {
		this.convert(input, output, null, null);
	}

	/***
	 * performs the actual conversion
	 * @param input				the CII file to convert
	 * @param output			the UBL file to write to
	 * @param profileID			The UBL profile ID to be used
	 * @param customizationID	The UBL customization ID to be used
	 */
	public void convert(File input, File output, String profileID, String customizationID) {
		final ErrorList occurred = new ErrorList();
		final CIIToUBL24Converter cc = new CIIToUBL24Converter();
		if (profileID != null) {
			cc.setProfileID(profileID);
		}
		if (customizationID != null) {
			cc.setCustomizationID(customizationID);
		}
		final Serializable aUBL = cc.convertCIItoUBL(input, occurred);
		if (aUBL instanceof oasis.names.specification.ubl.schema.xsd.invoice_24.InvoiceType) {
			UBL24Marshaller.invoice().setFormattedOutput(true).write((oasis.names.specification.ubl.schema.xsd.invoice_24.InvoiceType) aUBL, output);
		} else if (aUBL instanceof oasis.names.specification.ubl.schema.xsd.creditnote_24.CreditNoteType) {
		   UBL24Marshaller.creditNote().setFormattedOutput(true).write((oasis.names.specification.ubl.schema.xsd.creditnote_24.CreditNoteType) aUBL, output);
		}
	}
}
