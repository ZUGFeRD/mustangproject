package org.mustangproject.ZUGFeRD;

import java.util.Date;

public interface IReferencedDocument {

	/***
	 * sets an ID assigned by the sender
	 * @return String of an ID
	 */
	String getIssuerAssignedID();

	/***
	 * sets a line ID assigned by the sender
	 * @return String of a lineID
	 */
	String getLineID();

	/***
	 * which type is the document? e.g. "916" for additional invoice related
	 * @return string of a most likely numeric code
	 */
	String getTypeCode();

	/***
	 * sets the Name assigned by the sender
	 * @return String of the Name
	 */
	default String getName() {
		return null;
	}

	/***
	 * type of the reference of this line, a UNTDID 1153 code
	 * @return String of a code
	 */
	String getReferenceTypeCode();

	/***
	 *
	 * issue date of this line
	 *
	 * @return date of the issue
	 */
	Date getFormattedIssueDateTime();

	/***
	 * @return this particular cash discount as cross industry invoice XML
	 */
	String getAsCII();
}
