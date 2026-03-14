package org.mustangproject.util;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.TransformerConfigurationException;
import javax.xml.transform.TransformerFactory;
import javax.xml.validation.SchemaFactory;
import javax.xml.validation.Validator;

import org.xml.sax.SAXNotRecognizedException;
import org.xml.sax.SAXNotSupportedException;

public class SecurityConfigurater {
	private SecurityConfigurater()
	{
		/* This utility class should not be instantiated */
	}

	public static void configure(DocumentBuilderFactory dbf, boolean namespaceAware)
	{
		//REDHAT
		//https://www.blackhat.com/docs/us-15/materials/us-15-Wang-FileCry-The-New-Age-Of-XXE-java-wp.pdf
		try {
			// prevent external connections
			dbf.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
		} catch (ParserConfigurationException e) {
			// ignore
		}
		try {
			dbf.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "");
		} catch (IllegalArgumentException e) {
			// ignore
		}
		try {
			dbf.setAttribute(XMLConstants.ACCESS_EXTERNAL_SCHEMA, "");
		} catch (IllegalArgumentException e) {
			// ignore
		}

		//OWASP
		//https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html
		try {
			dbf.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
		} catch (ParserConfigurationException e) {
			// ignore
		}
		try {
			dbf.setFeature("http://xml.org/sax/features/external-general-entities", false);
		} catch (ParserConfigurationException e) {
			// ignore
		}
		try {
			dbf.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
		} catch (ParserConfigurationException e) {
			// ignore
		}
		// Disable external DTDs as well
		try {
			dbf.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
		} catch (ParserConfigurationException e) {
			// ignore
		}
		// and these as well, per Timothy Morgan's 2014 paper: "XML Schema, DTD, and Entity Attacks"
		dbf.setXIncludeAware(false);
		dbf.setExpandEntityReferences(false);
		dbf.setNamespaceAware(namespaceAware);
	}

	public static void configure(TransformerFactory factory)
	{
		try {
			factory.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
		} catch (TransformerConfigurationException e) {
			// ignore
		}
	}

	public static void configure(SchemaFactory factory)
	{
		try {
			factory.setProperty(XMLConstants.ACCESS_EXTERNAL_DTD, "");
		} catch (SAXNotSupportedException | SAXNotRecognizedException e) {
			// ignore
		}
	}

	public static void configure(Validator validator)
	{
		try {
			validator.setFeature(XMLConstants.FEATURE_SECURE_PROCESSING, true);
		} catch (SAXNotSupportedException | SAXNotRecognizedException e) {
			// ignore
		}
	}
}
