package org.mustangproject;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNull;

import java.text.SimpleDateFormat;
import java.util.Date;

import org.junit.jupiter.api.Test;
import org.mustangproject.ZUGFeRD.ZUGFeRDDateFormat;

public class XMLToolsTest {

	@Test
	public void rejectsADayTheMonthDoesNotContain() {
		Date rolled = XMLTools.tryDate("20240231");
		assertNull(rolled, rolled == null ? "" : ZUGFeRDDateFormat.DATE.getFormatter().format(rolled));
		assertNull(XMLTools.tryDate("20230229"));
		assertNull(XMLTools.tryDate("2024-02-31"));
		assertNull(XMLTools.tryDate("20240229extra"));
		assertEquals("20240229", ZUGFeRDDateFormat.DATE.getFormatter().format(XMLTools.tryDate("20240229")));
		assertEquals("2024-02-29", new SimpleDateFormat("yyyy-MM-dd").format(XMLTools.tryDate("2024-02-29")));
	}
}
