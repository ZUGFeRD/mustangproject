package toecount;

public class StatRun {
	private int pdfCount = 0;
	private int horseCount = 0;
	private int fileCount = 0;
	private int dirCount = 0;
	private boolean checkFileExt=true;

	public void ignoreFileExtension() {
		checkFileExt=false;
	}
	
	public boolean shallIgnoreFileExt() {
		return !checkFileExt;
	}
	public void incFileCount(){
		fileCount++;
	}

	public void incPDFCount(){
		pdfCount++;
	}

	public void incZUGFeRDCount(){
		horseCount++;
	}

	public void incDirCount(){
		dirCount++;
	}

	public int getFileCount(){
		return fileCount;
	}

	public int getPDFCount(){
		return pdfCount;
	}

	public int getZUGFeRDCount(){
		return horseCount;
	}

	public int getDirCount(){
		return dirCount;
	}

	/***
	 * returns final statistics
	 * @return
	 */
	public String getSummaryLine() {
	
		return "\r\n===================================================================\r\n"+String.format(
				"Files:\t%d\tDirs:\t%d\tPDF:\t%d\tZUGFeRD:\t%d\r\n",
				getFileCount(), getDirCount(), getPDFCount(), getZUGFeRDCount());
	
	}
	/***
	 * show that something is happening
	 * @return String
	 */
	public String getOutputLine() {
		return ".";
	}

	
}
