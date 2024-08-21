package org.mustangproject.ZUGFeRD;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Date;
import java.util.List;

import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.mustangproject.*;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;

public class ZUGFeRDInvoiceImporter extends ZUGFeRDImporter {
	private static final Logger LOGGER = LoggerFactory.getLogger(ZUGFeRDInvoiceImporter.class.getCanonicalName()); // log

	public ZUGFeRDInvoiceImporter() {
		super();
	}

	public ZUGFeRDInvoiceImporter(String filename) {
		super(filename);
	}

	public ZUGFeRDInvoiceImporter(InputStream stream) {
		super(stream);
	}

}
