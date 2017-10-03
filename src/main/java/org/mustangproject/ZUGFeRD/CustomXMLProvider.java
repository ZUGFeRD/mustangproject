package org.mustangproject.ZUGFeRD;

public class CustomXMLProvider implements IXMLProvider {

	protected byte[] zugferdData;
	
	@Override
	public byte[] getXML() {
		return zugferdData;
	}

	public void setXML(byte[] newData) {
		zugferdData=newData;
	}

	@Override
	public void generateXML(IZUGFeRDExportableTransaction trans) {
		// TODO Auto-generated method stub
		
	}

	@Override
	public void setTest() {
		// TODO Auto-generated method stub
		
	}

}
