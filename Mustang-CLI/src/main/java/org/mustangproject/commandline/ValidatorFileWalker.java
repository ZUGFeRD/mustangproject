package org.mustangproject.commandline;


import java.io.IOException;
import java.nio.file.FileSystems;
import java.nio.file.FileVisitResult;
import java.nio.file.Path;
import java.nio.file.PathMatcher;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Arrays;
import java.util.Date;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.mustangproject.validator.ZUGFeRDValidator;

import static org.xmlunit.assertj.XmlAssert.assertThat;

public class ValidatorFileWalker
	extends SimpleFileVisitor<Path> {
	private static final Logger LOGGER = LoggerFactory.getLogger(ValidatorFileWalker.class.getCanonicalName()); // log
	protected PathMatcher matcher;
	protected ZUGFeRDValidator zul;
	protected int fileCount = 1;
	protected boolean expectValid = true;
	protected boolean allValid = true;
	protected String[] excludedFiles = {};

	public ValidatorFileWalker(boolean expectValid, String[] excludedFiles) {
		this.zul = new ZUGFeRDValidator();
		this.expectValid = expectValid;
		this.excludedFiles = excludedFiles;
		matcher = FileSystems.getDefault().getPathMatcher("glob:*.{pdf,xml}");

	}

	public boolean getResult() {
		return allValid;
	}

	// Print information about
	// each type of file.
	@Override
	public FileVisitResult visitFile(Path file,
									 BasicFileAttributes attr) {
		DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		//get current date time with Date()
		Date date = new Date();
		String expectedString = "valid";
		if (!expectValid) {
			expectedString = "invalid";
		}
		if ((attr != null) && (attr.isRegularFile())) {
			if (matcher.matches(file.getFileName())) {
				// I could have extended the path matcher but an exclusion list is quite simple
				if ((excludedFiles == null) || (!Arrays.asList(excludedFiles).contains(file.getFileName().toString()))) {

					String thisResultString = "  valid";
					try {
						assertThat(zul.validate(file.toAbsolutePath().toString())).valueByXPath("/validation/summary/@status")
							.asString()
							.isEqualTo(expectedString);

					} catch (AssertionError ae) {
						thisResultString = "invalid";
						allValid = false;
					}
					LOGGER.info("\n@{} Testing file {}: {} ({}) ", dateFormat.format(date), fileCount++, thisResultString, file);
				}
			}
		}
		return FileVisitResult.CONTINUE;
	}

	// Print each directory visited.
	@Override
	public FileVisitResult postVisitDirectory(Path dir,
											  IOException exc) {
		LOGGER.info("\nDirectory: {} \n", dir);
		return FileVisitResult.CONTINUE;
	}

	// If there is some error accessing
	// the file, let the user know.
	// If you don't override this method
	// and an error occurs, an IOException
	// is thrown.
	@Override
	public FileVisitResult visitFileFailed(Path file,
										   IOException exc) {
		LOGGER.error(exc.getMessage(), exc);
		return FileVisitResult.CONTINUE;
	}
}
