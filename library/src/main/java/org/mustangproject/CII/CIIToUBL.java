package org.mustangproject.CII;

import java.io.File;
import java.io.Serializable;

import com.helger.commons.error.list.ErrorList;
import com.helger.en16931.cii2ubl.CIIToUBL23Converter;
import com.helger.ubl21.UBL21Writer;
import com.helger.ubl22.UBL22Writer;
import com.helger.ubl23.UBL23Writer;

/***
 * converts a Cross Industry Invoice XML file to a UBL XML file
 * thanks to Philip Helger for his library
*/
public class CIIToUBL {
	/***
	 * performs the actual conversion
	 * @param input the CII file to convert
	 * @param output the UBL file to write to
	 */
   public void convert(File input, File output) {
	   final ErrorList occurred=new ErrorList();
	   final CIIToUBL23Converter cc=new CIIToUBL23Converter();
	   final Serializable aUBL = cc.convertCIItoUBL(input, occurred);
	   if (aUBL instanceof oasis.names.specification.ubl.schema.xsd.invoice_21.InvoiceType)
	   {
		   UBL21Writer.invoice ()
				   .setFormattedOutput (true)
				   .write ((oasis.names.specification.ubl.schema.xsd.invoice_21.InvoiceType) aUBL, output);
	   }
	   else	if (aUBL instanceof oasis.names.specification.ubl.schema.xsd.creditnote_21.CreditNoteType)
	   {
		   UBL21Writer.creditNote ()
				   .setFormattedOutput (true)
				   .write ((oasis.names.specification.ubl.schema.xsd.creditnote_21.CreditNoteType) aUBL, output);
	   }
	   else	if (aUBL instanceof oasis.names.specification.ubl.schema.xsd.invoice_22.InvoiceType)
	   {
		   UBL22Writer.invoice ()
				   .setFormattedOutput (true)
				   .write ((oasis.names.specification.ubl.schema.xsd.invoice_22.InvoiceType) aUBL, output);
	   }
	   else if (aUBL instanceof oasis.names.specification.ubl.schema.xsd.creditnote_22.CreditNoteType)
	   {
		   UBL22Writer.creditNote ()
				   .setFormattedOutput (true)
				   .write ((oasis.names.specification.ubl.schema.xsd.creditnote_22.CreditNoteType) aUBL, output);
	   }
	   else if (aUBL instanceof oasis.names.specification.ubl.schema.xsd.invoice_23.InvoiceType)
	   {
		   UBL23Writer.invoice ()
				   .setFormattedOutput (true)
				   .write ((oasis.names.specification.ubl.schema.xsd.invoice_23.InvoiceType) aUBL, output);
	   }
     else if (aUBL instanceof oasis.names.specification.ubl.schema.xsd.creditnote_23.CreditNoteType)
	   {
		   UBL23Writer.creditNote ()
				   .setFormattedOutput (true)
				   .write ((oasis.names.specification.ubl.schema.xsd.creditnote_23.CreditNoteType) aUBL, output);
	   }
   }

}
