package org.mustangproject.validator;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.StringWriter;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Calendar;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
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
import com.helger.schematron.svrl.SVRLHelper;
import com.helger.schematron.svrl.jaxb.FailedAssert;
import com.helger.schematron.svrl.jaxb.FiredRule;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.xslt.SchematronResourceXSLT;

public class XMLValidator extends Validator {

	private static final Logger LOGGER = LoggerFactory.getLogger(XMLValidator.class.getCanonicalName()); // log output
	// is
	// ignored for the
	// time being

	protected String zfXML = "";
	protected String filename = "";
	int firedRules = 0;
	int failedRules = 0;
	boolean disableNotices = false;
	ISchematronResource aResSCH = null;


	public XMLValidator(ValidationContext ctx) {
		super(ctx);
	}

	/***
	 * set source file
	 * @param name the absolute filename of an xml file to validate
	 * @throws IrrecoverableValidationError
	 */
	@Override
  public void setFilename(String name) throws IrrecoverableValidationError { // from XML Filename
		filename = name;
		// file existence must have been checked before

		try {
			zfXML = new String(XMLTools.removeBOM(Files.readAllBytes(Paths.get(name))), StandardCharsets.UTF_8);
		} catch (final IOException e) {

			final ValidationResultItem vri = new ValidationResultItem(ESeverity.exception, e.getMessage()).setSection(9)
					.setPart(EPart.fx);
			final StringWriter sw = new StringWriter();
			final PrintWriter pw = new PrintWriter(sw);
			e.printStackTrace(pw);
			vri.setStacktrace(sw.toString());
			context.addResultItem(vri);
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
	 * whether uri1 has the same meaning like uri1 (it has, if it only differs in the fragment, i.e. uri1#1==uri1#2 )
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
				ESeverity XrechnungSeverity = ESeverity.notice;
				/***
				 * private static final String VALID_SCHEMATRON = "test-sch/valid01.sch";
				 * private static final String VALID_XMLINSTANCE = "test-xml/valid01.xml";
				 *
				 * @Test public void testWriteValid () throws Exception { final Document aDoc =
				 *       SchematronResourceSCH.fromClassPath (VALID_SCHEMATRON)
				 *       .applySchematronValidation (new ClassPathResource (VALID_XMLINSTANCE));
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
						"//*[local-name()=\"GuidelineSpecifiedDocumentContextParameter\"]/*[local-name()=\"ID\"]/text()");
				// evaluate expression result on XML document
				ndList = (NodeList) expr.evaluate(doc, XPathConstants.NODESET);

				for (int bookingIndex = 0; bookingIndex < ndList.getLength(); bookingIndex++) {
					final Node booking = ndList.item(bookingIndex);
					// if there is a attribute in the tag number:value
					// urn:ferd:CrossIndustryDocument:invoice:1p0:extended
					// setForeignReference(booking.getTextContent());

					context.setProfile(booking.getNodeValue());
				}
				boolean isOrderX = false;
				boolean isMiniumum = false;
				boolean isBasic = false;
				boolean isBasicWithoutLines = false;
				boolean isEN16931 = false;
				boolean isExtended = false;
				boolean isXRechnung = false;
				String xsltFilename = null;
				// urn:ferd:CrossIndustryDocument:invoice:1p0:extended,
				// urn:ferd:CrossIndustryDocument:invoice:1p0:comfort,
				// urn:ferd:CrossIndustryDocument:invoice:1p0:basic,

				// urn:cen.eu:en16931:2017
				// urn:cen.eu:en16931:2017:compliant:factur-x.eu:1p0:basic
				if (root.getNodeName().equalsIgnoreCase("rsm:SCRDMCCBDACIOMessageStructure")) {
					context.setGeneration("1");
					isOrderX=true;
					isBasic = context.getProfile().contains("basic");
					isEN16931 = context.getProfile().contains("comfort");
					isExtended = context.getProfile().contains("extended");
					validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), "OX_10/comfort/SCRDMCCBDACIOMessageStructure_100pD20B.xsd", 99, EPart.ox);
					xsltFilename = "/xslt/OX_10/comfort/SCRDMCCBDACIOMessageStructure_100pD20B_COMFORT.xslt";

				} else if (root.getNodeName().equalsIgnoreCase("rsm:CrossIndustryInvoice")) { // ZUGFeRD 2.0 or Factur-X
					context.setGeneration("2");

					isMiniumum = context.getProfile().contains("minimum");
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
					if (isMiniumum) {
						LOGGER.debug("is Minimum");
						validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), "ZF_211/MINIMUM/FACTUR-X_MINIMUM.xsd", 18, EPart.fx);
						xsltFilename = "/xslt/ZF_211/FACTUR-X_MINIMUM.xslt";
					} else if (isBasicWithoutLines) {
						LOGGER.debug("is Basic/WL");
						validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), "ZF_211/BASIC-WL/FACTUR-X_BASIC-WL.xsd", 18, EPart.fx);
						xsltFilename = "/xslt/ZF_211/FACTUR-X_BASIC-WL.xslt";
					} else if (isBasic) {
						LOGGER.debug("is Basic");
						validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), "ZF_211/BASIC/FACTUR-X_BASIC.xsd", 18, EPart.fx);
						xsltFilename = "/xslt/ZF_211/FACTUR-X_BASIC.xslt";
					} else if (isEN16931) {
						LOGGER.debug("is EN16931");
						validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), "ZF_211/EN16931/FACTUR-X_EN16931.xsd", 18, EPart.fx);
						xsltFilename = "/xslt/ZF_211/FACTUR-X_EN16931.xslt";
					} else if (isExtended) {
						LOGGER.debug("is EXTENDED");
						validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), "ZF_211/EXTENDED/FACTUR-X_EXTENDED.xsd", 18, EPart.fx);
						xsltFilename = "/xslt/ZF_211/FACTUR-X_EXTENDED.xslt";
					} else if (isXRechnung) {
						LOGGER.debug("is XRechnung");
						validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), "ZF_211/EXTENDED/FACTUR-X_EXTENDED.xsd", 18, EPart.fx);
						xsltFilename = "/xslt/ZF_211/FACTUR-X_EN16931.xslt";
						XrechnungSeverity = ESeverity.error;
					} /*
					 * ISchematronResource aResSCH = SchematronResourceXSLT.fromFile(new File(
					 * "/Users/jstaerk/workspace/ZUV/src/main/resources/ZUGFeRDSchematronStylesheet.xsl"
					 * ));
					 */

					// takes around 10 Seconds. //
					// http://www.bentoweb.org/refs/TCDL2.0/tsdtf_schematron.html // explains that
					// this xslt can be created using sth like
					// saxon java net.sf.saxon.Transform -o tcdl2.0.tsdtf.sch.tmp.xsl -s
					// tcdl2.0.tsdtf.sch iso_svrl.xsl

				} else if (root.getNodeName().equalsIgnoreCase("Invoice")) {
					context.setGeneration("2");
					context.setFormat("UBL");
					// UBL
					LOGGER.debug("UBL");
					validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), "UBL_21/maindoc/UBL-Invoice-2.1.xsd", 18, EPart.fx);
					xsltFilename = "/xslt/UBL_21/EN16931-UBL-validation.xsl";
					XrechnungSeverity = ESeverity.error;
				} else { // ZUGFeRD 1.0
					context.setGeneration("1");
					//
					if ((!matchesURI(context.getProfile(), "urn:ferd:CrossIndustryDocument:invoice:1p0:basic"))
							&& (!matchesURI(context.getProfile(), "urn:ferd:CrossIndustryDocument:invoice:1p0:comfort"))
							&& (!matchesURI(context.getProfile(), "urn:ferd:CrossIndustryDocument:invoice:1p0:extended"))) {
						context.addResultItem(new ValidationResultItem(ESeverity.error, "Unsupported profile type")
								.setSection(25).setPart(EPart.fx));
					}
					validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), "ZF_10/ZUGFeRD1p0.xsd", 18, EPart.fx);

					xsltFilename = "/xslt/ZUGFeRD_1p0.xslt";
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
									new ValidationResultItem(ESeverity.error, "Unsupported profile type " + context.getProfile())
											.setSection(25).setPart(EPart.fx));

						}
					} else /** v1 */ {
						if (isOrderX) {
							//order-x 1.0
							if ((!matchesURI(context.getProfile(), "urn:order-x.eu:1p0:basic"))
									&& (!matchesURI(context.getProfile(), "urn:order-x.eu:1p0:comfort"))
									&& (!matchesURI(context.getProfile(), "urn:order-x.eu:1p0:extended"))) {
								//zf 1.0
								context.addResultItem(new ValidationResultItem(ESeverity.error, "Unsupported profile type")
										.setSection(25).setPart(EPart.fx));

							}
						} else
						if ((!matchesURI(context.getProfile(), "urn:ferd:CrossIndustryDocument:invoice:1p0:basic"))
								&& (!matchesURI(context.getProfile(), "urn:ferd:CrossIndustryDocument:invoice:1p0:comfort"))
								&& (!matchesURI(context.getProfile(), "urn:ferd:CrossIndustryDocument:invoice:1p0:extended"))) {
							//zf 1.0
							context.addResultItem(new ValidationResultItem(ESeverity.error, "Unsupported profile type")
									.setSection(25).setPart(EPart.fx));

						}
					}
				}

				// main schematron validation
				validateSchematron(zfXML, xsltFilename, 4, ESeverity.error);

				if (context.getFormat().equals("CII")) {

					if (context.getGeneration().equals("2")
							&& (isEN16931 || isXRechnung)) {
						//additionally validate against CEN
						validateSchematron(zfXML, "/xslt/cii16931schematron/EN16931-CII-validation.xslt", 24, ESeverity.error);
						if (!disableNotices || XrechnungSeverity != ESeverity.notice) {
							validateXR(zfXML, XrechnungSeverity);
						}
					}
				}


			} catch (final IrrecoverableValidationError er) {
				throw er;
			} catch (final Exception e) {
				final ValidationResultItem vri = new ValidationResultItem(ESeverity.exception, e.getMessage()).setSection(22)
						.setPart(EPart.fx);
				final StringWriter sw = new StringWriter();
				final PrintWriter pw = new PrintWriter(sw);
				e.printStackTrace(pw);
				vri.setStacktrace(sw.toString());
				context.addResultItem(vri);
			}

		}
		final long endTime = Calendar.getInstance().getTimeInMillis();

		context.addCustomXML("<info><version>" + ((context.getGeneration() != null) ? context.getGeneration() : "invalid")
				+ "</version><profile>" + ((context.getProfile() != null) ? context.getProfile() : "invalid") +
				"</profile><validator version=\"" + XMLValidator.class.getPackage().getImplementationVersion() + "\"></validator><rules><fired>" + firedRules + "</fired><failed>" + failedRules + "</failed></rules>" + "<duration unit=\"ms\">" + (endTime - startXMLTime) + "</duration></info>");

	}

	public void validateXR(String xml, ESeverity errorImpact) throws IrrecoverableValidationError {

		//Guideline ID=urn:cen.eu:en16931:2017#compliant#urn:xoev-de:kosit:standard:xrechnung_1.2  or
		if (xml.contains(":xrechnung_1.")) {
			validateSchematron(xml, "/xslt/XR_12/XRechnung-CII-validation.xslt", 27, errorImpact);
		} else if (xml.contains(":xrechnung_2.0")) {
			// urn:cen.eu:en16931:2017#compliant#urn:xoev-dede:kosit:standard:xrechnung_2.0#conformant#urn:xoev-de:kosit:extension:xrechnung_2.0
			validateSchematron(xml, "/xslt/XR_20/XRechnung-CII-validation.xslt", 27, errorImpact);
		} else { // This is the default check which is also run on en16931 files to generate notices.
			// As of the next version this should probably if (xml.contains(":xrechnung_2.1"))
			validateSchematron(xml, "/xslt/XR_21/XRechnung-CII-validation.xslt", 27, errorImpact);
		}

	}


	/***
	 * validate using a xslt file generated from a schematron in the build preparation of this software
	 * @param xml the xml to be checked
	 * @param xsltFilename the filename of the intermediate XSLT file
	 * @param section the error type code, if one arises
	 * @param severity how serious a error should be treated - may only be notice
	 * @throws IrrecoverableValidationError if anything happened that prevents further checks
	 */
	public void validateSchematron(String xml, String xsltFilename, int section, ESeverity severity) throws IrrecoverableValidationError {
		ISchematronResource aResSCH = null;
		aResSCH = SchematronResourceXSLT.fromClassPath(xsltFilename);
		if (aResSCH != null) {
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

			final List<Object> failedAsserts = sout.getActivePatternAndFiredRuleAndFailedAssert();
			if (failedAsserts.size() > 0) {
				for (final Object object : failedAsserts) {
					if (object instanceof FailedAssert) {

						final FailedAssert failedAssert = (FailedAssert) object;
						LOGGER.info("FailedAssert ", failedAssert);

						context.addResultItem(new ValidationResultItem(severity, SVRLHelper.getAsString(failedAssert.getText()))
								.setLocation(failedAssert.getLocation()).setCriterion(failedAssert.getTest()).setSection(section)
								.setPart(EPart.fx));
						failedRules++;
					} else if (object instanceof FiredRule) {
						firedRules++;
					}
				}

			}
			if (firedRules == 0) {
				context.addResultItem(new ValidationResultItem(ESeverity.error, "No rules matched, XML to minimal?").setSection(26)
						.setPart(EPart.fx));

			}
			//  for (String currentString : sout.getText()) {
			// schematronValidationString += "<output>" + currentString + "</output>";
			// }

			// schematronValidationString += new SVRLMarshaller ().getAsString (sout);
			// returns the complete SVRL

		}
	}


	public int getFiredRules() {
		return firedRules;
	}

	public int getFailedRules() {
		return failedRules;
	}


}
