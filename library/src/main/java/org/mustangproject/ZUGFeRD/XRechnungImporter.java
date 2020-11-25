package org.mustangproject.ZUGFeRD;

import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;

public class XRechnungImporter extends ZUGFeRDImporter {

    public XRechnungImporter(byte[] rawXml) {
	super();

	try {
	    setRawXML(rawXml);
	    containsMeta = true;
	} catch (final IOException e) {
	    Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
	    throw new ZUGFeRDExportException(e);
	}
    }

}
