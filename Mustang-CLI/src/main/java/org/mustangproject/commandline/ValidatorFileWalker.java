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
import java.util.Date;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xmlunit.builder.Input;
import org.xmlunit.xpath.JAXPXPathEngine;
import org.xmlunit.xpath.XPathEngine;
import org.mustangproject.validator.ZUGFeRDValidator;

import static org.xmlunit.assertj.XmlAssert.assertThat;

public  class ValidatorFileWalker
    extends SimpleFileVisitor<Path> {
	private static final Logger LOGGER = LoggerFactory.getLogger(ValidatorFileWalker.class.getCanonicalName()); // log
	protected PathMatcher matcher;
	protected ZUGFeRDValidator zul;
	protected int fileCount=1;

	public ValidatorFileWalker() {
		this.zul = new ZUGFeRDValidator();
		;
		matcher = FileSystems.getDefault().getPathMatcher("glob:*.{pdf,xml}");

	}
    // Print information about
    // each type of file.
    @Override
    public FileVisitResult visitFile(Path file,
                                   BasicFileAttributes attr) {
    	DateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        //get current date time with Date()
        Date date = new Date();
        if ((attr!=null)&&(attr.isRegularFile())) {
        	if (matcher.matches(file.getFileName())) {
        		
                LOGGER.info(String.format("\n@%s Testing file %d: %s ", dateFormat.format(date), fileCount++, file));
                assertThat(zul.validate(file.toAbsolutePath().toString())).valueByXPath("/validation/summary/@status") 
    			.asString() 
    			.isEqualTo(
    					"valid");

        	}
        }
        return FileVisitResult.CONTINUE;
    }

    // Print each directory visited.
    @Override
    public FileVisitResult postVisitDirectory(Path dir,
                                          IOException exc) {
        LOGGER.info("\nDirectory: %s%n", dir);
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
        LOGGER.error(exc.getMessage(),exc);
        return FileVisitResult.CONTINUE;
    }
}
