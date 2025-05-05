package org.mustangproject.util;

import javax.xml.XMLConstants;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerFactory;

public class TransformerBuilderSingleton {
	private static final TransformerFactory FACTORY = TransformerFactory.newInstance();

	private static boolean initalized = false;

	private TransformerBuilderSingleton() {
		// avoid instantiation
	}

	public static TransformerFactory getInstance() throws TransformerConfigurationException {
		if (!TransformerBuilderSingleton.initalized) {
			TransformerBuilderSingleton.FACTORY.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);

			TransformerBuilderSingleton.initalized = true;
		}
		return TransformerBuilderSingleton.FACTORY;
	}
}
