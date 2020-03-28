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

import java.math.BigDecimal;

public class StatRun {
	private int pdfCount = 0;
	private int horseCount = 0;
	private int fileCount = 0;
	private int dirCount = 0;
	private BigDecimal total = BigDecimal.ZERO;
	private boolean checkFileExt = true;

	public void ignoreFileExtension() {
		checkFileExt = false;
	}

	public boolean shallIgnoreFileExt() {
		return !checkFileExt;
	}

	public void incFileCount() {
		fileCount++;
	}

	public void incPDFCount() {
		pdfCount++;
	}

	public void incZUGFeRDCount(int version) {
		horseCount++;
	}

	public void incDirCount() {
		dirCount++;
	}

	public int getFileCount() {
		return fileCount;
	}

	public int getPDFCount() {
		return pdfCount;
	}

	public int getZUGFeRDCount() {
		return horseCount;
	}

	public int getDirCount() {
		return dirCount;
	}

	/**
	 * returns final statistics
	 *
	 * @return english string with linefeeds detailling number of files, directories, number of pdfs and of zugferd files
	 */
	public String getSummaryLine() {

		return "\r\n===================================================================\r\n" + String.format(
				"Files:\t%d\tDirs:\t%d\tPDF:\t%d\tZUGFeRD:\t%d\tTotal:\t%s\r\n",
				getFileCount(), getDirCount(), getPDFCount(), getZUGFeRDCount(), total.toString());

	}

	/**
	 * show that something is happening
	 *
	 * @return String, usually a dot
	 */
	public String getOutputLine() {
		return ".";
	}

	public void incTotal(BigDecimal delta) {
		total=total.add(delta);
		
	}


}
