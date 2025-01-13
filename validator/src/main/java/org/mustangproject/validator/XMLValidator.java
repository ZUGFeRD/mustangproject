package org.mustangproject.validator;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.UncheckedIOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Calendar;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.mustangproject.XMLTools;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;

import com.helger.schematron.ISchematronResource;
import com.helger.schematron.svrl.SVRLMarshaller;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.xslt.SchematronResourceXSLT;

public class XMLValidator extends Validator {

	private static final Logger LOGGER = LoggerFactory.getLogger(XMLValidator.class.getCanonicalName());
	// log output is ignored for the time being

	private static final String INVOICE = "Invoice";
	private static final String UNSUPPORTED_PROFILE_TYPE = "Unsupported profile type: '%s'";

	protected String zfXML = "";
	protected String filename = "";
	int firedRules = 0;
	int failedRules = 0;
	boolean disableNotices = false;

	public XMLValidator(ValidationContext ctx) {
		super(ctx);
	}

	/***
	 * set source file
	 * @param name the absolute filename of an XML file to validate
	 * @throws IrrecoverableValidationError if e.g. the file can not be found, or does not contain XML, so no further validation can take place
	 */
	@Override
	public void setFilename(String name) throws IrrecoverableValidationError { // from XML Filename
		LOGGER.debug("public void setFilename(String name='{}')", name);
		filename = name;
		// file existence must have been checked before
		if (autoload) {
			try {
				zfXML = new String(XMLTools.removeBOM(Files.readAllBytes(Paths.get(filename))), StandardCharsets.UTF_8);
			} catch (final IOException e) {

				final ValidationResultItem vri = new ValidationResultItem(ESeverity.exception, e.getMessage()).setSection(9)
						.setPart(EPart.fx);
				try (final StringWriter sw = new StringWriter();
					 final PrintWriter pw = new PrintWriter(sw)) {
					e.printStackTrace(pw);
					vri.setStacktrace(sw.toString());
					context.addResultItem(vri);
				} catch (IOException ex) {
					throw new UncheckedIOException(ex);
				}
			}

		}

	}

	/***
	 * manually set the xml content
	 * @param xml the xml to be checked
	 */
	public void setStringContent(String xml) {
		zfXML = xml;
	}

	/**
	 * whether uri1 has the same meaning as uri1 (it has, if it only differs in the fragment, i.e. uri1#1==uri1#2 )
	 *
	 * @param uri1 basis guideline ID
	 * @param uri2 guideline ID to be checked
	 * @return true if semantically identical
	 */
	public static boolean matchesURI(String uri1, String uri2) {
		return (uri1.equals(uri2) || uri1.startsWith(uri2 + "#"));
	}

	/***
	 * don't report notices in validation report
	 */
	public void disableNotices() {
		disableNotices = true;
	}

	/***
	 * perform validation
	 * @throws IrrecoverableValidationError if any fatal errors occur, e.g. source file can not be read
	 */
	@Override
	public void validate() throws IrrecoverableValidationError {
		final long startXMLTime = Calendar.getInstance().getTimeInMillis();
		firedRules = 0;
		failedRules = 0;

		if (zfXML.isEmpty()) {
			final ValidationResultItem res = new ValidationResultItem(ESeverity.exception,
					"XML data not found in " + filename
							+ ": did you specify a pdf or xml file and does the xml file contain an embedded XML file?")
					.setSection(3);
			context.addResultItem(res);

		} else {

			// final ISchematronResource aResSCH =
			// SchematronResourceSCH.fromFile (new File("ZUGFeRD_1p0.scmt"));
			// ... DOES work but is highly deprecated (and rightly so) because
			// it takes 30-40min,

			try {
				ESeverity severity = ESeverity.notice;
				/*
				 * private static final String VALID_SCHEMATRON = "test-sch/valid01.sch";
				 * private static final String VALID_XMLINSTANCE = "test-xml/valid01.xml";
				 *
				 * @Test public void testWriteValid () throws Exception { final Document aDoc =
				 *		 SchematronResourceSCH.fromClassPath (VALID_SCHEMATRON)
				 *		 .applySchematronValidation (new ClassPathResource (VALID_XMLINSTANCE));
				 *
				 */

				final DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
				dbf.setNamespaceAware(true); // otherwise we can not act namespace independently, i.e. use
				// document.getElementsByTagNameNS("*",...

				final DocumentBuilder db = dbf.newDocumentBuilder();
				final InputSource is = new InputSource(new StringReader(zfXML));
				final Document doc = db.parse(is);

				final Element root = doc.getDocumentElement();

				final NodeList ndList;

				// rootNode = document.getDocumentElement();
				// ApplicableSupplyChainTradeSettlement

				// Create XPathFactory object
				final XPathFactory xpathFactory = XPathFactory.newInstance();

				// Create XPath object
				final XPath xpath = xpathFactory.newXPath();
				final XPathExpression expr = xpath.compile(
						"(//*[local-name()=\"GuidelineSpecifiedDocumentContextParameter\"]/*[local-name()=\"ID\"])/text()|//*[local-name()=\"CustomizationID\"]/text()");
				// evaluate expression result on XML document
				ndList = (NodeList) expr.evaluate(doc, XPathConstants.NODESET);

				for (int bookingIndex = 0; bookingIndex < ndList.getLength(); bookingIndex++) {
					final Node booking = ndList.item(bookingIndex);
					// if there is an attribute in the tag number:value
					// urn:ferd:CrossIndustryDocument:invoice:1p0:extended
					// setForeignReference(booking.getTextContent());

					context.setProfile(booking.getNodeValue());
				}
				boolean isOrderX = false;
				boolean isMinimum;
				boolean isBasic = false;
				boolean isBasicWithoutLines;
				boolean isEN16931 = false;
				boolean isExtended;
				boolean isXRechnung = false;
				int mainSchematronSectionErrorTypeCode = 4;
				String xsltFilename = null;
				// urn:ferd:CrossIndustryDocument:invoice:1p0:extended,
				// urn:ferd:CrossIndustryDocument:invoice:1p0:comfort,
				// urn:ferd:CrossIndustryDocument:invoice:1p0:basic,

				// urn:cen.eu:en16931:2017
				// urn:cen.eu:en16931:2017:compliant:factur-x.eu:1p0:basic
				if (root.getLocalName().equalsIgnoreCase("SCRDMCCBDACIOMessageStructure")) {
					context.setGeneration("1");
					isOrderX = true;
					isBasic = context.getProfile().contains("basic");
					isEN16931 = context.getProfile().contains("comfort");
					isExtended = context.getProfile().contains("extended");
					if (isBasic) {
						validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), SchemesPerVersion.mapOfSchemesPerVersion.get(EVersion.OX_10_BASIC), 99, EPart.ox);
						xsltFilename = ScriptsPerVersion.mapOfScriptsPerVersion.get(EVersion.OX_10_BASIC);
					} else if (isExtended) {
						validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), SchemesPerVersion.mapOfSchemesPerVersion.get(EVersion.OX_10_EXTENDED), 99, EPart.ox);
						xsltFilename = ScriptsPerVersion.mapOfScriptsPerVersion.get(EVersion.OX_10_EXTENDED);
					} else {
						validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), SchemesPerVersion.mapOfSchemesPerVersion.get(EVersion.OX_10_COMFORT), 99, EPart.ox);
						xsltFilename = ScriptsPerVersion.mapOfScriptsPerVersion.get(EVersion.OX_10_COMFORT);
					}

				} else if (root.getLocalName().equalsIgnoreCase("CrossIndustryInvoice")) { // ZUGFeRD 2.0 or Factur-X
					context.setGeneration("2");

					isMinimum = context.getProfile().contains("minimum");
					isBasic = context.getProfile().contains("basic");
					isBasicWithoutLines = context.getProfile().contains("basicwl");
					if (isBasicWithoutLines) {
						isBasic = false;// basicwl also contains the string basic...
					}
					isEN16931 = matchesURI(context.getProfile(), "urn:cen.eu:en16931:2017:compliant:factur-x.eu:1p0:en16931")
							|| matchesURI(context.getProfile(), "urn:cen.eu:en16931:2017");

					isExtended = context.getProfile().contains("extended");
					isXRechnung = context.getProfile().contains("xrechnung");

					if ((isExtended) || (isXRechnung)) {
						isEN16931 = false;// the uri for extended is urn:cen.eu:en16931:2017#conformant#urn:zugferd.de:2p0:extended and thus contains en16931...
					}
					if (isMinimum) {
						LOGGER.debug("is Minimum");
						validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), SchemesPerVersion.mapOfSchemesPerVersion.get(EVersion.ZF_23_MINIMUM), 18, EPart.fx);
						xsltFilename = ScriptsPerVersion.mapOfScriptsPerVersion.get(EVersion.ZF_23_MINIMUM);
					} else if (isBasicWithoutLines) {
						LOGGER.debug("is Basic/WL");
						validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), SchemesPerVersion.mapOfSchemesPerVersion.get(EVersion.ZF_23_BASIC_WL), 18, EPart.fx);
						xsltFilename = ScriptsPerVersion.mapOfScriptsPerVersion.get(EVersion.ZF_23_BASIC_WL);
					} else if (isBasic) {
						LOGGER.debug("is Basic");
						validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), SchemesPerVersion.mapOfSchemesPerVersion.get(EVersion.ZF_23_BASIC), 18, EPart.fx);
						xsltFilename = ScriptsPerVersion.mapOfScriptsPerVersion.get(EVersion.ZF_23_BASIC);
					} else if (isEN16931) {
						LOGGER.debug("is EN16931");
						validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), SchemesPerVersion.mapOfSchemesPerVersion.get(EVersion.ZF_23_EN16931), 18, EPart.fx);
						xsltFilename = ScriptsPerVersion.mapOfScriptsPerVersion.get(EVersion.ZF_23_EN16931);
					} else if (isXRechnung) {
						LOGGER.debug("is XRechnung");
						/*
						the validation against the XRechnung Schematron will happen below but a
						XRechnung is a EN16931 subset so the validation vis a vis FACTUR-X_EN16931.xslt=schematron also has to pass
						* */
						validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), SchemesPerVersion.mapOfSchemesPerVersion.get(EVersion.ZF_23_EN16931), 18, EPart.fx);

						severity = ESeverity.error;
					} else if (isExtended) {
						LOGGER.debug("is EXTENDED");
						validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), SchemesPerVersion.mapOfSchemesPerVersion.get(EVersion.ZF_23_EXTENDED), 18, EPart.fx);
						xsltFilename = ScriptsPerVersion.mapOfScriptsPerVersion.get(EVersion.ZF_23_EXTENDED);
					}

					// takes around 10 Seconds. //
					// http://www.bentoweb.org/refs/TCDL2.0/tsdtf_schematron.html // explains that
					// this xslt can be created using sth like
					// saxon java net.sf.saxon.Transform -o tcdl2.0.tsdtf.sch.tmp.xsl -s
					// tcdl2.0.tsdtf.sch iso_svrl.xsl

				} else if (root.getLocalName().equalsIgnoreCase(INVOICE) || root.getLocalName().equalsIgnoreCase("CreditNote")) {
					String profile = context.getProfile();
					String rootName = root.getLocalName();
					context.setGeneration("2");
					context.setFormat("UBL");
					isXRechnung = profile.contains("xrechnung");
					// UBL
					LOGGER.debug("UBL");
					if (rootName.equalsIgnoreCase(INVOICE)) {
						validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), SchemesPerVersion.mapOfSchemesPerVersion.get(EVersion.UBL_24_INVOICE), 18, EPart.fx);
					} else {
						validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), SchemesPerVersion.mapOfSchemesPerVersion.get(EVersion.UBL_24_CREDIT_NOTE), 18, EPart.fx);
					}
					xsltFilename = ScriptsPerVersion.mapOfScriptsPerVersion.get(EVersion.EN16931_UBL);

					mainSchematronSectionErrorTypeCode = 24;

					if (isXRechnung) {
						validateSchematron(zfXML, xsltFilename, 24, ESeverity.error);
						/*
						the validation against the XRechnung Schematron will happen below but a
						XRechnung is a EN16931 subset so the validation vis a vis FACTUR-X_EN16931.xslt=schematron also has to pass
						* */
						//validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), "ZF_211/EN16931/FACTUR-X_EN16931.xsd", 18, EPart.fx);
						xsltFilename = ScriptsPerVersion.mapOfScriptsPerVersion.get(getVersion(getXRVersion(profile), rootName));
						severity = ESeverity.error;
						mainSchematronSectionErrorTypeCode = 27;

					}

				} else if (root.getLocalName().equalsIgnoreCase("CrossIndustryDocument")) { // ZUGFeRD 1.0
					context.setGeneration("1");
					//
					if ((!matchesURI(context.getProfile(), "urn:ferd:CrossIndustryDocument:invoice:1p0:basic"))
							&& (!matchesURI(context.getProfile(), "urn:ferd:CrossIndustryDocument:invoice:1p0:comfort"))
							&& (!matchesURI(context.getProfile(), "urn:ferd:CrossIndustryDocument:invoice:1p0:extended"))) {
						context.addResultItem(new ValidationResultItem(ESeverity.error, String.format(UNSUPPORTED_PROFILE_TYPE, context.getProfile()))
								.setSection(25).setPart(EPart.fx));
					}
					validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), SchemesPerVersion.mapOfSchemesPerVersion.get(EVersion.ZF_10), 18, EPart.fx);

					xsltFilename = ScriptsPerVersion.mapOfScriptsPerVersion.get(EVersion.ZF_10);
				} else { // unknown document root
					context.addResultItem(new ValidationResultItem(ESeverity.fatal, "Unsupported root element")
							.setSection(3).setPart(EPart.fx));
				}
				if (context.getFormat().equals("CII")) {

					if (context.getGeneration().equals("2")) {
						if ((!matchesURI(context.getProfile(), "urn:factur-x.eu:1p0:minimum"))
								&& (!matchesURI(context.getProfile(), "urn:zugferd.de:2p0:minimum"))
								&& (!matchesURI(context.getProfile(), "urn:factur-x.eu:1p0:basicwl"))
								&& (!matchesURI(context.getProfile(), "urn:zugferd.de:2p0:basicwl"))
								&& (!matchesURI(context.getProfile(), "urn:cen.eu:en16931:2017#compliant#urn:factur-x.eu:1p0:basic"))
								&& (!matchesURI(context.getProfile(), "urn:cen.eu:en16931:2017#compliant#urn:zugferd.de:2p0:basic"))
								&& (!matchesURI(context.getProfile(), "urn:cen.eu:en16931:2017"))
								&& (!matchesURI(context.getProfile(), "urn:cen.eu:en16931:2017#conformant#urn:factur-x.eu:1p0:extended"))
								&& (!matchesURI(context.getProfile(), "urn:cen.eu:en16931:2017#conformant#urn:zugferd.de:2p0:extended"))) {
							context.addResultItem(
									new ValidationResultItem(ESeverity.error, String.format(UNSUPPORTED_PROFILE_TYPE, context.getProfile()))
											.setSection(25).setPart(EPart.fx));

						}
					} else /* v1 */ {
						if (isOrderX) {
							//order-x 1.0
							if ((!matchesURI(context.getProfile(), "urn:order-x.eu:1p0:basic"))
									&& (!matchesURI(context.getProfile(), "urn:order-x.eu:1p0:comfort"))
									&& (!matchesURI(context.getProfile(), "urn:order-x.eu:1p0:extended"))) {
								//zf 1.0
								context.addResultItem(new ValidationResultItem(ESeverity.error, String.format(UNSUPPORTED_PROFILE_TYPE, context.getProfile()))
										.setSection(25).setPart(EPart.fx));

							}
						} else if ((!matchesURI(context.getProfile(), "urn:ferd:CrossIndustryDocument:invoice:1p0:basic"))
								&& (!matchesURI(context.getProfile(), "urn:ferd:CrossIndustryDocument:invoice:1p0:comfort"))
								&& (!matchesURI(context.getProfile(), "urn:ferd:CrossIndustryDocument:invoice:1p0:extended"))) {
							//zf 1.0
							context.addResultItem(new ValidationResultItem(ESeverity.error, String.format(UNSUPPORTED_PROFILE_TYPE, context.getProfile()))
									.setSection(25).setPart(EPart.fx));

						}
					}
				}

				if (xsltFilename != null) {
					// main schematron validation
					validateSchematron(zfXML, xsltFilename, mainSchematronSectionErrorTypeCode, ESeverity.error);

				}

				if (context.getFormat().equals("CII") && context.getGeneration().equals("2")
						&& (isBasic || isEN16931 || isXRechnung)) {
					//additionally validate against CEN
					validateSchematron(zfXML, ScriptsPerVersion.mapOfScriptsPerVersion.get(EVersion.EN16931_CII), 24, ESeverity.error);
					if (!disableNotices || severity != ESeverity.notice) {
						validateXR(zfXML, severity);
					}
				}

			} catch (final IrrecoverableValidationError er) {
				throw er;
			} catch (final Exception e) {
				final ValidationResultItem vri = new ValidationResultItem(ESeverity.exception, e.getMessage()).setSection(22)
						.setPart(EPart.fx);
				try (final StringWriter sw = new StringWriter();
					 final PrintWriter pw = new PrintWriter(sw)) {
					e.printStackTrace(pw);
					vri.setStacktrace(sw.toString());
					context.addResultItem(vri);
				} catch (IOException ex) {
					throw new UncheckedIOException(ex);
				}
			}

		}
		final long endTime = Calendar.getInstance().getTimeInMillis();

		context.addCustomXML("<info><version>" + ((context.getGeneration() != null) ? context.getGeneration() : "invalid")
				+ "</version><profile>" + ((context.getProfile() != null) ? context.getProfile() : "invalid") +
				"</profile><validator version=\"" + XMLValidator.class.getPackage().getImplementationVersion() + "\"></validator><rules><fired>" + firedRules + "</fired><failed>" + failedRules + "</failed></rules>" + "<duration unit=\"ms\">" + (endTime - startXMLTime) + "</duration></info>");

	}

	private String getXRVersion(final String profile) throws IllegalArgumentException {
		String rv = profile.substring(profile.length() - 3).replace(".", "");
		if (
				!rv.equals("12")
						&& !rv.equals("20")
						&& !rv.equals("21")
						&& !rv.equals("22")
						&& !rv.equals("23")
						&& !rv.equals("30")
		) {
			throw new IllegalArgumentException("Unsupported XR version");
		}
		LOGGER.debug("is XRechnung v{}", rv);
		return rv;
	}

	private EVersion getVersion(final String xrVersion, final String rootName) {
		EVersion rv;
		try {
			switch (xrVersion) {
				case "12":
				case "20":
				case "21":
				case "22":
					if (rootName.equalsIgnoreCase(INVOICE)) {
						rv = EVersion.valueOf(String.format("XR_%s_UBL_INVOICE", xrVersion));
					} else {
						rv = EVersion.valueOf(String.format("XR_%s_UBL_CREDIT_NOTE", xrVersion));
					}
					break;
				case "23":
				case "30":
					rv = EVersion.valueOf(String.format("XR_%s_UBL", xrVersion));
					break;
				default:
					rv = EVersion.XR_30_UBL;
					break;
			}
		} catch (IllegalArgumentException e) {
			rv = EVersion.XR_30_UBL;
		}
		return rv;
	}

	public void validateXR(String xml, ESeverity errorImpact) throws IrrecoverableValidationError {

		//Guideline ID=urn:cen.eu:en16931:2017#compliant#urn:xoev-de:kosit:standard:xrechnung_1.2  or
		if (xml.contains(":xrechnung_1.")) {
			validateSchematron(xml, ScriptsPerVersion.mapOfScriptsPerVersion.get(EVersion.XR_12_CII), 27, errorImpact);
		} else if (xml.contains(":xrechnung_2.0")) {
			// urn:cen.eu:en16931:2017#compliant#urn:xoev-dede:kosit:standard:xrechnung_2.0#conformant#urn:xoev-de:kosit:extension:xrechnung_2.0
			validateSchematron(xml, ScriptsPerVersion.mapOfScriptsPerVersion.get(EVersion.XR_20_CII), 27, errorImpact);
		} else if (xml.contains(":xrechnung_2.1")) { // This is the default check which is also run on en16931 files to generate notices.
			validateSchematron(xml, ScriptsPerVersion.mapOfScriptsPerVersion.get(EVersion.XR_21_CII), 27, errorImpact);
		} else if (xml.contains(":xrechnung_2.2")) { // This is the default check which is also run on en16931 files to generate notices.
			validateSchematron(xml, ScriptsPerVersion.mapOfScriptsPerVersion.get(EVersion.XR_22_CII), 27, errorImpact);
		} else if (xml.contains(":xrechnung_2.3")) { // This is the default check which is also run on en16931 files to generate notices.
			validateSchematron(xml, ScriptsPerVersion.mapOfScriptsPerVersion.get(EVersion.XR_23_CII), 27, errorImpact);
		} else { // This is the default check which is also run on en16931 files to generate notices.
			validateSchematron(xml, ScriptsPerVersion.mapOfScriptsPerVersion.get(EVersion.XR_30_CII), 27, errorImpact);
		}

	}

	/***
	 * validate using a xslt file generated from a schematron in the build preparation of this software
	 * @param xml the xml to be checked
	 * @param xsltFilename the filename of the intermediate XSLT file
	 * @param section the error type code, if one arises
	 * @param defaultSeverity how serious an error should be treated - may only be notice
	 * @throws IrrecoverableValidationError if anything happened that prevents further checks
	 */
	public void validateSchematron(String xml, String xsltFilename, int section, ESeverity defaultSeverity) throws IrrecoverableValidationError {
		LOGGER.debug(
				"public void validateSchematron(String xml, String xsltFilename='{}', int section={}, ESeverity defaultSeverity={})",
				xsltFilename,
				section,
				defaultSeverity
		);
		ISchematronResource aResSCH = SchematronResourceXSLT.fromClassPath(xsltFilename);

		if (!aResSCH.isValidSchematron()) {
			throw new IllegalArgumentException(xsltFilename + " is invalid Schematron!");
		}

		final SchematronOutputType sout;
		try {
			sout = aResSCH
					.applySchematronValidationToSVRL(new StreamSource(new StringReader(xml)));
		} catch (final Exception e) {
			throw new IrrecoverableValidationError(e.getMessage());
		}
		if (sout == null) {
			throw new IrrecoverableValidationError("Cannot retrieve SVRL report.");
		}
		// SVRLHelper.getAllFailedAssertions (sout);
		Document document = new SVRLMarshaller().getAsDocument(sout);
		XPath xPath = XPathFactory.newInstance().newXPath();
		String expression = "//*[local-name() = 'failed-assert']";
		NodeList failedAsserts;
		try {
			failedAsserts = (NodeList) xPath.compile(expression).evaluate(document, XPathConstants.NODESET);

			String thisFailText = "";
			String thisFailID = "";
			String thisFailIDStr = "";
			String thisFailTest = "";
			String thisFailLocation = "";
			if (failedAsserts.getLength() > 0) {

				for (int nodeIndex = 0; nodeIndex < failedAsserts.getLength(); nodeIndex++) {
					//nodes.item(i).getTextContent())) {
					Node currentFailNode = failedAsserts.item(nodeIndex);
					if (currentFailNode.getAttributes().getNamedItem("id") != null) {
						thisFailID = currentFailNode.getAttributes().getNamedItem("id").getNodeValue();
						thisFailIDStr = " [ID " + thisFailID + "]";
					}
					if (currentFailNode.getAttributes().getNamedItem("test") != null) {
						thisFailTest = currentFailNode.getAttributes().getNamedItem("test").getNodeValue();
					}
					if (currentFailNode.getAttributes().getNamedItem("location") != null) {
						thisFailLocation = currentFailNode.getAttributes().getNamedItem("location").getNodeValue();
					}

					ESeverity severity;
					if (defaultSeverity == ESeverity.notice) {
						severity = defaultSeverity;
					} else if (currentFailNode.getAttributes().getNamedItem("flag") != null
							&& currentFailNode.getAttributes().getNamedItem("flag").getNodeValue().equals("warning")) {
						// the XR issues warnings with flag=warning
						severity = ESeverity.warning;
					} else {
						severity = ESeverity.error;
					}

					NodeList nodes = currentFailNode.getChildNodes();
					for (int failChildIndex = 0; failChildIndex < nodes.getLength(); failChildIndex++) {
						if (nodes.item(failChildIndex).getLocalName() != null && nodes.item(failChildIndex).getLocalName().equals("text")) {
							//	if (itemChilds.item(failChildIndex).getAttributes().getNamedItem("schemeID") != null) {
							thisFailText = nodes.item(failChildIndex).getTextContent();

						}

					}

					LOGGER.info("FailedAssert {}", thisFailText);

					context.addResultItem(new ValidationResultItem(severity, thisFailText + thisFailIDStr + " from " + xsltFilename + ")")
							.setLocation(thisFailLocation).setCriterion(thisFailTest).setSection(section).setID(thisFailID)
							.setPart(EPart.fx));
					failedRules++;

				}

			}

		} catch (XPathExpressionException e) {
			LOGGER.error(e.getMessage(), e);
		}
		expression = "//*[local-name() = 'fired-rule']";
		NodeList firedAsserts;
		try {
			firedAsserts = (NodeList) xPath.compile(expression).evaluate(document, XPathConstants.NODESET);
			firedRules = firedAsserts.getLength();
		} catch (XPathExpressionException e) {
			LOGGER.error(e.getMessage(), e);
		}
	/*	int activePatterns=0;
		expression = "//*[local-name() = 'active-pattern']";
		 firedAsserts = null;
		try {
			firedAsserts = (NodeList) xPath.compile(expression).evaluate(document, XPathConstants.NODESET);
			activePatterns = firedAsserts.getLength();
		} catch (XPathExpressionException e) {
			LOGGER.error(e.getMessage(), e);
		}*/

		if (firedRules == 0) {
			context.addResultItem(new ValidationResultItem(ESeverity.error, "No rules matched, XML too minimal?").setSection(26)
					.setPart(EPart.fx));

		}
		//	for (String currentString : sout.getText()) {
		// schematronValidationString += "<output>" + currentString + "</output>";
		// }

		// schematronValidationString += new SVRLMarshaller ().getAsString (sout);
		// returns the complete SVRL

	}

	@SuppressWarnings("unused")
	public int getFiredRules() {
		return firedRules;
	}

	@SuppressWarnings("unused")
	public int getFailedRules() {
		return failedRules;
	}

}
