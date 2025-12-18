2.21.0
=======
2025-12-18

- #969 Support Factur-X 1.08 / ZUGFeRD 2.4
- #978 Subtotal validation in ZF 2.4 Extended
- #952 Add optional Invoicer and Invoicee for Extended profile
- #954 Parsing XML documents fails with ZUGFeRD visualizer due to secure processing not being functional
- #947 replace fixed version number with new variable from root pom.xml
- #984 set default vat exemtion reason text on reverse charge
- #983 Be able to easily reference an invoice in a credit memo
- #979, #985 allow vat percent=null sometimes
- #977 Update History.md
- 961/962 Adding a tax ExemptionReasonCode to Product/TradeTax for the XML generation
- have a start of a primitive and incomplete list of human readable unit codes

2.20.0
=======
2025-10-30

- upgrade to pdfbox 3.0.6
- #950 issues with nonshaded version: 2.19.1: ClassNotFoudException while running the PDFValidator
- #959 Added FactoorSharp to the list of valid pdf sources
- change return type of getCashDiscounts to CashDiscount object, not interface
- #923 Support for BT-17 (tender or lot reference)
- #960 incorrect calculation for product charges

2.19.1
=======
2025-10-09

- added JSONIgnore for Products intra community supply, reverse charge and invoice's isValid (which rather means isComplete, by the way)
- #917/#940 percentual allowance/charges actualamount not multiplied with qty/Some quantities and allowances may cause Non-terminating decimal expansion
- #915 Update SubjectCode.java to add subject code 'PMT'
- #921 Treat schematron rule flag "information" as notice.
- #926 reject FX with UBL
- upgrade apache fop 2.10 to 2.11
- #931 Enable setting and reading Additional Document Description.
- #932 Fix typo
- #933,  #413, #557, #765 Format list of dates for PDFs individually/Bug: "FORG0001: Invalid date (Day must be two digits)" bei der Transformation von ZUGFeRD nach PDF/Visualize XML into PDF throws error if XML contains multiple SpecifiedTradePaymentTerms blocks/Exception when generating PDF 
- make Line Calculation, e.g. total line net amount, accessible via JSON using getCalculation
- #939 Remove System.out.println from XRTest.java
- #692 parse cash discounts
- #943/#944 ZUGFeRD2PullProvider getXML() does not set fixed Encoding / Use UTF-8 when creating new Strings from byte[].
- #914 Optimize pom.xml´s.

2.19.0
=======
2025-08-12

changes
- #913 downgrade PDF/A errors to warnings

corrections
- #893 Tradeparty globalID is not read from JSON
- #902 Tests to use definted TZ (UTC)
- #905 Parse product level charges/discounts into JSON
- #869 Import Account Holder returns SellerTradeParty.name instead of AccountHolder
- #861 Multiple problems with Product.CountryOfOrigin
- #882 Change order of ApplicableProductCharacteristic and DesignatedProduct…
- #899 fix encoding error in ZUGFeRDInvoiceImporter.java
- #901 Enhance code quality - part 2
- #908 Validation: Make clear when embedded file name is wrong
- #909 ShipToTradeParty should not contain URIUniversalCommunication
- #821 ERROR org.mustangproject.ZUGFeRD.ValidationLogVisualizer - Failed to create PDF
- #911 Update validation to XRechnung 3.0.2.
- #912 github action tz issue


2.18.0
=======
2025-07-14

- support parsing of BT-90 CreditorReferenceID
- #871 schema validation does not ignore external entities
- #868 Fix wrong version in History.md
- #729 Updates about SpecifiedTradeSettlementHeaderMonetarySummation and SpecifiedTradeSettlementPaymentMeans
- #863 LineCalculator throws NPE if product is null (since 2.17.0)
- #731 Got a broken translation key when visualizing XML into PDF (xr:Business_process_type)
- #865 Add sevdesk signature to PDF creators
- #849 Ignore calculation errors when extracting xml from pdf
- #856 Read contact´s fax number.
- #850/#843 Correction for "Re-Initialize the HTML-template on language change
- #855 Suppress empty nodes in output XML
- #874 Skip PDNameTreeNodes if the names are null or empty
- #830 Invalid XML generated: Item vat-category-code summed up with other 0 percent category codes
- #878 report arithmetic issues in validation report 
- corrected typo ArithmetricException to ArithmeticException
- #726 Financial account information (IBAN) is lost when converting a cii invoice to ubl
- #885 JSON duplicates on item allowances/charges
- #887 incorrect percentual item allowances

2.17.0
=======
2025-06-11
- Breaking change: #764 Item allowances not to be multiplied by quantity
(there are now product level quantities for that)
- #820/801/815 Fix invoiceImporter: empty NodeList, empty Strings
- #822 Wrapping Message Text in Validation Result PDF
- #843 Re-Initialize the HTML-template on language change
- #854 allow multiple item charges/allowances when visualizing to html
- #786 Fix Invoices with Category Code "O" #786
- add getCalculation on calculatedInvoice
- Transactioncalculator getTaxDetails to include correct percentage, calculated amounts

2.16.5
=======
2025-05-22
- #819 correct generateXSLTFromSchematron profile
- #458 Its not possible to add multiple PaymentTerms when using the extended profile
- #788 Invoice taxes aren't acessible
- #790 Crash upon importing an invoice with empty name.
- upgrade from PDFBOX 3.0.2 to 3.0.5 
- #817 dded ZUGFeRD.PDF-csharp to list of PDF creators
- #811 Fix typo in xpath when extracting buyer trade party address
- #833 support zugferd 2.3.3/fx 1.07.3
- #835 UBL does not read item allowances/charges
- #816 Wrong grand total amount for UBL invoices

2.16.4
=======
2025-04-19
- #722 extend ValidationLogVisualizer to not use only file system
- #774 disable XML parsing entities
- #742/#753 "Adresszusatz 1" (LineTwo) showing up as "Postfach" in HTML visualization
- #778 Added XEE Protection features (that were missing according to Stackoverflow)
- #759 Use the dedicated class instead of var type
- #614, #770 Exemption reason text should not be reused
- #728 Invoice setCorrection causes duplicate XML output
- #776 Fix potential resource leaks in core file processing classes
- #741 read position accountingReference
- #782/771 prevent NullPointerException on Product Description
- #772 TradeParty Name should be optional for ShipToTradeParty
- #775 not deleted tmp files
- #802 fix: capital letter for ID in listID
- #809 invoice reader to support multiple charges per item
- #812 fileattachment relation should have a default
- #818 need exceptions from files validated with validateExpectValid


2.16.3
=======
2025-03-03
- #558 ZUGFeRDInvoiceImporter does not read BankDetails.accountName
- #686 Item: add BillingSpecifiedPeriod
- #739 also parse invoiceperiod from ubl
- #745 be able to specify legalorganisation id without schema
- #747 correct profile detection
- #710 Validation Error due to empty elements
- #712 Correct bracket setting on condition for output of allowance reason.
- #725 Unable to perform XML-oriented attacks
- #685 Security Issue: XXE Vulnerability in ZUGFeRDInvoiceImporter (PR #725)
- #761 Allow to set item allowance/charges from JSON

2.16.2
=======
2025-02-04
- #705 specifiedLogisticsCharge is not imported
- #707 invoiceimporter may fail if certain values are not set
- #708 embedded files cannot be determined
- #709 ZUGFeRDInvoiceImporter ignored "first" embedded file in list of pdf attachments
- #607 Enable flexible PaymentReference and a DocumentName. **Important note:** The library’s behavior for generating ZUGFeRD 2 documents is not fully backward compatible. Except for the “Minimum” profile, BT‑83 was automatically populated with the document number in earlier versions. From this release onward, applications must explicitly set BT‑83.
- #649 Reuse toPDF method to work without any dependencies to the file system
- #650 Add net.sf.offo:fop-hyph
- #665 Fix #632: Return ubl_creditnote as Standard for CreditNotes
- #684 Optimize validation-report to pdf functionality
- #703 Fill TaxExemptionReason during InvoiceImport.
- #701 Ensure Base64 decoding can handle newlines when decoding a FileAttachment
- #691 Fix current check failures.

2.16.1
=======
2025-01-21
- #678 some ubl creditnote attributes are not parsed
- #679 validation of a XR does not ignore whitespace
- #681 IBAN assigned to invoice sender not recipient on direct debit
- #689 incorrect element order when both charge reason and reasoncode are specified
- be able to set detailedDeliveryPeriodFrom, detailedDeliveryPeriodTo MS188
- updated verapdf from 1.26.1 to 1.26.2
- cashDiscount JSON now corrently ignores values for cii and xr methods 

2.16.0
=======
2025-01-10
- #657 allow allowancechargereasoncodes on document level
- allow to add includedNotes with type
- #356 print version of xml report
- #645 Fix visualization of validation logs
- #639 Fix invoice calculation if rounding amount is present
- #633 Bump ch.qos.logback:logback-core from 1.2.13 to 1.5.13
- #626 Fix minor java issues
- #622 Fix FOP config 
- #631  multiple invoice referenced documents
- #629 Visualizing xml
- #630 Fix issue #296 (Validation-Error: Ungültiger Content wurde beginnend mit Element 'ram:DueDateDateTime' ) (duplicate of #565)
- #658 prevent nullpointerexception
- #648 Fix log visualization
- #651 ZUGFeRDInvoiceImporter: Item-Allowances not imported
- #652 Discount VAT is not subtracted from duepayable
- #620 Fix logback config
- #653 ZF2EdgeTest: methods 'getPaymentMeansCode()' & 'getPaymentMeansInformation()' does not override super methods
- #654 remove wrong test methods

2.15.2
=======
2024-12-19
- correcly write charge reason codes also for non-Xrechnung #617
- correctly import additional referenced documents into invoice/corrected setting of attachments from jackson
- corrected parseException structure
- allow 1p0 as potential xmp version number
- #618 import BT-20
- #599 add tax category code for free export
- #600 Fixes a problem where a stream was not safely closed

2.15.1
=======
2024-12-07
- #566 Failed to parse PDF - Could not reproduce the invoice
- closes #579 prepaidamount is only read in UBL
- #581 parse lineTotalAmount, TaxBasisAmount, duePayableAmount
- #576 read lineid, #578 set lineid
- log error ids, be able to access them from context
- #503 import more ubl
- allow jackson to run over more classes, e.g., DirectDebit, bean contructor for direct debit
- allow json in document includedNotes and 
- #591 Import IncludedNotes also on item level
- #595 Treat all fatal XR schematron rules as errors, not as warnings.
- #577 dom4j: exclude all (optional) dependencies to avoid potential conflicts.
- #575 Fix compilation problems.
- #573 Feature/category code
- #601 exceptions in metrics
- #606 also parse BT-25


2.15.0
=======
2024-11-18
- #435 use invoiceimporter as common technical basis also for zugferdimporter 
- also import delivery address
- #527 metrics may raise error on some pdf files
- #517 read product GlobalID
- #380 Added test for input stream validation
- #518 corrently validate more XRechnung versions
- make document charges and allowances serializable
- #523 Verapdf claims PDF-A/3s created witth visualize are invalid
- #530 duedate can not be set directly
- #532 support validation warnings!
- #534 new signature
- #538 Mustang validator always claims PDF is invalid if flavour is PDF/A-3A
- #555 be able to validate ubl credit notes
- when parsing now distinguishing between the parseExceptions StructureException and ArithmetricException
- #554 Import IncludedNotes on invoice extraction 
- #542 Visualize SpecifiedLogisticsServiceCharge 
- #531 Support ZUGFeRD 2.3.2 
- #480 Support netherlands Euro

2.14.2
=======
2024-10-14

- also parse BICs in InvoiceImporter not only IBANs
- #509 CLI currently does not write a logfile
- #505 crash after invoking ZUGFeRD2PullProvider
- #506 Fix POM missing dependencies

2.14.1 
=======
2024-10-06

- #481 also be able to convert XRechnung/UBL to PDF not only CII
- #494 Quantity/Price Decimal Places
- #391 Runden bei Negativwerten
- #491/501 non terminating decimal expansion
- upgraded en16931 cen schematron to 1.3.12 
- #499/500 PDF layout corrections

2.14.0
=======
2024-09-22

- #461 UBL import contacts
- #463 add support for BT-33, i.e. Tradeparty description #463
- #456 Provide a way to set uriUniversalCommunicationId on the TradeParty using JSON deserialization
- #467 Fix test using wrong file
- #468 Fix validator dependencies
- #469 Enable EN16931 schema validation for XRechnung
- #471 Fix LegalOrganisation schemeId
- #473 Fix UnsupportedOperationException in buildNotes
- #476 Add DesignatedProductClassification for SpecifiedTradeProduct
- #482 Fix current validation errors
- #423 can no longer add attachments via cli
- #465 cli version should also be able to combine PDF/A-3 source
- #487 update to zugferd 2.3.0
- #472 Fix logging implementation missing in CLI
- #479 Re-Formatted and re-organized POMs - Part 2


2.13.0
=======
2024-08-28

- Item Attributes and Country of Origin missing on Product.  #420
- Avoid NullPointerException if dueDate is not set.  #441
- support reasoncodes #431 
- Enhance Charges/Allowances with reasonCode. #432
- Fix build warnings from editing and building. #415
- ZUGFeRDVisualizer.toPDF(): generate PDF/A-3b. #400
- allow access to invoice attachments via  ZUGFeRDInvoiceImporter zii.getFileAttachmentsPDF() 
  and XML (zii.getFileAttachmentsXML)
- No interface for required field CreditorReferenceID #436 and
- X-Rechnung direct-debit missing mandatory field BT-90  #370. (langfr)
- refactor(ZUGFeRDVisualizer): improve PDF visualization performance #438
- product creation without description now possible empty description
- filename of embedded file was not xrechnung.xml when using profile xrechnung #452
- allow legalorganisation to have a tradingbusinessname #447 
- JSon deserialization does not work with BankDetails #455
- Fix ClassCastException in CLI (Main.java). #451
- changed additional references by line from String to List and implemented it on Item #454
 
2.12.0
=======
2024-07-20

- support pdf export/visualization to PDF, thanks to Heavenfighter #387 allow embedd fonts from jar-file for pdf creation #388
- Fix #389: ClassCastException: ZUGFeRDExporterFromA3
- jakarta support #372
- Upgrade to PDFBox 3 #373
- Requires Java 11
- #397 Build succeeds but file is unusable on alpine/docker
- #392 CLI: action combine: --ignorefileextension to ignore PDF/A input file errors dosen't work
- for CLI combine, fx is now default
- set profile to XR if XR is imported #395
- Powershell compatibility: added --no-additional-attachments command line option for better batch processing:
  In cmd also --attachments "" worked but in powershell it was hard to figure out that one had to use --attachments '""'
- Be able to validate XRechnung/UBL files #337
- ph-schematron aktualisiert, logback zugungsten log4j entfernt #402
- java.util Logging zugungsten log4j entfernt #407
- ZF extended no longer requires deliverydate #411
- Return all BankDetails from parsed CII xml. Closes #408.
- ubl visualization: do not require ubl namespace prefix #416

2.11.0
=======
2024-05-22

- EN16931 validation 1.3.12 codelists v11 #357
- Fonts removed #358
- xrechnungimporter to read from filename, inputstream
- invoice's getSender/getRecipient() now return tradeparty no IZUGFeRDExportableTradeParty
- (first) IBAN is now parsed into sender's getBankDetails
- zugferdimporter to accept xml files
- UBL importer to also parse contacts
- https://github.com/ZUGFeRD/mustangproject/pull/369
- support inputstreams https://github.com/ZUGFeRD/mustangproject/pull/379
- #314 ZUGFeRDInvoiceImporter additional constructur
- add XML cash discount write support (new class, previously only possible for XRechnung, not ZF Extended, using a manually encoded setPaymentTermDescription) 
- surrendered to XRechnung 3 compromises, e.g. no longer put gross amount if it does not deviate from net
- be able to programmatically access validation messages  https://github.com/ZUGFeRD/mustangproject/pull/382

2.10.0
=======
2023-12-30

- also accept pdf/a3 from inputstream
- closes #354 factur-x 1 from commandline
- support XR 3.0.1 (#343), 
  - i.e. processid
  - set email in tradeparty class
  - empty description remove

2.9.0
=======
2023-11-27

- Missing closing tag in BankDetails when there's no BIC number #339
- ZUGFeRDExporterFromA3 did not set default ZUGFeRD Version
- Have a way to merge to PDF file without knowing if it is A-1 or A-3 #341
- Be able to validate XR 3.0 #347

2.8.0
=======
2023-09-14

- Improvement of included notes #331
- fixes #259 by Heavenfighter
- introduction of --disable-file-logging command line option

2.7.3
=======
2023-06-16

- \#328 parse SpecifiedTradeProduct/SellerAssignedID, SellerOrderReferencedDocument/ram:IssuerAssignedID and BuyerOrderReferencedDocument/ram:IssuerAssignedID in invoiceparser 

2.7.2
=======
2023-06-09

- \#322 support basis quantity in item class, invoice importer
- \#327 expose validation results and location item (thanks to jpep-in) 

2.7.1
=======
2023-05-25

- \#317 (support conversion towards peppol #282)
- \#313 Update CII2UBL library
- https://github.com/ZUGFeRD/mustangproject/pull/315 invoiceimporter constructor for InputStream
- be able to extract data into existing invoice objects

2.7.0
=======
2023-04-17
- support english and french output in factur-x visualization (read: conversion to HTML), UBL invoice and creditnote input+ resolve codelist attributes (thanks to https://jcthiele.github.io/xrechnung-visualization-codelist-resolve/)

2.6.2 "Happy Easter"
=======
2023-04-06

- corrected linux build, fixes Github action
- Issue 308: (be able to) define when VAT collection become applicable #309
- upgraded CEN schematron to v1.3.9
- remove logback.xml in some cases PR #311
- upgrade XRechnung to 2.3 both in default creation+validator


2.6.1
=======
2023-02-13

- return error code not only on validation but also on recursive directory validation
- allow Bank credentials without BIC
- allow minimum profile without delivery date
- allow prepaid amount in invoice class
- toolchain.xml now only required on `mvn release:release` not already on `mvn package`
- upgraded dependencies jackson-databind from 2.13.4.1 to 2.14.2 and xmlunit-assertj from 2.9.0 to 2.9.1

2.6.0 "Joyeux Noël"
=======
2022-12-23

- Allow foreign (e.g., french) trade parties whose addresses only consist of the country
- Allow invoices in minimum profile e.g. hide applicabletradetax, linetotalamount, paymentreference etc in Minimum profile
- due date and delivery date no longer mandatory for credit notes
- invoiceimporter to parse BuyerReference
- support LineThree in TradeParty (BT-165?)
- Corrected forgotten --d CLI shortcut
- No uber jar #297
- automated server tests 
- prevent nullpointerexception https://github.com/ZUGFeRD/mustangproject/pull/302  thanks to weclapp-dev
- lines no longer included in basic-wl and minimum

2.5.7
=======
2022-11-07

- Import of ZF1 invoices (thanks to Stefan Schmaltz https://github.com/ZUGFeRD/mustangproject/pull/292)
- works again in Java 1.8 (#286)
- updated Jackson https://github.com/ZUGFeRD/mustangproject/pull/293
- now also running EN16931 checks on Basic, which apparently is also a CIUS 
- Add getter methods to ZUGFeRDImporter #295

2.5.6
=======
2022-09-22

Removed an unnecessary dependency (ph-jaxb).
Added some javadoc.

2.5.5
=======
2022-09-19

Updated PH-schematron, now also reporting IDs of failed assertions


2.5.4
=======
2022-09-01

Extend importer PR #281 thanks to weclapp-dev
Allow to violate CII-SR-450 and specify both ID and Global ID

2.5.3
=======
2022-08-15

- Support GlobalIDs(schemedIDs) for Tradeparties and products #280
- Dependency update #273

2.5.2
=======
2022-07-09

- Support validation of XRechnung (CII) 2.2
- allow to create fx 1 files with command line again
- is maven build profile to gen xslt, mvn clean package -P generateXSLTFromSchematron
- OXPullprovider to no longer generate invalid XML if a duedate is set
- Add missing encodeXML to node payment terms description #278 thanks to weclapp-dev

2.5.1
=======
2022-05-12

- upgraded en16931 validation to 1.3.8
- Be able to embed/write/read Cross Industry Delivery Advice https://www.gs1-germany.de/gs1-standards/umsetzung/fachpublikationen/detailansicht/der-digitale-lieferschein-dls-die-digitale-abloesung-des-papier-lieferscheins/
- Be able to write UBL 1Lieferschein https://www.bobbie.de/maschinenraum/1lieferschein
- update xr to v. 2.2 (mandatory as of August)
- logging output now stderr again, since 2.4.0 it had mistakenly been on stdout

2.5.0
=======
2022-04-07

- allow to specify additional files to be attached in command line
- update to zf 2.2, apparently this also fixes #268
- update to verapdf 1.20.1 
- log whether a XML or a PDF file was validated
- allow 2.1 in RDF metadata in validation for Referenzprofil XRechnung's v 2.1.1
- XR improvements PR 261 e.g. allowing the XRechnung version to be explicitly set in the PDF
- allow to specify a tradeparties' legalorganisation i.e. allow to write Factur-X invoices to french authorities
- allow to add attachments in CLI. Thanks to AlexGeller1 RE #270
- replaced jargs with apache commons cli as command line parser
- nicer XML  https://github.com/ZUGFeRD/mustangproject/issues/266 thanks to weclapp-dev
- XR now also tests paymenttermdescription(#238)
- allow XRechnung to the Deutsche Bahn: allow to reference a shipping note DespatchAdviceReferencedDocument/IssuerAssignedID #253


2.4.0
=======
2022-01-13

- issue #255 support order-x
- switched xrechnung signature to 2.1(.1) as required as of February 
- xr now checks en16931 profile not extended
- Validation errors now contain the filename of the failed xslt~schematron
- PR 257 issue #227 shaded/lightweight jars (thanks a lot to quadrik!)
- PR 258 Multiple XRechnung improvements like the possibility to set it's version in the PDF metadata (thanks a lot to ivaklinov) 
- add signature comment into xml
- upgraded en16931 validation to 1.3.7
- upgraded xrechnung schematron to 1.6.1
- changed PDF/A extension scheme name from ZUGFeRD to Factur-X
- corrected a possible nullpointerexception in contact.getPhone() vs. getName() (thanks to Chritoph W.)

2.3.3
=======
2021-12-21

- updated logback from 1.2.3 to 1.2.9 https://github.com/ZUGFeRD/mustangproject/security/dependabot/validator/pom.xml/ch.qos.logback:logback-core/open
- nor 2021-12-13 nor 2021-12-20 of https://github.com/mergebase/log4j-detector have complained so far


2.3.2
=======
2021-12-16

- Jacksonability: Invoice and dependent objects can now be Stringified to / restored from a JSON (persistence? XML?) using e.g. Jackson
- Please note Mustang was *not* affected by log4j CVE-2021-44228 or CVE-2021-45046: this is *not* a security update
- unknown root elements will now throw separate errors (type 3)
- added some automated tests
- Remove faulty '/' from getNodeListByPath call. PR #256, Thanks again to Weclapp-dev
- Issue 238 Validierungsproblem mit Skonto/do not remove linebreaks in XML
- Do not trim trailing whitespace in XML submitted by the user, e.g. for XRechnung Skonto in PaymenttermsDescription

2.3.1
=======
2021-10-25

- Add a document type and additional fields #252 (Add documentType PARTIAL_BILLING,  Add invoiceReferencedIssueDate
  Add specifiedProcuringProject) Thanks to Weclapp-dev!
- Added possibility to have multiple referenced documents per line item, also in parser 
- ZugferdInvoideImporter to be able to read XML, not only PDF
- ignore whitespace around numbers in invoiceimporter
- better namespace prefix agnostics in importers

2.3.0
=======
2021-10-04

- support validating XR 2.1 (UN/CEFACT)
- invalid output PDF for input with incomplete CIDsets #249
To prevent regressions it is recommended to re-validate your PDF output after upgrading to 2.3.0
- Upgrade to PDFBox 2.0.24

2.2.1
=======
2021-08-26

- Now supporting specifying ram:BuyerOrderReferencedDocument/LineID in items field BT-132 issue #247
- OX Schema incompat is now type 10
- Upgrade to PDFBox 2.0.23 #233

2.2.0
=======
2021-05-20

- PR #225 exemption reasons only for certain tax category codes thanks to weclapp-dev
- allow 1.2 and 2.0 in RDF versions for XRechnung 2.0 Referenzprofil 
- also use shortcut "t" for extended in zf1 #230
- falscher Text in Exception #237
- pr 240 ignore input pdf errors when specified on command line https://github.com/ZUGFeRD/mustangproject/pull/240
- pr 241 use sepa transfer instead of bank transfer https://github.com/ZUGFeRD/mustangproject/pull/241
- be able to validate Order-X files

2.1.1
=======
2021-02-09

- PR #217 seller order referenced document thanks to weclapp-dev
- PR #218 allow recipient contact in XRechnung thanks to seeeeew
- PR #221 remove outdated dependency thanks to heisej
- PR #223 allow XRechnung without street thanks to murygin
- only deploy library and validator to maven central, not core nor cli
- a correction should reference the original invoice via invoiceReferencedDocument, not buyerOrderReferencedDocument
- upgraded CEN Schematron validation (codes 24) to v1.3.4
- added unit tests for ubl conversion and visualization

2.1.0
=======
2021-01-19
- support CII to UBL conversion (thanks to https://github.com/phax/en16931-cii2ubl)
- make  IExportableTransaction.getZFAllowances() getZFCharges() and getZFLogisticsServiceCharges() and item.getItemAllowances, item.getItemCharges optional, correct getCurrency optionality
  make IZUGFeRDExportableTradeParty name id zip location street mandatory
- fixed a charge/allowance rounding error #212 
- Corrected intra community supply tax exemption category code
- removal of Tradeparty.getZip in favor of getZIP (as it's also setZIP) to avoid jackson errors

2.0.3
=======
2020-12-06

- #201 correct embedded files in XRechnung
- transaction calculator getGrandTotal now public
- corrected sample in docs thanks to tweimer PR #204
- don't write "null" as paymentDescription if no Bank account is specified
- generic and unitcode/categorycode improvements (thanks to weclapp-dev) PR #207
- programmatically switch to XRechnung 2.0 if invoked next year
- support Credit Notes (additionally to corrected invoices)

2.0.2
=======
2020-11-25

- #197 file attachments
- Charges/Allowances CategoryCode improvement PR #198 Thanks to weclapp-dev
- support reverse charge
- support intra community supply also in product class, not only interface

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
- occurrence periods  setOccurrencePeriod(Date start, Date end)
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
- allow for different namespace prefixes #140
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


