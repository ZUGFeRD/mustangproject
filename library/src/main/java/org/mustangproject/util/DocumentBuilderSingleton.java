package org.mustangproject.util;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;

public class DocumentBuilderSingleton {
	private static final DocumentBuilderFactory FACTORY = DocumentBuilderFactory.newInstance();

	private static boolean initalized = false;

	private DocumentBuilderSingleton() {
		// avoid instantiation
	}

	public static DocumentBuilderFactory getInstance() throws ParserConfigurationException {
		if (!DocumentBuilderSingleton.initalized) {
			//REDHAT
			//https://www.blackhat.com/docs/us-15/materials/us-15-Wang-FileCry-The-New-Age-Of-XXE-java-wp.pdf
			DocumentBuilderSingleton.FACTORY.setAttribute(XMLConstants.FEATURE_SECURE_PROCESSING, Boolean.TRUE);
			DocumentBuilderSingleton.FACTORY.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "");
			DocumentBuilderSingleton.FACTORY.setAttribute(XMLConstants.ACCESS_EXTERNAL_SCHEMA, "");

			//OWASP
			//https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html
			DocumentBuilderSingleton.FACTORY.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
			DocumentBuilderSingleton.FACTORY.setFeature("http://xml.org/sax/features/external-general-entities", false);
			DocumentBuilderSingleton.FACTORY.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
			// Disable external DTDs as well
			DocumentBuilderSingleton.FACTORY.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);

			// and these as well, per Timothy Morgan's 2014 paper: "XML Schema, DTD, and Entity Attacks"
			DocumentBuilderSingleton.FACTORY.setXIncludeAware(false);
			DocumentBuilderSingleton.FACTORY.setExpandEntityReferences(false);
			DocumentBuilderSingleton.FACTORY.setNamespaceAware(true);

			DocumentBuilderSingleton.initalized = true;
		}
		return DocumentBuilderSingleton.FACTORY;
	}
}
