package org.mustangproject.ZUGFeRD;

import junit.framework.TestCase;
import org.mustangproject.SubjectCode;

import java.io.File;
import java.nio.file.Files;
import java.nio.charset.StandardCharsets;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Set;
import java.util.TreeSet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Collectors;

/**
 * Asserts that {@link SubjectCode} contains exactly the same set of codes that the bundled
 * EN16931 CII validation XSLT enforces for rule BR-CL-08.
 *
 * <p><strong>Architectural Decision Note:</strong> This test reads the XSLT file from the
 * {@code validator} module via a relative file path. This was an active decision to keep this 
 * code-list conformance test in the {@code library} module's normal tests, rather than muddying 
 * the {@code validator} module with a test that only depends on the order of operations and is 
 * conceptually a library concern.
 *
 * <p>If the XSLT is updated, this test will fail if {@link SubjectCode} has drifted, making
 * the discrepancy immediately visible.
 */
public class SubjectCodeListSyncTest extends TestCase {

    private static final String XSLT_FILE_PATH = "../validator/src/main/resources/xslt/en16931schematron/EN16931-CII-validation.xslt";

    /**
     * Extracts the BR-CL-08 token list from the XSLT by finding the template that matches
     * {@code ram:SubjectCode} and then parsing the {@code contains(' ... ')} expression in it.
     */
    public void testSubjectCodeEnumMatchesBrCl08() throws Exception {
        File xsltFile = new File(XSLT_FILE_PATH);
        // Fallback for IDEs running from the project root instead of the library module root
        if (!xsltFile.exists()) {
            xsltFile = new File("validator/src/main/resources/xslt/en16931schematron/EN16931-CII-validation.xslt");
        }
        
        assertTrue("Could not find XSLT file at " + xsltFile.getAbsolutePath(), xsltFile.exists());
        
        String xslt = new String(Files.readAllBytes(xsltFile.toPath()), StandardCharsets.UTF_8);

        // Locate the ram:SubjectCode template block
        int templateIdx = xslt.indexOf("match=\"ram:SubjectCode\"");
        assertTrue("Could not find ram:SubjectCode template in XSLT", templateIdx >= 0);

        // Within that block, find the contains(' AAA ... ZZZ ') token list
        int afterTemplate = xslt.indexOf("contains('", templateIdx);
        assertTrue("Could not find contains(' ... ') expression after ram:SubjectCode template", afterTemplate >= 0);

        Pattern tokenListPattern = Pattern.compile("contains\\('\\s+([^']+?)\\s+',");
        Matcher m = tokenListPattern.matcher(xslt.substring(afterTemplate, afterTemplate + 50000));
        assertTrue("Could not parse token list from BR-CL-08 rule", m.find());

        String tokenString = m.group(1).trim();
        Set<String> normativeCodes = new HashSet<>(Arrays.asList(tokenString.split("\\s+")));

        Set<String> enumCodes = Arrays.stream(SubjectCode.values())
            .map(Enum::name)
            .collect(Collectors.toSet());

        Set<String> inEnumNotNormative = new TreeSet<>(enumCodes);
        inEnumNotNormative.removeAll(normativeCodes);

        Set<String> inNormativeNotEnum = new TreeSet<>(normativeCodes);
        inNormativeNotEnum.removeAll(enumCodes);

        assertTrue(
            "SubjectCode enum contains codes NOT in the normative BR-CL-08 list (would cause validation failures): "
                + inEnumNotNormative,
            inEnumNotNormative.isEmpty()
        );
        assertTrue(
            "SubjectCode enum is MISSING codes from the normative BR-CL-08 list (BT-21 cannot use these codes): "
                + inNormativeNotEnum,
            inNormativeNotEnum.isEmpty()
        );
    }
}
