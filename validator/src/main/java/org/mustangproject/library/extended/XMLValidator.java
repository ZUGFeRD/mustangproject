package org.mustangproject.library.extended;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Calendar;
import java.util.List;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.transform.*;
import javax.xml.transform.stream.StreamResult;
import javax.xml.transform.stream.StreamSource;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import com.helger.schematron.svrl.jaxb.FailedAssert;
import com.helger.schematron.svrl.jaxb.FiredRule;
import com.helger.schematron.svrl.jaxb.SchematronOutputType;
import com.helger.schematron.ISchematronResource;
import com.helger.schematron.xslt.SchematronResourceXSLT;
import com.helger.schematron.svrl.SVRLHelper;
import org.xml.sax.InputSource;

public class XMLValidator extends Validator {
    public XMLValidator(ValidationContext ctx) {
        super(ctx);
    }

    private static final Logger LOGGER = LoggerFactory.getLogger(XMLValidator.class.getCanonicalName()); // log output
    // is
    // ignored for the
    // time being

    protected String zfXML = "";
    protected String filename = "";
    int firedRules = 0;
    int failedRules = 0;
    ISchematronResource aResSCH = null;

    public void setFilename(String name) throws IrrecoverableValidationError { // from XML Filename
        filename = name;
        // file existence must have been checked before

        try {
            zfXML = new String(Files.readAllBytes(Paths.get(name)));
        } catch (IOException e) {

            ValidationResultItem vri = new ValidationResultItem(ESeverity.exception, e.getMessage()).setSection(9)
                    .setPart(EPart.fx);
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            e.printStackTrace(pw);
            vri.setStacktrace(sw.toString());
            context.addResultItem(vri);
        }
    }

    public void setStringContent(String xml) {
        zfXML = xml;
    }

    public static boolean matchesURI(String uri1, String uri2) {
        return (uri1.equals(uri2) || uri1.startsWith(uri2 + "#"));
    }

    /***
     *
     * @param xmlString
     * @param overrideProfileCheck
     *            if set to true, all ZF2 files will be checked against EN16931
     *            schematron, since no other schematron is available
     * @return
     */
    @Override
    public void validate() throws IrrecoverableValidationError {
        long startXMLTime = Calendar.getInstance().getTimeInMillis();
        firedRules = 0;
        failedRules = 0;


        ByteArrayInputStream xmlByteInputStream = new ByteArrayInputStream(zfXML.getBytes(StandardCharsets.UTF_8));

        if (zfXML.isEmpty()) {
            ValidationResultItem res = new ValidationResultItem(ESeverity.exception,
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

                /***
                 * private static final String VALID_SCHEMATRON = "test-sch/valid01.sch";
                 * private static final String VALID_XMLINSTANCE = "test-xml/valid01.xml";
                 *
                 * @Test public void testWriteValid () throws Exception { final Document aDoc =
                 *       SchematronResourceSCH.fromClassPath (VALID_SCHEMATRON)
                 *       .applySchematronValidation (new ClassPathResource (VALID_XMLINSTANCE));
                 *
                 */

                DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
                dbf.setNamespaceAware(true); // otherwise we can not act namespace independently, i.e. use
                // document.getElementsByTagNameNS("*",...

                DocumentBuilder db = dbf.newDocumentBuilder();

                Document doc = db.parse(xmlByteInputStream);

                Element root = doc.getDocumentElement();

                NodeList ndList;

                // rootNode = document.getDocumentElement();
                // ApplicableSupplyChainTradeSettlement

                // Create XPathFactory object
                XPathFactory xpathFactory = XPathFactory.newInstance();

                // Create XPath object
                XPath xpath = xpathFactory.newXPath();
                XPathExpression expr = xpath.compile(
                        "//*[local-name()=\"GuidelineSpecifiedDocumentContextParameter\"]/*[local-name()=\"ID\"]/text()");
                // evaluate expression result on XML document
                ndList = (NodeList) expr.evaluate(doc, XPathConstants.NODESET);

                for (int bookingIndex = 0; bookingIndex < ndList.getLength(); bookingIndex++) {
                    Node booking = ndList.item(bookingIndex);
                    // if there is a attribute in the tag number:value
                    // urn:ferd:CrossIndustryDocument:invoice:1p0:extended
                    // setForeignReference(booking.getTextContent());

                    context.setProfile(booking.getNodeValue());
                }
                boolean isMiniumum = false;
                boolean isBasic = false;
                boolean isBasicWithoutLines = false;
                boolean isEN16931 = false;
                boolean isExtended = false;
                String xsltFilename = null;
                // urn:ferd:CrossIndustryDocument:invoice:1p0:extended,
                // urn:ferd:CrossIndustryDocument:invoice:1p0:comfort,
                // urn:ferd:CrossIndustryDocument:invoice:1p0:basic,

                // urn:cen.eu:en16931:2017
                // urn:cen.eu:en16931:2017:compliant:factur-x.eu:1p0:basic
                if (root.getNodeName().equalsIgnoreCase("rsm:CrossIndustryInvoice")) { // ZUGFeRD 2.0 or Factur-X
                    context.setVersion("2");

                    isMiniumum = context.getProfile().contains("minimum");
                    isBasic = context.getProfile().contains("basic");
                    isBasicWithoutLines = context.getProfile().contains("basicwl");
                    if (isBasicWithoutLines) {
                        isBasic = false;// basicwl also contains the string basic...
                    }
                    isEN16931 = matchesURI(context.getProfile(), "urn:cen.eu:en16931:2017:compliant:factur-x.eu:1p0:en16931")
                            || matchesURI(context.getProfile(), "urn:cen.eu:en16931:2017");

                    isExtended = context.getProfile().contains("extended");
                    if (isExtended) {
                        isEN16931 = false;// the uri for extended is urn:cen.eu:en16931:2017#conformant#urn:zugferd.de:2p0:extended and thus contains en16931...
                    }
                    if (isMiniumum) {
                        LOGGER.debug("is Minimum");
                        validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), "zf2/MINIMUM/FACTUR-X_MINIMUM.xsd", 18, EPart.fx);
                        xsltFilename = "/xslt/zugferd21_minimum.xsl";
                    } else if (isBasicWithoutLines) {
                        LOGGER.debug("is Basic/WL");
                        validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), "zf2/BASIC-WL/FACTUR-X_BASIC-WL.xsd", 18, EPart.fx);
                        xsltFilename = "/xslt/zugferd21_basicwl.xsl";
                    } else if (isBasic) {
                        LOGGER.debug("is Basic");
                        validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), "zf2/BASIC/FACTUR-X_BASIC.xsd", 18, EPart.fx);
                        xsltFilename = "/xslt/zugferd21_basic.xsl";
                    } else if (isEN16931) {
                        LOGGER.debug("is EN16931");
                        validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), "zf2/EN16931/FACTUR-X_EN16931.xsd", 18, EPart.fx);
                        xsltFilename = "/xslt/zugferd21_en16931.xsl";
                    } else if (isExtended) {
                        LOGGER.debug("is EXTENDED");
                        validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), "zf2/EXTENDED/FACTUR-X_EXTENDED.xsd", 18, EPart.fx);
                        xsltFilename = "/xslt/zugferd21_extended.xsl";
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

                } else { // ZUGFeRD 1.0
                    context.setVersion("1");
                    //
                    if ((!matchesURI(context.getProfile(), "urn:ferd:CrossIndustryDocument:invoice:1p0:basic"))
                            && (!matchesURI(context.getProfile(), "urn:ferd:CrossIndustryDocument:invoice:1p0:comfort"))
                            && (!matchesURI(context.getProfile(), "urn:ferd:CrossIndustryDocument:invoice:1p0:extended"))) {
                        context.addResultItem(new ValidationResultItem(ESeverity.error, "Unsupported profile type")
                                .setSection(25).setPart(EPart.fx));
                    }
                    validateSchema(zfXML.getBytes(StandardCharsets.UTF_8), "zf1/ZUGFeRD1p0.xsd", 18, EPart.fx);

                    xsltFilename = "/xslt/ZUGFeRD_1p0.xslt";
                }
                if (context.getVersion().equals("2")) {
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
                } else /** v1 */ {//urn:ferd:invoice:rc:comfort
                    if ((!matchesURI(context.getProfile(), "urn:ferd:CrossIndustryDocument:invoice:1p0:basic"))
                            && (!matchesURI(context.getProfile(), "urn:ferd:CrossIndustryDocument:invoice:1p0:comfort"))
                            && (!matchesURI(context.getProfile(), "urn:ferd:CrossIndustryDocument:invoice:1p0:extended"))) {
                        context.addResultItem(new ValidationResultItem(ESeverity.error, "Unsupported profile type")
                                .setSection(25).setPart(EPart.fx));

                    }
                }

                // main schematron validation
                validateSchematron(zfXML, xsltFilename, 4, ESeverity.error);

                if (context.getVersion().equals("2")
                        && isEN16931) {
                    //additionally validate against CEN
                    validateSchematron(zfXML, "/xslt/cii16931schematron/EN16931-CII-validation.xslt", 24, ESeverity.error);

                    validateXR(zfXML);
                }


            } catch (IrrecoverableValidationError er) {
                throw er;
            } catch (Exception e) {
                ValidationResultItem vri = new ValidationResultItem(ESeverity.exception, e.getMessage()).setSection(22)
                        .setPart(EPart.fx);
                StringWriter sw = new StringWriter();
                PrintWriter pw = new PrintWriter(sw);
                e.printStackTrace(pw);
                vri.setStacktrace(sw.toString());
                context.addResultItem(vri);
            }

        }
        long endTime = Calendar.getInstance().getTimeInMillis();

        context.addCustomXML("<info><version>" + ((context.getVersion() != null) ? context.getVersion() : "invalid")
                + "</version><profile>" + ((context.getProfile() != null) ? context.getProfile() : "invalid") +
                "</profile><validator version=\"" + Main.class.getPackage().getImplementationVersion() + "\"></validator><rules><fired>" + firedRules + "</fired><failed>" + failedRules + "</failed></rules>" + "<duration unit='ms'>" + (endTime - startXMLTime) + "</duration></info>");

    }

    protected String getXRValidationResult(String xml) {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        TransformerFactory factory = TransformerFactory.newInstance();

        try {
            // Use the factory to create a template containing the xsl file
            Templates template = factory.newTemplates(new StreamSource(
                    this.getClass().getResourceAsStream("/xslt/XRechnung-CII-validation.xsl")));

            // Use the template to create a transformer
            Transformer xformer = template.newTransformer();

            // Prepare the input and output files

            Source source = new StreamSource(new ByteArrayInputStream(xml.getBytes()));
            Result result = new StreamResult(baos);

            // Apply the xsl file to the source file and write the result
            // to the output file
            xformer.transform(source, result);

        } catch (Exception ex) {
            LOGGER.error(ex.getMessage(), ex);
        }
        return baos.toString();

    }

    public void validateXR(String xml) throws IrrecoverableValidationError {

/*
        DocumentBuilderFactory docbfactory = DocumentBuilderFactory.newInstance();
        try {
            DocumentBuilder builder = docbfactory.newDocumentBuilder();
            InputSource is = new InputSource(new StringReader(getXRValidationResult(xml)));
            Document docXMP = builder.parse(is);

            XPathFactory xpathFactory = XPathFactory.newInstance();

            // Create XPath object XPath xpath = xpathFactory.newXPath(); XPathExpression

            XPath xpath = xpathFactory.newXPath();
            // xpath.compile("//*[local-name()=\"GuidelineSpecifiedDocumentContextParameter\"]/[local-name()=\"ID\"]");
            // evaluate expression result on XML document ndList = (NodeList)

            // get the first element
            XPathExpression xpr = xpath.compile(
                    "//*[local-name()=\"failed-assert\"]");
            NodeList nodes = (NodeList) xpr.evaluate(docXMP, XPathConstants.NODESET);
            for (int nodeIndex = 0; nodeIndex < nodes.getLength(); nodeIndex++) {
                String loc=nodes.item(nodeIndex).getAttributes().getNamedItem("location").getTextContent();
                NodeList failedSubNodes=nodes.item(nodeIndex).getChildNodes();
                for (int failedSubNodeIndex = 0; failedSubNodeIndex < nodes.getLength(); failedSubNodeIndex++) {

                    if (failedSubNodes.item(failedSubNodeIndex).getNodeName().equals("svrl:text")) {
                        context.addResultItem(
                                new ValidationResultItem(ESeverity.warning, failedSubNodes.item(failedSubNodeIndex).getTextContent())
                                        .setLocation(loc).setSection(27).setPart(EPart.xr));

                    }
                }


            }
        } catch (Exception ex) {
            LOGGER.error(ex.getMessage(), ex);

        }
*/

        validateSchematron(xml, "/xslt/XRechnung-CII-validation.xslt",27, ESeverity.notice);

    }


    public void validateSchematron(String xml, String xsltFilename, int section, ESeverity severity) throws IrrecoverableValidationError {
        ISchematronResource aResSCH = null;
        aResSCH = SchematronResourceXSLT.fromClassPath(xsltFilename);
        if (aResSCH != null) {
            if (!aResSCH.isValidSchematron()) {
                throw new IllegalArgumentException(xsltFilename + " is invalid Schematron!");
            }

            SchematronOutputType sout;
            try {
                sout = aResSCH
                        .applySchematronValidationToSVRL(new StreamSource(new StringReader(xml)));
            } catch (Exception e) {
                throw new IrrecoverableValidationError(e.getMessage());
            }

            List<Object> failedAsserts = sout.getActivePatternAndFiredRuleAndFailedAssert();
            if (failedAsserts.size() > 0) {
                for (Object object : failedAsserts) {
                    if (object instanceof FailedAssert) {

                        FailedAssert failedAssert = (FailedAssert) object;
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
