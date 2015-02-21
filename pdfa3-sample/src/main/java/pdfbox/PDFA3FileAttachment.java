/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package pdfbox;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.util.Collections;
import java.util.GregorianCalendar;

import javax.xml.transform.TransformerException;

import org.apache.jempbox.xmp.XMPMetadata;
import org.apache.jempbox.xmp.XMPSchemaBasic;
import org.apache.jempbox.xmp.XMPSchemaDublinCore;
import org.apache.jempbox.xmp.XMPSchemaPDF;
import org.apache.jempbox.xmp.pdfa.XMPSchemaPDFAId;
import org.apache.pdfbox.cos.COSDictionary;
import org.apache.pdfbox.pdmodel.PDDocument;
import org.apache.pdfbox.pdmodel.PDDocumentCatalog;
import org.apache.pdfbox.pdmodel.PDDocumentInformation;
import org.apache.pdfbox.pdmodel.PDDocumentNameDictionary;
import org.apache.pdfbox.pdmodel.PDEmbeddedFilesNameTreeNode;
import org.apache.pdfbox.pdmodel.PDPage;
import org.apache.pdfbox.pdmodel.common.PDMetadata;
import org.apache.pdfbox.pdmodel.common.filespecification.PDComplexFileSpecification;
import org.apache.pdfbox.pdmodel.common.filespecification.PDEmbeddedFile;
import org.apache.pdfbox.pdmodel.documentinterchange.logicalstructure.PDMarkInfo;
import org.apache.pdfbox.pdmodel.edit.PDPageContentStream;
import org.apache.pdfbox.pdmodel.font.PDFont;
import org.apache.pdfbox.pdmodel.font.PDTrueTypeFont;
import org.apache.pdfbox.pdmodel.graphics.color.PDOutputIntent;

/**
 * This is an example that creates a simple PDF/A document.
 */
public class PDFA3FileAttachment
{
  /**
   * Constructor.
   */
  public PDFA3FileAttachment()
  {
    super();
  }

  private void attachSampleFile(PDDocument doc) throws IOException
  {
    PDEmbeddedFilesNameTreeNode efTree = new PDEmbeddedFilesNameTreeNode();

    // first create the file specification, which holds the embedded file

    PDComplexFileSpecification fs = new PDComplexFileSpecification();
    fs.setFile("Test.txt");
    COSDictionary dict = fs.getCOSDictionary();
    // Relation "Source" for linking with eg. catalog
    dict.setName("AFRelationship", "Alternative");
    // dict.setName("AFRelationship", "Source");

    dict.setString("UF", "Test.txt");
    // fs.put(new PdfName("AFRelationship"), new PdfName("Source"));

    String payload = "This is a test";

    InputStream is = new ByteArrayInputStream(payload.getBytes());

    PDEmbeddedFile ef = new PDEmbeddedFile(doc, is);
    // set some of the attributes of the embedded file

    ef.setSubtype("text/plain");
    // ef.setFile(fs);
    // ef.getStream().setItem(COSName.UF, fs);

    ef.setModDate(GregorianCalendar.getInstance());

    // PdfFileSpecification fs = PdfFileSpecification.fileEmbedded(writer,
    // src.getAbsolutePath(), src.getName(), null, false, "image/jpeg",
    // fileParameter);

    // fs.put(new PdfName("AFRelationship"), new PdfName("Source"));

    ef.setSize(payload.length());
    ef.setCreationDate(new GregorianCalendar());
    fs.setEmbeddedFile(ef);

    // now add the entry to the embedded file tree and set in the document.
    efTree.setNames(Collections.singletonMap("My first attachment", fs));

    /**
     * Validating file "RE-20131206_22.pdf" for conformance level pdfa-3a The
     * key UF is required but missing. The key AFRelationship is required but
     * missing. File specification 'Test.txt' not associated with an object.
     */
    // attachments are stored as part of the "names" dictionary in the document
    // catalog
    PDDocumentCatalog catalog = doc.getDocumentCatalog();

    PDDocumentNameDictionary names = new PDDocumentNameDictionary(doc.getDocumentCatalog());
    names.setEmbeddedFiles(efTree);
    catalog.setNames(names);

    // // AF entry (Array) in catalog with the FileSpec
    // PDAcroForm pdAcroForm = new PDAcroForm(doc);
    // COSArray cosArray = new COSArray();
    // cosArray.add(fs);
    // catalog.setItem("AF", cosArray);

  }

  /**
   * Create a simple PDF/A-3 document.
   * This example is based on HelloWorld example.
   * As it is a simple case, to conform the PDF/A norm, are added : - the font
   * used in the document - the sRGB color profile - a light xmp block with only
   * PDF identification schema (the only mandatory) - an output intent To
   * conform to A/3 - the mandatory MarkInfo dictionary displays tagged PDF
   * support - and optional producer and - optional creator info is added
   * 
   * @param file
   *          The file to write the PDF to.
   * @param message
   *          The message to write in the file.
   * @throws Exception
   *           If something bad occurs
   */
  public void doIt(String file, String message) throws Exception
  {
    // the document
    PDDocument doc = null;
    try
    {
      doc = new PDDocument();

      // now create the page and add content
      PDPage page = new PDPage();

      doc.addPage(page);

      InputStream fontStream = PDFA3FileAttachment.class.getResourceAsStream("/Ubuntu-R.ttf");
      PDFont font = PDTrueTypeFont.loadTTF(doc, fontStream);

      // create a page with the message where needed
      PDPageContentStream contentStream = new PDPageContentStream(doc, page);
      contentStream.beginText();
      contentStream.setFont(font, 12);
      contentStream.moveTextPositionByAmount(100, 700);
      contentStream.drawString(message);
      contentStream.endText();
      contentStream.saveGraphicsState();
      contentStream.close();

      PDDocumentCatalog cat = makeA3compliant(doc);
      attachSampleFile(doc);

      InputStream colorProfile = PDFA3FileAttachment.class.getResourceAsStream("/sRGB Color Space Profile.icm");
      // create output intent
      PDOutputIntent oi = new PDOutputIntent(doc, colorProfile);
      oi.setInfo("sRGB IEC61966-2.1");
      oi.setOutputCondition("sRGB IEC61966-2.1");
      oi.setOutputConditionIdentifier("sRGB IEC61966-2.1");
      oi.setRegistryName("http://www.color.org");
      cat.addOutputIntent(oi);

      doc.save(file);

    }
    finally
    {
      if (doc != null)
      {
        doc.close();
      }
    }
  }

  /**
   * Makes A PDF/A3a-compliant document from a PDF-A1 compliant document (on the
   * metadata level, this will not e.g. convert graphics to JPG-2000)
   */
  private PDDocumentCatalog makeA3compliant(PDDocument doc) throws IOException, TransformerException
  {
    PDDocumentCatalog cat = doc.getDocumentCatalog();
    PDMetadata metadata = new PDMetadata(doc);
    cat.setMetadata(metadata);
    // jempbox version
    XMPMetadata xmp = new XMPMetadata();
    XMPSchemaPDFAId pdfaid = new XMPSchemaPDFAId(xmp);
    xmp.addSchema(pdfaid);

    XMPSchemaDublinCore dc = xmp.addDublinCoreSchema();
    String creator = System.getProperty("user.name");
    String producer = "PDFBOX";
    dc.addCreator(creator);
    dc.setAbout("");

    XMPSchemaBasic xsb = xmp.addBasicSchema();
    xsb.setAbout("");

    xsb.setCreatorTool(creator);
    xsb.setCreateDate(GregorianCalendar.getInstance());
    // PDDocumentInformation pdi=doc.getDocumentInformation();
    PDDocumentInformation pdi = new PDDocumentInformation();
    pdi.setProducer(producer);
    pdi.setAuthor(creator);
    doc.setDocumentInformation(pdi);

    XMPSchemaPDF pdf = xmp.addPDFSchema();
    pdf.setProducer(producer);
    pdf.setAbout("");

    // Mandatory: PDF-A3 is tagged PDF which has to be expressed using a
    // MarkInfo dictionary (PDF A/3 Standard sec. 6.7.2.2)
    PDMarkInfo markinfo = new PDMarkInfo();
    markinfo.setMarked(true);
    doc.getDocumentCatalog().setMarkInfo(markinfo);

    pdfaid.setPart(3);
    pdfaid.setConformance("A");/*
                                * All files are PDF/A-3, setConformance refers
                                * to the level conformance, e.g. PDF/A-3-B where
                                * B means only visually preservable, U means
                                * visually and unicode preservable and A -like
                                * in this case- means full compliance, i.e.
                                * visually, unicode and structurally preservable
                                */
    pdfaid.setAbout("");
    metadata.importXMPMetadata(xmp);
    return cat;
  }

  /**
   * This will create a hello world PDF/A document. <br />
   * see usage() for commandline
   * 
   * @param args
   *          Command line arguments.
   */
  public static void main(String[] args)
  {
    PDFA3FileAttachment app = new PDFA3FileAttachment();
    try
    {
      if (args.length != 2)
      {
        app.usage();
      }
      else
      {
        app.doIt(args[0], args[1]);
      }
    }
    catch (Exception e)
    {
      e.printStackTrace();
    }
  }

  /**
   * This will print out a message telling how to use this example.
   */
  private void usage()
  {
    System.err.println("usage: " + this.getClass().getName() + " <output-file> <Message>");
  }
}
