package org.mustangproject.ZUGFeRD;

import static org.assertj.core.api.Assertions.assertThat;

import java.io.InputStream;
import java.text.ParseException;
import java.util.List;
import javax.xml.xpath.XPathExpressionException;
import org.junit.jupiter.api.Test;
import org.mustangproject.IncludedNote;
import org.mustangproject.Invoice;
import org.mustangproject.SubjectCode;

class ZUGFeRDInvoiceImporterTest {

  @Test
  void testImportIncludedNotes() throws XPathExpressionException, ParseException {
    InputStream inputStream = this.getClass()
        .getResourceAsStream("/EN16931_Einfach.pdf");
    ZUGFeRDInvoiceImporter importer = new ZUGFeRDInvoiceImporter(inputStream);
    Invoice invoice = importer.extractInvoice();
    List<IncludedNote> notesWithSubjectCode = invoice.getNotesWithSubjectCode();
    assertThat(notesWithSubjectCode).hasSize(2);
    assertThat(notesWithSubjectCode.get(0).getSubjectCode()).isNull();
    assertThat(notesWithSubjectCode.get(0).getContent()).isEqualTo("Rechnung gemäß Bestellung vom 01.11.2024.");
    assertThat(notesWithSubjectCode.get(1).getSubjectCode()).isEqualTo(SubjectCode.REG);
    assertThat(notesWithSubjectCode.get(1).getContent()).isEqualTo("Lieferant GmbH\t\t\t\t\n"
        + "Lieferantenstraße 20\t\t\t\t\n"
        + "80333 München\t\t\t\t\n"
        + "Deutschland\t\t\t\t\n"
        + "Geschäftsführer: Hans Muster\n"
        + "Handelsregisternummer: H A 123");

  }

}
