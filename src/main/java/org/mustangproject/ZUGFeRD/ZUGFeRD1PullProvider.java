package org.mustangproject.ZUGFeRD;

import java.io.ByteArrayOutputStream;
import java.io.IOException;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.bind.JAXBException;
import javax.xml.bind.Marshaller;

import org.mustangproject.ZUGFeRD.model.CrossIndustryDocumentType;

public class ZUGFeRD1PullProvider implements IXMLProvider {
	

	protected byte[] zugferdData;
	private Marshaller marshaller;

	private boolean isTest;

	

	/**
	 * enables the flag to indicate a test invoice in the XML structure
	 *
	 */
	public void setTest() {
		isTest = true;
	}
	public ZUGFeRD1PullProvider() {
		// TODO Auto-generated constructor stub
		try {
			marshaller = JAXBContext.newInstance("org.mustangproject.ZUGFeRD.model").createMarshaller();
			marshaller.setProperty(Marshaller.JAXB_FORMATTED_OUTPUT, true);
			marshaller.setProperty(Marshaller.JAXB_ENCODING, "UTF-8");
        } catch (JAXBException e) {
            throw new ZUGFeRDExportException("Could not initialize JAXB", e);
        }

	}

	private String createZugferdXMLForTransaction(IZUGFeRDExportableTransaction trans) {

		JAXBElement<CrossIndustryDocumentType> jaxElement =
			new ZUGFeRDTransactionModelConverter(trans).withTest(isTest).convertToModel();

		try {
			return marshalJaxToXMLString(jaxElement);
		} catch (JAXBException e) {
			throw new ZUGFeRDExportException("Could not marshal ZUGFeRD transaction to XML", e);
		}
	}

	private String marshalJaxToXMLString(Object jaxElement) throws JAXBException {
		ByteArrayOutputStream outputXml = new ByteArrayOutputStream();
		marshaller.marshal(jaxElement, outputXml);
		return outputXml.toString();
	}


	@Override
	public byte[] getXML() {
		return zugferdData;
	}


	@Override
	public void generateXML(IZUGFeRDExportableTransaction trans) {
		  // create a dummy file stream, this would probably normally be a
        // FileInputStream

        byte[] zugferdRaw = createZugferdXMLForTransaction(trans).getBytes(); //$NON-NLS-1$

        if ((zugferdRaw[0] == (byte) 0xEF)
                        && (zugferdRaw[1] == (byte) 0xBB)
                        && (zugferdRaw[2] == (byte) 0xBF)) {
                // I don't like BOMs, lets remove it
                zugferdData = new byte[zugferdRaw.length - 3];
                System.arraycopy(zugferdRaw, 3, zugferdData, 0,
                                zugferdRaw.length - 3);
        } else {
                zugferdData = zugferdRaw;
        }
	}



}
