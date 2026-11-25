package org.mustangproject.CII;

import com.helger.diagnostics.error.list.ErrorList;
import com.helger.en16931.cii2ubl.CIIToUBLDispatcher;
import com.helger.ubl21.UBL21Marshaller;
import com.helger.ubl25.UBL25Marshaller;

import java.io.File;
import java.io.Serializable;


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
		final CIIToUBLDispatcher cc = new CIIToUBLDispatcher();
		if (profileID != null) {
			cc.setProfileID(profileID);
		}
		if (customizationID != null) {
			cc.setCustomizationID(customizationID);
		}
		final Serializable aUBL = cc.convertCIItoUBL(input, occurred);
		if (aUBL instanceof oasis.names.specification.ubl.schema.xsd.invoice_21.InvoiceType) {
			UBL21Marshaller.invoice().setFormattedOutput(true).write((oasis.names.specification.ubl.schema.xsd.invoice_21.InvoiceType) aUBL, output);
		} else if (aUBL instanceof oasis.names.specification.ubl.schema.xsd.invoice_25.InvoiceType) {
			UBL25Marshaller.invoice().setFormattedOutput(true).write((oasis.names.specification.ubl.schema.xsd.invoice_25.InvoiceType) aUBL, output);
		} else if (aUBL instanceof oasis.names.specification.ubl.schema.xsd.creditnote_21.CreditNoteType) {
			UBL21Marshaller.creditNote().setFormattedOutput(true).write((oasis.names.specification.ubl.schema.xsd.creditnote_21.CreditNoteType) aUBL, output);
		} else if (aUBL instanceof oasis.names.specification.ubl.schema.xsd.creditnote_25.CreditNoteType) {
			UBL25Marshaller.creditNote().setFormattedOutput(true).write((oasis.names.specification.ubl.schema.xsd.creditnote_25.CreditNoteType) aUBL, output);
		}
	}
}
