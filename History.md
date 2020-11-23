
2.0.1
=====
2020-11-21

- corrected VAT calculation on prices with >2 decimals (PR#195 thanks to weclapp-dev)
- have fax numbers only in appropriate profiles, i.e., extended
- do not list tax numbers for shiptotradeparties
- do not expect dueDate for corrected invoices
- XR test now includes guideline ID (of XRechnung 1.2.2) #172
- BigDecimal specific refactoring PR #192 Thanks to weclapp-dev
- Preserving metadata PR #193 Thanks to mr-stephan
- support zero-rated goods: confirm that VAT category code switches from S to Z on 0%VAT
- new sample invoice
- delivery period also on item level
- corrected more than 100 javadoc entries
- support specification of account (holder) names
- new sample invoice (20201121_508) 
 
2.0.0 
=====
2020-11-12

- support for ZF 2.1.1, i.e. "Reference profile" Xrechnung 
- ZF 2.1.1 now default (up to 1.7.8 ZF2 could be set but ZF1 was default)
- integrates validator
- removed jaxb #87
- fluent setter api/pushprovider #40 
- new xrechnung reference profile
- visualization zugferdvisualizer
- migration feature (XSLT upgrade of ZF1 to ZF2) has been improved and moved from the commandline into the library
- german bank account numbers can no longer be specified (dropped in favor of IBAN and BIC)
- factory for xrechnung #86
- moved to Maven central
- complete or discard read into push provider
- now TransactionCalculator is a dedicated class and no longer mixed up with pullprovider
- validator now additionally supports xrechnung 
- modular project setup
- getSellerTradePartyAddress (PR #157 ) thanks to aberndt-hub 
- switched from eclipse to IntelliJ
- added ph-schematron-maven-plugin so that xrechnung xslt can be generated
- be able to recursively validate directories
- be able to ignore input pdf errors with -i
- be able to recursively scan directories using validateExpectValid/validateExpectInvalid
- upgraded to verapdf 1.16.1
- support to validate XRechnung 2.0
- added Ghostscript signature
- removal of izugferddate/IZUGFeRDPaymentTerms,IZUGFeRDPaymentDiscountTerms
switch
- change from ZUGFeRDExporter to IZUGFeRDExporter
- switch recipient, shipping address from contact to tradeparty
- switch from profiles to profile
- javadoc export
- have visualizer
- validate as library doc
- unify loggers
- release notes
- new tradeparty class, Contact getOwnContact superseded by TradeParty getSender
- new invoicecorrection class
- order-x xml read support
- support included notes on document and item level 
- occurence periods  setOccurrencePeriod(Date start, Date end)
- automated tests zuv/verapdf validate created library test files
- trans.getTradeSettlementPayment() removed in favor of trans.getTradeSettlement()
- commandline option for no notices
- new features 
  - additional docs, 
  - contract id, 
  - delivery period, 
  - corrected invoices,
  - contacts also for recipients 
  - absolute and relative allowances and charges on item and document level #135,
  - support contact fax numbers
  - closes #190 BOM not treated correctly on XML input file

Alpha3 2020-10-24
Alpha2 2020-09-15
Alpha1 2020-08-06

Mustangproject 1.7.8
=====
2020-06-14
- corrected ZF2 gross price 


Mustangproject 1.7.7
=====
2020-05-26

- Refactored comparison operator for ChargeIndicator https://github.com/ZUGFeRD/mustangproject/pull/153
- ZUGFeRD2PullProvider needs getDueDate() although getPaymentTermDescription() is defined  https://github.com/ZUGFeRD/mustangproject/pull/155
- #148 support additional documents for items
- #154 german VAT ID may not be used for sellercontact scheme id

Validator 0.9.0
=====
2020-03-24

- ZF 2.1 Schema/Schematrons
- check against URI allowing for different fragments
- #27 wrong exit code
- now context also loggs
- introduced fatal errors. new errors: filename empty (10), xml not extractable (17), En16931 CEN Schematron error (24)
- fail better if -f missing
- validate against CEN 1.3
- corrected invalidation of complete output status for broken pdfs
- mention filename in report
- escape xml in report elements, e.g. < in criterion to become <
- validation element has been removed from pdf info and added as attribute in root, duration is now direct child of info
- file not found and file too small now without filename
- XML pretty print output. (XML report may now contain header <?xml...)
- First XMLUnit tests
- Better Check of XML Validity also against documents which start with comments or not with xml header <?xml...
- prevent accidental CEN EN16931 application on extended profile
- solved issues when XML structures start with comments instead of root node
- added Symtrax signature
- paymenttermsdescription skonto xrechnung ?
- occurencedate vs deliverydate
- exception on invoice import if wrong


Mustangproject 1.7.6
=====
2020-02-06

- support different ship to address
- allow for diffent namespace prefixes #140
- include exemption reason if doing intra community supply
- allow different currencies also for ZF2 (#150)
- minor correction VAT exemptions

Mustangproject 1.7.5
=====
2019-11-05

- support Sepa Direct Debit
- closes #134 ZUGFeRD2PullProvider uses NetPrice for GrossPrice
- support intra community supply (=vat category codes)
- Support different Date formats #136
- corrected RDF metadata for ZF2
- default conformance level now EN16931, not extended

Validator 0.8.3
=====
2019-10-20

- #22 rounding errors when applying schematron
- check for 1.0 or 2p0 in RDF, not 1.0 and 2.0 like before
- updated to zf 2.0.1

Validator 0.8.2
=====
2019-10-10

- #22 rounding errors when applying schematron

Validator 0.8.1
=====
2019-09-01

- added Signature pdfMachine
- added check for additional data correctness
- #23 ZF2 basic was incorrectly checked against Minimum/Basic Without lines Schema/Schematron
- Merged -x and -z to -f
- Created ZUGFeRDValidatorClass and MiscValidatorTests for e.g. tests without existing files

Mustangproject 1.7.4
=====
2019-08-24

- #102 XML entities for ZF2 export
- corrected addAddtionaldata to addAdditionalFile
- add zugferdimporter.getversion
- add total amount in metrics
- #132 Mustangproject does not work w/ Java 11


Mustangproject 1.7.3
=====
2019-08-01

- #105 does not build in windows
- #99 BOMs confuse parser
- updated javadoc
- fixed #104 nullpointerex when specifying no parameter
- PR #112 complete profile options for v1 
- access to TotalPrepaidAmount in ZF v1 #118
- have unit tests for nDigitFormat #23


Mustangproject 1.7.2
=====
2019-07-08

- Support BuyerReference (r+w), as well as SpecifiedLegalOrganization (w) and DefinedTradeContact (w) 
- use dom4j to format output xml document
- corrected some exception logging glitches
- upgrade PDFBox to 2.0.15+
- extraction to use proper filename instead of alias #98
- NullPointerException in ZUGFeRDImporter.extractLowLevel #96
- Removed Bankleitzahl from ZF2

Validator 0.8.0
=====
2019-07-08

- updated Mustang to mitigate #20 zf1 validation does not always return a section
- validate not only against schematron but also against schema files

Validator 0.7.0
=====
2019-05-31

- ZUGFeRD 2 final compatible
- now displaying number of applied and failed rules
- now failing if no rule could be applied at all
- profileoverride option no longer needed
- version dependent checks for profiles (i.e. comfort is not a valid ZF2 profile!)
- allow new ZF2 filename (zugferd-invoice.xml instead ZUGFeRD-invoice.xml)
- more JUnit tests
- include own version number in XML report

Mustangproject 1.7.1
=====
2019-05-26

Corrected EN16931 ZF2 profile name

Mustangproject 1.7.0
=====
2019-05-05

- Export ZF2 final now seems halfway valid (new filename, new namespace prefixa)
- Migrates profile names in ZF1 to ZF2 migration
- Nullpointerex solved with certain invalid profiles
- Be able to access additional files ("additional data")
- Known bugs: src/test/resources/migration/reference/ZUGFeRD2_EXTENDED_Warenrechnung.xml is invalid

Validator 0.6.0
=====
2019-02-15 

Factur-X compatible Mention xpath location where the errors occurred JUnit tests new way to collect&handle errors XMP/PDF-A-Schema extension validation


Mustangproject 1.6.0
=====
2019-02-03

- Closes #69.
- Corrected EN 16931 XMP Schema Extension header
- Can now read xmp metadata via ZUGFeRDImporter getXMP
- Exporting valid EN16931 Factur-X when version/profile set to 2/EN16931 mode


Mustangproject 1.5.5
=====
2018-10-22

- Fixes by Indigo744: Issues #66 Commandline: provide a way to set input parameters and #68 Combine with ZUGFeRD v2: NullPointerException
- Fixes #63 PDF/A3 conversion not valid.

Validator 0.5.0
=====
2018-09-10 

- Non-16931 profiles are no longer automatically (but still can be manually) checked
- now writing a log file
- attempt to find out which toolkit created that particular file (issue #2)
- fixing that XML could not be extracted from certain valid PDF/A-3 files (issue #9)
- added --action parameter (has to be validate)
- -f option changes to "-o -z"
- added APL license
- added possibility to check XML files only
- fixing issues with files that contained a UTF8 BOM in the XML content ("Content not allowed in prolog")
- Upgraded VeraPDF-validation from 1.10.5 to 1.12.1

Mustangproject 1.5.4
=====
2018-08-29

- Fixed #62 fail gracefully on commandline extraction of XML if none is present.
- New public function: ZUGFeRDImporter.getUTF8 returns raw XML without Byte Order Mark, if one had been used.

Mustangproject 1.5.3
=====
2018-07-20

- Fixed #60 nullpointerexception in ZUGFeRDimporter on some input files 
- and #61 missing in maven repo 
- Now possible to skip parse() and go from zi.extract to e.g. zi.getAmount()

Mustangproject 1.5.2
=====
2018-06-10

Fixed #57 commandline not converting PDF from A1 to A3 when adding XML to PDF (-c) 

Validator 0.4.3
=====
2018-03-19

Java 8 capability (fixes issue #8)

Validator 0.4.2
=====
2018-03-11 

POJO embedding VeraPDF: unable to solve some severe deployment issues

Validator 0.4.1
=====
2018-02-12 

ZUGFeRD 2 public preview EN16931 validation using the schematron files the CEN had published under APL

Mustangproject 1.5.1
=====
2018-01-13

Fixed a major issue with the Maven repository (thanks to Markus Plangg, https://github.com/ZUGFeRD/mustangproject/issues/52)

Mustangproject 1.5.0
=====
2017-11-30

- Support for ZUGFeRD 2.0 "public review" part 1.
- Now using factories to create/configure ZUGFeRDExporter.
- Export is now also possible on OutputStream.
- Removed need to call PDFattachZugferdFile(null) or exporter close();
- More unit tests, e.g. for custom xml export, PDF/A Schema extensions.
- The command line utility "toecount" is now integrated and the main class so "java -jar mustang-1.5.0.jar" should suffice.
- It now also features options to combine PDF with XML and upgrade XML files from ZF1 to ZF2.

First attempts be able to start with a PDF/A-3 in the first place and better error messages for non-PDF/A-conformance.

Further changes: 

* be able to specify profile #50
* close pdf files automatically after export #49 
* ZUGFeRDimporter does not close #48 
* command line option -e does not work on all-in-one jar #47 
* invoices have wrong namespaces #45 
* invalid a3 #44
* warn on export #39

Validator 0.3.0
=====
2017-07-24 

First release as VeraPDF plugin
 
Mustangproject 1.4.0
=====
2017-05-11

- Switched to ZUGFeRD extended, new all-in-one jar including dependencies, 
- switch to Apache PDFBox 2.0. Some bugfixes. 
Thanks to AlexanderSchmidt and yankee42. 

Mustangproject 1.3.1
=====
2016-06-01
 
Mustangproject 1.3.0
=====
2016-03-15

Additional checks in the new version facilitate correct usage within your own applications. For example, input data (PDF/A-1) and the sequence of the calls are checked for accuracy.
A community patch (thanks to Alexander Schmidt) improves the internal functioning and removes the last known bugs.

Mustangproject 1.2.0
=====
2015-10-15

Compliance to GEFEG and ZUGFeRD Checker.

Mustangproject 1.1.2
=====
2015-06-15

The ZUGFeRD-Metadata now conforms to more validators like the Konik Validation Service. As a new feature it is now also possible to create test invoices.

Mustangproject 1.1.1
=====
2015-03-31

Maven and custom xml

Mustangproject 1.1.0
=====
2014-12-07

ZUGFeRD 1.0

Mustangproject 1.0.0
=====
2014-05-22

ZUGFeRD 1.0RC Comfort


