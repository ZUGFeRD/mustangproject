package org.mustangproject.Exceptions;

import java.text.ParseException;

/***
 * will be thrown if a invoice cant be read
 */
public class StructureException extends ParseException {
	private static final long serialVersionUID = 1L;

	public StructureException(String message, int line) {
		super(message, line);
	}
}
