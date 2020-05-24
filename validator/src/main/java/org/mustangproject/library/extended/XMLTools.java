package org.mustangproject.library.extended;

import org.dom4j.io.XMLWriter;

public class XMLTools extends XMLWriter {
	public  String escapeAttributeEntities(String s) {	
		return super.escapeAttributeEntities(s); 
	}
	public String escapeElementEntities(String s) {
		return super.escapeElementEntities(s); 
	
	}

}
