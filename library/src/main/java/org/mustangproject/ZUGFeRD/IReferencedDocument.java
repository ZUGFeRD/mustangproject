package org.mustangproject.ZUGFeRD;

import java.util.Date;

public interface IReferencedDocument {

	/***
	 * sets an ID assigned by the sender
	 * @return String of an ID
	 */
	String getIssuerAssignedID();

	/***
	 * which type is the document? e.g. "916" for additional invoice related
	 * @return string of a most likely numeric code
	 */
	String getTypeCode();

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

}
