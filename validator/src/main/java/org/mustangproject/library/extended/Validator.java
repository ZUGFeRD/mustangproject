package org.mustangproject.library.extended;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.net.URL;

import javax.xml.XMLConstants;
import javax.xml.transform.Source;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.xml.sax.SAXException;

//abstract class
public abstract class Validator {
	private static final Logger LOGGER = LoggerFactory.getLogger(Validator.class.getCanonicalName()); // log output
	
	protected ValidationContext context;
	
	public Validator(ValidationContext ctx){
		this.context=ctx;
	}
	
	//abstract method
	
	public abstract void setFilename(String filename) throws IrrecoverableValidationError;
	public abstract void validate() throws IrrecoverableValidationError;

	public String getXMLResult() {
		return context.getXMLResult();
	}
	
	/***
	 * validates a schema, which can only be needed in XML validation - and in pdf validation for additional data
	 * @param xmlRawData
	 * @param schemaPath
	 */
	protected void validateSchema(byte[] xmlRawData, String schemaPath,int section, EPart part) throws IrrecoverableValidationError {
		URL schemaFile = ClassLoader.getSystemResource("schema/" + schemaPath);
		Source xmlData = new StreamSource(new ByteArrayInputStream(xmlRawData));
		SchemaFactory schemaFactory = SchemaFactory.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
		try {
			Schema schema = schemaFactory.newSchema(schemaFile);
			javax.xml.validation.Validator validator = schema.newValidator();
			validator.validate(xmlData);
		} catch (SAXException e) {
			context.addResultItem(new ValidationResultItem(ESeverity.error, "schema validation fails:" + e)
					.setSection(section).setPart(part));
		} catch (IOException e) {
			LOGGER.error(e.getMessage(), e);
		}

	}



}
