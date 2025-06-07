package org.mustangproject.util;

import javax.xml.XMLConstants;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerFactory;

public class TransformerFactoryCreator {
	private TransformerFactoryCreator() {
		// avoid instantiation
	}

	public static TransformerFactory getInstance() throws TransformerConfigurationException {
		TransformerFactory factory = TransformerFactory.newInstance();
		factory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);

		// to be compliant, prohibit the use of all protocols by external entities:
		factory.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "");
		factory.setAttribute(XMLConstants.ACCESS_EXTERNAL_STYLESHEET, "");

		// not supported
		// factory.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
		// factory.setFeature("http://xml.org/sax/features/external-general-entities", false);
		// factory.setFeature("http://xml.org/sax/features/external-parameter-entities", false);

		return factory;
	}
}
