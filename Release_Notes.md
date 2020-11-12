
## Changes

On it's official website you can [download](https://www.mustangproject.org/deploy/Mustang-CLI-2.0.0.jar) Mustang 2.

* Factur-X/ZUGFeRD 2 is now the default. In Mustangproject 1.x one had to select ZUGFeRD version 2 if that was desired, in Mustangproject 2 one now has to select ZUGFeRD version 1 if version 2 is not appropriate.
* Mustang is now available via Maven Central, which makes it even easier to use the Mustang library. Apart from making it easier in Maven because there is no longer the need to mention the custom repository, it also makes it possible to use Mustang in Gradle projects
* ZUGFeRD 2.1.1 is now supported with it's XRechnung "reference profile". The previous stable version, Mustang 1.7.8, only supported ZUGFeRD 2.1.
* There is now an experimental visualization feature and an improved experimental upgrade functionality from ZF1 XML to ZF2 XML.
* Mustang now supports percentual and absolute charges and allowances on both item and document level
* Mustang can now embed additional invoice-accompanying files like plans or worklists into the PDFs
* Additionally to the usual interface-based architecture there are now also classes for invoice, tradeparty etc., which makes it easier to develop in the Mustang library. Please feel free to have a look at it's tests on https://github.com/ZUGFeRD/mustangproject/blob/master/library/src/test/java/org/mustangproject/ZUGFeRD/ZF2PushTest.java.
* Mustang now includes a validator, which can check the syntactical correctness of an e-invoice.
The validator component has previously been developed under the name ZUGFeRD and VeraPDF "ZUV".
It is now mature enought to be merged into the Mustang mainstream project. 
ZUV already was the validator behind https://www.zugferd-community.net/de/open_community/validation with around 1,000 validations/month alone, 
supports ZUGFeRD 1 and ZUGFeRD 2 and can be used via commandline. 
Additionally, the Mustang validator now also supports XRechnung 2, can now also be used as library and supports validation of whole directory trees.

 

### Use on command line
`java -jar Mustang-CLI-2.0.0-alpha3.jar --action=combine` embedds a XML into a PDF (A-1) file and exports as PDF/A-3

`java -jar mustang-cli.jar --action=extract` extracts XML from a ZUGFeRD file and

`java -jar mustang-cli.jar --action=validate` validates XML or PDF files.

`java -jar mustang-cli.jar --help` still outputs the parameters which can be used
to for non-interactive (i.e., batch) processing. 


The source file parameter for validation changed 
from `-f` (ZUV) to the usual `--source`. 

### Use as Library

We're now on maven central, please remove the old github repository. Additionally, the following changed

| What  | old value | new value |
|---|---|---|
| Group id  | org.mustangproject.zugferd | org.mustangproject|
| Artifact ID | mustang | library  |
| Version | 1.7.8 | 2.0.0-alpha3  |

If you want you can also embed the validator in your software using validator
as artifact ID. "validator" includes the library functionality but is >20 MB 
bigger due to it's dependencies. 


### Update from Mustang 1.x to 2.0

ZF2 was possible with Mustang 1 but it is default in Mustang 2, so 
you will need to `.setZUGFeRDVersion(1)` if you don't want ZUGFeRD 2 files.

In the commandline, all actions will have to be invoked via --action=<theaction>, so
--combine changes to --action=combine.

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

Instead of `Profile.EXTENDED` use `Profiles.getByName("Extended")`.
If you want to use Profiles from older versions, please specify the version like
 `Profiles.getByName("Extended")` for an Extended profile of ZF1.

The old Contact class has been corrected to TradeParty. The TradeParty class
can now refer to a (human) Contact from the new Contact() class. 

The importer can still be used like

```
ZUGFeRDImporter zi = new ZUGFeRDImporter(inputStream);
String amount = zi.getAmount();
``` 
but there is also the new invoiceImporter 
```

		ZUGFeRDInvoiceImporter zii=new ZUGFeRDInvoiceImporter(TARGET_PDF);

		Invoice invoice=null;
		try {
			invoice=zii.extractInvoice();
		} catch (XPathExpressionException | ParseException e) {
// handle Exceptions
		}
		assertFalse(hasExceptions);
		// Reading ZUGFeRD
		assertEquals("Bei Spiel GmbH", invoice.getOwnOrganisationName());
		assertEquals(3, invoice.getZFItems().length);
		assertEquals("400.0000", invoice.getZFItems()[1].getQuantity().toString());

		assertEquals("160.0000", invoice.getZFItems()[0].getPrice().toString());
		assertEquals("Heiße Luft pro Liter", invoice.getZFItems()[2].getProduct().getName());
		assertEquals("LTR", invoice.getZFItems()[2].getProduct().getUnit());
		assertEquals("7.00", invoice.getZFItems()[0].getProduct().getVATPercent().toString());
		assertEquals("RE-20170509/505", invoice.getNumber());

		SimpleDateFormat sdf=new SimpleDateFormat("yyyy-MM-dd");
		assertEquals("2017-05-09",sdf.format(invoice.getIssueDate()));

		assertEquals("Bahnstr. 42", invoice.getRecipient().getStreet());
		assertEquals("88802", invoice.getRecipient().getZIP());
		assertEquals("DE", invoice.getRecipient().getCountry());
		assertEquals("Spielkreis", invoice.getRecipient().getLocation());

		TransactionCalculator tc=new TransactionCalculator(invoice);
		assertEquals(new BigDecimal("571.04"),tc.getTotalGross());

``` 

### Using the library to create e-invoices
From maven central fetch
```

<dependencies>
    <dependency>
       <groupId>org.mustangproject</groupId>
       <artifactId>library</artifactId>
       <version>2.0.0-alpha3</version>
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

### Export XML
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
### Embedding ZF1 to ZF2 migration
The functionality is based on the XSLT file in library/src/main/resources/stylesheets/ZF1ToZF2.xsl,
it can be accessed via 
```
		XMLUpgrader zmi = new XMLUpgrader();
		String xml = zmi.migrateFromV1ToV2(xmlName);
		Files.write(Paths.get(outName), xml.getBytes());

```
### Embedding ZF2 visualization 

In case you don't want to access this functionality over the 
commandline you can use
```
		ZUGFeRDVisualizer zvi = new ZUGFeRDVisualizer();
			xml = zvi.visualize(sourceName);
			Files.write(Paths.get("factur-x.xml"), xml.getBytes());
```
for the visualizer.     The output requires a CSS and a javascript file which are in the
	    jar's resources as 
		(/src/main/resources/)xrechnung-viewer.css
		(/src/main/respurces/)xrechnung-viewer.js


### Embedding the validator
The validator library also contains the functionality to 
read/write ZUGFeRD-invoices like the (smaller) library module. 
```
<dependencies>
   <dependency>
      <groupId>org.mustangproject</groupId>
      <artifactId>validator</artifactId>
      <version>2.0.0</version>
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
