
## Context

On it's official website you can [download](https://www.mustangproject.org/files/Mustang-CLI-2.0.0-alpha1.jar) a alpha release of Mustang 2.

It integrates the successor of the ZUGFeRD [Validator ZUV](https://github.com/ZUGFeRD/ZUV/) in it's command line tool and can be used as library.
 
This is a preview release, please do not (yet) use it in production

##Use on command line
`java -jar Mustang-CLI-2.0.0-alpha1.jar --action=combine` embedds a XML into a PDF (A-1) file and exports as PDF/A-3

`java -jar mustang-cli.jar --action=extract` extracts XML from a ZUGFeRD file and

`java -jar mustang-cli.jar --action=validate` validates XML or PDF files.

`java -jar mustang-cli.jar --help` still outputs the parameters which can be used
to for non-interactive (i.e., batch) processing. 


The source file parameter for validation changed 
from `-f` (ZUV) to the usual `--source`. The following 
result codes apply:

| section  | meaning  |
|---|---|
| 1  | file not found  |
| 2  | additional data schema validation fails  |
| 3  | xml data not found  |
| 4  | schematron rule failed  |
| 5  | file too small  |
| 6  | VeraPDFException |
| 7  | IOException PDF  |
| 8  | File does not look like PDF nor XML (contains neither %PDF nor <?xml)  |
| 9  | IOException XML  |
| 11  | XMP Metadata: ConformanceLevel not found  |
| 12  | XMP Metadata: ConformanceLevel contains invalid value  |
| 13  | XMP Metadata: DocumentType not found  |
| 14  | XMP Metadata: DocumentType invalid  |
| 15  | XMP Metadata: Version not found  |
| 16  | XMP Metadata: Version contains invalid value  |
| 18  | schema validation failed  |
| 19  | XMP Metadata: DocumentFileName contains invalid value  |
| 20  | not a pdf  |
| 21  | XMP Metadata: DocumentFileName not found")  |
| 22  | generic XML validation exception  |
| 23  | Not a PDF/A-3  |
| 24  | Issues in CEN EN16931 Schematron Check |
| 25  | Unsupported profile type  |
| 26  | No rules matched, XML to minimal?  |
| 27  | XRechnung Schematron Check |
 
 
##Use as Library

| What  | old value | new value |
|---|---|---|
| Group id  | org.mustangproject.zugferd | org.mustangproject|
| Artifact ID | mustang | library  |
| Version | 1.7.8 | 1.9.0-alpha1  |

If you want you can also embed the validator in your software using validator
as artifact ID. "validator" includes the library functionality but is >20 MB 
bigger due to it's dependencies. 


##Update from 1.x to 2.0

ZF2 was possible with Mustang 1 but it is default in Mustang 2, so 
you will need to `.setZUGFeRDVersion(1)` if you don't want ZUGFeRD 2 files.
`PDFattachZugferdFile` is now called `setTransaction` and instead of
a `ZUGFeRDExporterFromA1Factory` the `ZUGFeRDExporterFromA1` will now return a
a class implementing `IZUGFeRDExporter` instead of a `ZUGFeRDExporter`.
So 
```
			 ZUGFeRDExporter ze = new ZUGFeRDExporterFromA1Factory().setZUGFeRDConformanceLevel(ZUGFeRDConformanceLevel.COMFORT).load(SOURCE_PDF)) {

``` 
changes to 
```
			 IZUGFeRDExporter ze = new ZUGFeRDExporterFromA1().setZUGFeRDVersion(1).setZUGFeRDConformanceLevel(ZUGFeRDConformanceLevel.EN16931).load(SOURCE_PDF)) {

``` 

The importer can still be used like

```
ZUGFeRDImporter zi = new ZUGFeRDImporter(inputStream);
String amount = zi.getAmount();
``` 
but we are also working on an importer to import into the new invoice class.

##Using the library
```

<repositories>
    <repository>
        <id>mustang-mvn-repo</id>
        <url>https://raw.github.com/ZUGFeRD/mustangproject/mvn-repo/</url>
    </repository>
</repositories>
<dependencies>
    <dependency>
       <groupId>org.mustangproject</groupId>
       <artifactId>library</artifactId>
       <version>1.9.0-alpha1</version>
    </dependency>
</dependencies>

```
```
import org.mustangproject.Contact;
import org.mustangproject.Invoice;
import org.mustangproject.Item;
import org.mustangproject.Product;
import org.mustangproject.ZUGFeRD.IZUGFeRDExporter;
import org.mustangproject.ZUGFeRD.Profiles;
import org.mustangproject.ZUGFeRD.ZUGFeRDExporterFromA1;
import java.math.BigDecimal;
import java.util.Date;

public class Main {
    public static void main(String[] args) {
    Invoice i = new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date()).setOwnOrganisationName("My company").setOwnStreet("teststr").setOwnZIP("12345").setOwnLocation("teststadt").setOwnCountry("DE").setOwnTaxID("4711").setOwnVATID("0815").setRecipient(new Contact("Franz Müller", "0177123456", "fmueller@test.com", "teststr.12", "55232", "Entenhausen", "DE")).setNumber("INV/123").addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(0)), new BigDecimal(1.0), new BigDecimal(1.0)));
        try {
            IZUGFeRDExporter ie = new ZUGFeRDExporterFromA1().load("source.pdf").setZUGFeRDVersion(2).setProfile(Profiles.EN16931);
            ie.setProfile(Profiles.EN16931).setTransaction(i).export("target.pdf");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
```

##Invoice class
A invoice like this
```
Invoice i = new Invoice().setDueDate(new Date()).setIssueDate(new Date()).setDeliveryDate(new Date()).setOwnOrganisationName(orgname).setOwnStreet("teststr").setOwnZIP("55232").setOwnLocation("teststadt").setOwnCountry("DE").setOwnTaxID("4711").setOwnVATID("0815").setRecipient(new Contact("Franz Müller", "0177123456", "fmueller@test.com", "teststr.12", "55232", "Entenhausen", "DE")).setNumber(number).addItem(new Item(new Product("Testprodukt", "", "C62", new BigDecimal(0)), amount, new BigDecimal(1.0)));
```
can be used to get XML
```
ZUGFeRD2PullProvider zf2p = new ZUGFeRD2PullProvider();
zf2p.generateXML(i);
String theXML = new String(zf2p.getXML());
```
or can also be used with setTransaction to generate invoice PDFs straight away.
##Embedding the validator
```

<repositories>
   <repository>
     <id>mustang-mvn-repo</id>
     <url>https://raw.github.com/ZUGFeRD/mustangproject/mvn-repo/</url>
   </repository>
</repositories>
<dependencies>
   <dependency>
      <groupId>org.mustangproject</groupId>
      <artifactId>validator</artifactId>
      <version>1.9.0-alpha1</version>
   </dependency>
</dependencies>

```
```
import org.mustangproject.validator.ZUGFeRDValidator;
public class Main {
    public static void main(String[] args) {
        ZUGFeRDValidator zfv = new ZUGFeRDValidator();
        System.out.println(zfv.validate("/tmp/factur-x.xml"));
    }
}
```
