package org.mustangproject.CII;

import java.io.File;
import java.io.Serializable;

import com.helger.commons.error.list.ErrorList;
import com.helger.en16931.cii2ubl.CIIToUBL23Converter;
import com.helger.ubl23.UBL23Marshaller;

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
		final CIIToUBL23Converter cc = new CIIToUBL23Converter();
		if (profileID != null) {
			cc.setProfileID(profileID);
		}
		if (customizationID != null) {
			cc.setCustomizationID(customizationID);
		}
		final Serializable aUBL = cc.convertCIItoUBL(input, occurred);
		if (aUBL instanceof oasis.names.specification.ubl.schema.xsd.invoice_23.InvoiceType) {
			UBL23Marshaller.invoice ().setFormattedOutput (true).write((oasis.names.specification.ubl.schema.xsd.invoice_23.InvoiceType)aUBL, output);
		}
		else if (aUBL instanceof oasis.names.specification.ubl.schema.xsd.creditnote_23.CreditNoteType)	{
		   UBL23Marshaller.creditNote ().setFormattedOutput (true).write((oasis.names.specification.ubl.schema.xsd.creditnote_23.CreditNoteType) aUBL, output);
		}
	}
}
