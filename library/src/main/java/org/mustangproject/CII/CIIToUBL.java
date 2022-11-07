package org.mustangproject.CII;
import com.helger.commons.error.list.ErrorList;
import com.helger.en16931.cii2ubl.CIIToUBL22Converter;
import com.helger.ubl21.UBL21Writer;
import com.helger.ubl22.UBL22Writer;

import java.io.File;
import java.io.Serializable;

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
	   ErrorList occurred=new ErrorList();
	   CIIToUBL22Converter cc=new CIIToUBL22Converter();
	   Serializable aUBL = cc.convertCIItoUBL(input, occurred);
	   if (aUBL instanceof oasis.names.specification.ubl.schema.xsd.invoice_21.InvoiceType)
	   {
		   UBL21Writer.invoice ()
				   .setFormattedOutput (true)
				   .write ((oasis.names.specification.ubl.schema.xsd.invoice_21.InvoiceType) aUBL, output);
	   }
	   else
	   if (aUBL instanceof oasis.names.specification.ubl.schema.xsd.creditnote_21.CreditNoteType)
	   {
		   UBL21Writer.creditNote ()
				   .setFormattedOutput (true)
				   .write ((oasis.names.specification.ubl.schema.xsd.creditnote_21.CreditNoteType) aUBL, output);
	   }
	   else
	   if (aUBL instanceof oasis.names.specification.ubl.schema.xsd.invoice_22.InvoiceType)
	   {
		   UBL22Writer.invoice ()
				   .setFormattedOutput (true)
				   .write ((oasis.names.specification.ubl.schema.xsd.invoice_22.InvoiceType) aUBL, output);
	   }
	   else
	   if (aUBL instanceof oasis.names.specification.ubl.schema.xsd.creditnote_22.CreditNoteType)
	   {
		   UBL22Writer.creditNote ()
				   .setFormattedOutput (true)
				   .write ((oasis.names.specification.ubl.schema.xsd.creditnote_22.CreditNoteType) aUBL, output);
	   }
   }

}
