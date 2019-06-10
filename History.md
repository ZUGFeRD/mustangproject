
1.7.2
=====

Support BuyerReference (r+w), as well as SpecifiedLegalOrganization (w) and DefinedTradeContact (w) 
use dom4j to format output xml document
corrected some exception logging glitches


1.7.1
=====
2019-05-26

Corrected EN16931 ZF2 profile name

1.7.0
=====
2019-05-05

Export ZF2 final now seems halfway valid (new filename, new namespace prefixa)
Migrates profile names in ZF1 to ZF2 migration
Nullpointerex solved with certain invalid profiles
Be able to access additional files ("additional data")
Known bugs: src/test/resources/migration/reference/ZUGFeRD2_EXTENDED_Warenrechnung.xml is invalid


1.6.0
=====
2019-02-03

Closes #69.
Corrected EN 16931 XMP Schema Extension header
Can now read xmp metadata via ZUGFeRDImporter getXMP
Exporting valid EN16931 Factur-X when version/profile set to 2/EN16931 mode


1.5.5
=====
2018-10-22

Fixes by Indigo744: Issues #66 Commandline: provide a way to set input parameters and #68 Combine with ZUGFeRD v2: NullPointerException
Fixes #63 PDF/A3 conversion not valid.

1.5.4
=====
2018-08-29

Fixed #62 fail gracefully on commandline extraction of XML if none is present.
New public function: ZUGFeRDImporter.getUTF8 returns raw XML without Byte Order Mark, if one had been used.

1.5.3
=====
2018-07-20

Fixed #60 nullpointerexception in ZUGFeRDimporter on some input files 
and #61 missing in maven repo 
Now possible to skip parse() and go from zi.extract to e.g. zi.getAmount()



1.5.2
=====
2018-06-10

Fixed #57 commandline not converting PDF from A1 to A3 when adding XML to PDF (-c) 

1.5.1
=====
2018-01-13

Fixed a major issue with the Maven repository (thanks to Markus Plangg, https://github.com/ZUGFeRD/mustangproject/issues/52)

1.5.0
=====
2017-11-30

Support for ZUGFeRD 2.0 "public review" part 1.
Now using factories to create/configure ZUGFeRDExporter.
Export is now also possible on OutputStream.
Removed need to call PDFattachZugferdFile(null) or exporter close();
More unit tests, e.g. for custom xml export, PDF/A Schema extensions.
The command line utility "toecount" is now integrated and the main class so "java -jar mustang-1.5.0.jar" should suffice.
It now also features options to combine PDF with XML and upgrade XML files from ZF1 to ZF2.

First attempts be able to start with a PDF/A-3 in the first place and better error messages for non-PDF/A-conformance.

Further changes: 

* be able to specify profile #50
* close pdf files automatically after export #49 
* ZUGFeRDimporter does not close #48 
* command line option -e does not work on all-in-one jar #47 
* invoices have wrong namespaces #45 
* invalid a3 #44
* warn on export #39

 
1.4.0
=====
2017-05-11
Switched to ZUGFeRD extended, new all-in-one jar including dependencies, 
switch to Apache PDFBox 2.0. Some bugfixes. 
Thanks to AlexanderSchmidt and yankee42. 

1.3.1
=====
2016-06-01
 
1.3.0
=====
2016-03-15
Additional checks in the new version facilitate correct usage within your own applications. For example, input data (PDF/A-1) and the sequence of the calls are checked for accuracy.
A community patch (thanks to Alexander Schmidt) improves the internal functioning and removes the last known bugs.

1.2.0
=====
2015-10-15
Compliance to GEFEG and ZUGFeRD Checker.

1.1.2
=====
2015-06-15
The ZUGFeRD-Metadata now conforms to more validators like the Konik Validation Service. As a new feature it is now also possible to create test invoices.

1.1.1
=====
2015-03-31
Maven and custom xml

1.1.0
=====
2014-12-07
ZUGFeRD 1.0

1.0.0
=====
2014-05-22
ZUGFeRD 1.0RC Comfort