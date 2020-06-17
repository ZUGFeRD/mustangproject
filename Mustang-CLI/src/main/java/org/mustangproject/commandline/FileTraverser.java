/** **********************************************************************
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

import java.io.IOException;
import java.nio.file.FileVisitResult;
import java.nio.file.Path;
import java.nio.file.SimpleFileVisitor;
import java.nio.file.attribute.BasicFileAttributes;

import static java.nio.file.FileVisitResult.CONTINUE;

public class FileTraverser extends SimpleFileVisitor<Path> {


	private StatRun thisRun;

	public FileTraverser(StatRun statistics) {
		this.thisRun = statistics;
	}

	/**
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

	/**
	 * for each directory
	 */
	@Override
	public FileVisitResult postVisitDirectory(Path dir, IOException exc) {
		// System.out.format("Directory: %s%n", dir);
		thisRun.incDirCount();
		return CONTINUE;
	}


	/**
	 * show errors like file permission stacktraces
	 */
	@Override
	public FileVisitResult visitFileFailed(Path file, IOException exc) {
		System.err.println(exc);
		return CONTINUE;
	}

}
