package org.mustangproject.toecount;

import static java.nio.file.FileVisitResult.CONTINUE;

import java.io.IOException;
import java.nio.file.FileVisitResult;
import java.nio.file.Path;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;

public class FileTraverser extends SimpleFileVisitor<Path> {


	private StatRun thisRun;
	public FileTraverser(StatRun statistics) {
		this.thisRun=statistics;
	}

	/***
	 * check each file
	 */
	@Override
	public FileVisitResult visitFile(Path file, BasicFileAttributes attr) {
		if (attr.isSymbolicLink()) {
			// Not yet handled
		} else if (attr.isRegularFile()) {
			String filename = file.toString();
			FileChecker fc = new FileChecker(filename, thisRun);
			fc.checkForZUGFeRD();
			System.out.print(fc.getOutputLine());

		} 
		return CONTINUE;
	}

	/***
	 * for each directory
	 */
	@Override
	public FileVisitResult postVisitDirectory(Path dir, IOException exc) {
		// System.out.format("Directory: %s%n", dir);
		thisRun.incDirCount();
		return CONTINUE;
	}


	/***
	 * show errors like file permission stacktraces
	 */
	@Override
	public FileVisitResult visitFileFailed(Path file, IOException exc) {
		System.err.println(exc);
		return CONTINUE;
	}

}
