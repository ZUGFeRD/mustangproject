package org.mustangproject.ZUGFeRD;

import org.mustangproject.XMLTools;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;
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

	public XRechnungImporter(String filename) {
		super();

		try {
			setRawXML(Files.readAllBytes(Paths.get(filename)));
			containsMeta = true;
		} catch (final IOException e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			throw new ZUGFeRDExportException(e);
		}

	}
	public XRechnungImporter(InputStream fileinput) {
		super();

		try {
			setRawXML(XMLTools.getBytesFromStream(fileinput));
			containsMeta = true;
		} catch (final IOException e) {
			Logger.getLogger(ZUGFeRDImporter.class.getName()).log(Level.SEVERE, null, e);
			throw new ZUGFeRDExportException(e);
		}


	}


}
