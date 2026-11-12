package org.mustangproject.dates;

import org.mustangproject.ZUGFeRD.IReferencedDocument;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.Date;

/**
 * Dates at midnight of the current default zone, so the expected values in the tests are
 * the same in every zone, while still comparing the exact instant.
 */
final class Days {

	private Days() {
	}

	/** midnight of the given day in the current default zone, i.e. how users create dates */
	static Date date(int year, int month, int day) {
		return Date.from(LocalDate.of(year, month, day).atStartOfDay(ZoneId.systemDefault()).toInstant());
	}

	/** the issue date of a referenced document, null if there is no document */
	static Date issueDate(IReferencedDocument doc) {
		return doc == null ? null : doc.getFormattedIssueDateTime();
	}
}
