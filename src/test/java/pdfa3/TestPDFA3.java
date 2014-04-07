package pdfa3;

import org.junit.Test;

import pdfbox.PDFA3File;
import pdfbox.PDFA3FileAttachment;
import pdfbox.PDFAFile;

public class TestPDFA3
{

  @Test
  public void testPDFA3File()
  {
    PDFA3File.main(new String[] { "PDFA3File.pdf", "Messsage" });
  }

  @Test
  public void testPDFA3FileAttachment()
  {
    PDFA3FileAttachment.main(new String[] { "PDFA3FileAttachment.pdf", "Messsage" });
  }

  @Test
  public void testPDFAFile()
  {
    PDFAFile.main(new String[] { "PDFAFile.pdf", "Messsage" });
  }

}
