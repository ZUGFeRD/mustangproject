package org.mustangproject.validator;

import java.io.*;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import javax.xml.bind.annotation.adapters.HexBinaryAdapter;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;

import org.dom4j.DocumentException;
import org.dom4j.DocumentHelper;
import org.dom4j.io.OutputFormat;
import org.dom4j.io.XMLWriter;
import org.mustangproject.XMLTools;
import org.riversun.bigdoc.bin.BigFileSearcher;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.xml.sax.InputSource;
import org.xml.sax.SAXParseException;

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
	protected String logAppend=null;

	/***
	 * within the validation it turned out something in the options was wrong, e.g.
	 * the file did not exist. recommendation to show the help text again. Should be
	 * false if XML or PDF file was found
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
	 * @return
	 */
	public boolean wasCompletelyValid() {
		return wasCompletelyValid;

	}

	/***
	 * performs a validation on the file filename
	 * 
	 * @param filename
	 * @return
	 */
	public String validate(String filename) {
		boolean xmlValidity;
		context.clear();
		StringBuffer finalStringResult = new StringBuffer();
		SimpleDateFormat isoDF = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
		Date date = new Date();
		startTime = Calendar.getInstance().getTimeInMillis();
		try {
			Path path = Paths.get(filename);
			context.setFilename(path.getFileName().toString());// set filename without path

		} catch (NullPointerException ex) {
			// ignore
		}
		finalStringResult
				.append("<validation filename='" + context.getFilename() + "' datetime='" + isoDF.format(date) + "'>");

		try {

			if (filename == null) {
				optionsRecognized = false;
				context.addResultItem(new ValidationResultItem(ESeverity.fatal, "Filename not specified").setSection(10)
						.setPart(EPart.pdf));
			}

			PDFValidator pdfv = new PDFValidator(context);
			File file = new File(filename);
			if (!file.exists()) {
				context.addResultItem(
						new ValidationResultItem(ESeverity.fatal, "File not found").setSection(1).setPart(EPart.pdf));
			} else if (file.length() < 32) {
				// with less then 32 bytes it can not even be a proper XML file
				context.addResultItem(
						new ValidationResultItem(ESeverity.fatal, "File too small").setSection(5).setPart(EPart.pdf));
			} else {
				BigFileSearcher searcher = new BigFileSearcher();
				XMLValidator xv = new XMLValidator(context);
				if (disableNotices) {
					xv.disableNotices();
				}
				byte[] pdfSignature = { '%', 'P', 'D', 'F' };
				boolean isPDF = searcher.indexOf(file, pdfSignature) == 0;
				if (isPDF) {
					pdfv.setFilename(filename);

					optionsRecognized = true;
					try {
						if (!file.exists()) {
							context.addResultItem(
									new ValidationResultItem(ESeverity.exception, "File " + filename + " not found")
											.setSection(1));
						}
					} catch (IrrecoverableValidationError irx) {
						// @todo log
					}

					finalStringResult.append("<pdf>");
					optionsRecognized = true;
					try {
						pdfv.validate();

						sha1Checksum = calcSHA1(file);

						// Validate PDF

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
					} catch (IrrecoverableValidationError irx) {
						// @todo log
					}

					finalStringResult.append("</pdf>\n");

					context.clearCustomXML();
				} else {
					boolean isXML = false;
					try {

					    DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
					    DocumentBuilder db = dbf.newDocumentBuilder();

						byte[] content=Files.readAllBytes(file.toPath());
						content= XMLTools.removeBOM(content);
						String s=new String(content);
						InputSource is = new InputSource(new StringReader(s));
					    Document doc = db.parse(is);
					    
					    Element root = doc.getDocumentElement();
					    isXML=true;//no exception so far
					    	
					}
					catch (Exception ex) {
						// probably no xml file, sth like SAXParseException content not allowed in prolog
						// ignore isXML is already false
						// in the tests, this may error-out anyway
						//ex.printStackTrace();

					}
					if (isXML) {
						pdfValidity = true;
						optionsRecognized = true;
						xv.setFilename(filename);
						if (file.exists()) {
							sha1Checksum = calcSHA1(file);
						}

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
						// @todo log
					}
					finalStringResult.append(xv.getXMLResult());
					finalStringResult.append("</xml>");
					context.clearCustomXML();
				}

				if ((isPDF)&&(!pdfValidity)) {
					context.setInvalid();
				}

			}
		}

		catch (IrrecoverableValidationError irx) {
			// @todo log
		} finally {
			finalStringResult.append(context.getXMLResult());
			finalStringResult.append("</validation>");

		}

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

		String toBeAppended="";
		if (logAppend!=null) {
			toBeAppended=logAppend;
		}



		LOGGER.info("Parsed PDF:" + (pdfValidity ? "valid" : "invalid") + " XML:" + (xmlValidity ? "valid" : "invalid")
				+ " Signature:" + Signature + " Checksum:" + sha1Checksum + " Profile:" + context.getProfile()
				+ " Version:" + context.getVersion() + " Took:" + duration + "ms Errors:["+context.getCSVResult()+"] "+toBeAppended);
		wasCompletelyValid = ((pdfValidity) && (xmlValidity));
		return sw.toString();
	}

	/***
	 * don't report notices in validation report
	 */
	public void disableNotices() {
		disableNotices=true;
	}
	/**
	 * Read the file and calculate the SHA-1 checksum
	 * 
	 * @param file the file to read
	 * @return the hex representation of the SHA-1 using uppercase chars
	 * @throws FileNotFoundException    if the file does not exist, is a directory
	 *                                  rather than a regular file, or for some
	 *                                  other reason cannot be opened for reading
	 * @throws IOException              if an I/O error occurs
	 * @throws NoSuchAlgorithmException should never happen
	 */
	private static String calcSHA1(File file) {
		MessageDigest sha1 = null;
		try {

			sha1 = MessageDigest.getInstance("SHA-1");
			InputStream input = new FileInputStream(file);
			byte[] buffer = new byte[8192];
			int len = input.read(buffer);

			while (len != -1) {
				sha1.update(buffer, 0, len);
				len = input.read(buffer);
			}
			input.close();
		} catch (FileNotFoundException e) {
			LOGGER.error(e.getMessage(), e);
		} catch (IOException e) {
			LOGGER.error(e.getMessage(), e);
		} catch (NoSuchAlgorithmException e) {
			LOGGER.error(e.getMessage(), e);
		}
		if (sha1 == null) {
			return "";
		} else {
			return new HexBinaryAdapter().marshal(sha1.digest());
		}
	}

}
