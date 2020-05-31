
0.9.0
======
2020-03-24
* ZF 2.1 Schema/Schematrons
* check against URI allowing for different fragments
* #27 wrong exit code
* now context also loggs
* introduced fatal errors. new errors: filename empty (10), xml not extractable (17), En16931 CEN Schematron error (24)
* fail better if -f missing
* validate against CEN 1.3
* corrected invalidation of complete output status for broken pdfs
* mention filename in report 
* escape xml in report elements, e.g. < in criterion to become &lt;
* validation element has been removed from pdf info and added as attribute in root, duration is now direct child of info
* file not found and file too small now without filename
* XML pretty print output. (XML report may now contain header <?xml...)
* First XMLUnit tests
* Better Check of XML Validity also against documents which start with comments or not with xml header <?xml...
* prevent accidental CEN EN16931 application on extended profile 
* solved issues when XML structures start with comments instead of root node
* added Symtrax signature

0.8.3
======
2019-10-20
* #22 rounding errors when applying schematron
* check for 1.0 or 2p0 in RDF, not 1.0 and 2.0 like before
* updated to zf 2.0.1

0.8.2
======
2019-10-10
* #22 rounding errors when applying schematron

0.8.1
======
2019-09-01

* added Signature pdfMachine
* added check for additional data correctness
* #23 ZF2 basic was incorrectly checked against Minimum/Basic Without lines Schema/Schematron
* Merged -x and -z to -f
* Created ZUGFeRDValidatorClass and MiscValidatorTests for e.g. tests without existing files

0.8.0
======
2019-07-08

* updated Mustang to mitigate #20 zf1 validation does not always return a <xml> section
* validate not only against *schematron* but also against *schema* files

0.7.0
======
2019-05-31

* ZUGFeRD 2 final compatible
* now displaying number of applied and failed rules
* now failing if no rule could be applied at all
* profileoverride option no longer needed
* version dependent checks for profiles (i.e. comfort is not a valid ZF2 profile!)
* allow new ZF2 filename (zugferd-invoice.xml instead ZUGFeRD-invoice.xml)
* more JUnit tests
* include own version number in XML report


0.6.0
=====
2019-02-15
Factur-X compatible
Mention xpath location where the errors occurred
JUnit tests
new way to collect&handle errors
XMP/PDF-A-Schema extension validation


0.5.0
=====
2018-09-10
Non-16931 profiles are no longer automatically (but still can be manually) checked,
now writing a log file, attempt to find out which toolkit created that particular file (issue #2),
fixing that XML could not be extracted from certain valid PDF/A-3 files (issue #9),
added --action parameter (has to be validate), -f option changes to "-o -z", added APL license, 
added possibility to check XML files only, fixing issues with files that contained a 
UTF8 BOM in the XML content ("Content not allowed in prolog"), 
Upgraded VeraPDF-validation from 1.10.5 to 1.12.1

0.4.3
=====
2018-03-19

Java 8 capability (fixes issue #8)

0.4.2
=====
2018-03-11
POJO embedding VeraPDF: unable to solve some severe deployment issues


0.4.1
=====
2018-02-12
ZUGFeRD 2 public preview EN16931 validation using the schematron files the CEN had
published under APL


0.3.0
=====
2017-07-24
First release as VeraPDF plugin
