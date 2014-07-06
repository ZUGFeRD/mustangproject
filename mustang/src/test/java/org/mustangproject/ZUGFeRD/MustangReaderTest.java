package org.mustangproject.ZUGFeRD;

import java.io.IOException;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

/**
 * Unit test for simple App.
 */
public class MustangReaderTest extends TestCase {
	/**
	 * Create the test case
	 * 
	 * @param testName
	 *            name of the test case
	 */
	public MustangReaderTest(String testName) {
		super(testName);
	}

	/**
	 * @return the suite of tests being tested
	 */
	public static Test suite() {
		return new TestSuite(MustangReaderTest.class);
	}

	/**
	 * Rigourous Test :-)
	 */
	public void testImport() {
		ZUGFeRDImporter zi = new ZUGFeRDImporter();
		zi.extract("./src/test/MustangGnuaccountingBeispielRE-20140703_502.pdf");
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
		

		assertEquals(amount, "571.04");
		assertEquals(bic, "COBADEFXXX");
		assertEquals(iban, "DE88 2008 0000 0970 3757 00");
		assertEquals(holder, "Bei Spiel GmbH");
		assertEquals(ref, "RE-20140703/502");
		
		
	}
	
}
