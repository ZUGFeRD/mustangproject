package org.mustangproject.validator;

/***
 * a validation error so drastical it has to abort everything, e.g. if no xml is found at all
 */
public class IrrecoverableValidationError extends Exception {

	/**
	 *
	 */
	private static final long serialVersionUID = 1L;

	/***
	 * constructor
	 * @param message the exception explanation
	 */
	public IrrecoverableValidationError(String message) {
		super(message);
	}

}
