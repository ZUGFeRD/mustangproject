package org.mustangproject.ZUGFeRD;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Paths;

import org.mustangproject.XMLTools;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class XRechnungImporter extends ZUGFeRDImporter {
  private static final Logger LOGGER = LoggerFactory.getLogger (XRechnungImporter.class);

	public XRechnungImporter(byte[] rawXml) {
		super();

		try {
			setRawXML(rawXml);
			containsMeta = true;
		} catch (final IOException e) {
			LOGGER.error ("Failed to set raw XML", e);
			throw new ZUGFeRDExportException(e);
		}
	}

	public XRechnungImporter(String filename) {
		super();

		try {
			setRawXML(Files.readAllBytes(Paths.get(filename)));
			containsMeta = true;
		} catch (final IOException e) {
      LOGGER.error ("Failed to set raw XML", e);
			throw new ZUGFeRDExportException(e);
		}

	}
	public XRechnungImporter(InputStream fileinput) {
		super();

		try {
			setRawXML(XMLTools.getBytesFromStream(fileinput));
			containsMeta = true;
		} catch (final IOException e) {
      LOGGER.error ("Failed to set raw XML", e);
			throw new ZUGFeRDExportException(e);
		}


	}


}
