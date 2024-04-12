package org.mustangproject.ZUGFeRD;

import junit.framework.TestCase;

import java.io.IOException;

public class EmptyPdfTest extends TestCase {

	public void testEmptyPdfFile() {
		try {
			new ZUGFeRDImporter("src/test/resources/emptyFile.pdf");
			fail("read empty pdf file");
		} catch (ZUGFeRDExportException e) {
			assertEquals("java.io.IOException: tried to read from empty file", e.getMessage());
		}

	}
}
