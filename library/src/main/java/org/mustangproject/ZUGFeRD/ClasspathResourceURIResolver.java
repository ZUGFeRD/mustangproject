package org.mustangproject.ZUGFeRD;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import javax.xml.transform.Source;
import javax.xml.transform.URIResolver;
import javax.xml.transform.stream.StreamSource;
import java.io.InputStream;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.file.InvalidPathException;
import java.util.regex.PatternSyntaxException;

public class ClasspathResourceURIResolver implements URIResolver {
	public static final ClassLoader CLASS_LOADER = ZUGFeRDVisualizer.class.getClassLoader();

	public static final String CUSTOM_BASE_PATH = "stylesheets/";
	public static final String MAIN_BASE_PATH = "xrechnung-3.0.2-xrechnung-visualization-2024-06-20/xsl/";
	public static final String RESOURCE_PATH = "";
	public static final String ZF10_BASE_PATH = "zugferd10-en/Stylesheet/";

	private static final Logger LOGGER = LoggerFactory.getLogger(ClasspathResourceURIResolver.class);

	ClasspathResourceURIResolver() {
		// Do nothing, just prevents synthetic access warning.
	}

	public static Source getSource(final String path) {
		LOGGER.debug("private static Source getSource(final String path='{}')", path);
		Source rv = null;
		if (path != null && !path.isEmpty()) {
			InputStream is = CLASS_LOADER.getResourceAsStream(RESOURCE_PATH + path);
			if (is != null) {
				rv = new StreamSource(is);
			} else {
				LOGGER.error("Cannot get resource '{}'.", path);
			}
		}
		return rv;
	}

	@Override
	public Source resolve(String href, String base) {
		LOGGER.debug("Resolving base='{}', href='{}' ...", base, href);
		Source rv = null;
		if (href != null && !href.isEmpty()) {
			if (!href.endsWith("xrechnung-html.univ.xsl")) {
				rv = getSource(MAIN_BASE_PATH + getLastPathSegment(href));
			} else {
				rv = getSource(CUSTOM_BASE_PATH + href);
			}
		}
		return rv;
	}

	private String getLastPathSegment(final String href) {
		String rv = href;
		if (href.endsWith(".css") || href.endsWith(".js") || href.startsWith("./")) {
			try {
				URI uri = new URI(href);
				rv = getLastItem(uri.getPath(), "/");
			} catch (URISyntaxException | InvalidPathException e) {
				LOGGER.error("Cannot parse URI string '{}'.", href);
			}
		}
		return rv;
	}

	@SuppressWarnings("SameParameterValue")
	private String getLastItem(final String s, final String separator) {
		String rv = s;
		if (s != null && separator != null) {
			try {
				String[] items = s.split(separator);
				if (items.length > 0) {
					rv = items[items.length - 1];
				}
			} catch (PatternSyntaxException e) {
				LOGGER.error("Cannot split string '{}' using separator '{}'.", s, separator);
			}
		}
		return rv;
	}
}
