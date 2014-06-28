package org.mustangproject.ZUGFeRD;

import java.io.IOException;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 * Unit test for simple App.
 */
public class AppTest extends TestCase {
	/**
	 * Create the test case
	 * 
	 * @param testName
	 *            name of the test case
	 */
	public AppTest(String testName) {
		super(testName);
	}

	/**
	 * @return the suite of tests being tested
	 */
	public static Test suite() {
		return new TestSuite(AppTest.class);
	}

	/**
	 * Rigourous Test :-)
	 */
	public void testImport() {
		ZUGFeRDImporter zi = new ZUGFeRDImporter();
		zi.extract("./src/test/java/org/mustangproject/ZUGFeRD/RE-20140628_9.pdf");
		// Reading ZUGFeRD
		
		String amount=null;
		String bic=null;
		String iban=null;
		String holder=null;
		String ref=null;
		
		if (zi.canParse()) {
			zi.parse();
			amount=zi.getAmount();
			bic=zi.getBIC();
			iban=zi.getIBAN();
			holder=zi.getHolder();
			ref=zi.getForeignReference();
		}
		

		assertEquals(amount, "1.19");
		assertEquals(bic, "DE5656565");
		assertEquals(iban, "DE1234");
		assertEquals(holder, "usegroup");
		assertEquals(ref, "RE-20140628/9");
		
		
	}
}
