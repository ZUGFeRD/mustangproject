package org.mustangproject.ZUGFeRD;

public class CustomXMLProvider implements IXMLProvider {

	protected byte[] zugferdData;
	
	@Override
	public byte[] getXML() {
		return zugferdData;
	}

	public void setXML(byte[] newData) {
		String zf=new String(newData);
		if (!zf.contains("<rsm:CrossIndustry")) {
			throw new RuntimeException("ZUGFeRD XML does not contain <rsm:CrossIndustry and can thus not be valid");
		}
		
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
