package org.mustangproject.toecount;

/***
 * This is the command line interface to mustangproject
 *
 */

import com.sanityinc.jargs.CmdLineParser;
import com.sanityinc.jargs.CmdLineParser.Option;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.UnsupportedEncodingException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.xml.transform.TransformerException;
import org.mustangproject.ZUGFeRD.ZUGFeRDConformanceLevel;
import org.mustangproject.ZUGFeRD.ZUGFeRDExporter;
import org.mustangproject.ZUGFeRD.ZUGFeRDExporterFromA1Factory;
import org.mustangproject.ZUGFeRD.ZUGFeRDExporterFromA3Factory;
import org.mustangproject.ZUGFeRD.ZUGFeRDImporter;
import org.mustangproject.ZUGFeRD.ZUGFeRDMigrator;

public class Toecount {
	// build with: /opt/local/bin/mvn clean compile assembly:single
	private static void printUsage() {
		System.err.println(getUsage());
	}

	private static String getUsage() {
		return "Usage: [-d,--directory] [-l,--listfromstdin] [-i,--ignorefileextension] | [-c,--combine] | [-e,--extract] | [-u,--upgrade] | [-a,--a3only] | [-h,--help]\r\n";
	}

	private static void printHelp() {
		System.out.println("Mustangproject.org " + org.mustangproject.ZUGFeRD.Version.VERSION + " \r\n"
				+ "A Apache Public License library and command line tool for statistics on PDF invoices with\r\n"
				+ "ZUGFeRD Metadata (http://www.zugferd.org)\r\n" + "\r\n" + getUsage() + "Count operations"
				+ "\t--directory= count ZUGFeRD files in directory to be scanned\r\n"
				+ "\t\tIf it is a directory, it will recurse.\r\n"
				+ "\t--listfromstdin=count ZUGFeRD files from a list of linefeed separated files on runtime.\r\n"
				+ "\t\tIt will start once a blank line has been entered.\r\n"
				+ "\t--ignorefileextension=if PDF files are counted check *.* instead of *.pdf files"
				+ "Merge operations" + "\t--combine= combine XML and PDF file to ZUGFeRD PDF file\r\n"
				+ "\t--extract= extract ZUGFeRD PDF to XML file\r\n"
				+ "\t--upgrade= upgrade ZUGFeRD XML to ZUGFeRD 2 XML\r\n"
				+ "\t--a3only= upgrade from PDF/A1 to A3 only (no ZUGFeRD data attached) \r\n"

				);
	}

	/***
	 * Asks the user for a String (offering a defaultValue) conforming to a Regex
	 * pattern
	 *
	 * @param prompt
	 * @param defaultValue
	 * @param pattern
	 * @return
	 * @throws Exception
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
			if (!firstInput) {
				System.out.print("\n(allowed pattern: " + pattern + ")");

			}
			System.out.print(":");
			BufferedReader buffer = new BufferedReader(new InputStreamReader(System.in));
			try {
				input = buffer.readLine();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}

			if (input.isEmpty()) {
				// pressed return without entering anything
				input = defaultValue;
			}

			firstInput = false;
		} while (!input.matches(pattern));

		return input;
	}

	/***
	 * Prompts the user for a input or output filename
	 * @param prompt
	 * @param defaultFilename
	 * @param expectedExtension will warn if filename does not match expected file extension
	 * @param ensureFileExists will warn if file does NOT exist (for input files)
	 * @param ensureFileNotExists will warn if file DOES exist (for output files)
	 *
	 * @return String
	 */
	protected static String getFilenameFromUser(String prompt, String defaultFilename, String expectedExtension, boolean ensureFileExists, boolean ensureFileNotExists) {
		boolean fileExistenceOK = false;
		String selectedName = "";
		do {
			// for a more sophisticated dialogue maybe https://github.com/mabe02/lanterna/ could be taken into account
			System.out.print(prompt + " (default: " + defaultFilename + "):");
			BufferedReader buffer=new BufferedReader(new InputStreamReader(System.in));
			try {
				selectedName=buffer.readLine();
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}


			if (selectedName.isEmpty()) {
				// pressed return without entering anything
				selectedName = defaultFilename;
			}

			// error cases
			if (!selectedName.toLowerCase().endsWith(expectedExtension.toLowerCase())) {
				System.err.println("Expected "+expectedExtension+" extension, this may corrupt your file. Do you still want to continue?(Y|N)");
				String selectedAnswer="";
				try {
					selectedAnswer=buffer.readLine();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
				if (!selectedAnswer.equals("Y")&&!selectedAnswer.equals("y")) {
					System.err.println("Aborted by user");
					System.exit(-1);
				}

			} else if (ensureFileExists) {
				File f = new File(selectedName);
				if (f.exists()) {
					fileExistenceOK = true;
				} else {
					System.out.println("File does not exist, try again or CTRL+C to cancel");
					// discard the input, a scanner.reset is not sufficient
					fileExistenceOK = false;
				}
			} else {
				fileExistenceOK=true;

				if (ensureFileNotExists) {
					File f = new File(selectedName);
					if (f.exists()) {
						fileExistenceOK = false;
						System.out.println("Output file already exists, try again or CTRL+C to cancel");
						// discard the input, a scanner.reset is not sufficient

					}
				} else {
					fileExistenceOK=true;
				}
			}


		} while (!fileExistenceOK);

			return selectedName;
		}

		// /opt/local/bin/mvn clean compile assembly:single
		public static void main(String[] args) {
			CmdLineParser parser = new CmdLineParser();
			Option<String> dirnameOption = parser.addStringOption('d', "directory");
			Option<Boolean> filesFromStdInOption = parser.addBooleanOption('l', "listfromstdin");
			Option<Boolean> ignoreFileExtOption = parser.addBooleanOption('i', "ignorefileextension");
			Option<Boolean> combineOption = parser.addBooleanOption('c', "combine");
			Option<Boolean> extractOption = parser.addBooleanOption('e', "extract");
			Option<Boolean> helpOption = parser.addBooleanOption('h', "help");
			Option<Boolean> upgradeOption = parser.addBooleanOption('u', "upgrade");
			Option<Boolean> a3onlyOption = parser.addBooleanOption('a', "a3only");

			try {
				parser.parse(args);
			} catch (CmdLineParser.OptionException e) {
				System.err.println(e.getMessage());
				printUsage();
				System.exit(2);
			}

			String directoryName = parser.getOptionValue(dirnameOption);

			Boolean filesFromStdIn = parser.getOptionValue(filesFromStdInOption, Boolean.FALSE);

			Boolean combineRequested = parser.getOptionValue(combineOption, Boolean.FALSE);

			Boolean extractRequested = parser.getOptionValue(extractOption, Boolean.FALSE);

			Boolean helpRequested = parser.getOptionValue(helpOption, Boolean.FALSE);

			Boolean upgradeRequested = parser.getOptionValue(upgradeOption, Boolean.FALSE);

			Boolean ignoreFileExt = parser.getOptionValue(ignoreFileExtOption, Boolean.FALSE);

			Boolean a3only = parser.getOptionValue(a3onlyOption, Boolean.FALSE);

			if (helpRequested) {
				printHelp();
			}

			else if (((directoryName != null) && (directoryName.length() > 0)) || filesFromStdIn.booleanValue()) {

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
						try {
							Files.walkFileTree(startingDir, pf);
						} catch (IOException e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}

					}

				}

				if (filesFromStdIn) {
					BufferedReader in = new BufferedReader(new InputStreamReader(System.in));
					String s;
					try {
						while ((s = in.readLine()) != null && s.length() != 0) {
							FileChecker fc = new FileChecker(s, sr);

							fc.checkForZUGFeRD();
							System.out.print(fc.getOutputLine());

						}
					} catch (IOException e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}

				}
				System.out.println(sr.getSummaryLine());
			} else if (combineRequested) {
				/*
				 * ZUGFeRDExporter ze= new ZUGFeRDExporterFromA1Factory()
				 * .setProducer("toecount") .setCreator(System.getProperty("user.name"))
				 * .loadFromPDFA1("invoice.pdf");
				 */
				String pdfName = "";
				String xmlName = "";
				String outName = "";

				try {

					pdfName = getFilenameFromUser("Source PDF", "invoice.pdf", "pdf", true, false);
					xmlName = getFilenameFromUser("ZUGFeRD XML", "ZUGFeRD-invoice.xml", "xml", true, false);
					outName = getFilenameFromUser("Ouput PDF", "invoice.ZUGFeRD.pdf", "pdf", false, true);
					String versionInput = "";
					try {
						versionInput = getStringFromUser("ZUGFeRD version (1 or 2)", "1", "1|2");

					} catch (Exception e) {
						// TODO Auto-generated catch block
						e.printStackTrace();
					}

					String profileInput = "";
					int zfIntVersion=Integer.valueOf(versionInput);

					ZUGFeRDConformanceLevel profile=ZUGFeRDConformanceLevel.EXTENDED;
					if (zfIntVersion==1) {
						try {
							profileInput = getStringFromUser("ZUGFeRD profile b)asic, c)omfort or e)xtended", "e", "B|b|C|c|E|e").toLowerCase();

						} catch (Exception e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						if (profileInput.equals("b")) {
							profile=ZUGFeRDConformanceLevel.BASIC;
						} else if (profileInput.equals("c")) {
							profile=ZUGFeRDConformanceLevel.COMFORT;
						} else if (profileInput.equals("e")) {
							profile=ZUGFeRDConformanceLevel.EXTENDED;

						}

					} else if (zfIntVersion==2) {
						try {
							profileInput = getStringFromUser("ZUGFeRD profile  [M]INIMUM, BASIC [W]L, [B]ASIC,\n" +
									"[C]IUS, [E]N16931, E[X]TENDED", "E", "M|m|W|w|B|b|C|c|E|e|X|x|").toLowerCase();

						} catch (Exception e) {
							// TODO Auto-generated catch block
							e.printStackTrace();
						}
						if (profileInput.equals("m")) {
							profile=ZUGFeRDConformanceLevel.MINIMUM;
						} else if (profileInput.equals("w")) {
							profile=ZUGFeRDConformanceLevel.BASICWL;
						} else if (profileInput.equals("b")) {
							profile=ZUGFeRDConformanceLevel.BASIC;
						} else if (profileInput.equals("c")) {
							profile=ZUGFeRDConformanceLevel.CIUS;
						} else if (profileInput.equals("e")) {
							profile=ZUGFeRDConformanceLevel.EN16931;
						} else if (profileInput.equals("x")) {
							profile=ZUGFeRDConformanceLevel.EXTENDED;
						}

					}

					ZUGFeRDExporter ze = new ZUGFeRDExporterFromA3Factory().setProducer("Toecount")
							.setCreator(System.getProperty("user.name")).setZUGFeRDConformanceLevel(profile).load(pdfName);
					ze.setZUGFeRDVersion(zfIntVersion);

					ze.setZUGFeRDXMLData(Files.readAllBytes(Paths.get(xmlName)));

					ze.export(outName);
				} catch (IOException e) {
					e.printStackTrace();
					// } catch (JAXBException e) {
					// e.printStackTrace();
				}
				System.out.println("Written to " + outName);
			} else if (extractRequested) {
				ZUGFeRDImporter zi = new ZUGFeRDImporter();
				String pdfName = getFilenameFromUser("Source PDF", "invoice.pdf", "pdf", true, false);
				String xmlName = getFilenameFromUser("ZUGFeRD XML", "ZUGFeRD-invoice.xml", "xml", false, true);

				zi.extract(pdfName);
				try {
					Files.write(Paths.get(xmlName), zi.getRawXML());
				} catch (IOException e) {
					e.printStackTrace();
				}
				System.out.println("Written to " + xmlName);

			} else if (a3only) {
				/*
				 * ZUGFeRDExporter ze= new ZUGFeRDExporterFromA1Factory()
				 * .setProducer("toecount") .setCreator(System.getProperty("user.name"))
				 * .loadFromPDFA1("invoice.pdf");
				 */
				String pdfName = "";
				String outName = "";
				try {
					pdfName = getFilenameFromUser("Source PDF", "invoice.pdf", "pdf", true, false);
					outName = getFilenameFromUser("Target PDF", "invoice.a3.pdf", "pdf", false, true);

					ZUGFeRDExporter ze = new ZUGFeRDExporterFromA1Factory().setAttachZUGFeRDHeaders(false).load(pdfName);

					ze.export(outName);
				} catch (IOException e) {
					e.printStackTrace();
				}
				System.out.println("Written to " + outName);
			} else if (upgradeRequested) {
                try {
                    String xmlName = "";
                    String outName = "";

                    xmlName = getFilenameFromUser("ZUGFeRD 1.0 XML source", "ZUGFeRD-invoice.xml", "xml", true, false);
                    outName = getFilenameFromUser("ZUGFeRD 2.0 XML target", "factur-x.xml", "xml", false, true);

                    ZUGFeRDMigrator zmi = new ZUGFeRDMigrator();
                    String xml = null;
                    xml = zmi.migrateFromV1ToV2(xmlName);
                    Files.write(Paths.get(outName), xml.getBytes());
                    System.out.println("Written to " + outName);
                } catch (FileNotFoundException ex) {
                    Logger.getLogger(Toecount.class.getName()).log(Level.SEVERE, null, ex);
                } catch (TransformerException | UnsupportedEncodingException ex) {
                    Logger.getLogger(Toecount.class.getName()).log(Level.SEVERE, null, ex);
                } catch (IOException ex) {
                    Logger.getLogger(Toecount.class.getName()).log(Level.SEVERE, null, ex);
                }
			} else {
				// no argument or argument unknown
				printUsage();
				System.exit(2);

			}
		}
	}
