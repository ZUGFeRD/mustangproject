package org.mustangproject.commandline;

import java.io.*;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.concurrent.TimeUnit;

import static org.junit.jupiter.api.Assertions.assertTrue;

import org.junit.jupiter.api.Test;

public class CliIT {

	public static File getResourceAsFile(String resourcePath) {
		try {
			InputStream in = ClassLoader.getSystemClassLoader().getResourceAsStream(resourcePath);
			if (in == null) {
				return null;
			}

			File tempFile = File.createTempFile(String.valueOf(in.hashCode()), ".tmp");
			tempFile.deleteOnExit();

			try (FileOutputStream out = new FileOutputStream(tempFile)) {
				// copy stream
				byte[] buffer = new byte[1024];
				int bytesRead;
				while ((bytesRead = in.read(buffer)) != -1) {
					out.write(buffer, 0, bytesRead);
				}
			}
			return tempFile;
		} catch (IOException e) {
			return null;
		}
	}

	@Test
	public void testCii2Ubl() throws Exception {
		Path output = Paths.get("target/ubl.xml");
		Files.deleteIfExists(output);
		Path jar = Files.newDirectoryStream(Paths.get("target"), "Mustang-CLI-*.jar").iterator().next();
		ProcessBuilder pb = new ProcessBuilder("java", "-jar", jar.toString(),
			"--action", "ubl", "--source", "src/test/resources/cii.xml", "--out",
			output.toString());
		pb.redirectErrorStream(true);
		Process process = pb.start();
		String result = getOutput(process);
		process.waitFor(10, TimeUnit.SECONDS);
		if (!result.isEmpty()) {
			System.out.println(result);
		}
		assertTrue(new String(Files.readAllBytes(output), StandardCharsets.UTF_8).contains("Invoice"));
	}

	private String getOutput(Process process) throws IOException {
		BufferedReader reader = new BufferedReader(new InputStreamReader(process.getInputStream()));
		StringBuilder builder = new StringBuilder();
		String line;
		while ((line = reader.readLine()) != null) {
			builder.append(line);
			builder.append(System.getProperty("line.separator"));
		}
		return builder.toString();
	}

	@Test
	public void testMetric() {
		StatRun sr = new StatRun();
		File tempFile = getResourceAsFile("corrupt-factur-x-waytoosmall.pdf");

		FileChecker fc = new FileChecker(tempFile.getAbsolutePath(), sr);

		fc.checkForZUGFeRD();
		System.out.print(fc.getOutputLine());


	}

}
