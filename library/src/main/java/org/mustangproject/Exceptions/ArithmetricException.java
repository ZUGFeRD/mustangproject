package org.mustangproject.Exceptions;

import java.text.ParseException;

/***
 * will be thrown if a invoice cant be reproduced numerically
 */
public class ArithmetricException extends ParseException {
	public ArithmetricException() {
		super(
			"Could not reproduce the invoice, this could mean that it could not be read properly", 0);
	}
}
