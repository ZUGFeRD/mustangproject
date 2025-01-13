package org.mustangproject.Exceptions;

import java.text.ParseException;

/**
 * will be thrown if an invoice cannot be reproduced numerically
 */
public class ArithmeticException extends ParseException {
	@SuppressWarnings("unused")
	public ArithmeticException() {
		this("");
	}
	public ArithmeticException(final String msg) {
		super("Could not reproduce the invoice. " + msg, 0);
	}
}
