/** **********************************************************************
 *
 * Use is subject to license terms.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy
 * of the License at http://www.apache.org/licenses/LICENSE-2.0.
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 *********************************************************************** */
package org.mustangproject.ZUGFeRD;

import java.io.*;
import java.net.URI;
import java.net.URISyntaxException;
import java.nio.charset.Charset;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.logging.Level;
import java.util.logging.Logger;


/**
 * This test utility class is providing usability functions to test file resources
 */
public class ResourceUtilities {
	private static final Logger LOG = Logger.getLogger(ResourceUtilities.class.getName());

	/**
	 * Loading a File into a String using a certain encoding and file path
	 * @param encoding the charset used in the file
	 * @param path the path to the file
	 * @return the file contents as a String
	 * @throws IOException if the file cannot be read
	 */
	public static String readFile(Charset encoding, String path) throws IOException {
		byte[] content = Files.readAllBytes(Paths.get(path));
		return new String(content, encoding);
	}

	/**
	 * Saving a String as a file to a certain file path
	 * @param encoding the charset used in the file
	 * @param path the path to the file
	 * @param content the contents of the file
	 * @throws FileNotFoundException if the file cannot be found
	 */
	public static void saveFile(Charset encoding, String path, String content) throws FileNotFoundException {

		// resources will be released automatically
		try (PrintWriter out = new PrintWriter(new OutputStreamWriter(new FileOutputStream(new File(path)), encoding), true)) {
			out.println(content);
		}
	}


	/**
	 * The relative path of the test file will be resolved and the absolute will be returned
	 *
	 * @param relativeFilePath Path of the test resource relative to <code>src/test/resource/</code>.
	 * @return the absolute path of the test file
	 * @throws FileNotFoundException If the file could not be found
	 */
	public static String getAbsolutePath(String relativeFilePath) throws FileNotFoundException {
		URI uri = null;
		try {
			uri = ResourceUtilities.class.getClassLoader().getResource(relativeFilePath).toURI();
			uri = new URI(toExternalForm(uri));
		} catch (URISyntaxException ex) {
			LOG.log(Level.SEVERE, null, ex);
		}
		if (uri == null) {
			throw new FileNotFoundException("Could not find the file '" + relativeFilePath + "'!");
		}
		return uri.getPath();
	}

	/**
	 * The relative path of the test file will be resolved and the absolute will be returned
	 *
	 * @param relativeFilePath Path of the test resource relative to <code>src/test/resource/</code>.
	 * @return the URI created based on the relativeFilePath
	 * @throws URISyntaxException if no URI could be created from the given relative path
	 */
	public static URI getURI(String relativeFilePath) throws URISyntaxException {
		String filePath = "file:" + ResourceUtilities.class.getClassLoader().getResource(relativeFilePath).getPath();
		filePath = toExternalForm(new URI(filePath));
		return new URI(filePath);
	}

	/**
	 * The relative path of the test file will be used to determine an absolute
	 * path to a temporary directory in the output directory.
	 *
	 * @param relativeFilePath Path of the test resource relative to <code>src/test/resource/</code>.
	 * @return absolute path to a test output
	 * @throws IOException if no absolute Path could be created.
	 */
	public static String getTestOutput(String relativeFilePath) throws IOException {
		File tempFile = File.createTempFile(relativeFilePath, null);
		tempFile.deleteOnExit();
		return tempFile.getAbsolutePath();
	}

	/**
	 * The Input of the test file will be resolved and the absolute will be returned
	 *
	 * @param relativeFilePath Path of the test resource relative to <code>src/test/resource/</code>.
	 * @return the absolute path of the test file
	 */
	public static InputStream getTestResourceAsStream(String relativeFilePath) {
		return ResourceUtilities.class.getClassLoader().getResourceAsStream(relativeFilePath);
	}

	/**
	 * Relative to the test output directory a test file will be returned dependent on the relativeFilePath provided.
	 *
	 * @param relativeFilePath Path of the test output resource relative to <code>target/test-classes/</code>.
	 * @return the empty <code>File</code> of the test output (to be filled)
	 */
	public static File newTestOutputFile(String relativeFilePath) {
		String filepath = null;
		try {
			filepath = ResourceUtilities.class.getClassLoader().getResource("").toURI().getPath() + relativeFilePath;
		} catch (URISyntaxException ex) {
			LOG.log(Level.SEVERE, null, ex);
		}
		return new File(filepath);
	}

	/**
	 * @return the absolute path of the test output folder, which is usually <code>target/test-classes/</code>.
	 */
	public static String getTestOutputFolder() {
		String testFolder = null;
		try {
			testFolder = ResourceUtilities.class.getClassLoader().getResource("").toURI().getPath();
		} catch (URISyntaxException ex) {
			LOG.log(Level.SEVERE, null, ex);
		}
		return testFolder;
	}

	public static File getTempTestDirectory() {
		File tempDir = new File(ResourceUtilities.getTestOutputFolder() + "temp");
		tempDir.mkdir(); //if it already exist no problem
		return tempDir;
	}

	/**
	 * To fix the 3 slashes bug for File URI: For example:
	 * file:/C:/work/test.txt gives file:///C:/work/test.txt
	 *
	 * @param u - the File URI
	 * @return the String of the URI
	 */
	public static String toExternalForm(URI u) {
		StringBuilder sb = new StringBuilder();
		if (u.getScheme() != null) {
			sb.append(u.getScheme());
			sb.append(':');
		}
		if (u.isOpaque()) {
			sb.append(u.getSchemeSpecificPart());
		} else {
			if (u.getHost() != null) {
				sb.append("//");
				if (u.getUserInfo() != null) {
					sb.append(u.getUserInfo());
					sb.append('@');
				}
				boolean needBrackets = ((u.getHost().indexOf(':') >= 0) && !u.getHost().startsWith("[") && !u.getHost().endsWith("]"));
				if (needBrackets)
					sb.append('[');
				sb.append(u.getHost());
				if (needBrackets)
					sb.append(']');
				if (u.getPort() != -1) {
					sb.append(':');
					sb.append(u.getPort());
				}
			} else if (u.getRawAuthority() != null) {
				sb.append("//");
				sb.append(u.getRawAuthority());
			} else {
				sb.append("//");
			}
			if (u.getRawPath() != null)
				sb.append(u.getRawPath());
			if (u.getRawQuery() != null) {
				sb.append('?');
				sb.append(u.getRawQuery());
			}
		}
		if (u.getFragment() != null) {
			sb.append('#');
			sb.append(u.getFragment());
		}
		String ret = null;
		try {
			ret = new URI(sb.toString()).toASCIIString();
		} catch (URISyntaxException ex) {
			LOG.log(Level.SEVERE, null, ex);
		}
		return ret;
	}

	private ResourceUtilities() {
	}
}
