package org.mustangproject.ZUGFeRD;

import java.io.IOException;
import javax.activation.DataSource;
import org.apache.pdfbox.preflight.PreflightDocument;
import org.apache.pdfbox.preflight.ValidationResult;
import org.apache.pdfbox.preflight.exception.ValidationException;
import org.apache.pdfbox.preflight.parser.PreflightParser;

public final class PdfAUtils {

    private PdfAUtils() {
    }

    /**
     * Parse the PDF file with PreflightParser that inherits from the
     * NonSequentialParser. Some additional controls are present to check a set of
     * PDF/A requirements. (Stream length consistency, EOL after some Keyword...)
     * 
     * @return validation result with a list of potential errors
     */
    public static ValidationResult validatePdfA(DataSource dataSource) throws IOException {
	PreflightParser preflightParser = new PreflightParser(dataSource);
	preflightParser.parse(); // might add a Format.PDF_A1A as parameter and iterate through A1 and A3

	try (PreflightDocument doc = preflightParser.getPreflightDocument()) {
	    /*
	     * Once the syntax validation is done, the parser can provide a
	     * PreflightDocument (that inherits from PDDocument) This document process the
	     * end of PDF/A validation.
	     */
	    doc.validate();
	    return doc.getResult();
	}
    }

    public static boolean isPdfAValid(DataSource dataSource) throws IOException {
	try {
	    return validatePdfA(dataSource).isValid();
	} catch (ValidationException e) {
	    /*
	     * the parse method can throw a SyntaxValidationException if the PDF file can't
	     * be parsed. In this case, the exception contains an instance of
	     * ValidationResult
	     */
	    return false;
	}
    }

}
