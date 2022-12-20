package org.mustangproject.commandline;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.concurrent.TimeUnit;

import static org.junit.jupiter.api.Assertions.assertTrue;
import org.junit.jupiter.api.Test;

public class CliIT {

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

}
