package org.mustangproject.validator;

import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.UncheckedIOException;
import java.math.BigDecimal;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.text.ParseException;
import java.util.Calendar;
import java.util.Set;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.mustangproject.CalculatedInvoice;
import org.mustangproject.XMLTools;
import org.mustangproject.ZUGFeRD.IZUGFeRDExportableItem;
import org.mustangproject.ZUGFeRD.LineCalculator;
import org.mustangproject.ZUGFeRD.ZUGFeRDInvoiceImporter;
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
	 * @throws IrrecoverableValidationError if e.g. the file can not be found, or does not contain XML, so no further validation can take place
	 */
	@Override
	public void setFilename(String name) throws IrrecoverableValidationError { // from XML Filename
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
	 * whether uri1 has the same meaning like uri1 (it has, if it only differs in the fragment, i.e. uri1#1==uri1#2 )
	 *
	 * @param uri1 basis guideline ID
	 * @param uri2 guideline ID to be checked
	 * @return true if semantically identical
	 */
	public static boolean matchesURI(String uri1, String uri2) {
		return (uri1 != null && (uri2 != null && (uri1.equals(uri2) || uri1.startsWith(uri2 + "#"))));
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
				//REDHAT
				//https://www.blackhat.com/docs/us-15/materials/us-15-Wang-FileCry-The-New-Age-Of-XXE-java-wp.pdf
				dbf.setAttribute(XMLConstants.FEATURE_SECURE_PROCESSING, true);
				dbf.setAttribute(XMLConstants.ACCESS_EXTERNAL_DTD, "");
				dbf.setAttribute(XMLConstants.ACCESS_EXTERNAL_SCHEMA, "");

				//OWASP
				//https://cheatsheetseries.owasp.org/cheatsheets/XML_External_Entity_Prevention_Cheat_Sheet.html
				dbf.setFeature("http://apache.org/xml/features/disallow-doctype-decl", true);
				dbf.setFeature("http://xml.org/sax/features/external-general-entities", false);
				dbf.setFeature("http://xml.org/sax/features/external-parameter-entities", false);
				// Disable external DTDs as well
				dbf.setFeature("http://apache.org/xml/features/nonvalidating/load-external-dtd", false);
				// and these as well, per Timothy Morgan's 2014 paper: "XML Schema, DTD, and Entity Attacks"
				dbf.setXIncludeAware(false);
				dbf.setExpandEntityReferences(false);
				dbf.setNamespaceAware(true);

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
					// if there is a attribute in the tag number:value
					// urn:ferd:CrossIndustryDocument:invoice:1p0:extended
					// setForeignReference(booking.getTextContent());

					context.setProfile(booking.getNodeValue());
				}
				boolean isOrderX = false;
				boolean isDespatchAdvice = false;
				boolean isMiniumum = false;
				boolean isBasic = false;
				boolean isBasicWithoutLines = false;
				boolean isEN16931 = false;
				boolean isExtended = false;
				boolean isXRechnung = false;
				String currentZFVersionDir = "ZF_240";
				int mainSchematronSectionErrorTypeCode = 4;
				String xsltFilename = null;
				// urn:ferd:CrossIndustryDocument:invoice:1p0:extended,
				// urn:ferd:CrossIndustryDocument:invoice:1p0:comfort,
				// urn:ferd:CrossIndustryDocument:invoice:1p0:basic,

				// urn:cen.eu:en16931:2017
				// urn:cen.eu:en16931:2017:compliant:factur-x.eu:1p0:basic
				String rootLocalName = root.getLocalName();
				String contextProfile = context.getProfile();
				if ("SCRDMCCBDACIOMessageStructure".equalsIgnoreCase(rootLocalName)) {
					context.setGeneration("1");
					isOrderX = true;
					isBasic = contextProfile.contains("basic");
					isEN16931 = contextProfile.contains("comfort");
					isExtended = contextProfile.contains("extended");
					validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), "OX_10/comfort/SCRDMCCBDACIOMessageStructure_100pD20B.xsd", 99, EPart.ox);
					xsltFilename = "/xslt/OX_10/comfort/SCRDMCCBDACIOMessageStructure_100pD20B_COMFORT.xslt";
					
				} else if (root.getLocalName().equalsIgnoreCase("CrossIndustryInvoice")) { // ZUGFeRD 2.0 or Factur-X
					context.setGeneration("2");

					isMiniumum = contextProfile.contains("minimum");
					isBasic = contextProfile.contains("basic");
					isBasicWithoutLines = contextProfile.contains("basicwl");
					if (isBasicWithoutLines) {
						isBasic = false;// basicwl also contains the string basic...
					}
					isEN16931 = Set.of(
							"urn:cen.eu:en16931:2017:compliant:factur-x.eu:1p0:en16931",
							"urn:cen.eu:en16931:2017"
						)
						.stream()
						.anyMatch(profile -> matchesURI(contextProfile, profile));

					isExtended = contextProfile.contains("extended");
					isXRechnung = contextProfile.contains("xrechnung");

					if ((isExtended) || (isXRechnung)) {
						isEN16931 = false;// the uri for extended is urn:cen.eu:en16931:2017#conformant#urn:zugferd.de:2p0:extended and thus contains en16931...
					}
					if (isMiniumum) {
						LOGGER.debug("is Minimum");
						validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), currentZFVersionDir + "/MINIMUM/FACTUR-X_MINIMUM.xsd", 18, EPart.fx);
						xsltFilename = "/xslt/" + currentZFVersionDir + "/FACTUR-X_MINIMUM.xslt";
					} else if (isBasicWithoutLines) {
						LOGGER.debug("is Basic/WL");
						validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), currentZFVersionDir + "/BASIC-WL/FACTUR-X_BASIC-WL.xsd", 18, EPart.fx);
						xsltFilename = "/xslt/" + currentZFVersionDir + "/FACTUR-X_BASIC-WL.xslt";
					} else if (isBasic) {
						LOGGER.debug("is Basic");
						validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), currentZFVersionDir + "/BASIC/FACTUR-X_BASIC.xsd", 18, EPart.fx);
						xsltFilename = "/xslt/" + currentZFVersionDir + "/FACTUR-X_BASIC.xslt";
					} else if (isEN16931) {
						LOGGER.debug("is EN16931");
						validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), currentZFVersionDir + "/EN16931/FACTUR-X_EN16931.xsd", 18, EPart.fx);
						xsltFilename = "/xslt/" + currentZFVersionDir + "/FACTUR-X_EN16931.xslt";
					} else if (isXRechnung) {
						LOGGER.debug("is XRechnung");
						/*
						the validation against the XRechnung Schematron will happen below but a
						XRechnung is a EN16931 subset so the validation vis a vis FACTUR-X_EN16931.xslt=schematron also has to pass
						* */
						validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), currentZFVersionDir + "/EN16931/FACTUR-X_EN16931.xsd", 18, EPart.fx);

						XrechnungSeverity = ESeverity.error;
					} else if (isExtended) {
						LOGGER.debug("is EXTENDED");
						validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), currentZFVersionDir + "/EXTENDED/FACTUR-X_EXTENDED.xsd", 18, EPart.fx);
						xsltFilename = "/xslt/" + currentZFVersionDir + "/FACTUR-X_EXTENDED.xslt";
					}

					// takes around 10 Seconds. //
					// http://www.bentoweb.org/refs/TCDL2.0/tsdtf_schematron.html // explains that
					// this xslt can be created using sth like
					// saxon java net.sf.saxon.Transform -o tcdl2.0.tsdtf.sch.tmp.xsl -s
					// tcdl2.0.tsdtf.sch iso_svrl.xsl

				} else if ("Invoice".equalsIgnoreCase(rootLocalName) || rootLocalName.equalsIgnoreCase("CreditNote")) {
					context.setGeneration("2");
					context.setFormat("UBL");
					isXRechnung = contextProfile.contains("xrechnung");
					// UBL
					LOGGER.debug("UBL");
					validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), "UBL_21/maindoc/UBL-" + rootLocalName + "-2.1.xsd", 18, EPart.fx);
					xsltFilename = "/xslt/en16931schematron/EN16931-UBL-validation.xslt";

					mainSchematronSectionErrorTypeCode = 24;

					if (isXRechnung) {
						validateSchematron(zfXML, xsltFilename, 24, ESeverity.error);
						/*
						the validation against the XRechnung Schematron will happen below but a
						XRechnung is a EN16931 subset so the validation vis a vis FACTUR-X_EN16931.xslt=schematron also has to pass
						* */
						//validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), "ZF_211/EN16931/FACTUR-X_EN16931.xsd", 18, EPart.fx);
						String xrVersion = contextProfile.substring(contextProfile.length() - 3).replace(".", "");
						
						Set<String> supportedVersions = Set.of("12", "20", "21", "22", "23", "30");
						if (!supportedVersions.contains(xrVersion)) {
							throw new Exception("Unsupported XR version");
						}
						LOGGER.debug("is XRechnung v{}", xrVersion);
						xsltFilename = "/xslt/XR_" + xrVersion + "/XRechnung-UBL-validation.xslt";
						XrechnungSeverity = ESeverity.error;
						mainSchematronSectionErrorTypeCode = 27;

					}

				} else if ("CrossIndustryDocument".equalsIgnoreCase(rootLocalName)) { // ZUGFeRD 1.0
					context.setGeneration("1");
					//
					Set<String> validZF1Profiles = Set.of(
						"urn:ferd:CrossIndustryDocument:invoice:1p0:basic",
						"urn:ferd:CrossIndustryDocument:invoice:1p0:comfort",
						"urn:ferd:CrossIndustryDocument:invoice:1p0:extended"
					);
					if (validZF1Profiles.stream().noneMatch(profile -> matchesURI(contextProfile, profile))) {
						addUnsupportedProfileResultItem();
					}
					validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), "ZF_10/ZUGFeRD1p0.xsd", 18, EPart.fx);

					xsltFilename = "/xslt/ZUGFeRD_1p0.xslt";
				} else { // unknown document root
					context.addResultItem(new ValidationResultItem(ESeverity.fatal, "Unsupported root element")
						.setSection(3).setPart(EPart.fx));
				}
				if ("CII".equals(context.getFormat())) {

					if ("2".equals(context.getGeneration())) {
						Set<String> validZF2Profiles = Set.of(
							"urn:factur-x.eu:1p0:minimum",
							"urn:zugferd.de:2p0:minimum",
							"urn:factur-x.eu:1p0:basicwl",
							"urn:zugferd.de:2p0:basicwl",
							"urn:cen.eu:en16931:2017#compliant#urn:factur-x.eu:1p0:basic",
							"urn:cen.eu:en16931:2017#compliant#urn:zugferd.de:2p0:basic",
							"urn:cen.eu:en16931:2017",
							"urn:cen.eu:en16931:2017#conformant#urn:factur-x.eu:1p0:extended",
							"urn:cen.eu:en16931:2017#conformant#urn:zugferd.de:2p0:extended"
						);
						if (validZF2Profiles.stream().noneMatch(profile -> matchesURI(contextProfile, profile))) {
							addUnsupportedProfileResultItem();
						}
					} else /** v1 */ {
						if (isOrderX) {
							//order-x 1.0
							if(Set.of(
								"urn:order-x.eu:1p0:basic",
								"urn:order-x.eu:1p0:comfort",
								"urn:order-x.eu:1p0:extended"
							).stream().noneMatch(profile -> matchesURI(contextProfile, profile))) {
								addUnsupportedProfileResultItem();
							}

						} else if (Set.of(
							"urn:ferd:CrossIndustryDocument:invoice:1p0:basic",
							"urn:ferd:CrossIndustryDocument:invoice:1p0:comfort",
							"urn:ferd:CrossIndustryDocument:invoice:1p0:extended"
						).stream().noneMatch(profile -> matchesURI(contextProfile, profile))) {
							//zf 1.0
							addUnsupportedProfileResultItem();
						}
					}
				} else {
					// no CII -> has to be UBL
					if (context.hasPDF()) {
						final ValidationResultItem vri = new ValidationResultItem(ESeverity.error, "Factur-X/ZUGFeRD and Order-X are always strictly CII only, no UBL allowed.").setSection(17)
							.setPart(EPart.fx);
						context.addResultItem(vri);

					}
				}

				if (xsltFilename != null) {
					// main schematron validation
					validateSchematron(zfXML, xsltFilename, mainSchematronSectionErrorTypeCode, ESeverity.error);

				}

				if ("CII".equals(context.getFormat()) && ("2".equals(context.getGeneration()))) {

					if (isXRechnung) {
						//additionally validate against CEN, the CEN rules are part of the ZF Schematron anyway
						validateSchematron(zfXML, "/xslt/en16931schematron/EN16931-CII-validation.xslt", 24, ESeverity.error);
					}
					if (isXRechnung || isBasic || isEN16931) {
						//potentially (basic or EN) or definitely validate against XR
						if (!disableNotices || XrechnungSeverity != ESeverity.notice) {
							validateXR(zfXML, XrechnungSeverity);
						}
					}
				}
				checkArithmetics(context);


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

		context.addCustomXML(getInfoXml(endTime, startXMLTime));
	}

	private void addUnsupportedProfileResultItem() throws IrrecoverableValidationError {
		context.addResultItem(new ValidationResultItem(ESeverity.error, "Unsupported profile type " + context.getProfile())
			.setSection(25).setPart(EPart.fx));
	}

	private String getInfoXml(long endTime, long startXMLTime) {
		String generation = context.getGeneration() != null ? context.getGeneration() : "invalid";
		String profile = context.getProfile() != null ? context.getProfile() : "invalid";
		String validatorVersion = XMLValidator.class.getPackage().getImplementationVersion();
		long duration = endTime - startXMLTime;

		return String.format(
			"<info>" +
				"<version>%s</version>" +
				"<profile>%s</profile>" +
				"<validator version=\"%s\"></validator>" +
				"<rules><fired>%d</fired><failed>%d</failed></rules>" +
				"<duration unit=\"ms\">%d</duration>" +
				"</info>",
			generation, profile, validatorVersion, firedRules, failedRules, duration
		);
	}

	private void checkArithmetics(ValidationContext context) {
		ZUGFeRDInvoiceImporter zi=new ZUGFeRDInvoiceImporter();
		try {
			zi.fromXML(zfXML);
			CalculatedInvoice ci=new CalculatedInvoice();
			zi.extractInto(ci);

			// check sub invoice line hierarchy if present
			checkSubInvoiceLineHierarchy(ci, context);

		} catch ( ArithmeticException e) {
			try {
				context.addResultItem(new ValidationResultItem(ESeverity.warning, "Arithmetical issue:"+e.getMessage()).setSection(10));

			} catch (IrrecoverableValidationError ie) {
				LOGGER.error(ie.getMessage(), ie);
			}
		} catch (XPathExpressionException e) {
			LOGGER.error(e.getMessage(), e);
		} catch (ParseException e) {
			LOGGER.error(e.getMessage(), e);
		}

	}

	/***
	 * validates that GROUP line totals match the sum of their DETAIL child lines
	 */
	private void checkSubInvoiceLineHierarchy(CalculatedInvoice invoice, ValidationContext context) {
		IZUGFeRDExportableItem[] items = invoice.getZFItems();
		if (items == null || items.length == 0) {
			return;
		}

		// check if we have any sub invoice lines at all
		boolean hasSubInvoiceLines = false;
		for (IZUGFeRDExportableItem item : items) {
			if (item.getLineStatusReasonCode() != null) {
				hasSubInvoiceLines = true;
				break;
			}
		}
		if (!hasSubInvoiceLines) {
			return;
		}

		// build a map of line ID to item for quick lookup
		java.util.HashMap<String, IZUGFeRDExportableItem> itemMap = new java.util.HashMap<>();
		for (IZUGFeRDExportableItem item : items) {
			if (item.getId() != null) {
				itemMap.put(item.getId(), item);
			}
		}

		// for each GROUP line, sum up the DETAIL children and compare
		for (IZUGFeRDExportableItem item : items) {
			if ("GROUP".equals(item.getLineStatusReasonCode())) {
				String groupId = item.getId();
				if (groupId == null) {
					continue;
				}

				// sum up direct DETAIL children
				BigDecimal childSum = BigDecimal.ZERO;
				for (IZUGFeRDExportableItem child : items) {
					if (groupId.equals(child.getParentLineID()) && "DETAIL".equals(child.getLineStatusReasonCode())) {
						LineCalculator lc = child.getCalculation();
						childSum = childSum.add(lc.getItemTotalNetAmount());
					}
				}

				// also sum up nested GROUP children (their totals should already include their DETAIL children)
				for (IZUGFeRDExportableItem child : items) {
					if (groupId.equals(child.getParentLineID()) && "GROUP".equals(child.getLineStatusReasonCode())) {
						LineCalculator lc = child.getCalculation();
						childSum = childSum.add(lc.getItemTotalNetAmount());
					}
				}

				// compare with GROUP total
				LineCalculator groupLc = item.getCalculation();
				BigDecimal groupTotal = groupLc.getItemTotalNetAmount();
				if (childSum.compareTo(groupTotal) != 0) {
					try {
						context.addResultItem(new ValidationResultItem(ESeverity.warning,
							"Sub invoice line hierarchy mismatch: GROUP line " + groupId +
							" has total " + groupTotal + " but sum of child lines is " + childSum)
							.setSection(10));
					} catch (IrrecoverableValidationError ie) {
						LOGGER.error(ie.getMessage(), ie);
					}
				}
			}
		}
	}

	public void validateXR(String xml, ESeverity errorImpact) throws IrrecoverableValidationError {

		//Guideline ID=urn:cen.eu:en16931:2017#compliant#urn:xoev-de:kosit:standard:xrechnung_1.2  or
		if (xml.contains(":xrechnung_1.")) {
			validateSchematron(xml, "/xslt/XR_12/XRechnung-CII-validation.xslt", 27, errorImpact);
		} else if (xml.contains(":xrechnung_2.0")) {
			// urn:cen.eu:en16931:2017#compliant#urn:xoev-dede:kosit:standard:xrechnung_2.0#conformant#urn:xoev-de:kosit:extension:xrechnung_2.0
			validateSchematron(xml, "/xslt/XR_20/XRechnung-CII-validation.xslt", 27, errorImpact);
		} else if (xml.contains(":xrechnung_2.1")) { // This is the default check which is also run on en16931 files to generate notices.
			validateSchematron(xml, "/xslt/XR_21/XRechnung-CII-validation.xslt", 27, errorImpact);
		} else if (xml.contains(":xrechnung_2.2")) { // This is the default check which is also run on en16931 files to generate notices.
			validateSchematron(xml, "/xslt/XR_22/XRechnung-CII-validation.xslt", 27, errorImpact);
		} else if (xml.contains(":xrechnung_2.3")) { // This is the default check which is also run on en16931 files to generate notices.
			validateSchematron(xml, "/xslt/XR_23/XRechnung-CII-validation.xslt", 27, errorImpact);
		} else { // This is the default check which is also run on en16931 files to generate notices.
			validateSchematron(xml, "/xslt/XR_30/XRechnung-CII-validation.xslt", 27, errorImpact);
		}

	}


	/***
	 * validate using a xslt file generated from a schematron in the build preparation of this software
	 * @param xml the xml to be checked
	 * @param xsltFilename the filename of the intermediate XSLT file
	 * @param section the error type code, if one arises
	 * @param defaultSeverity how serious a error should be treated - may only be notice
	 * @throws IrrecoverableValidationError if anything happened that prevents further checks
	 */
	public void validateSchematron(String xml, String xsltFilename, int section, ESeverity defaultSeverity) throws IrrecoverableValidationError {
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
			// SVRLHelper.getAllFailedAssertions (sout);
			Document SVRLReport = new SVRLMarshaller().getAsDocument(sout);
			XPath xPath = XPathFactory.newInstance().newXPath();
			String expression = "//*[local-name() = 'failed-assert']";
			NodeList failedAsserts = null;
			try {
				failedAsserts = (NodeList) xPath.compile(expression).evaluate(SVRLReport, XPathConstants.NODESET);

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
						Node failNode = currentFailNode.getAttributes().getNamedItem("flag");
						String failVal = failNode == null ? null : failNode.getNodeValue();
						if (defaultSeverity == ESeverity.notice) {
							severity = defaultSeverity;
						} else if ("warning".equals(failVal)) {
							// the XR issues warnings with flag=warning
							severity = ESeverity.warning;
						} else if ("information".equals(failVal)) {
							severity = ESeverity.notice;
						} else {
							severity = ESeverity.error;
						}

						NodeList failChilds = currentFailNode.getChildNodes();
						for (int failChildIndex = 0; failChildIndex < failChilds.getLength(); failChildIndex++) {
							if (failChilds.item(failChildIndex).getLocalName() != null) {

								if (failChilds.item(failChildIndex).getLocalName().equals("text")) {
									//	if (itemChilds.item(failChildIndex).getAttributes().getNamedItem("schemeID") != null) {
									thisFailText = failChilds.item(failChildIndex).getTextContent();

								}
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
			NodeList firedAsserts = null;
			try {
				firedAsserts = (NodeList) xPath.compile(expression).evaluate(SVRLReport, XPathConstants.NODESET);
				firedRules = firedAsserts.getLength();
			} catch (XPathExpressionException e) {
				LOGGER.error(e.getMessage(), e);
			}
		/*	int activePatterns=0;
			expression = "//*[local-name() = 'active-pattern']";
			 firedAsserts = null;
			try {
				firedAsserts = (NodeList) xPath.compile(expression).evaluate(SVRLReport, XPathConstants.NODESET);
				activePatterns = firedAsserts.getLength();
			} catch (XPathExpressionException e) {
				LOGGER.error(e.getMessage(), e);
			}*/


			if (firedRules == 0) {
				context.addResultItem(new ValidationResultItem(ESeverity.error, "No rules matched, XML too minimal?").setSection(26)
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
