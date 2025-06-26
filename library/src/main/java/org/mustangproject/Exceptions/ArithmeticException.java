package org.mustangproject.Exceptions;

import java.text.ParseException;

/***
 * will be thrown if an invoice cant be reproduced numerically
 */
public class ArithmeticException extends ArithmetricException {
	public ArithmeticException() {
		this("");
	}

	public ArithmeticException(String details) {
//		super("Could not reproduce the invoice. " + details, 0);
	}
}
