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
		return factory;
	}
}
