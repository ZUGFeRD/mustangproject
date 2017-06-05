package org.mustangproject.ZUGFeRD;

public class ZUGFeRDExportException extends RuntimeException {
    /**
	 *
	 */
	private static final long serialVersionUID = 1L;

	public ZUGFeRDExportException() {
    }

    public ZUGFeRDExportException(String message) {
        super(message);
    }

    public ZUGFeRDExportException(String message, Throwable cause) {
        super(message, cause);
    }

    public ZUGFeRDExportException(Throwable cause) {
        super(cause);
    }
}
