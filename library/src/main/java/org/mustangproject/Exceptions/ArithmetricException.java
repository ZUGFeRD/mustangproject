package org.mustangproject.Exceptions;

import java.text.ParseException;

/***
 * will be thrown if an invoice cant be reproduced numerically
 * (deprecated, because of typo)
 */
public class ArithmetricException extends ParseException {
	public ArithmetricException() {
		this("");
	}

	public ArithmetricException(String details) {
		super("Could not reproduce the invoice. " + details, 0);
	}
}
