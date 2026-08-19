package org.mustangproject.ZUGFeRD;

import java.io.File;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.nio.file.Files;
import java.nio.file.Path;

import org.apache.commons.io.IOUtils;
import org.junit.Ignore;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import junit.framework.TestCase;

@Ignore
public class ResourceCase extends TestCase {
	private static final Logger LOGGER = LoggerFactory.getLogger(ResourceCase.class.getCanonicalName()); // log output is

	public static File getResourceAsFile(String resourcePath) {
		try {
			InputStream in = ClassLoader.getSystemClassLoader().getResourceAsStream(resourcePath);
			if (in == null) {
				return null;
			}

			Path tempPath = Files.createTempFile(String.valueOf(in.hashCode()), ".tmp");
			try (OutputStream out = Files.newOutputStream(tempPath)) {
				// copy stream
				IOUtils.copy(in, out);
			}

			File tempFile = tempPath.toFile();
			tempFile.deleteOnExit();
			return tempFile;
		} catch (IOException e) {
			LOGGER.error(e.getMessage(), e);
			return null;
		}
	}

	public static Path getResourceAsPath(String resourcePath) {
		try {
			InputStream in = ClassLoader.getSystemClassLoader().getResourceAsStream(resourcePath);
			if (in == null) {
				return null;
			}

			Path tempPath = Files.createTempFile(String.valueOf(in.hashCode()), ".tmp");
			try (OutputStream out = Files.newOutputStream(tempPath)) {
				// copy stream
				IOUtils.copy(in, out);
			}

			return tempPath;
		} catch (IOException e) {
			LOGGER.error(e.getMessage(), e);
			return null;
		}
	}
}
