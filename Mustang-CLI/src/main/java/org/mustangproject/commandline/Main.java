/************************************************************************
 *
 * Copyright 2018 Jochen Staerk
 *
 * Use is subject to license terms.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy
 * of the License at http://www.apache.org/licenses/LICENSE-2.0.
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 *********************************************************************** */
package org.mustangproject.commandline;

import org.apache.commons.cli.*;
import org.mustangproject.CII.CIIToUBL;
import org.mustangproject.EStandard;
import org.mustangproject.FileAttachment;
import org.mustangproject.ZUGFeRD.*;
import org.mustangproject.validator.ZUGFeRDValidator;
import org.slf4j.LoggerFactory;

import javax.xml.transform.TransformerException;
import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;

public class Main {
	private static org.slf4j.Logger LOGGER; // log output
	private static void printUsage() {
		System.err.println(getUsage());
	}

	private static String getUsage() {
		return "Usage: --action metrics|combine|extract|a3only|ubl|validate|validateExpectInvalid|validateExpectValid|visualize [-d,--directory] [-l,--listfromstdin] [-i,--ignore fileextension, PDF/A errors] [--disable-file-logging] | [-h,--help] \r\n"
				+ "        --action license   display open source license and notice\n"
				+ "        --action metrics\n"
				+ "          -d, --directory count ZUGFeRD files in directory to be scanned\n"
				+ "                If it is a directory, it will recurse.\n"
				+ "          -l, --listfromstdin     count ZUGFeRD files from a list of linefeed separated files on runtime.\n"
				+ "                It will start once a blank line has been entered.\n" + "\n"
				+ "        Additional parameter for both count operations\n"
				+ "        [-i, --ignorefileextension]     Check for all files (*.*) instead of PDF files only (*.pdf) in metrics, ignore PDF/A input file errors in combine\n"
			    + "        [--disable-file-logging]		disable logging to file.\n"
				+ "        --action extract   extract Factur-X PDF to XML file\n"
				+ "                Additional parameters (optional - user will be prompted if not defined)\n"
				+ "                [--source <filename>]: set input PDF file\n"
				+ "                [--out <filename>]: set output XML file\n"
				+ "        --action a3only    upgrade from PDF/A1 to A3 only (no ZUGFeRD data attached)\n"
				+ "                Additional parameters (optional - user will be prompted if not defined)\n"
				+ "                [--source <filename>]: set input PDF file\n"
				+ "                [--out <filename>]: set output PDF file\n"
				+ "        --action combine   combine XML and PDF file to Factur-X PDF file\n"
				+ "                Additional parameters (optional - user will be prompted if not defined)\n"
				+ "                [--source <filename>]: set input PDF file\n"
				+ "                [--source-xml <filename>]: set input XML file\n"
				+ "                [--out <filename>]: set output PDF file\n"
				+ "                [--format <fx|zf|ox|da>]: set Factur-X, ZUGFeRD, Order-X or Cross Industry Despatch Advice\n"
				+ "                [--version <1|2>]: set ZUGFeRD version\n"
				+ "                [--profile <...>]: set ZUGFeRD profile\n"
				+ "                        For ZUGFeRD v1 or Order-X: <B>ASIC, <C>OMFORT or EX<T>ENDED\n"
				+ "                        For ZUGFeRD v2: <M>INIMUM, BASIC <W>L, <B>ASIC, <C>IUS, <E>N16931, <X>Rechnung, EX<T>ENDED\n"
				+ "                [--attachments <filenames>]: list of file attachments (passing a single empty file name prevents prompting)\n"
				+ "        --action ubl   convert UN/CEFACT 2016b CII XML to UBL XML\n"
				+ "                [--source <filename>]: set input XML file\n"
				+ "                [--out <filename>]: set output XML file\n"
				+ "        --action upgrade   upgrade ZUGFeRD XML to ZUGFeRD 2 XML\n"
				+ "                Additional parameters (optional - user will be prompted if not defined)\n"
				+ "                [--source <filename>]: set input XML ZUGFeRD 1 file\n"
				+ "                [--out <filename>]: set output XML ZUGFeRD 2 file\n"
				+ "        --action validate  validate XML or PDF file \n"
				+ "                [--no-notices]: refrain from reporting notices\n"
				+ "                [--logAppend <text>]: text to be added to log line\n"
				+ "                Additional parameters (optional - user will be prompted if not defined)\n"
				+ "                [--source <filename>]: input PDF or XML file\n"
				+ "        --action validateExpectInvalid  validate directory expecting negative results \n"
				+ "                [--no-notices]: refrain from reporting notices\n"
				+ "                Additional parameters (optional - user will be prompted if not defined)\n"
				+ "					-d, --directory to check recursively\n"
				+ "        --action validateExpectValid  validate directory expecting positive results \n"
				+ "                [--no-notices]: refrain from reporting notices\n"
				+ "                Additional parameters (optional - user will be prompted if not defined)\n"
				+ "					-d, --directory to check recursively \n"
				+ "        --action visualize  convert XML to HTML \n"
				+ "                [--language <lang>]: set output lang (en, fr or de)\n"
				+ "                [--source <filename>]: set input XML file\n"
				+ "                [--out <filename>]: set output HTML file\n"
			+ "        --action pdf  convert XML to PDF \n"
			+ "                [--source <filename>]: set input XML file\n"
			+ "                [--out <filename>]: set output PDF file\n"
			;
	}

	private static void printHelp() {
		System.out.println("Mustangproject.org " + org.mustangproject.ZUGFeRD.Version.VERSION + " \r\n"
			+ "A Apache Public License tool for e-invoices with\r\n"
			+ "ZUGFeRD Metadata (http://www.zugferd.org)\r\n" + "\r\n" + getUsage() + "\r\n");
	}

	/**
	 * Asks the user (repeatedly, if neccessary) on the command line for a String
	 * (offering a defaultValue) conforming to a Regex pattern
	 *
	 * @param prompt       the question to be asked to the user
	 * @param defaultValue the default return value if user hits enter
	 * @param pattern      a regex of acceptable values
	 * @return the user answer conforming to pattern
	 * @throws Exception if pattern not compielable or IOexception on input
	 */
	protected static String getStringFromUser(String prompt, String defaultValue, String pattern) throws Exception {
		String input = "";
		if (!defaultValue.matches(pattern)) {
			throw new Exception("Default value must match pattern");
		}
		boolean firstInput = true;
		do {
			// for a more sophisticated dialogue maybe https://github.com/mabe02/lanterna/
			// could be taken into account
			System.out.print(prompt + " (default: " + defaultValue + ")");
			if ((!firstInput) && (pattern.length() > 0)) {
				System.out.print("\n(allowed pattern: " + pattern + ")");

			}
			System.out.print(":");
			BufferedReader buffer = new BufferedReader(new InputStreamReader(System.in));
			try {
				input = buffer.readLine();
			} catch (IOException e) {
				LOGGER.error(e.getMessage(), e);

			}

			if (input.isEmpty()) {
				// pressed return without entering anything
				input = defaultValue;
			}

			firstInput = false;
		} while (!input.matches(pattern));

		return input;
	}

	/**
	 * Prompts the user for a input or output filename
	 *
	 * @param prompt              the text the user is asked
	 * @param defaultFilename     a default Filename. Passing an empty string indicates that specifying a file is optional
	 * @param expectedExtension   will warn if filename does not match expected file extension, "or" possible with e.g. pdf|xml
	 * @param ensureFileExists    will warn if file does NOT exist (for input files)
	 * @param ensureFileNotExists will warn if file DOES exist (for output files)
	 * @return String
	 */
	protected static String getFilenameFromUser(String prompt, String defaultFilename, String expectedExtension,
												boolean ensureFileExists, boolean ensureFileNotExists) {
		boolean fileExistenceOK = false;
		String selectedName = "";
		do {
			// for a more sophisticated dialogue maybe https://github.com/mabe02/lanterna/
			// could be taken into account
			System.out.print(prompt + (defaultFilename.isEmpty() ? ":" : " (default: " + defaultFilename + "):"));
			BufferedReader buffer = new BufferedReader(new InputStreamReader(System.in));
			try {
				selectedName = buffer.readLine();
			} catch (IOException e) {
				LOGGER.error(e.getMessage(), e);

			}

			if (selectedName.isEmpty()) {
				// pressed return without entering anything
				if (defaultFilename.isEmpty()) {
					return "";  //no default -> this is an optional filename
				}
				selectedName = defaultFilename;
			}

			boolean hasCorrectExtension = false;
			String[] expectedExtensions = expectedExtension.split("\\|");
			for (String currentExtension : expectedExtensions) {
				if (selectedName.toLowerCase().endsWith(currentExtension.toLowerCase())) {
					hasCorrectExtension = true;
					break;
				}
			}
			// error cases
			if (ensureFileExists) {
				if (fileExists(selectedName)) {
					fileExistenceOK = true;
				} else {
					System.out.println("File does not exist, try again or CTRL+C to cancel");
					// discard the input, a scanner.reset is not sufficient
					fileExistenceOK = false;
				}
			} else if (!hasCorrectExtension) {
				System.err.println("Expected " + expectedExtension
					+ " extension, this may corrupt your file. Do you still want to continue?(Y|N)");
				String selectedAnswer = "";
				try {
					selectedAnswer = buffer.readLine();
				} catch (IOException e) {
					LOGGER.error(e.getMessage(), e);
				}
				if (!selectedAnswer.equals("Y") && !selectedAnswer.equals("y")) {
					System.err.println("Aborted by user");
					System.exit(-1);
				}

			} else {
				fileExistenceOK = true;

				if (ensureFileNotExists) {
					if (fileExists(selectedName)) {
						fileExistenceOK = false;
						System.out.println("Output file already exists, try again or CTRL+C to cancel");
						// discard the input, a scanner.reset is not sufficient
					}
				} else {
					fileExistenceOK = true;
				}
			}

		} while (!fileExistenceOK);

		return selectedName;
	}

	private static void performUpgrade(String xmlName, String outName) throws IOException, TransformerException {

		// Get params from user if not already defined
		if (xmlName == null) {
			xmlName = getFilenameFromUser("ZUGFeRD 1.0 XML source", "ZUGFeRD-invoice.xml", "xml", true, false);
		} else {
			System.out.println("ZUGFeRD 1.0 XML source set to " + xmlName);
		}
		if (outName == null) {
			outName = getFilenameFromUser("ZUGFeRD 2.0 XML target", "factur-x.xml", "xml", false, true);
		} else {
			System.out.println("ZUGFeRD 2 XML target to " + outName);
		}

		// Verify params
		ensureFileExists(xmlName);
		ensureFileNotExists(outName);

		// All params are good! continue...
		XMLUpgrader zmi = new XMLUpgrader();
		String xml = zmi.migrateFromV1ToV2(xmlName);
		Files.write(Paths.get(outName), xml.getBytes());
		System.out.println("Written to " + outName);

	}

	/***
	 * converts from CII to UBL
	 * @param xmlName the name of the xml file
	 * @param outName the name of the output file
	 * @throws IOException
	 * @throws TransformerException
	 */
	private static void performUBL(String xmlName, String outName) throws IOException, TransformerException {

		// Get params from user if not already defined
		if (xmlName == null) {
			xmlName = getFilenameFromUser("Factur-X XML source", "factur-x.xml", "xml", true, false);
		} else {
			System.out.println("Factur-X XML source set to " + xmlName);
		}
		if (outName == null) {
			outName = getFilenameFromUser("UBL target", "ubl-invoice.xml", "xml", false, true);
		} else {
			System.out.println("UBL target to " + outName);
		}

		// Verify params
		ensureFileExists(xmlName);
		ensureFileNotExists(outName);

		// All params are good! continue...
		CIIToUBL c2u = new CIIToUBL();
		c2u.convert(new File(xmlName), new File(outName));
		System.out.println("Written to " + outName);

	}

	public static void printLicense() {
		InputStream is = Thread.currentThread().getContextClassLoader().getResourceAsStream("LICENSE");
		System.out.println(convertInputStreamToString(is));
		is = Thread.currentThread().getContextClassLoader().getResourceAsStream("NOTICE");
		System.out.println(convertInputStreamToString(is));

	}

	// Plain Java
	// based on https://mkyong.com/java/how-to-convert-inputstream-to-string-in-java/
	private static String convertInputStreamToString(InputStream is) {
		int DEFAULT_BUFFER_SIZE = 8192;
		ByteArrayOutputStream result = new ByteArrayOutputStream();
		byte[] buffer = new byte[DEFAULT_BUFFER_SIZE];
		int length;
		try {
			while ((length = is.read(buffer)) != -1) {
				result.write(buffer, 0, length);
			}

			// Java 1.1
			return result.toString(StandardCharsets.UTF_8.name());
		} catch (IOException e) {
			e.printStackTrace();
		}
		return null;
		// Java 10
		// return result.toString(StandardCharsets.UTF_8);

	}

	/***
	 * the main function of the commandline tool...
	 * @param args the commandline args, see also https://www.mustangproject.org/commandline/#verbose
	 */
	public static void main(String[] args) {
		try {
			CommandLine cmd;
			CommandLineParser parser = new BasicParser();

			// create Options object
			Options options = new Options();
			options.addOption(new Option("h", "help", false, "display usage"));
			options.addOption(new Option("a", "action", true, "which action to perform"));
			options.addOption(new Option("f", "format", true, "which format to output"));
			options.addOption(new Option("version", "version", true, "which version of the standard to use"));
			options.addOption(new Option("profile", "profile", true, "which profile of the standard to use"));
			Option attachmentOpt = new Option("attachments", "attachments", true, "File attachments");
			attachmentOpt.setValueSeparator(',');
			attachmentOpt.setArgs(Option.UNLIMITED_VALUES);

			options.addOption(attachmentOpt);
			options.addOption(new Option("source", "source",true, "which source file to use"));
			options.addOption(new Option("source-xml", "source-xml",true, "which source file to use"));
			options.addOption(new Option("language", "language",true, "output language (en, de or fr)"));
			options.addOption(new Option("out", "out",true, "which output file to write to"));
			options.addOption(new Option("no-notices", "no-notices",false, "suppress non-fatal errors"));
			options.addOption(new Option("logAppend", "logAppend",true, "freeform text to be appended to log messages"));
			options.addOption(new Option("disable-file-logging", "disable-file-logging", false, "suppress logging to file"));
			options.addOption(new Option("d", "directory",true, "which directory to operate on"));
			options.addOption(new Option("i", "ignorefileextension",false, "ignore non-matching file extensions"));
			options.addOption(new Option("l", "listfromstdin",false, "take list of files from commandline"));

			boolean optionsRecognized=false;
			String action = "";

			Boolean disableFileLogging = false;
			try {
				cmd = parser.parse(options, args);

				// Retrieve all options
				action = cmd.getOptionValue("action");
				String directoryName = cmd.getOptionValue("directory");
				Boolean filesFromStdIn = cmd.hasOption("listfromstdin");//((Number)cmdLine.getParsedOptionValue("integer-option")).intValue();
				Boolean ignoreFileExt = cmd.hasOption("ignorefileextension");
				Boolean helpRequested = cmd.hasOption("help")  || ((action!=null)&&(action.equals("help")));
				disableFileLogging = cmd.hasOption("disable-file-logging");

				String sourceName = cmd.getOptionValue("source");
				String sourceXMLName = cmd.getOptionValue("source-xml");
				String outName = cmd.getOptionValue("out");
				String format = cmd.getOptionValue("format");
				String lang = cmd.getOptionValue("language");
				Boolean noNotices = cmd.hasOption("no-notices");

				String zugferdVersion = cmd.getOptionValue("version");
				String zugferdProfile = cmd.getOptionValue("profile");

				String[] attachmentFilenames = cmd.hasOption("attachments") ? cmd.getOptionValues("attachments") : null;




				ArrayList<FileAttachment> attachments=new ArrayList <>();
				/*
					setting system property to disable FILE appender and
					suppress creation of files and folders.
				 */
				System.setProperty("FILE_APPENDER_ENABLED",  ((Boolean)(disableFileLogging==false)).toString());

				LOGGER = LoggerFactory.getLogger(org.slf4j.Logger.ROOT_LOGGER_NAME);

				if (helpRequested) {
					printHelp();
					optionsRecognized = true;
				} /* else if ((action!=null)&&(action.equals("license"))) {
				printLicense();
				optionsRecognized=true;
			} */ else if ((action != null) && (action.equals("metrics"))) {
					performMetrics(directoryName, filesFromStdIn, ignoreFileExt);
					optionsRecognized = true;
				} else if ((action != null) && (action.equals("combine"))) {
					performCombine(sourceName, sourceXMLName, outName, format, zugferdVersion, zugferdProfile, ignoreFileExt, attachmentFilenames, attachments);
					optionsRecognized = true;
				} else if ((action != null) && (action.equals("extract"))) {
					performExtract(sourceName, outName);
					optionsRecognized = true;
				} else if ((action != null) && (action.equals("a3only"))) {
					performConvert(sourceName, outName);
					optionsRecognized = true;
				} else if ((action != null) && (action.equals("pdf"))) {
					performVisualization(sourceName, lang, outName, true);
					optionsRecognized = true;
				} else if ((action != null) && (action.equals("visualize"))) {
					performVisualization(sourceName, lang, outName, false);
					optionsRecognized = true;
				} else if ((action != null) && (action.equals("upgrade"))) {
					performUpgrade(sourceName, outName);
					optionsRecognized = true;
				} else if ((action != null) && (action.equals("ubl"))) {
					performUBL(sourceName, outName);
					optionsRecognized = true;
				} else if ((action != null) && (action.equals("validate"))) {
					optionsRecognized = performValidate(sourceName, noNotices != null && noNotices, cmd.getOptionValue("logAppend"));
				} else if ((action != null) && (action.equals("validateExpectValid"))) {
					optionsRecognized = performValidateExpect(true, directoryName);
				} else if ((action != null) && (action.equals("validateExpectInvalid"))) {
					optionsRecognized = performValidateExpect(false, directoryName);
				}

			} catch (UnrecognizedOptionException ex) {
				optionsRecognized = false;
			}

			if (!optionsRecognized) {
				// no argument or argument unknown
				printUsage();
				System.exit(2);
			}
		} catch (Exception e) {
			LOGGER.error(e.getMessage(), e);
			System.exit(-1);
		}

	}

	private static boolean performValidate(String sourceName, boolean noNotices, String logAppend) {
		boolean optionsRecognized;
		if (sourceName == null) {
			sourceName = getFilenameFromUser("Source PDF or XML", "invoice.pdf", "pdf|xml", true, false);
		}
		ZUGFeRDValidator zfv = new ZUGFeRDValidator();
		if ((logAppend != null) && (logAppend.length() > 0)) {
			zfv.setLogAppend(logAppend);
		}
		if (noNotices) {
			zfv.disableNotices();
		}
		System.out.println(zfv.validate(sourceName));
		optionsRecognized = !zfv.hasOptionsError();
		if (!zfv.wasCompletelyValid()) {
			System.exit(-1);
		}
		return optionsRecognized;
	}

	private static boolean performValidateExpect(boolean valid, String dirName) {
		ValidatorFileWalker zfWalk = new ValidatorFileWalker(valid);
		Path startingDir = Paths.get(dirName);
		try {
			Files.walkFileTree(startingDir, zfWalk);

		} catch (IOException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		String totalResult = "valid";
		if (!zfWalk.getResult()) {
			totalResult = "invalid";
			System.exit(-1);
		}

		System.out.println("Overall test result: " + totalResult);

		return true;
	}


	private static void performConvert(String pdfName, String outName) throws IOException {
		/*
		 * ZUGFeRDExporter ze= new ZUGFeRDExporterFromA1Factory()
		 * .setProducer("toecount") .setCreator(System.getProperty("user.name"))
		 * .loadFromPDFA1("invoice.pdf");
		 */
		// Get params from user if not already defined
		if (pdfName == null) {
			pdfName = getFilenameFromUser("Source PDF", "invoice.pdf", "pdf", true, false);
		} else {
			System.out.println("Source PDF set to " + pdfName);
		}
		if (outName == null) {
			outName = getFilenameFromUser("Target PDF", "invoice.a3.pdf", "pdf", false, true);
		} else {
			System.out.println("Target PDF set to " + outName);
		}

		// Verify params
		ensureFileExists(pdfName);
		ensureFileNotExists(outName);

		// All params are good! continue...
		ZUGFeRDExporterFromA1 ze = new ZUGFeRDExporterFromA1().convertOnly().load(pdfName);

		ze.export(outName);
		System.out.println("Written to " + outName);
	}

	private static void performExtract(String pdfName, String xmlName) throws IOException {
		// Get params from user if not already defined
		if (pdfName == null) {
			pdfName = getFilenameFromUser("Source PDF", "invoice.pdf", "pdf", true, false);
		} else {
			System.out.println("Source PDF set to " + pdfName);
		}
		if (xmlName == null) {
			xmlName = getFilenameFromUser("ZUGFeRD XML", "factur-x.xml", "xml", false, true);
		} else {
			System.out.println("ZUGFeRD XML set to " + pdfName);
		}

		// Verify params
		ensureFileExists(pdfName);
		ensureFileNotExists(xmlName);

		// All params are good! continue...
		ZUGFeRDImporter zi = new ZUGFeRDImporter(pdfName);
		byte[] XMLContent = zi.getRawXML();
		if (XMLContent == null) {
			System.err.println("No ZUGFeRD XML found in PDF file");

		} else {
			Files.write(Paths.get(xmlName), XMLContent);
			System.out.println("Written to " + xmlName);
		}
	}

	private static void performCombine(String pdfName, String xmlName, String outName, String format, String zfVersion,
									   String zfProfile, Boolean ignoreInputErrors, String[] attachmentFilenames, ArrayList<FileAttachment> attachments) throws Exception {
		/*
		 * ZUGFeRDExporter ze= new ZUGFeRDExporterFromA1Factory()
		 * .setProducer("toecount") .setCreator(System.getProperty("user.name"))
		 * .loadFromPDFA1("invoice.pdf");
		 */
		try {
			int zfIntVersion = ZUGFeRDExporterFromA3.DefaultZUGFeRDVersion;
			Profile zfConformanceLevelProfile = Profiles.getByName("EXTENDED");

			if (pdfName == null) {
				pdfName = getFilenameFromUser("Source PDF", "invoice.pdf", "pdf", true, false);
			} else {
				System.out.println("Source PDF set to " + pdfName);
			}

			if (xmlName == null) {
				xmlName = getFilenameFromUser("ZUGFeRD XML", "factur-x.xml", "xml", true, false);
			} else {
				System.out.println("ZUGFeRD XML set to " + xmlName);
			}

			if (outName == null) {
				outName = getFilenameFromUser("Output PDF", "invoice.ZUGFeRD.pdf", "pdf", false, true);
			} else {
				System.out.println("Output PDF set to " + outName);
			}

			if (attachmentFilenames == null) {
				byte attachmentContents[] = null;
				String attachmentFilename, attachmentMime, attachmentDescription;
				attachmentFilename = getFilenameFromUser("Additional file attachments filename (empty for none)", "", "pdf", true, false);
				if (attachmentFilename.length() != 0) {
					attachmentContents = Files.readAllBytes(Paths.get(attachmentFilename));
					attachmentMime = Files.probeContentType(Paths.get(attachmentFilename));
					attachments.add(new FileAttachment(attachmentFilename, attachmentMime, "Data", attachmentContents));
				}
			} else {
				for (int i = 0; i < attachmentFilenames.length; i++) {
					String attachmentFilename = attachmentFilenames[i];
					if (!attachmentFilename.isEmpty()) {
						byte[] attachmentContents = Files.readAllBytes(Paths.get(attachmentFilename));
						String attachmentMime = Files.probeContentType(Paths.get(attachmentFilename));
						attachments.add(new FileAttachment(attachmentFilename, attachmentMime, "Data", attachmentContents));
					}
				}
			}


			if (format == null) {
				try {
					format = getStringFromUser("Format (fx=Factur-X, zf=ZUGFeRD, ox=Order-X, da=Cross Industry Despatch Advice)", "zf", "fx|zf|ox|da");
				} catch (Exception e) {
					LOGGER.error(e.getMessage(), e);
				}
			} else {
				System.out.println("Format set to " + format);
			}

			if (zfVersion == null) {
				try {
					zfVersion = getStringFromUser("Version (1 or 2)", Integer.toString(ZUGFeRDExporterFromA3.DefaultZUGFeRDVersion), "1|2");
				} catch (Exception e) {
					LOGGER.error(e.getMessage(), e);
				}
			} else {
				System.out.println("Version set to " + zfVersion);
			}
			zfIntVersion = Integer.valueOf(zfVersion);

			if (zfProfile == null) {
				try {
					if ((format.equals("zf") && (zfIntVersion == 1)) || (format.equals("ox"))) {
						zfProfile = getStringFromUser("Profile (b)asic, (c)omfort or ex(t)ended", "t", "B|b|C|c|T|t");
					} else if ((format.equals("da"))) {
						zfProfile = getStringFromUser("Profile (p)ilot", "p", "P|p");
					} else {
						zfProfile = getStringFromUser(
							"Profile  [M]INIMUM, BASIC [W]L, [B]ASIC,\n" + "[C]IUS, [E]N16931, EX[T]ENDED or [X]RECHNUNG", "E",
							"M|m|W|w|B|b|C|c|E|e|T|t|X|x|");
					}
				} catch (Exception e) {
					LOGGER.error(e.getMessage(), e);
				}
			} else {
				System.out.println("Profile set to " + zfProfile);
			}
			zfProfile = zfProfile.toLowerCase();


			// Verify params
			ensureFileExists(pdfName);
			ensureFileExists(xmlName);
			ensureFileNotExists(outName);

			if ((format.equals("fx")) && (zfIntVersion > 1)) {
				throw new Exception("Factur-X is only available in version 1 (roughly corresponding to ZF2)");
			}

			EStandard standard = EStandard.facturx;
			if (format.equals("zf")) {
				standard = EStandard.zugferd;
			}
			if (format.equals("da")) {
				standard = EStandard.despatchadvice;

				zfConformanceLevelProfile = Profiles.getByName(standard, "PILOT", 1);
			} else if (((format.equals("zf")) && (zfIntVersion == 1)) || (format.equals("ox"))) {
				if (format.equals("ox")) {
					standard = EStandard.orderx;
				}
				if (zfProfile.equals("b")) {
					zfConformanceLevelProfile = Profiles.getByName(standard, "BASIC", zfIntVersion);
				} else if (zfProfile.equals("c")) {
					zfConformanceLevelProfile = Profiles.getByName(standard, "COMFORT", zfIntVersion);
				} else if (zfProfile.equals("t")) {
					zfConformanceLevelProfile = Profiles.getByName(standard, "EXTENDED", zfIntVersion);
				} else {
					throw new Exception(String.format("Unknown ZUGFeRD profile '%s'", zfProfile));
				}
			} else if (((format.equals("zf")) && (zfIntVersion == 2)) || (format.equals("fx"))) {
				if (zfProfile.equals("m")) {
					zfConformanceLevelProfile = Profiles.getByName(standard, "MINIMUM", zfIntVersion);
				} else if (zfProfile.equals("w")) {
					zfConformanceLevelProfile = Profiles.getByName(standard, "BASICWL", zfIntVersion);
				} else if (zfProfile.equals("b")) {
					zfConformanceLevelProfile = Profiles.getByName(standard, "BASIC", zfIntVersion);
				} else if (zfProfile.equals("c")) {
					zfConformanceLevelProfile = Profiles.getByName(standard, "CIUS", zfIntVersion);
				} else if (zfProfile.equals("e")) {
					zfConformanceLevelProfile = Profiles.getByName(standard, "EN16931", zfIntVersion);
				} else if (zfProfile.equals("t")) {
					zfConformanceLevelProfile = Profiles.getByName(standard, "EXTENDED", zfIntVersion);
				} else if (zfProfile.equals("x")) {
					zfConformanceLevelProfile = Profiles.getByName(standard, "XRECHNUNG", zfIntVersion);
				} else {
					throw new Exception(String.format("Unknown ZUGFeRD profile '%s'", zfProfile));
				}
			} else {
				throw new Exception(String.format("Unknown version '%i'", zfIntVersion));
			}

			IZUGFeRDExporter ze = null;
			// All params are good! continue...
			if (format.equals("ox")) {
				ze = new OXExporterFromA1().setProducer("Mustang-cli")
					.setZUGFeRDVersion(zfIntVersion)
					.setCreator(System.getProperty("user.name")).setProfile(zfConformanceLevelProfile);
				if (ignoreInputErrors) {
					((OXExporterFromA1) ze).ignorePDFAErrors();
				}

			} else if (format.equals("da")) {
				ze = new DXExporterFromA1().setProducer("Mustang-cli")
					.setZUGFeRDVersion(zfIntVersion)
					.setCreator(System.getProperty("user.name")).setProfile(zfConformanceLevelProfile);

				if (ignoreInputErrors) {
					((DXExporterFromA1) ze).ignorePDFAErrors();
				}

			} else {
				if (format.equals("fx")) {
					zfIntVersion=2;// actually we are talking of generation, not version
					// so even if someone correctly requested factur-x 1 internally we call it zugferd 2 :-(
				}
				ze = new ZUGFeRDExporterFromPDFA().load(pdfName);

					ze.setProducer("Mustang-cli")
					.setZUGFeRDVersion(zfIntVersion)
					.setCreator(System.getProperty("user.name")).setProfile(zfConformanceLevelProfile);
				if (ignoreInputErrors) {
					((ZUGFeRDExporterFromA1) ze).ignorePDFAErrors();
				}
			}
			for (FileAttachment attachment : attachments) {
				((ZUGFeRDExporterFromA3) ze).attachFile(attachment.getFilename(), attachment.getData(), attachment.getMimetype(), attachment.getRelation());
			}

//			ze = ze.load(pdfName);

			if (format.equals("zf")) {
				ze.disableFacturX();
			}

			ze.setXML(Files.readAllBytes(Paths.get(xmlName)));

			ze.export(outName);
			System.out.println("Written to " + outName);

		} catch (Exception e) {
			LOGGER.error(e.getMessage(), e);
			System.err.println(e.getMessage());
		}
	}

	private static void performMetrics(String directoryName, Boolean filesFromStdIn, Boolean ignoreFileExt)
		throws IOException {

		StatRun sr = new StatRun();
		if (ignoreFileExt) {
			sr.ignoreFileExtension();
		}
		if (directoryName != null) {
			Path startingDir = Paths.get(directoryName);

			if (Files.isRegularFile(startingDir)) {
				String filename = startingDir.toString();
				FileChecker fc = new FileChecker(filename, sr);

				fc.checkForZUGFeRD();
				System.out.print(fc.getOutputLine());

			} else if (Files.isDirectory(startingDir)) {
				FileTraverser pf = new FileTraverser(sr);
				Files.walkFileTree(startingDir, pf);
			}
		}

		if (filesFromStdIn) {
			BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
			String s;
			while ((s = in.readLine()) != null && s.length() != 0) {
				FileChecker fc = new FileChecker(s, sr);

				fc.checkForZUGFeRD();
				System.out.print(fc.getOutputLine());

			}

		}
		System.out.println(sr.getSummaryLine());
	}

	private static void performVisualization(String sourceName, String lang, String outName, boolean intoPDF) {
		// Get params from user if not already defined
		if (sourceName == null) {
			sourceName = getFilenameFromUser("ZUGFeRD XML source", "factur-x.xml", "xml", true, false);
		} else {
			System.out.println("ZUGFeRD XML source set to " + sourceName);
		}
		if (!intoPDF) {
			if (lang == null) {
				try {
					lang = getStringFromUser("Output language", "en", "en|de|fr");
				} catch (Exception e) {
					LOGGER.error(e.getMessage(), e);
				}
			} else {
				System.out.println("Output language set to " + lang);
			}
		}

		if (outName == null) {
			String defaultFilename = "factur-x.html";
			String defaultExtension = "html";
			if (intoPDF) {
				defaultFilename = "factur-x.pdf";
				defaultExtension = "pdf";
			}
			outName = getFilenameFromUser("Target file", defaultFilename, defaultExtension, false, true);
		} else {
			System.out.println("Target set to " + outName);
		}

		// Verify params
		try {
			ensureFileExists(sourceName);
			ensureFileNotExists(outName);

			// stylesheets/ZUGFeRD_1p0_c1p0_s1p0.xslt
		} catch (IOException e) {
			LOGGER.error(e.getMessage(), e);
		}

		ZUGFeRDVisualizer zvi = new ZUGFeRDVisualizer();
		String xml = null;
		try {
			if (!intoPDF) {
				ZUGFeRDVisualizer.Language langCode = ZUGFeRDVisualizer.Language.EN;
				if (lang.equalsIgnoreCase("de")) {
					langCode = ZUGFeRDVisualizer.Language.DE;
				}
				if (lang.equalsIgnoreCase("fr")) {
					langCode = ZUGFeRDVisualizer.Language.FR;
				}
				xml = zvi.visualize(sourceName, langCode);
				Files.write(Paths.get(outName), xml.getBytes());
			} else {
				zvi.toPDF(sourceName, outName);
			}
		} catch (FileNotFoundException e) {
			LOGGER.error(e.getMessage(), e);
		} catch (UnsupportedEncodingException e) {
			LOGGER.error(e.getMessage(), e);
		} catch (TransformerException e) {
			LOGGER.error(e.getMessage(), e);
		} catch (IOException e) {
			LOGGER.error(e.getMessage(), e);
		}
		System.out.println("Written to " + outName);

		if (!intoPDF) {

			try {
				ExportResource("/xrechnung-viewer.css");
				ExportResource("/xrechnung-viewer.js");

				System.out.println("xrechnung-viewer.css and xrechnung-viewer.js written as well (to local working dir)");
			} catch (Exception e) {
				LOGGER.error(e.getMessage(), e);
			}
		}


	}

	/**
	 * Export a resource embedded into a Jar file to the local file path.
	 *
	 * @param resourceName ie.: "/SmartLibrary.dll"
	 * @return The path to the exported resource
	 * @throws Exception e.g. if the specified resource does not exist at the specified location
	 */
	static public String ExportResource(String resourceName) throws Exception {
		InputStream stream = null;
		OutputStream resStreamOut = null;
		String jarFolder;
		try {
			stream = Main.class.getResourceAsStream(resourceName);//note that each / is a directory down in the "jar tree" been the jar the root of the tree
			if (stream == null) {
				throw new Exception("Cannot get resource \"" + resourceName + "\" from Jar file.");
			}

			int readBytes;
			byte[] buffer = new byte[4096];
			jarFolder = System.getProperty("user.dir");
			resStreamOut = new FileOutputStream(jarFolder + resourceName);
			while ((readBytes = stream.read(buffer)) > 0) {
				resStreamOut.write(buffer, 0, readBytes);
			}
		} catch (Exception ex) {
			throw ex;
		} finally {
			stream.close();
			resStreamOut.close();
		}

		return jarFolder + resourceName;
	}

	private static void ensureFileExists(String fileName) throws IOException {
		if (!fileExists(fileName)) {
			throw new IOException(String.format("File %s does not exists", fileName));
		}
	}

	private static void ensureFileNotExists(String fileName) throws IOException {
		if (fileExists(fileName)) {
			throw new IOException(String.format("File %s already exists", fileName));
		}
	}

	private static Boolean fileExists(String fileName) {
		if (fileName == null)
			return false;
		File f = new File(fileName);
		return f.exists();
	}

}
