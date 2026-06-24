package org.mustangproject.Exceptions;

import java.text.ParseException;

/***
 *
 * (deprecated, because of typo)
 */
public class ArithmetricException extends ParseException {
	/***
	 * will be thrown if an invoice cant be reproduced numerically
	 */
	public ArithmetricException() {
		this("");
	}

	/***
	 * Telling the issue...
	 * @param details explanation details
	 */
	public ArithmetricException(String details) {
		super("Could not reproduce the invoice. " + details, 0);
	}
}
