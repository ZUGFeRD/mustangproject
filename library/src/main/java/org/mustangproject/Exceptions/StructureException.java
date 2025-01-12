package org.mustangproject.Exceptions;

import java.text.ParseException;

/***
 * will be thrown if an invoice cannot be read
 */
public class StructureException extends ParseException {
    public StructureException(String message, int line) {
        super(message, line);
    }
}
