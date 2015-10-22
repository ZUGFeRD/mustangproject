package toecount;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import com.sanityinc.jargs.CmdLineParser;
import com.sanityinc.jargs.CmdLineParser.Option;

public class Toecount {
//build with: /opt/local/bin/mvn clean compile assembly:single
	private static void printUsage() {
		System.err
				.println(getUsage());
	}

	private static String getUsage() {
		return "Usage: Toecount [-d,--directory] [-l,--listfromstdin] [-i,--ignorefileextension] [-h,--help]\r\n";
	}
	private static void printHelp() {
		System.out
		.println("Mustangproject.org's Toecount 0.0.6 \r\n"
				+ "A Apache Public License command line tool for statistics on PDF invoices with\r\n"
				+ "ZUGFeRD Metadata (http://www.zugferd.de)\r\n"
				+ "\r\n"
				+ getUsage()
				+ "\t--directory= can specify a single PDF or a directory to be scanned\r\n"
				+ "\t\tIf it is a directory, it will recurse.\r\n"
				+ "\t--listfromstdin allows to specify a list of linefeed separated files on runtime.\r\n"
				+ "\t\tIt will start once a blank line has been entered.\r\n"
				+ "\t--ignorefileextension check *.* instead of *.pdf files");
	}
	

	// /opt/local/bin/mvn clean compile assembly:single
	public static void main(String[] args) {
		CmdLineParser parser = new CmdLineParser();
		Option<String> dirnameOption = parser.addStringOption('d', "directory");
		Option<Boolean> filesFromStdInOption = parser.addBooleanOption('l',
				"listfromstdin");
		Option<Boolean> ignoreFileExtOption = parser.addBooleanOption('i',
				"ignorefileextension");
		Option<Boolean> helpOption = parser.addBooleanOption('h',
				"help");

		if (args.length==0) {
			printUsage();
			System.exit(2);
			
		}
		try {
			parser.parse(args);
		} catch (CmdLineParser.OptionException e) {
			System.err.println(e.getMessage());
			printUsage();
			System.exit(2);
		}

		String directoryName = parser.getOptionValue(dirnameOption);

		Boolean filesFromStdIn = parser.getOptionValue(filesFromStdInOption,
				Boolean.FALSE);
		
		Boolean helpRequested = parser.getOptionValue(helpOption,
				Boolean.FALSE);

		Boolean ignoreFileExt  = parser.getOptionValue(ignoreFileExtOption,
				Boolean.FALSE);
		
		if (helpRequested) {
			printHelp();
		}

		StatRun sr=new StatRun();
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
	}
}
