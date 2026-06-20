package org.mustangproject.Exceptions;

import java.text.ParseException;

/***
 * ArithmetricException for backwards compatibility, was a spelling error
 */
public class ArithmeticException extends ArithmetricException {
	/***
	 *  will be thrown if an invoice cant be reproduced numerically
	 */
	public ArithmeticException() {
		super();
	}

	/***
	 * Exceptions usually are raised with details
	 * @param details the text
	 */
	public ArithmeticException(String details) {
		super(details);
	}
}
