package org.mustangproject.ZUGFeRD;

public interface IXMLProvider {

	public byte[] getXML();
	public void setTest();

	public void generateXML(IZUGFeRDExportableTransaction trans);
	
}
