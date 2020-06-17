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

import org.mustangproject.ZUGFeRD.ZUGFeRDImporter;

public class FileChecker {
	String filename;
	StatRun thisRun;
	boolean isPDF = false;

	public FileChecker(String filename, StatRun statistics) {
		this.filename = filename;
		thisRun = statistics;
		thisRun.incFileCount();
		String extension = "";
		if (!thisRun.shallIgnoreFileExt()) {
			int extIndex = filename.lastIndexOf(".");
			if (extIndex >= 0) {
				extension = filename.substring(extIndex).toLowerCase();
				isPDF = extension.equals(".pdf");// alternative check for PDF: File starts with %PDF-
				if (isPDF) {
					thisRun.incPDFCount();
				}
			}

		} else {
			thisRun.incPDFCount();
		}
	}

	public boolean checkForZUGFeRD() {
		if ((!isPDF) && (!thisRun.shallIgnoreFileExt())) {
			return false;
		}
		ZUGFeRDImporter zi = new ZUGFeRDImporter(filename);
		try {
			if (zi.canParse()) {
				thisRun.incZUGFeRDCount(zi.getVersion());
				thisRun.incTotal(new BigDecimal(zi.getAmount()));
				return true;
			} else {
				return false;
			}
		} catch (NullPointerException e) {
			// something really rare happened -- corrupted ZF?
			/***
			 * e.g. Exception in thread "main" java.lang.NullPointerException
			 at org.mustangproject.ZUGFeRD.ZUGFeRDImporter.extractLowLevel(ZUGFeRDImporter.java:90)
			 at org.mustangproject.ZUGFeRD.ZUGFeRDImporter.extract(ZUGFeRDImporter.java:64)
			 at toecount.FileChecker.checkForZUGFeRD(FileChecker.java:33)
			 at toecount.Toecount.main(Toecount.java:111)
			 *
			 */
			// Ignore nevertheless, most likely we're batch processing
			return false;
		} catch (Exception e2) {
			/**
			 * probably thrown up from
			 AM org.apache.pdfbox.pdfparser.PDFParser parse, most likely
			 INFORMATION: Document is encrypted
			 but also other internal PDF errors possible like
			 ..Okt 23, 2015 11:17:53 AM org.apache.pdfbox.pdfparser.XrefTrailerResolver setStartxref
			 */
			return false;
		}
	}

	public boolean isPDF() {
		return isPDF;
	}

	public String getOutputLine() {
		return thisRun.getOutputLine();
	}

}
