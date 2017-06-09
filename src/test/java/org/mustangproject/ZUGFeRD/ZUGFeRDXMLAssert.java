package org.mustangproject.ZUGFeRD;

import com.helger.schematron.ISchematronResource;
import com.helger.schematron.pure.SchematronResourcePure;
import org.junit.Assert;
import org.mustangproject.ZUGFeRD.model.CrossIndustryDocumentType;
import org.w3c.dom.Document;
import org.w3c.dom.Node;

import javax.xml.bind.JAXBContext;
import javax.xml.bind.JAXBElement;
import javax.xml.parsers.DocumentBuilderFactory;

public class ZUGFeRDXMLAssert {
    private static final ISchematronResource SCHEMATRON = loadSchematron();

    public static void assertValidZugferd(JAXBElement<CrossIndustryDocumentType> xml) throws Exception {
        assertValidZugferd(toDocument(xml));
    }

    public static void assertValidZugferd(Node xml) throws Exception {
        Assert.assertTrue("schema valid", SCHEMATRON.getSchematronValidity(xml).isValid());
    }

    private static Document toDocument(Object jaxbElement) throws Exception {
        final Document result = DocumentBuilderFactory.newInstance().newDocumentBuilder().newDocument();
        JAXBContext.newInstance("org.mustangproject.ZUGFeRD.model").createMarshaller().marshal(jaxbElement, result);
        return result;
    }

    private static SchematronResourcePure loadSchematron() {
        final SchematronResourcePure result = SchematronResourcePure.fromClassPath("/ZUGFeRD_1p0.scmt");
        if (!result.isValidSchematron ()) {
            throw new IllegalArgumentException("Invalid Schematron!");
        }
        return result;
    }
}
