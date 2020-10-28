# ZUV
ZUV (ZUgferd+[VeraPDF](http://VeraPDF.org)) is an open-source e-invoice validator for the [ZUGFeRD](https://www.ferd-net.de/zugferd/specification/index.html)/[Factur-X](http://fnfe-mpe.org/factur-x/) standard.

It checks both PDF/A-3 compliance (based on VeraPDF) and ZUGFeRD version 1 respectively 2/2.1 XMLs for correctness.
The XML check is done by validating against the official ZUGFeRD schematron file for v1 and v2.1 and additionally the EN16931 UN/CEFACT SCRDM v16B uncoupled schematron from the [CEN](https://github.com/CenPC434/validation).


## Build
In the pom.xml directory compile the jar with `./mvnw clean package`

To prepare the schematron files they have to be converted to XSLT files, which is done with a XSLT transformation
itself.
Get [Saxon](http://saxon.sourceforge.net/#F9.9HE) and the [XSLT](https://github.com/Schematron/stf/tree/master/iso-schematron-xslt2) to convert schematron to XSLT 
and run
`java -jar ./saxon9he.jar -o:minimum.xsl -s:zugferd2p0_basicwl_minimum.sch ./schematron_to_xslt/iso-schematron-xslt2/iso_svrl_for_xslt1.xsl`
to do so.

To create a new en16931 run 
`
git clone https://github.com/ConnectingEurope/eInvoicing-EN16931.git 
mvn -f pom-xslt.xml package
`


      

## Run

To check a file for ZUGFeRD conformance use

`java -jar ZUV-0.9.0.jar --action validate -f <filename of ZUGFeRD PDF.pdf>`

You can provide either the complete PDF which will be checked for XML and PDF correctness, or just a XML file, which of course
will only be checked for XML correctness.


## Output
A valid file looks like this
```
<?xml version="1.0" encoding="UTF-8"?>

<validation filename="Facture_UE_MINIMUM.pdf" datetime="2020-03-23 12:34:54">
  <pdf> 
    <report> 
      <buildInformation> 
        <releaseDetails id="core" version="1.12.1" buildDate="2018-05-08T18:57:00+02:00"/>  
        <releaseDetails id="validation-model" version="1.12.1" buildDate="2018-05-08T20:39:00+02:00"/> 
      </buildInformation>  
      <jobs> 
        <job> 
          <item size="101181"> 
            <name>/Users/jstaerk/workspace/zugferd/helper_files/../foreign_samples/fx/Facture_UE_MINIMUM.pdf</name> 
          </item>  
          <validationReport profileName="PDF/A-3B validation profile" statement="PDF file is compliant with Validation Profile requirements." isCompliant="true"> 
            <details passedRules="123" failedRules="0" passedChecks="11082" failedChecks="0"/> 
          </validationReport>  
          <duration start="1584963295227" finish="1584963296646">00:00:01.419</duration> 
        </job> 
      </jobs>  
      <batchSummary totalJobs="1" failedToParse="0" encrypted="0"> 
        <validationReports compliant="1" nonCompliant="0" failedJobs="0">1</validationReports>  
        <featureReports failedJobs="0">0</featureReports>  
        <repairReports failedJobs="0">0</repairReports>  
        <duration start="1584963294997" finish="1584963296679">00:00:01.682</duration> 
      </batchSummary> 
    </report>  
    <info>
      <signature>Factur/X Python</signature>
      <duration unit="ms">2361</duration>
    </info>
    <summary status="valid"/>
  </pdf>  
  <xml>
    <info>
      <version>2</version>
      <profile>urn:factur-x.eu:1p0:minimum</profile>
      <validator version="0.8.4-RESTRICTED"/>
      <rules>
        <fired>26</fired>
        <failed>0</failed>
      </rules>
      <duration unit="ms">2772</duration>
    </info>
    <summary status="valid"/>
  </xml>
  <summary status="valid"/>
</validation>
```
Invalid files with errors e.g. in the XML part can look like this
```
<?xml version="1.0" encoding="UTF-8"?>

<validation filename="Facture_UE_EXTENDED.pdf" datetime="2020-03-23 12:34:43">
  <pdf> 
    <report> 
      <buildInformation> 
        <releaseDetails id="core" version="1.12.1" buildDate="2018-05-08T18:57:00+02:00"/>  
        <releaseDetails id="validation-model" version="1.12.1" buildDate="2018-05-08T20:39:00+02:00"/> 
      </buildInformation>  
      <jobs> 
        <job> 
          <item size="109172"> 
            <name>/Users/jstaerk/workspace/zugferd/helper_files/../foreign_samples/fx/Facture_UE_EXTENDED.pdf</name> 
          </item>  
          <validationReport profileName="PDF/A-3B validation profile" statement="PDF file is compliant with Validation Profile requirements." isCompliant="true"> 
            <details passedRules="123" failedRules="0" passedChecks="11082" failedChecks="0"/> 
          </validationReport>  
          <duration start="1584963283448" finish="1584963284790">00:00:01.342</duration> 
        </job> 
      </jobs>  
      <batchSummary totalJobs="1" failedToParse="0" encrypted="0"> 
        <validationReports compliant="1" nonCompliant="0" failedJobs="0">1</validationReports>  
        <featureReports failedJobs="0">0</featureReports>  
        <repairReports failedJobs="0">0</repairReports>  
        <duration start="1584963283223" finish="1584963284825">00:00:01.602</duration> 
      </batchSummary> 
    </report>  
    <info>
      <signature>Factur/X Python</signature>
      <duration unit="ms">2296</duration>
    </info>
    <summary status="valid"/>
  </pdf>  
  <xml>
    <info>
      <version>2</version>
      <profile>urn:cen.eu:en16931:2017#conformant#urn:factur-x.eu:1p0:extended</profile>
      <validator version="0.8.4-RESTRICTED"/>
      <rules>
        <fired>97</fired>
        <failed>1</failed>
      </rules>
      <duration unit="ms">8546</duration>
    </info>
    <messages>
      <error type="4" location="/*[local-name()='CrossIndustryInvoice' and namespace-uri()='urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100']/*[local-name()='SupplyChainTradeTransaction' and namespace-uri()='urn:un:unece:uncefact:data:standard:CrossIndustryInvoice:100']/*[local-name()='ApplicableHeaderTradeSettlement' and namespace-uri()='urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100']/*[local-name()='ApplicableTradeTax' and namespace-uri()='urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100']/*[local-name()='CategoryCode' and namespace-uri()='urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:100']" criterion="(/rsm:CrossIndustryInvoice/rsm:SupplyChainTradeTransaction/ram:ApplicableHeaderTradeDelivery/ram:ActualDeliverySupplyChainEvent/ram:OccurrenceDateTime/udt:DateTimeString) or (../../ram:BillingSpecifiedPeriod/ram:StartDateTime) or (../../ram:BillingSpecifiedPeriod/ram:EndDateTime)">In an Invoice with a VAT breakdown (BG-23) where the VAT category code (BT-118) is "Intra-community supply" the Actual delivery date (BT-72) or the Invoicing period (BG-14) shall not be blank.</error> 
    </messages>
    <summary status="invalid"/>
  </xml>
  <messages></messages>
  <summary status="invalid"/>
</validation>
```

## Embed

Feel free to embed this into your java software, send me a PR to use it as a library, or exec it and parse it's output to put on the web.

For exec, you might try something like  
```
exec('java -Dfile.encoding=UTF-8 -jar /path/to/ZUV-0.9.0.jar --action validate -f '.escapeshellarg($uploadfile).' 2>/dev/null', $output);
```
* Redirecting stderr away (some logging messages might otherwise disturb XML well formedness)
* Escaping any file names in case you use original file names at all (apart from security concerns please take into account that they might contain spaces)
* Signal java to use UTF-8 even when otherwise it would not: You might run into trouble with XML files starting with a BOM otherwise and when you exec, keep in mind that you lose all env vars.  

## License

Permissive Open Source APL2, see LICENSE

## Codes

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

## History

see the Mustangproject [history file](History.md)


## Authors

Jochen Staerk "Mustangproject Chief ZUGFeRD amatuer" <jochen@zugferd.org>

