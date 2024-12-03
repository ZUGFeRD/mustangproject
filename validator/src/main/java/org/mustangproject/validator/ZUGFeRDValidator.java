package org.mustangproject.validator;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.io.InputStream;
import java.io.StringReader;
import java.io.StringWriter;
import java.io.UncheckedIOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.apache.commons.io.IOUtils;
import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.XMLWriter;
import org.mustangproject.util.ByteArraySearcher;
import org.mustangproject.XMLTools;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.InputSource;

import com.helger.commons.io.stream.StreamHelper;

import jakarta.xml.bind.DatatypeConverter;

//abstract class
public class ZUGFeRDValidator {
	private static final Logger LOGGER = LoggerFactory.getLogger(ZUGFeRDValidator.class.getCanonicalName()); // log
	// output
	protected ValidationContext context = new ValidationContext(LOGGER);
	protected String sha1Checksum;
	protected boolean pdfValidity;
	protected boolean displayXMLValidationOutput;
	protected long startTime;
	protected boolean optionsRecognized;
	protected boolean disableNotices = false;
	protected String Signature;
	protected boolean wasCompletelyValid = false;
	protected String logAppend = null;

	/***
	 * within the validation it turned out something in the options was wrong, e.g.
	 * the file did not exist. recommendation to show the help text again. Should be
	 * false if XML or PDF file was found
	 * @return false if any valid option was picked up
	 */
	public boolean hasOptionsError() {
		return !optionsRecognized;

	}

	public void setLogAppend(String tobeappended) {
		logAppend = tobeappended;
	}

	/***
	 * in case the result was not valid the error code of the app will be set to -1
	 *
	 * @return true if both xml and pdf were valid (contained no errors, notices are ignored)
	 */
	public boolean wasCompletelyValid() {
		return wasCompletelyValid;

	}

	private String internalValidate(String contextFilename, InputStream inputStream, long inputLength) {
		context.clear();
		StringBuilder finalStringResult = new StringBuilder();
		SimpleDateFormat isoDF = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = new Date();
		startTime = Calendar.getInstance().getTimeInMillis();
		context.setFilename(contextFilename);// fallback to provided name
		finalStringResult.append("<validation filename='").append(contextFilename).append("' datetime='").append(isoDF.format(date)).append("'>");

		boolean isPDF = false;
		byte[] content = null;
		try {

			if (contextFilename == null || contextFilename.isEmpty()) {
				optionsRecognized = false;
				context.addResultItem(new ValidationResultItem(ESeverity.fatal, "Filename not specified").setSection(10)
					.setPart(EPart.pdf));
			}

			PDFValidator pdfv = new PDFValidator(context);
			if (inputStream == null) {
				context.addResultItem(
					new ValidationResultItem(ESeverity.fatal, "File not found").setSection(1).setPart(EPart.pdf));
			} else if (inputLength < 32) {
				// with less than 32 bytes it can not even be a proper XML file
				// Except it is "<?xml version='1.0'?><xml/>" LOL
				context.addResultItem(
					new ValidationResultItem(ESeverity.fatal, "File too small").setSection(5).setPart(EPart.pdf));
			} else if (inputLength >= Integer.MAX_VALUE) {
				// Byte arrays are limited to 2GB in Java
				context.addResultItem(
					new ValidationResultItem(ESeverity.fatal, "File too big").setSection(5).setPart(EPart.pdf));
			} else {
				content = IOUtils.toByteArray(inputStream);
				XMLValidator xv = new XMLValidator(context);
				if (disableNotices) {
					xv.disableNotices();
				}
				isPDF = ByteArraySearcher.startsWith(content, new byte[]{'%', 'P', 'D', 'F'});
				if (isPDF) {
					// Avoid reading again from file
					pdfv.setFilenameAndContents(contextFilename, content);

					optionsRecognized = true;
					finalStringResult.append("<pdf>");
					try {
						pdfv.validate();

						sha1Checksum = calcSHA1(content);

						// Validate PDF

						getPdfValidationResults(finalStringResult, pdfv, xv);
					} catch (IrrecoverableValidationError irx) {
						LOGGER.info(irx.getMessage());
					}

					finalStringResult.append("</pdf>\n");

					context.clearCustomXML();
				} else {
					boolean isXML = false;
					String xmlAsString = null;
					try {
						DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
						DocumentBuilder db = dbf.newDocumentBuilder();

						content = XMLTools.removeBOM(content);
						xmlAsString = new String(content, StandardCharsets.UTF_8);
						InputSource is = new InputSource(new StringReader(xmlAsString));
						Document doc = db.parse(is);

						Element root = doc.getDocumentElement();
						isXML = true;//no exception so far

					} catch (Exception ex) {
						// probably no xml file, sth like SAXParseException content not allowed in prolog
						// ignore isXML is already false
						// in the tests, this may error-out anyway
						LOGGER.info("No XML part provided");
					}
					if (isXML) {
						pdfValidity = true;
						optionsRecognized = true;
						xv.setStringContent(xmlAsString);
						xv.setAutoload(false);
						xv.setFilename(contextFilename);
						sha1Checksum = calcSHA1(content);

						displayXMLValidationOutput = true;

					} else {
						optionsRecognized = false;
						context.addResultItem(new ValidationResultItem(ESeverity.exception,
							"File does not look like PDF nor XML (contains neither %PDF nor <?xml)").setSection(8));

					}
				}
				if ((optionsRecognized) && (displayXMLValidationOutput)) {
					finalStringResult.append("<xml>");
					try {
						xv.validate();
					} catch (IrrecoverableValidationError irx) {
						LOGGER.error("XML validation threw an exception ", irx);
					}
					finalStringResult.append(xv.getXMLResult());
					finalStringResult.append("</xml>");
					context.clearCustomXML();
				}

				if ((isPDF) && (!pdfValidity)) {
					context.setInvalid();
				}

			}
		} catch (IrrecoverableValidationError | IOException irx) {
			LOGGER.info(irx.getMessage());
			context.setInvalid();
		} finally {
			finalStringResult.append(context.getXMLResult());
			finalStringResult.append("</validation>");

		}

		return formatOutput(finalStringResult, isPDF);
	}

	/***
	 * performs a validation on the file filename
	 *
	 * @param filename the complete absolute filename of a PDF or XML
	 * @return a xml string with the validation result
	 */
	public String validate(String filename) {
		String contextFilename;
		InputStream inputStream;
		long inputLength;
		if (filename == null) {
			// No filename provided
			contextFilename = "";
			inputStream = null;
			inputLength = 0;
		} else {
			File file = new File(filename);
			// set filename without path
			contextFilename = file.getName();
			if (file.isFile()) {
				try {
					inputStream = new FileInputStream(file);
					inputLength = Files.size(file.toPath());
				} catch (IOException ex) {
					throw new UncheckedIOException(ex);
				}
			} else {
				// Non-existing or Directory
				inputStream = null;
				inputLength = 0;
			}
		}
		try {
			return internalValidate(contextFilename, inputStream, inputLength);
		} finally {
			StreamHelper.close(inputStream);
		}
	}

	public String validate(InputStream inputStream, String fileNameOfInputStream) {
		long inputLength;
		try {
			inputLength = inputStream == null ? 0 : inputStream.available();
		} catch (IOException ex) {
			throw new UncheckedIOException(ex);
		}
		try {
			return internalValidate(fileNameOfInputStream, inputStream, inputLength);
		} finally {
			StreamHelper.close(inputStream);
		}
	}

	public String validate(byte[] bytes, String fileNameOfInputStream) {
		try (ByteArrayInputStream bais = new ByteArrayInputStream(bytes)) {
			return internalValidate(fileNameOfInputStream, bais, bytes.length);
		} catch (IOException ex) {
			throw new UncheckedIOException(ex);
		}
	}

	private void getPdfValidationResults(StringBuilder finalStringResult, PDFValidator pdfv, XMLValidator xv) throws IrrecoverableValidationError {
		finalStringResult.append(pdfv.getXMLResult());
		pdfValidity = context.isValid();

		Signature = context.getSignature();
		context.clear();// clear sets valid to true again
		if (pdfv.getRawXML() != null) {
			xv.setStringContent(pdfv.getRawXML());
			displayXMLValidationOutput = true;
		} else {
			context.addResultItem(
				new ValidationResultItem(ESeverity.exception, "XML could not be extracted")
					.setSection(17));
		}
	}

	private String formatOutput(StringBuilder finalStringResult, boolean isPDF) {
		boolean xmlValidity;
		OutputFormat format = OutputFormat.createPrettyPrint();
		StringWriter sw = new StringWriter();
		org.dom4j.Document document = null;
		try {
			document = DocumentHelper.parseText(new String(finalStringResult));
		} catch (DocumentException e1) {
			LOGGER.error(e1.getMessage());
		}
		XMLWriter writer = new XMLWriter(sw, format);
		try {
			writer.write(document);
		} catch (Exception e) {
			LOGGER.error(e.getMessage());
		}

		xmlValidity = context.isValid();
		long duration = Calendar.getInstance().getTimeInMillis() - startTime;

		String toBeAppended = "";
		if (logAppend != null) {
			toBeAppended = logAppend;
		}


		String pdfResult = "invalid";
		if (!isPDF) {
			pdfResult = "absent";
		} else if (pdfValidity) {
			pdfResult = "valid";
		}


		LOGGER.info("Parsed PDF:" + pdfResult + " XML:" + (xmlValidity ? "valid" : "invalid")
			+ " Signature:" + Signature + " Checksum:" + sha1Checksum + " Profile:" + context.getProfile()
			+ " Version:" + context.getGeneration() + " Took:" + duration + "ms Errors:[" + context.getCSVResult()
			+ "] ErrorIDs: [" + context.getCSVIDResult()  + "]" + toBeAppended);
		wasCompletelyValid = ((pdfValidity) && (xmlValidity));
		return sw.toString();
	}

	/***
	 * don't report notices in validation report
	 */
	public void disableNotices() {
		disableNotices = true;
	}

	/**
	 * Read the file and calculate the SHA-1 checksum
	 *
	 * @param data the InputStream to read
	 * @return the hex representation of the SHA-1 using uppercase chars
	 * @throws FileNotFoundException    if the file does not exist, is a directory
	 *                                  rather than a regular file, or for some
	 *                                  other reason cannot be opened for reading
	 * @throws IOException              if an I/O error occurs
	 * @throws NoSuchAlgorithmException should never happen
	 */
	private static String calcSHA1(byte[] data) {
		MessageDigest sha1 = null;
		try {

			sha1 = MessageDigest.getInstance("SHA-1");
			sha1.update(data, 0, data.length);
		} catch (NoSuchAlgorithmException e) {
			LOGGER.error(e.getMessage(), e);
		}
		if (sha1 == null) {
			return "";
		} else {
			return DatatypeConverter.printHexBinary(sha1.digest());
		}
	}

}
