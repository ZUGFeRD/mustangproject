package org.mustangproject.validator;

import static org.xmlunit.assertj.XmlAssert.assertThat;

import java.io.File;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.junit.Before;
import org.junit.Test;
import org.xmlunit.xpath.JAXPXPathEngine;
import org.xmlunit.xpath.XPathEngine;

import junit.framework.TestCase;

public class PathTest extends TestCase {

	TestFileWalker zfWalk;

	@Before
	public void beforeEachTestMethod() {
		System.out.println("Invoked before each test method");
		TestFileWalker zfWalk = new TestFileWalker();

	}

	@Test
	public void testOfficialSamples() {
		// ignored for the
		// time being
		Path startingDir = Paths.get(System.getProperty("user.dir") + "/../../Release/Beispiele/");
		TestFileWalker zfWalk = new TestFileWalker();
		try {
			Files.walkFileTree(startingDir, zfWalk);

		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		// XPathEngine xpath = new JAXPXPathEngine();
		// File tempFile = getResourceAsFile("invalidV2.xml");
//https://stackoverflow.com/questions/16245914/execute-an-external-jar -> http://docs.oracle.com/javase/tutorial/deployment/jar/jarclassloader.html

		/**
		 * assertThat(content).valueByXPath("count(//error)") .asInt()
		 * .isGreaterThan(1); //2 errors are OK because there is a known bug
		 *
		 *
		 * assertThat(content).valueByXPath("//error[@type=\"4\"]") .asString()
		 * .contains( "In Deutschland sind die Profile MINIMUM und BASIC WL nur als
		 * Buchungshilfe (TypeCode: 751) zugelassen.");
		 *
		 */

	}

	@Test
	public void testFacturX() {
		TestFileWalker zfWalk = new TestFileWalker();
		Path startingDir = Paths.get(System.getProperty("user.dir") + "/../../foreign_samples/fx/");
		try {
			Files.walkFileTree(startingDir, zfWalk);

		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}

		// XPathEngine xpath = new JAXPXPathEngine();
		// File tempFile = getResourceAsFile("invalidV2.xml");
//https://stackoverflow.com/questions/16245914/execute-an-external-jar -> http://docs.oracle.com/javase/tutorial/deployment/jar/jarclassloader.html

		/**
		 * assertThat(content).valueByXPath("count(//error)") .asInt()
		 * .isGreaterThan(1); //2 errors are OK because there is a known bug
		 *
		 *
		 * assertThat(content).valueByXPath("//error[@type=\"4\"]") .asString()
		 * .contains( "In Deutschland sind die Profile MINIMUM und BASIC WL nur als
		 * Buchungshilfe (TypeCode: 751) zugelassen.");
		 *
		 */

	}

	@Test
	public void testTestFiles() {
		// ignored for the
		// time being
		/*https://www.xoev.de/sixcms/media.php/13/XRechnung_Kompakt.pdf "Problem
		–
		Nur positive Beispiele als Testgrundlage
		•
		Negative Beispiele sind sehr wichtig!"*/
	/*	Path startingDir = Paths.get(System.getProperty("user.dir") + "/testfiles/toPass/");
		try {
			Files.walkFileTree(startingDir, zfWalk);

		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
*/
		// XPathEngine xpath = new JAXPXPathEngine();
		// File tempFile = getResourceAsFile("invalidV2.xml");
//https://stackoverflow.com/questions/16245914/execute-an-external-jar -> http://docs.oracle.com/javase/tutorial/deployment/jar/jarclassloader.html

		/**
		 * assertThat(content).valueByXPath("count(//error)") .asInt()
		 * .isGreaterThan(1); //2 errors are OK because there is a known bug
		 *
		 *
		 * assertThat(content).valueByXPath("//error[@type=\"4\"]") .asString()
		 * .contains( "In Deutschland sind die Profile MINIMUM und BASIC WL nur als
		 * Buchungshilfe (TypeCode: 751) zugelassen.");
		 *
		 */

	}

}
