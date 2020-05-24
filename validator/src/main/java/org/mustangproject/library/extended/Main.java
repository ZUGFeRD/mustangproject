package org.mustangproject.library.extended;

import java.io.File;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.sanityinc.jargs.CmdLineParser;
import com.sanityinc.jargs.CmdLineParser.Option;

public class Main {

	static final ClassLoader cl = Main.class.getClassLoader();

	private static final Logger LOGGER = LoggerFactory.getLogger(Main.class.getCanonicalName()); // log output is
																									// ignored for the
																									// time being

	public void run(String[] args) {

		/***
		 * prerequisite is a mvn generate-resources
		 */

		CmdLineParser parser = new CmdLineParser();
		Option<String> actionOption = parser.addStringOption('a', "action");
		Option<String> filenameOption = parser.addStringOption('f', "Filename");

		Option<Boolean> licenseOption = parser.addBooleanOption('l', "license");
		Option<Boolean> helpOption = parser.addBooleanOption('h', "help");
		Option<String> logAppendOption = parser.addStringOption("logAppend");

		boolean optionsRecognized = false;

		try {
			parser.parse(args);
		} catch (CmdLineParser.OptionException e) {
			System.err.println(e.getMessage());
			System.exit(-2);
		}

		Boolean helpRequested = parser.getOptionValue(helpOption);
		
		if (parser.getOptionValue(licenseOption) != null) {
			optionsRecognized = true;

			System.out.println("Copyright 2018 Jochen Stärk\n" + "\n"
					+ "Licensed under the Apache License, Version 2.0 (the \"License\");\n"
					+ "you may not use this file except in compliance with the License.\n"
					+ "You may obtain a copy of the License at\n" + "\n"
					+ "    http://www.apache.org/licenses/LICENSE-2.0\n" + "\n"
					+ "Unless required by applicable law or agreed to in writing, software\n"
					+ "distributed under the License is distributed on an \"AS IS\" BASIS,\n"
					+ "WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.\n"
					+ "See the License for the specific language governing permissions and\n"
					+ "limitations under the License.\n\n\n\n\n"
					+ "This software is embedding the PDF/A validator VeraPDF, "
					+ "http://verapdf.org/, which is available under GPL and MPL licenses.");

			System.exit(0);
		}
		String filename = parser.getOptionValue(filenameOption);
		String action = parser.getOptionValue(actionOption);
		File logdir = new File("log");
		if (!logdir.exists() || !logdir.isDirectory() || !logdir.canWrite()) {
			System.err.println("Need writable subdirectory 'log' for log files.");
		}

		if ((action != null) && (action.equals("validate"))) {
			ZUGFeRDValidator zfv=new ZUGFeRDValidator();
			zfv.setLogAppend(parser.getOptionValue(logAppendOption));
			System.out.println(zfv.validate(filename));

			optionsRecognized = !zfv.hasOptionsError();
			if (!zfv.wasCompletelyValid()) {
				System.exit(-1);
			}

		}

		if ((!optionsRecognized) || (helpRequested != null && helpRequested.booleanValue())) {
			System.out.println(
					"usage: --action validate -f <ZUGFeRD PDF Filename.pdf>|<ZUGFeRD XML Filename.xml> [-l (shows license)][--logAppend \"String to be appended to validation result log\"]");
			System.exit(-1);
		}

	}

	public static void main(String[] args) {
		new Main().run(args);
	}


}
