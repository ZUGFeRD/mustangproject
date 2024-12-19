package org.mustangproject.validator;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.Arrays;
import java.util.Calendar;
import java.util.EnumSet;
import java.util.HashMap;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpression;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.mustangproject.util.ByteArraySearcher;
import org.mustangproject.ZUGFeRD.ZUGFeRDImporter;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.verapdf.features.FeatureExtractorConfig;
import org.verapdf.features.FeatureFactory;
import org.verapdf.gf.foundry.VeraGreenfieldFoundryProvider;
import org.verapdf.metadata.fixer.FixerFactory;
import org.verapdf.metadata.fixer.MetadataFixerConfig;
import org.verapdf.pdfa.flavours.PDFAFlavour;
import org.verapdf.pdfa.validation.validators.ValidatorConfig;
import org.verapdf.pdfa.validation.validators.ValidatorFactory;
import org.verapdf.processor.ItemProcessor;
import org.verapdf.processor.ProcessorConfig;
import org.verapdf.processor.ProcessorFactory;
import org.verapdf.processor.ProcessorResult;
import org.verapdf.processor.TaskType;
import org.verapdf.processor.plugins.PluginsCollectionConfig;
import org.verapdf.processor.reports.ItemDetails;
import org.w3c.dom.Document;
import org.w3c.dom.NodeList;
import org.xml.sax.InputSource;
import org.xml.sax.SAXException;

public class PDFValidator extends Validator {

	public PDFValidator(ValidationContext ctx) {
		super(ctx);
	}

	private static final Logger LOGGER = LoggerFactory.getLogger(PDFValidator.class.getCanonicalName()); // log output
	private static final PDFAFlavour[] PDF_A_3_FLAVOURS = {PDFAFlavour.PDFA_3_A, PDFAFlavour.PDFA_3_B, PDFAFlavour.PDFA_3_U};

	private String pdfFilename;

	private byte[] fileContents;

	private String pdfReport;
	private ProcessorResult processorResult = null;

	private String Signature;

	private String zfXML = null;
	protected boolean autoload=true;

	protected static boolean stringArrayContains(String[] arr, String targetValue) {
		return Arrays.asList(arr).contains(targetValue);
	}

	@Override
	public void validate() throws IrrecoverableValidationError {

		zfXML = null;
		// file existence must have been checked before
		if (!ByteArraySearcher.startsWith(fileContents, new byte[]{'%', 'P', 'D', 'F'})) {
			context.addResultItem(
				new ValidationResultItem(ESeverity.fatal, "Not a PDF file " + pdfFilename).setSection(20).setPart(EPart.pdf));

		}

		final long startPDFTime = Calendar.getInstance().getTimeInMillis();

		// Step 1 Validate PDF

		VeraGreenfieldFoundryProvider.initialise();
		// Default validator config
		final ValidatorConfig validatorConfig = ValidatorFactory.defaultConfig();
		// Default features config
		final FeatureExtractorConfig featureConfig = FeatureFactory.defaultConfig();
		// Default plugins config
		final PluginsCollectionConfig pluginsConfig = PluginsCollectionConfig.defaultConfig();
		// Default fixer config
		final MetadataFixerConfig fixerConfig = FixerFactory.defaultConfig();
		// Tasks configuring
		final EnumSet<TaskType> tasks = EnumSet.noneOf(TaskType.class);
		tasks.add(TaskType.VALIDATE);
		// tasks.add(TaskType.EXTRACT_FEATURES);
		// tasks.add(TaskType.FIX_METADATA);
		// Creating processor config
		final ProcessorConfig processorConfig = ProcessorFactory.fromValues(validatorConfig, featureConfig, pluginsConfig,
			fixerConfig, tasks
		);
		// Creating processor and output stream.
		final InputStream inputStream = new ByteArrayInputStream(fileContents);
		try (ItemProcessor processor = ProcessorFactory.createProcessor(processorConfig)) {
			// Generating list of files for processing
			// starting the processor
			ItemDetails itemDetails = ItemDetails.fromValues(pdfFilename);
			inputStream.mark(Integer.MAX_VALUE);
			processorResult = processor.process(itemDetails, inputStream);
			pdfReport = processorResult.getValidationResult().toString().replaceAll(
				"<\\?xml version=\"1\\.0\" encoding=\"utf-8\"\\?>",
				""
			);
			inputStream.reset();
		} catch (final Exception excep) {
			context.addResultItem(new ValidationResultItem(ESeverity.exception, excep.getMessage()).setSection(7)
				.setPart(EPart.pdf).setStacktrace(excep.getStackTrace().toString()));
		}

		// step 2 validate XMP
		final ZUGFeRDImporter zi = new ZUGFeRDImporter();
		zi.doIgnoreCalculationErrors();//of course the calculation will still be schematron checked
		zi.setInputStream(inputStream);
		final String xmp = zi.getXMP();

		final DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
		final Document docXMP;

		if (xmp == null || xmp.length() == 0) {
			context.addResultItem(new ValidationResultItem(ESeverity.error, "Invalid XMP Metadata not found")
				.setSection(17).setPart(EPart.pdf));
		}
		else
		/*
		 * checking for sth like <zf:ConformanceLevel>EXTENDED</zf:ConformanceLevel>
		 * <zf:DocumentType>INVOICE</zf:DocumentType>
		 * <zf:DocumentFileName>ZUGFeRD-invoice.xml</zf:DocumentFileName>
		 * <zf:Version>1.0</zf:Version>
		 */
		try {
			final DocumentBuilder builder = factory.newDocumentBuilder();
			final InputSource is = new InputSource(new StringReader(xmp));
			docXMP = builder.parse(is);

			final XPathFactory xpathFactory = XPathFactory.newInstance();

			// Create XPath object XPath xpath = xpathFactory.newXPath(); XPathExpression

			final XPath xpath = xpathFactory.newXPath();
			// xpath.compile("//*[local-name()=\"GuidelineSpecifiedDocumentContextParameter\"]/[local-name()=\"ID\"]");
			// evaluate expression result on XML document ndList = (NodeList)

			// get the first element
			XPathExpression xpr = xpath.compile(
				"//*[local-name()=\"ConformanceLevel\"]|//*[local-name()=\"Description\"]/@ConformanceLevel");
			NodeList nodes = (NodeList) xpr.evaluate(docXMP, XPathConstants.NODESET);

			if (nodes.getLength() == 0) {
				context.addResultItem(
					new ValidationResultItem(ESeverity.error, "XMP Metadata: ConformanceLevel not found")
						.setSection(11).setPart(EPart.pdf));
			}

			boolean conformanceLevelValid = false;
			for (int i = 0; i < nodes.getLength(); i++) {

				final String[] valueArray = {"BASIC WL", "BASIC", "MINIMUM", "EN 16931", "COMFORT", "CIUS", "EXTENDED", "XRECHNUNG"};
				if (stringArrayContains(valueArray, nodes.item(i).getTextContent())) {
					conformanceLevelValid = true;
				}
			}
			if (!conformanceLevelValid) {
				context.addResultItem(new ValidationResultItem(
					ESeverity.error,
					"XMP Metadata: ConformanceLevel contains invalid value"
				).setSection(12).setPart(EPart.pdf));

			}
			xpr = xpath.compile("//*[local-name()=\"DocumentType\"]|//*[local-name()=\"Description\"]/@DocumentType");
			nodes = (NodeList) xpr.evaluate(docXMP, XPathConstants.NODESET);

			if (nodes.getLength() == 0) {
				context.addResultItem(new ValidationResultItem(ESeverity.error, "XMP Metadata: DocumentType not found")
					.setSection(13).setPart(EPart.pdf));
			}

			boolean documentTypeValid = false;
			for (int i = 0; i < nodes.getLength(); i++) {
				if (nodes.item(i).getTextContent().equals("INVOICE") || nodes.item(i).getTextContent().equals("ORDER")
					|| nodes.item(i).getTextContent().equals("ORDER_RESPONSE") || nodes.item(i).getTextContent()
					.equals("ORDER_CHANGE")) {
					documentTypeValid = true;
				}
			}
			if (!documentTypeValid) {
				context.addResultItem(
					new ValidationResultItem(ESeverity.error, "XMP Metadata: DocumentType invalid")
						.setSection(14).setPart(EPart.pdf));

			}
			xpr = xpath.compile(
				"//*[local-name()=\"DocumentFileName\"]|//*[local-name()=\"Description\"]/@DocumentFileName");
			nodes = (NodeList) xpr.evaluate(docXMP, XPathConstants.NODESET);

			if (nodes.getLength() == 0) {
				context.addResultItem(
					new ValidationResultItem(ESeverity.error, "XMP Metadata: DocumentFileName not found")
						.setSection(21).setPart(EPart.pdf));
			}
			boolean documentFilenameValid = false;
			for (int i = 0; i < nodes.getLength(); i++) {
				final String[] valueArray = {"factur-x.xml", "ZUGFeRD-invoice.xml", "zugferd-invoice.xml", "xrechnung.xml", "order-x.xml"};
				if (stringArrayContains(valueArray, nodes.item(i).getTextContent())) {
					documentFilenameValid = true;
				}

				// e.g. ZUGFeRD-invoice.xml
			}
			if (!documentFilenameValid) {

				context.addResultItem(new ValidationResultItem(
					ESeverity.error,
					"XMP Metadata: DocumentFileName contains invalid value"
				).setSection(19).setPart(EPart.pdf));
			}
			xpr = xpath.compile("//*[local-name()=\"Version\"]|//*[local-name()=\"Description\"]/@Version");
			nodes = (NodeList) xpr.evaluate(docXMP, XPathConstants.NODESET);

			// get all child nodes
			// NodeList nodes = element.getChildNodes();
			// expr.evaluate(docXMP, XPathConstants.NODESET);
			// print the text content of each child
			if (nodes.getLength() == 0) {
				context.addResultItem(new ValidationResultItem(ESeverity.error, "XMP Metadata: Version not found")
					.setSection(15).setPart(EPart.pdf));
			}

			boolean versionValid = false;
			for (int i = 0; i < nodes.getLength(); i++) {
				final String[] valueArray = {"1.0", "1p0", "2p0", "1.2", "2.0", "2.1", "2.2", "2.3", "3.0"}; //1.2, 2.0, 2.1, 2.2, 2.3 and 3.0 are for xrechnung 1.2, 2p0 can be ZF 2.0, 2.1, 2.1.1

				if (stringArrayContains(valueArray, nodes.item(i).getTextContent())) {
					versionValid = true;
				} // e.g. 1.0
			}
			if (!versionValid) {
				context.addResultItem(
					new ValidationResultItem(ESeverity.error, "XMP Metadata: Version contains invalid value")
						.setSection(16).setPart(EPart.pdf));

			}
		} catch (final SAXException | IOException | ParserConfigurationException | XPathExpressionException e) {
			LOGGER.error(e.getMessage(), e);
		}
		zfXML = zi.getUTF8();

		// step 3 find signatures
		final byte[] symtraxSignature = "Symtrax".getBytes(StandardCharsets.UTF_8);
		final byte[] mustangSignature = "via mustangproject".getBytes(StandardCharsets.UTF_8);
		final byte[] facturxpythonSignature = "by Alexis de Lattre".getBytes(StandardCharsets.UTF_8);
		final byte[] intarsysSignature = "intarsys ".getBytes(StandardCharsets.UTF_8);
		final byte[] konikSignature = "Konik".getBytes(StandardCharsets.UTF_8);
		final byte[] pdfMachineSignature = "pdfMachine from Broadgun Software".getBytes(StandardCharsets.UTF_8);
		final byte[] ghostscriptSignature = "%%Invocation:".getBytes(StandardCharsets.UTF_8);
		final byte[] cibpdfbrewerSignature = "CIB pdf brewer".getBytes(StandardCharsets.UTF_8);
		final byte[] lexofficeSignature = "lexoffice".getBytes(StandardCharsets.UTF_8);

		if (ByteArraySearcher.contains(fileContents, symtraxSignature)) {
			Signature = "Symtrax";
		} else if (ByteArraySearcher.contains(fileContents, mustangSignature)) {
			Signature = "Mustang";
		} else if (ByteArraySearcher.contains(fileContents, facturxpythonSignature)) {
			Signature = "Factur/X Python";
		} else if (ByteArraySearcher.contains(fileContents, intarsysSignature)) {
			Signature = "Intarsys";
		} else if (ByteArraySearcher.contains(fileContents, konikSignature)) {
			Signature = "Konik";
		} else if (ByteArraySearcher.contains(fileContents, pdfMachineSignature)) {
			Signature = "pdfMachine";
		} else if (ByteArraySearcher.contains(fileContents, ghostscriptSignature)) {
			Signature = "Ghostscript";
		} else if (ByteArraySearcher.contains(fileContents, cibpdfbrewerSignature)) {
			Signature = "CIB pdf brewer";
		} else if (ByteArraySearcher.contains(fileContents, lexofficeSignature)) {
			Signature = "Lexware office";
		}

		context.setSignature(Signature);

		// step 4:validate additional data
		final HashMap<String, byte[]> additionalData = zi.getAdditionalData();
		for (final String filename : additionalData.keySet()) {
			// validating xml in byte[]	additionalData.get(filename)
			LOGGER.info("validating additionalData " + filename);
			validateSchema(additionalData.get(filename), "ad/basic/additional_data_base_schema.xsd", 2, EPart.pdf);
		}


		//end

		final long endTime = Calendar.getInstance().getTimeInMillis();
		if (!processorResult.getValidationResult().isCompliant()) {
			context.setInvalid();
		}

		PDFAFlavour pdfaFlavourFromValidationResult = processorResult.getValidationResult().getPDFAFlavour();
		if (Arrays.stream(PDF_A_3_FLAVOURS)
			.noneMatch(pdfaFlavourFromValidationResult::equals)) {
			context.addResultItem(
				new ValidationResultItem(ESeverity.error, "Not a PDF/A-3").setSection(23).setPart(EPart.pdf));

		}
		context.addCustomXML(pdfReport + "<info><signature>"
			+ ((context.getSignature() != null) ? context.getSignature() : "unknown")
			+ "</signature><duration unit=\"ms\">" + (endTime - startPDFTime) + "</duration></info>");

	}


	@Override
	public void setFilename(String filename) throws IrrecoverableValidationError {
		this.pdfFilename = filename;
		if(autoload) {
			try {
				fileContents=Files.readAllBytes(Paths.get(pdfFilename));
			} catch (IOException ex) {
				throw new IrrecoverableValidationError("Could not read file");
			}
		}
	}

  public void setFileContents(byte[] fileContents) {
    this.fileContents = fileContents;
  }

  public void setFilenameAndContents(String filename, byte[] fileContents) {
    this.pdfFilename = filename;
    this.fileContents = fileContents;
  }

	public String getRawXML() {
		return zfXML;

	}

	public String getSignature() {
		return Signature;
	}

}
