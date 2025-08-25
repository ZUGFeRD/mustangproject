package org.mustangproject.ZUGFeRD;

import org.junit.jupiter.api.Test;

import java.util.stream.Stream;

import static org.assertj.core.api.Assertions.assertThat;


/**
 * User: pavel
 * Date: 25.08.25
 * Time: 09:35
 */
class ZUGFeRDInvoiceImporterTest {

	@Test
	void isValidZugferdFilename() {

		var valid = Stream.of(
							  "ZUGFeRD-invoice.xml",
							  "ZUGFeRD_001.xml",
							  "zugferd-invoice.xml",
							  "factur-x.xml",
							  "xrechnung.xml",
							  "order-x.xml",
							  "cida.xml"
						  ).allMatch(ZUGFeRDInvoiceImporter::isValidZugferdFilename);

		assertThat(valid).as("correct xml file names for ZUGFeRD invoice are valid")
						 .isTrue();

		var notValid = Stream.of(
							  "ZUGFeR.xml",
							  "aaa.xml",
							  "rechnung.xml",
							  "order.xml",
							  "da.xml"
						  ).anyMatch(ZUGFeRDInvoiceImporter::isValidZugferdFilename);

		assertThat(notValid).as("incorrect xml file names for ZUGFeRD invoice are invalid")
						 .isFalse();

	}
}
