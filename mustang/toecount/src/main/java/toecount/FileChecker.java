package toecount;

import org.mustangproject.ZUGFeRD.ZUGFeRDImporter;

public class FileChecker {
	String filename;
	StatRun thisRun;
	boolean isPDF=false;
	
	public FileChecker(String filename, StatRun statistics) {
		this.filename=filename;
		thisRun=statistics;
		thisRun.incFileCount();
		String extension = "";
		if (!thisRun.shallIgnoreFileExt()) {
			int extIndex = filename.lastIndexOf(".");
			if (extIndex >= 0) {
				extension = filename.substring(extIndex).toLowerCase();
				isPDF=extension.equals(".pdf");// alternative check for PDF: File starts with %PDF-
				thisRun.incPDFCount();
			}
			
		} else {
			thisRun.incPDFCount();			
		}
	}
	
	public boolean checkForZUGFeRD() {
		if ((!isPDF)&&(!thisRun.shallIgnoreFileExt())) {
			return false;
		}
		ZUGFeRDImporter zi=new ZUGFeRDImporter();
		zi.extract(filename);
		if (zi.canParse()) {
			thisRun.incZUGFeRDCount();
			return true;
		} else {
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
