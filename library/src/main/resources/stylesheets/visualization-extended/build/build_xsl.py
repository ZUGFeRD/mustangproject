#!/usr/bin/env python3
"""Erzeugt ../ZUGFeRD_EXTENDED_html.xsl (HTML) und ../ZUGFeRD_EXTENDED_fo.xsl (XSL-FO/PDF)
aus template_html.xsl bzw. template_fo.xsl; beide erhalten den gemeinsamen Teil
aus common.xsl (an der Markierung @@COMMON@@).

Eingebettet werden
  * Beschriftungen (DE/EN/FR) für alle Elemente des EXTENDED-Schemas (unten gepflegt),
  * Codelisten (EN/FR aus "1_FACTUR-X 1.09.2 - EN FR.xlsx", DE/FR-Ergänzungen unten),
  * Zuordnung XPath -> BT/BG-Kennung (aus dem Blatt "Factur-X CII D22B EXTENDED").

Aufruf:  python build_xsl.py   (benötigt openpyxl)

OriginalPrompt: referenz ist in "ZUGFeRD_2.5.2_DE\Dokumentation\7_ZUGFeRD_2.5.2_Technischer_Anhang_Profil_EXTENDED.pdf"
schema und schematron in ZUGFeRD_2.5.2_DE\Schema\4_Factur-X_1.09.2_EXTENDED beispiele in
ZUGFeRD_2.5.2_DE\Beispiele\4. EXTENDED erstelle eine XSLT-Visualisierung die zugferd extended xml in deutsches,
englisches oder französisches HTML umwandelt

"""
import os
import re
import sys
from xml.sax.saxutils import quoteattr

import openpyxl

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, "..", ".."))
XLSX = os.path.join(ROOT, "Dokumentation", "1_FACTUR-X 1.09.2 - EN FR.xlsx")
COMMON = os.path.join(HERE, "common.xsl")
TEMPLATES = [  # (Vorlage, Ausgabe)
    (os.path.join(HERE, "template_html.xsl"), os.path.join(HERE, "..", "ZUGFeRD_EXTENDED_html.xsl")),
    (os.path.join(HERE, "template_fo.xsl"), os.path.join(HERE, "..", "ZUGFeRD_EXTENDED_fo.xsl")),
]

# ---------------------------------------------------------------------------
# Beschriftungen: Schlüssel | Deutsch | Englisch | Französisch
#   Schlüssel = Elementname, "Eltern/Element", "Gruppe/Element"
#   (Gruppen: TradeParty, ReferencedDocument, TradeTax, ProductTradePrice),
#   "Eltern/Element@schemeID", "Element#true|false" (ChargeIndicator) oder ui.*
# ---------------------------------------------------------------------------
LABELS = r"""
ui.invoice|Rechnung|Invoice|Facture
ui.docno|Nr.|No.|N°
ui.invdate|Rechnungsdatum|Invoice date|Date de facture
ui.deliverydate|Liefer-/Leistungsdatum|Delivery date|Date de livraison
ui.period|Abrechnungszeitraum|Invoicing period|Période de facturation
ui.duedate|Fällig am|Due date|Date d'échéance
ui.orderno|Bestellnummer|Purchase order|Numéro de commande
ui.general|Allgemeine Angaben|General information|Informations générales
ui.profile|Profil|Profile|Profil
ui.notes|Bemerkungen|Notes|Notes
ui.parties|Weitere Beteiligte|Other parties|Autres intervenants
ui.refs|Referenzen|References|Références
ui.document|Dokument|Document|Document
ui.number|Nummer|Number|Numéro
ui.lineref|Position|Line|Ligne
ui.date|Datum|Date|Date
ui.moreinfo|Weitere Angaben|Further information|Informations complémentaires
ui.lines|Rechnungspositionen|Invoice lines|Lignes de facture
ui.pos|Pos.|Line|Ligne
ui.item|Bezeichnung|Description|Désignation
ui.qty|Menge|Quantity|Quantité
ui.unit|Einheit|Unit|Unité
ui.unitprice|Einzelpreis netto|Net unit price|Prix unitaire HT
ui.vat|USt.|VAT|TVA
ui.linenet|Gesamt netto|Net amount|Montant HT
ui.linedetails|Alle Angaben zur Position|All line details|Tous les détails de la ligne
ui.partof|Unterposition von Pos.|Sub-line of line|Sous-ligne de la ligne
ui.gross|Brutto|Gross|Brut
ui.of|von|of|de
ui.allowances|Zu- und Abschläge auf Dokumentebene|Document level allowances and charges|Remises et charges au niveau du document
ui.kind|Art|Type|Type
ui.reason|Grund|Reason|Motif
ui.basis|Basisbetrag|Base amount|Montant de base
ui.amount|Betrag|Amount|Montant
ui.description|Beschreibung|Description|Description
ui.logistics|Logistikgebühren|Logistics service charges|Frais de service logistique
ui.vatbreakdown|Umsatzsteueraufschlüsselung|VAT breakdown|Ventilation de la TVA
ui.category|Kategorie|Category|Catégorie
ui.rate|Steuersatz|Rate|Taux
ui.taxbase|Bemessungsgrundlage|Taxable amount|Base d'imposition
ui.taxamount|Steuerbetrag|Tax amount|Montant de la taxe
ui.payment|Zahlungsinformationen|Payment information|Informations de paiement
ui.furthersettlement|Weitere Abrechnungsangaben|Further settlement information|Autres informations de règlement
ui.download|Herunterladen|Download|Télécharger
ui.true|Ja|Yes|Oui
ui.false|Nein|No|Non
ui.week|KW|Week|Semaine
ui.showbt|BT-Kennungen|BT IDs|ID BT
ui.testbanner|Testrechnung – nicht zur Zahlung|Test invoice – not for payment|Facture de test – ne pas payer
ui.copybanner|Kopie|Copy|Copie
ui.page|Seite|Page|Page
ui.pageof|von|of|sur
ui.embedded|im PDF eingebettet|embedded in this PDF|intégré à ce PDF
ui.footer|Automatisch erzeugte Darstellung der strukturierten Rechnungsdaten|Automatically generated view of the structured invoice data|Représentation générée automatiquement des données structurées de la facture
ui.version|Extended-Visualisierung Version 1.0|Extended visualization version 1.0|Visualisation Extended version 1.0
ui.nocii|Das Dokument ist keine ZUGFeRD/Factur-X-Rechnung (rsm:CrossIndustryInvoice).|The document is not a ZUGFeRD/Factur-X invoice (rsm:CrossIndustryInvoice).|Le document n'est pas une facture ZUGFeRD/Factur-X (rsm:CrossIndustryInvoice).

ExchangedDocumentContext|Dokumentkontext|Document context|Contexte du document
TestIndicator|Testkennzeichen|Test indicator|Indicateur de test
BusinessProcessSpecifiedDocumentContextParameter/ID|Geschäftsprozess|Business process type|Type de processus métier
GuidelineSpecifiedDocumentContextParameter/ID|Spezifikationskennung|Specification identifier|Identifiant de spécification
BusinessProcessSpecifiedDocumentContextParameter|Geschäftsprozess|Business process|Processus métier
GuidelineSpecifiedDocumentContextParameter|Spezifikation|Specification|Spécification
ExchangedDocument|Dokument|Document|Document
ExchangedDocument/ID|Rechnungsnummer|Invoice number|Numéro de facture
ExchangedDocument/Name|Dokumentenname|Document name|Nom du document
ExchangedDocument/TypeCode|Dokumentart|Invoice type|Type de facture
IssueDateTime|Rechnungsdatum|Invoice issue date|Date d'émission
CopyIndicator|Kopie|Copy|Copie
LanguageID|Sprache|Language|Langue
IncludedNote|Bemerkung|Note|Note
Content|Text|Text|Texte
ContentCode|Textbaustein|Content code|Code de contenu
SubjectCode|Betreff|Subject code|Objet
EffectiveSpecifiedPeriod|Vertragliches Fälligkeitsdatum|Contractual due date|Date d'échéance contractuelle
EffectiveSpecifiedPeriod/CompleteDateTime|Vertragliches Fälligkeitsdatum|Contractual due date|Date d'échéance contractuelle
CompleteDateTime|Zeitpunkt|Date|Date
SupplyChainTradeTransaction|Handelsgeschäft|Trade transaction|Transaction commerciale

IncludedSupplyChainTradeLineItem|Rechnungsposition|Invoice line|Ligne de facture
AssociatedDocumentLineDocument|Positionsangaben|Line information|Informations de ligne
LineID|Position|Line ID|Identifiant de ligne
AssociatedDocumentLineDocument/LineID|Positionsnummer|Invoice line identifier|Identifiant de ligne de facture
ReferencedDocument/LineID|Referenzierte Position|Referenced line|Ligne référencée
ParentLineID|Übergeordnete Position|Parent line|Ligne parente
LineStatusCode|Positionsstatus|Line status|Statut de la ligne
LineStatusReasonCode|Positionsart|Line type|Type de ligne
SpecifiedTradeProduct|Artikel|Item information|Informations sur l'article
ID|Kennung|Identifier|Identifiant
GlobalID|Globale Kennung|Global identifier|Identifiant global
SpecifiedTradeProduct/ID|Artikelkennung|Item identifier|Identifiant de l'article
SpecifiedTradeProduct/GlobalID|Standardkennung (z. B. GTIN)|Item standard identifier|Identifiant standard de l'article
SellerAssignedID|Art.-Nr. Verkäufer|Seller's item ID|Réf. vendeur
BuyerAssignedID|Art.-Nr. Käufer|Buyer's item ID|Réf. acheteur
IndustryAssignedID|Branchenkennung|Industry assigned ID|Identifiant sectoriel
ModelID|Modellkennung|Model ID|Identifiant du modèle
Name|Name|Name|Nom
SpecifiedTradeProduct/Name|Artikelname|Item name|Nom de l'article
Description|Beschreibung|Description|Description
BatchID|Chargennummer|Batch (lot) ID|Numéro de lot
BrandName|Marke|Brand name|Marque
ModelName|Modellname|Model name|Nom du modèle
ApplicableProductCharacteristic|Artikelmerkmal|Item attribute|Caractéristique de l'article
ApplicableProductCharacteristic/Description|Merkmal|Attribute name|Caractéristique
ApplicableProductCharacteristic/Value|Wert|Attribute value|Valeur
ApplicableProductCharacteristic/TypeCode|Merkmalsart|Attribute type|Type de caractéristique
ValueMeasure|Messwert|Measured value|Valeur mesurée
DesignatedProductClassification|Artikelklassifizierung|Item classification|Classification de l'article
ClassCode|Klassifizierungscode|Classification code|Code de classification
ClassName|Klassifizierung|Classification name|Nom de la classification
IndividualTradeProductInstance|Artikelinstanz|Item instance|Instance de l'article
SupplierAssignedSerialID|Seriennummer|Serial number|Numéro de série
OriginTradeCountry|Ursprungsland|Country of origin|Pays d'origine
OriginTradeCountry/ID|Ursprungsland|Country of origin|Pays d'origine
IncludedReferencedProduct|Enthaltener Artikel|Included item|Produit inclus
UnitQuantity|Enthaltene Menge|Included quantity|Quantité incluse

SpecifiedLineTradeAgreement|Vertragsangaben zur Position|Line trade agreement|Accord commercial de la ligne
SpecifiedLineTradeDelivery|Lieferangaben zur Position|Line delivery|Livraison de la ligne
SpecifiedLineTradeSettlement|Abrechnungsangaben zur Position|Line settlement|Règlement de la ligne
ApplicableTradeDeliveryTerms|Lieferbedingungen|Delivery terms|Conditions de livraison
DeliveryTypeCode|Lieferbedingung|Delivery terms code|Code des conditions de livraison
RelevantTradeLocation|Ort der Lieferbedingung|Delivery terms location|Lieu des conditions de livraison
SellerOrderReferencedDocument|Auftragsbestätigung|Sales order|Commande vendeur
BuyerOrderReferencedDocument|Bestellung|Purchase order|Bon de commande
QuotationReferencedDocument|Angebot|Quotation|Devis
ContractReferencedDocument|Vertrag|Contract|Contrat
AdditionalReferencedDocument|Rechnungsbegründendes Dokument|Supporting document|Document justificatif
UltimateCustomerOrderReferencedDocument|Bestellung des Endkunden|Ultimate customer order|Commande du client final
DespatchAdviceReferencedDocument|Lieferavis|Despatch advice|Avis d'expédition
ReceivingAdviceReferencedDocument|Wareneingangsmeldung|Receiving advice|Avis de réception
DeliveryNoteReferencedDocument|Lieferschein|Delivery note|Bon de livraison
InvoiceReferencedDocument|Vorausgegangene Rechnung|Preceding invoice|Facture antérieure
InvoiceSpecifiedReferencedDocument|Anzahlungsrechnung|Advance payment invoice|Facture d'acompte
IssuerAssignedID|Dokumentnummer|Document number|Numéro de document
URIID|URI|URI|URI
ReferencedDocument/URIID|Externe Fundstelle|External document location|Emplacement externe
TypeCode|Art|Type code|Code de type
ReferencedDocument/TypeCode|Dokumentart|Document type|Type de document
ReferencedDocument/Name|Beschreibung|Description|Description
AttachmentBinaryObject|Anhang|Attachment|Pièce jointe
ReferenceTypeCode|Referenzart|Reference type|Type de référence
FormattedIssueDateTime|Dokumentdatum|Document date|Date du document

GrossPriceProductTradePrice|Bruttopreis|Gross price|Prix brut
NetPriceProductTradePrice|Nettopreis|Net price|Prix net
ChargeAmount|Preis|Price|Prix
GrossPriceProductTradePrice/ChargeAmount|Bruttopreis|Item gross price|Prix brut
NetPriceProductTradePrice/ChargeAmount|Nettopreis|Item net price|Prix net
BasisQuantity|Basismenge|Base quantity|Quantité de base
ProductTradePrice/BasisQuantity|Preisbasismenge|Item price base quantity|Quantité de base du prix
AppliedTradeAllowanceCharge|Preisnachlass oder -zuschlag|Price allowance or charge|Remise ou majoration sur prix
AppliedTradeAllowanceCharge#false|Preisnachlass|Item price discount|Remise sur prix
AppliedTradeAllowanceCharge#true|Preiszuschlag|Item price charge|Majoration sur prix
SpecifiedTradeAllowanceCharge|Zu- oder Abschlag|Allowance or charge|Remise ou charge
SpecifiedTradeAllowanceCharge#false|Abschlag|Allowance|Remise
SpecifiedTradeAllowanceCharge#true|Zuschlag|Charge|Charge
ChargeIndicator|Zuschlag|Charge indicator|Indicateur de charge
SequenceNumeric|Berechnungsreihenfolge|Calculation sequence|Ordre de calcul
CalculationPercent|Prozentsatz|Percentage|Pourcentage
BasisAmount|Basisbetrag|Base amount|Montant de base
ActualAmount|Betrag|Amount|Montant
ReasonCode|Grund (Code)|Reason code|Code du motif
Reason|Grund|Reason|Motif
CategoryTradeTax|Umsatzsteuer|VAT|TVA
IncludedTradeTax|Enthaltene Steuer|Included tax|Taxe incluse
AppliedTradeTax|Umsatzsteuer|VAT|TVA
ApplicableTradeTax|Umsatzsteuer|VAT|TVA
CalculatedAmount|Steuerbetrag|Tax amount|Montant de la taxe
TradeTax/TypeCode|Steuerart|Tax type|Type de taxe
TradeTax/BasisAmount|Bemessungsgrundlage|Taxable amount|Base d'imposition
ExemptionReason|Befreiungsgrund|Exemption reason|Motif d'exonération
ExemptionReasonCode|Befreiungsgrund (Code)|Exemption reason code|Code du motif d'exonération
CategoryCode|Umsatzsteuerkategorie|VAT category|Catégorie de TVA
RateApplicablePercent|Steuersatz|VAT rate|Taux de TVA
LineTotalBasisAmount|Positionssumme (Basis)|Line total basis amount|Total des lignes (base)
AllowanceChargeBasisAmount|Zu-/Abschläge (Basis)|Allowance/charge basis amount|Remises/charges (base)
TaxPointDate|Steuerfälligkeit|Tax point date|Date d'exigibilité de la TVA
DueDateTypeCode|Steuerfälligkeit (Code)|Tax point date code|Code d'exigibilité de la TVA

BilledQuantity|Menge|Invoiced quantity|Quantité facturée
ChargeFreeQuantity|Menge ohne Berechnung|Charge-free quantity|Quantité gratuite
PackageQuantity|Anzahl Packstücke|Package quantity|Nombre de colis
PerPackageUnitQuantity|Menge je Packstück|Quantity per package|Quantité par colis
ActualDeliverySupplyChainEvent|Lieferung|Delivery|Livraison
OccurrenceDateTime|Lieferdatum|Actual delivery date|Date de livraison effective
ActualDeliverySupplyChainEvent/OccurrenceDateTime|Liefer-/Leistungsdatum|Actual delivery date|Date de livraison effective
BillingSpecifiedPeriod|Abrechnungszeitraum|Invoicing period|Période de facturation
StartDateTime|Beginn|Start date|Date de début
EndDateTime|Ende|End date|Date de fin
SpecifiedTradeSettlementLineMonetarySummation|Positionssummen|Line totals|Totaux de la ligne
SpecifiedTradeSettlementLineMonetarySummation/LineTotalAmount|Nettobetrag der Position|Line net amount|Montant net de la ligne
LineTotalAmount|Nettobetrag|Net amount|Montant net
ChargeTotalAmount|Summe Zuschläge|Sum of charges|Total des charges
AllowanceTotalAmount|Summe Abschläge|Sum of allowances|Total des remises
TaxTotalAmount|Umsatzsteuer gesamt|Total VAT amount|Montant total de TVA
GrandTotalAmount|Gesamtbetrag|Total amount|Montant total
TotalAllowanceChargeAmount|Summe Zu-/Abschläge|Total allowances/charges|Total remises/charges
ReceivableSpecifiedTradeAccountingAccount|Buchungskonto|Accounting account|Compte comptable
ReceivableSpecifiedTradeAccountingAccount/ID|Kontierung des Käufers|Buyer accounting reference|Référence comptable de l'acheteur
ReceivableSpecifiedTradeAccountingAccount/TypeCode|Kontoart|Account type|Type de compte

ApplicableHeaderTradeAgreement|Vertragsangaben|Trade agreement|Accord commercial
BuyerReference|Käuferreferenz / Leitweg-ID|Buyer reference|Référence acheteur
SpecifiedProcuringProject|Projekt|Project reference|Référence de projet
SpecifiedProcuringProject/ID|Projektnummer|Project ID|Identifiant du projet
SpecifiedProcuringProject/Name|Projektname|Project name|Nom du projet
ApplicableHeaderTradeDelivery|Lieferangaben|Delivery information|Informations de livraison
RelatedSupplyChainConsignment|Sendung|Consignment|Envoi
SpecifiedLogisticsTransportMovement|Transport|Transport|Transport
ModeCode|Verkehrszweig|Transport mode|Mode de transport
ApplicableHeaderTradeSettlement|Abrechnungsangaben|Settlement|Règlement
CreditorReferenceID|Gläubiger-ID|Creditor identifier|Identifiant créancier SEPA
PaymentReference|Verwendungszweck|Remittance information|Référence de paiement
TaxCurrencyCode|Steuerwährung|VAT accounting currency|Devise de comptabilisation de la TVA
InvoiceCurrencyCode|Rechnungswährung|Invoice currency|Devise de facturation
InvoiceIssuerReference|Referenz des Rechnungsstellers|Invoice issuer reference|Référence de l'émetteur
TaxApplicableTradeCurrencyExchange|Währungsumrechnung|Currency exchange|Conversion de devise
SourceCurrencyCode|Ausgangswährung|Source currency|Devise source
TargetCurrencyCode|Zielwährung|Target currency|Devise cible
ConversionRate|Umrechnungskurs|Exchange rate|Taux de change
ConversionRateDateTime|Kursdatum|Exchange rate date|Date du taux de change

SpecifiedTradeSettlementPaymentMeans|Zahlungsart|Payment means|Moyen de paiement
SpecifiedTradeSettlementPaymentMeans/TypeCode|Zahlungsart|Payment means|Moyen de paiement
Information|Erläuterung|Payment means text|Libellé du moyen de paiement
ApplicableTradeSettlementFinancialCard|Zahlungskarte|Payment card|Carte de paiement
ApplicableTradeSettlementFinancialCard/ID|Kartennummer|Card number|Numéro de carte
CardholderName|Karteninhaber|Cardholder name|Titulaire de la carte
PayerPartyDebtorFinancialAccount|Zu belastendes Konto|Debited account|Compte à débiter
PayeePartyCreditorFinancialAccount|Bankverbindung|Payment account|Compte de paiement
IBANID|IBAN|IBAN|IBAN
AccountName|Kontoinhaber|Account name|Titulaire du compte
ProprietaryID|Nationale Kontonummer|National account number|Numéro de compte national
PayerSpecifiedDebtorFinancialInstitution|Bank des Zahlungspflichtigen|Payer's bank|Banque du payeur
PayeeSpecifiedCreditorFinancialInstitution|Bank des Zahlungsempfängers|Payee's bank|Banque du bénéficiaire
BICID|BIC|BIC|BIC
SpecifiedLogisticsServiceCharge|Logistikgebühr|Logistics service charge|Frais de service logistique
AppliedAmount|Betrag|Amount|Montant
SpecifiedTradePaymentTerms|Zahlungsbedingungen|Payment terms|Conditions de paiement
SpecifiedTradePaymentTerms/Description|Zahlungsbedingungen|Payment terms|Conditions de paiement
DueDateDateTime|Fälligkeitsdatum|Payment due date|Date d'échéance
DirectDebitMandateID|Mandatsreferenz|Mandate reference|Référence du mandat
PartialPaymentAmount|Teilzahlungsbetrag|Partial payment amount|Montant du paiement partiel
ApplicableTradePaymentPenaltyTerms|Verzugszuschlag|Payment penalty terms|Pénalités de retard
ApplicableTradePaymentDiscountTerms|Skonto|Payment discount terms|Escompte
BasisDateTime|Basisdatum|Base date|Date de référence
BasisPeriodMeasure|Frist|Period|Délai
ActualDiscountAmount|Skontobetrag|Discount amount|Montant de l'escompte
ActualPenaltyAmount|Zuschlagsbetrag|Penalty amount|Montant de la pénalité
ApplicableTradePaymentDiscountTerms/CalculationPercent|Skontosatz|Discount percentage|Taux d'escompte
ApplicableTradePaymentPenaltyTerms/CalculationPercent|Zuschlagssatz|Penalty percentage|Taux de pénalité

SpecifiedTradeSettlementHeaderMonetarySummation|Summen|Document totals|Totaux du document
SpecifiedTradeSettlementHeaderMonetarySummation/LineTotalAmount|Summe der Positionen|Sum of invoice line net amounts|Total des lignes HT
TaxBasisTotalAmount|Gesamtbetrag ohne USt.|Invoice total without VAT|Total HT
SpecifiedTradeSettlementHeaderMonetarySummation/TaxTotalAmount|Umsatzsteuer|VAT total|Total TVA
RoundingAmount|Rundungsbetrag|Rounding amount|Montant d'arrondi
SpecifiedTradeSettlementHeaderMonetarySummation/GrandTotalAmount|Gesamtbetrag inkl. USt.|Invoice total with VAT|Total TTC
TotalPrepaidAmount|Bereits gezahlt|Paid amount|Montant déjà payé
DuePayableAmount|Zahlbetrag|Amount due for payment|Montant à payer
SpecifiedFinancialAdjustment|Finanzielle Anpassung|Financial adjustment|Ajustement financier
SpecifiedAdvancePayment|Anzahlung|Advance payment|Acompte
PaidAmount|Gezahlter Betrag|Paid amount|Montant payé
FormattedReceivedDateTime|Zahlungseingang|Date received|Date de réception
SpecifiedAdvancePayment/IncludedTradeTax|Enthaltene Umsatzsteuer|Included VAT|TVA incluse

SellerTradeParty|Verkäufer|Seller|Vendeur
BuyerTradeParty|Käufer|Buyer|Acheteur
SalesAgentTradeParty|Handelsvertreter|Sales agent|Agent commercial
BuyerTaxRepresentativeTradeParty|Steuervertreter des Käufers|Buyer tax representative|Représentant fiscal de l'acheteur
SellerTaxRepresentativeTradeParty|Steuervertreter des Verkäufers|Seller tax representative|Représentant fiscal du vendeur
ProductEndUserTradeParty|Endverbraucher|Product end user|Utilisateur final
BuyerAgentTradeParty|Einkaufsvertreter|Buyer agent|Mandataire de l'acheteur
ShipToTradeParty|Warenempfänger|Deliver to party|Destinataire de la livraison
UltimateShipToTradeParty|Endempfänger|Ultimate ship-to party|Destinataire final
ShipFromTradeParty|Versender|Ship-from party|Expéditeur
InvoicerTradeParty|Rechnungsaussteller|Invoicer|Émetteur de la facture
InvoiceeTradeParty|Rechnungsempfänger|Invoicee|Destinataire de la facture
PayeeTradeParty|Zahlungsempfänger|Payee|Bénéficiaire
PayerTradeParty|Zahlungspflichtiger|Payer|Payeur
ItemSellerTradeParty|Verkäufer der Position|Item seller|Vendeur de l'article
ManufacturerTradeParty|Hersteller|Manufacturer|Fabricant
TradeParty/ID|Kennung|Identifier|Identifiant
TradeParty/GlobalID|Globale Kennung|Global identifier|Identifiant global
TradeParty/Name|Name|Name|Nom
TradeParty/Description|Weitere rechtliche Informationen|Additional legal information|Informations juridiques complémentaires
RoleCode|Rolle|Role|Rôle
SpecifiedLegalOrganization|Registrierung|Legal registration|Immatriculation
SpecifiedLegalOrganization/ID|Registernummer|Legal registration ID|Numéro d'immatriculation
TradingBusinessName|Handelsname|Trading name|Nom commercial
SpecifiedLegalOrganization/PostalTradeAddress|Anschrift laut Register|Registered address|Adresse du siège
PostalTradeAddress|Anschrift|Postal address|Adresse postale
PostcodeCode|Postleitzahl|Post code|Code postal
LineOne|Adresszeile 1|Address line 1|Ligne d'adresse 1
LineTwo|Adresszeile 2|Address line 2|Ligne d'adresse 2
LineThree|Adresszeile 3|Address line 3|Ligne d'adresse 3
CityName|Ort|City|Ville
CountryID|Land|Country|Pays
CountrySubDivisionName|Region|Country subdivision|Subdivision du pays
DefinedTradeContact|Kontakt|Contact|Contact
PersonName|Ansprechpartner|Contact person|Personne à contacter
DepartmentName|Abteilung|Department|Service
DefinedTradeContact/TypeCode|Kontaktart|Contact type|Type de contact
TelephoneUniversalCommunication|Telefon|Telephone|Téléphone
FaxUniversalCommunication|Fax|Fax|Fax
EmailURIUniversalCommunication|E-Mail|E-mail|E-mail
URIUniversalCommunication|Elektronische Adresse|Electronic address|Adresse électronique
TelephoneUniversalCommunication/CompleteNumber|Telefon|Telephone|Téléphone
FaxUniversalCommunication/CompleteNumber|Fax|Fax|Fax
EmailURIUniversalCommunication/URIID|E-Mail|E-mail|E-mail
URIUniversalCommunication/URIID|Elektronische Adresse|Electronic address|Adresse électronique
CompleteNumber|Nummer|Number|Numéro
SpecifiedTaxRegistration|Steuerregistrierung|Tax registration|Immatriculation fiscale
SpecifiedTaxRegistration/ID|Steuerregistrierung|Tax registration|Immatriculation fiscale
SpecifiedTaxRegistration/ID@VA|USt-IdNr.|VAT identifier|Numéro de TVA intracommunautaire
SpecifiedTaxRegistration/ID@FC|Steuernummer|Tax registration identifier|Identifiant fiscal
"""

# ---------------------------------------------------------------------------
# Codelisten-Ergänzungen: Liste | Code | Deutsch | Französisch (| Englisch)
# EN/FR kommen sonst aus der Excel-Datei; fehlt eine Sprache, wird EN verwendet.
# ---------------------------------------------------------------------------
CODES = r"""
1001|71|Zahlungsanforderung|Demande de paiement
1001|80|Belastungsanzeige (Waren/Dienstleistungen)|Note de débit (biens ou services)
1001|81|Gutschriftsanzeige (Waren/Dienstleistungen)|Avoir (biens ou services)
1001|82|Rechnung über Verbrauchsleistungen|Facture de services mesurés
1001|83|Gutschrift (Finanzkorrektur)|Avoir (ajustements financiers)
1001|84|Belastungsanzeige (Finanzkorrektur)|Note de débit (ajustements financiers)
1001|102|Steuerbescheid|Avis d'imposition
1001|130|Rechnungsdatenblatt|Fiche de données de facturation
1001|202|Direkte Zahlungsbewertung|Évaluation de paiement direct
1001|203|Vorläufige Zahlungsbewertung|Évaluation de paiement provisoire
1001|204|Zahlungsbewertung|Évaluation de paiement
1001|211|Abschlagszahlungsanforderung|Demande de paiement intermédiaire
1001|218|Schlusszahlungsanforderung nach Fertigstellung|Demande de paiement final après achèvement
1001|219|Zahlungsanforderung für fertiggestellte Einheiten|Demande de paiement pour unités achevées
1001|261|Selbst ausgestellte Gutschrift|Avoir autofacturé
1001|262|Sammelgutschrift|Avoir récapitulatif
1001|295|Preisänderungsrechnung|Facture de révision de prix
1001|296|Gutschrift wegen Preisänderung|Avoir pour révision de prix
1001|308|Delkredere-Gutschrift|Avoir ducroire
1001|325|Proformarechnung|Facture pro forma
1001|326|Teilrechnung|Facture partielle
1001|331|Handelsrechnung mit Packliste|Facture commerciale avec liste de colisage
1001|380|Rechnung|Facture
1001|381|Gutschrift|Avoir
1001|382|Provisionsabrechnung|Note de commission
1001|383|Belastungsanzeige|Note de débit
1001|384|Rechnungskorrektur|Facture rectificative
1001|385|Sammelrechnung|Facture récapitulative
1001|386|Vorauszahlungsrechnung|Facture d'acompte
1001|387|Mietrechnung|Facture de location
1001|388|Steuerrechnung|Facture fiscale
1001|389|Selbst ausgestellte Rechnung (Gutschriftsverfahren)|Autofacture
1001|390|Delkredere-Rechnung|Facture ducroire
1001|393|Factoring-Rechnung|Facture affacturée
1001|394|Leasingrechnung|Facture de crédit-bail
1001|395|Konsignationsrechnung|Facture de consignation
1001|396|Factoring-Gutschrift|Avoir affacturé
1001|420|OCR-Zahlungsgutschrift|Avoir de paiement OCR
1001|456|Belastungsanzeige (Bank)|Avis de débit
1001|457|Storno einer Belastung|Annulation de débit
1001|458|Storno einer Gutschrift|Annulation de crédit
1001|471|Selbst ausgestellte Rechnungskorrektur|Facture rectificative autofacturée
1001|472|Factoring-Rechnungskorrektur|Facture rectificative affacturée
1001|473|Selbst ausgestellte Factoring-Rechnungskorrektur|Facture rectificative autofacturée affacturée
1001|500|Selbst ausgestellte Vorauszahlungsrechnung|Facture d'acompte autofacturée
1001|501|Selbst ausgestellte Factoring-Rechnung|Autofacture affacturée
1001|502|Selbst ausgestellte Factoring-Gutschrift|Avoir autofacturé affacturé
1001|503|Gutschrift zur Vorauszahlungsrechnung|Avoir sur facture d'acompte
1001|527|Selbst ausgestellte Belastungsanzeige|Note de débit autofacturée
1001|532|Gutschrift des Spediteurs|Avoir du transitaire
1001|553|Abweichungsbericht zur Speditionsrechnung|Rapport d'écart sur facture du transitaire
1001|575|Versicherungsrechnung|Facture d'assureur
1001|623|Speditionsrechnung|Facture du transitaire
1001|633|Hafengebührenrechnung|Documents de frais portuaires
1001|751|Rechnungsinformation für Buchungszwecke|Information de facture pour comptabilisation
1001|780|Frachtrechnung|Facture de fret
1001|817|Schadensmeldung|Notification de sinistre
1001|870|Konsulatsfaktura|Facture consulaire
1001|875|Abschlagsrechnung (Bauleistung)|Facture de situation (travaux)
1001|876|Teilschlussrechnung (Bauleistung)|Facture de situation finale partielle (travaux)
1001|877|Schlussrechnung (Bauleistung)|Facture finale (travaux)
1001|935|Zollrechnung|Facture douanière
1001|916|Referenzdokument|Document de référence|Related document
1001|50|Ausschreibung oder Los|Appel d'offres ou lot|Validated pricing tender (tender or lot)

5305|S|Normalsatz|Taux normal
5305|Z|Nullsatz|Taux zéro
5305|E|Steuerbefreit|Exonéré de TVA
5305|AE|Umkehrung der Steuerschuldnerschaft (Reverse Charge)|Autoliquidation
5305|K|Innergemeinschaftliche Lieferung (steuerfrei)|Livraison intracommunautaire exonérée
5305|G|Steuerfreie Ausfuhr|Exportation hors UE exonérée
5305|O|Nicht steuerbar|Hors du champ d'application de la TVA
5305|L|Kanarische Inseln (IGIC)|Impôt général indirect des îles Canaries
5305|M|Ceuta und Melilla (IPSI)|Taxe de production, services et importation (Ceuta et Melilla)

5153|VAT|Umsatzsteuer|Taxe sur la valeur ajoutée

4461|1|Nicht definiert|Instrument non défini
4461|10|Barzahlung|Espèces
4461|20|Scheck|Chèque
4461|30|Überweisung|Virement
4461|31|Lastschrift (nicht SEPA)|Débit
4461|42|Zahlung auf Bankkonto|Paiement sur compte bancaire
4461|48|Bankkarte|Carte bancaire
4461|49|Lastschrift|Prélèvement
4461|54|Kreditkarte|Carte de crédit
4461|55|Debitkarte|Carte de débit
4461|57|Dauerauftrag|Accord permanent
4461|58|SEPA-Überweisung|Virement SEPA
4461|59|SEPA-Lastschrift|Prélèvement SEPA
4461|68|Online-Zahlungsdienst|Service de paiement en ligne
4461|97|Verrechnung zwischen Partnern|Compensation entre partenaires
4461|ZZZ|Gegenseitig vereinbart|Défini d'un commun accord

5189|41|Bonus für vorzeitige Fertigstellung|Prime pour travaux en avance
5189|42|Sonstiger Bonus|Autre prime
5189|60|Herstellerrabatt für Verbraucher|Remise fabricant au consommateur
5189|62|Rabatt wegen Militärstatus|Remise statut militaire
5189|63|Rabatt wegen Arbeitsunfall|Remise accident du travail
5189|64|Sondervereinbarung|Accord spécial
5189|65|Rabatt wegen Produktionsfehler|Remise pour défaut de production
5189|66|Neueröffnungsrabatt|Remise nouveau point de vente
5189|67|Musterrabatt|Remise sur échantillon
5189|68|Auslaufrabatt|Remise fin de série
5189|70|Incoterm-Rabatt|Remise Incoterm
5189|71|Mindestumsatzrabatt am Verkaufsort|Remise seuil point de vente
5189|88|Material-Zu-/Abschlag|Majoration/déduction matière
5189|95|Rabatt|Remise
5189|100|Sonderrabatt|Rabais spécial
5189|102|Langfristig fest|Fixe à long terme
5189|103|Vorübergehend|Temporaire
5189|104|Standard|Standard
5189|105|Jahresumsatzrabatt|Remise sur chiffre d'affaires annuel

7161|AA|Werbung|Publicité
7161|AAA|Telekommunikation|Télécommunication
7161|ABK|Sonstiges|Divers
7161|ABL|Verpackungszuschlag|Supplément d'emballage
7161|ADR|Sonstige Leistungen|Autres services
7161|ADT|Abholung|Enlèvement
7161|FC|Frachtkosten|Frais de transport
7161|FI|Finanzierung|Frais financiers
7161|LA|Kennzeichnung|Étiquetage
7161|PC|Verpackung|Emballage
7161|SH|Versand|Expédition
7161|TAC|Prüfung|Essais
7161|ZZZ|Gegenseitig vereinbart|Défini d'un commun accord

4451|AAA|Warenbeschreibung|Description des marchandises
4451|AAB|Zahlungsbedingungen|Conditions de paiement
4451|AAI|Allgemeine Informationen|Informations générales
4451|AAK|Preiskonditionen|Conditions de prix
4451|ABL|Rechtliche Hinweise|Informations réglementaires
4451|ABN|Buchhaltungshinweise|Informations comptables
4451|ACB|Zusätzliche Informationen|Informations complémentaires
4451|ADU|Hinweis|Note
4451|AFM|Erläuterungen|Explications
4451|AGM|Anmerkungen|Remarques
4451|AUT|Echtheitsbescheinigung|Authentification
4451|CUS|Zollhinweise|Informations douanières
4451|DEL|Lieferhinweise|Informations de livraison
4451|INV|Rechnungshinweise|Instructions de facturation
4451|PAI|Zahlungshinweise|Instructions de paiement
4451|PMD|Zahlungsbezogene Hinweise|Détail de paiement
4451|PMT|Zahlungsinformationen|Informations de paiement
4451|PRF|Hinweise zu Preisberechnung|Formule de prix
4451|REG|Registerangaben|Informations réglementaires (registre)
4451|SUR|Lieferantenhinweise|Remarques du fournisseur
4451|TXD|Steuerhinweise|Informations fiscales
4451|ZZZ|Gegenseitig vereinbart|Défini d'un commun accord

2005|3|Rechnungsdatum|Date d'émission de la facture
2005|35|Liefer-/Leistungsdatum|Date de livraison effective
2005|432|Zahlungsdatum|Date de paiement
2475|5|Rechnungsdatum|Date de facture
2475|29|Lieferdatum|Date de livraison
2475|72|Zahlungsdatum|Date de paiement

linereason|DETAIL|Normale Position|Ligne standard
linereason|GROUP|Gruppe / Zwischensumme|Groupe / sous-total
linereason|INFORMATION|Nur zur Information|Pour information uniquement

8067|0|Nicht angegeben|Non spécifié
8067|1|Seeverkehr|Transport maritime
8067|2|Schienenverkehr|Transport ferroviaire
8067|3|Straßenverkehr|Transport routier
8067|4|Luftverkehr|Transport aérien
8067|5|Post|Courrier
8067|6|Multimodaler Verkehr|Transport multimodal
8067|7|Feste Transporteinrichtung|Installation de transport fixe
8067|8|Binnenschifffahrt|Navigation intérieure
8067|9|Nicht anwendbar|Non applicable

acc|1|Finanzbuchhaltung|Comptabilité financière|Financial
acc|2|Sonderbuchhaltung|Comptabilité spéciale|Subsidiary
acc|3|Budget|Budget|Budget
acc|4|Kostenrechnung|Comptabilité analytique|Cost accounting
acc|5|Forderung|Créance|Receivable
acc|6|Verbindlichkeit|Dette|Payable
acc|7|Projektbuchhaltung|Comptabilité de projet|Job cost accounting

3139|AA|Versicherungskontakt|Contact assurance|Insurance contact
3139|AB|Abteilung/Person für Gefahrgutinformationen|Contact marchandises dangereuses|Dangerous goods contact
3139|AD|Buchhaltung|Comptabilité|Accounting contact
3139|BJ|Abteilung oder Mitarbeiter|Service ou employé|Department or employee
3139|CR|Kundenbetreuung|Service clientèle|Customer relations
3139|IC|Informationskontakt|Contact information|Information contact
3139|PD|Einkauf|Achats|Purchasing contact
3139|SD|Versand|Expédition|Shipping contact
3139|SR|Vertriebsmitarbeiter|Représentant commercial|Sales representative

3035|AB|Käufer-Bank|Banque de l'acheteur|Buyer's financial institution
3035|DL|Faktor|Factor|Factor
3035|SR|Verkäufer-Bank|Banque du vendeur|Seller's financial institution
3035|WD|Lager|Entrepôt|Warehouse depot

lang2|de|Deutsch|allemand|German
lang2|en|Englisch|anglais|English
lang2|fr|Französisch|français|French
lang2|it|Italienisch|italien|Italian
lang2|es|Spanisch|espagnol|Spanish
lang2|nl|Niederländisch|néerlandais|Dutch
lang|deu|Deutsch|allemand
lang|ger|Deutsch|allemand
lang|eng|Englisch|anglais
lang|fra|Französisch|français
lang|fre|Französisch|français
lang|ita|Italienisch|italien
lang|spa|Spanisch|espagnol
lang|nld|Niederländisch|néerlandais
lang|dut|Niederländisch|néerlandais

currency|EUR|Euro|euro|Euro
currency|USD|US-Dollar|dollar des États-Unis|US Dollar
currency|GBP|Pfund Sterling|livre sterling|Pound Sterling
currency|CHF|Schweizer Franken|franc suisse|Swiss Franc
currency|JPY|Yen|yen|Yen
currency|CNY|Renminbi Yuan|yuan renminbi|Yuan Renminbi
currency|SEK|Schwedische Krone|couronne suédoise|Swedish Krona
currency|DKK|Dänische Krone|couronne danoise|Danish Krone
currency|NOK|Norwegische Krone|couronne norvégienne|Norwegian Krone
currency|PLN|Złoty|zloty|Zloty
currency|CZK|Tschechische Krone|couronne tchèque|Czech Koruna
currency|HUF|Forint|forint|Forint
currency|CAD|Kanadischer Dollar|dollar canadien|Canadian Dollar
currency|AUD|Australischer Dollar|dollar australien|Australian Dollar
"""

# Maßeinheiten (UN/ECE Rec. 20/21): Code | Deutsch | Französisch | Englisch (kurz)
UNITS = r"""
C62|Stück|unité|unit
H87|Stück|pièce|piece
XPP|Stück|pièce|piece
EA|Stück|unité|each
NAR|Anzahl Artikel|nombre d'articles|number of articles
NPR|Anzahl Paare|nombre de paires|number of pairs
PR|Paar|paire|pair
SET|Satz|ensemble|set
LS|pauschal|forfait|lump sum
HUR|Stunde|heure|hour
MIN|Minute|minute|minute
SEC|Sekunde|seconde|second
DAY|Tag|jour|day
WEE|Woche|semaine|week
MON|Monat|mois|month
ANN|Jahr|an|year
QAN|Quartal|trimestre|quarter
KGM|kg|kg|kg
GRM|g|g|g
TNE|t|t|t
MGM|mg|mg|mg
MTR|m|m|m
KMT|km|km|km
CMT|cm|cm|cm
MMT|mm|mm|mm
MTK|m²|m²|m²
MTQ|m³|m³|m³
LTR|l|l|l
MLT|ml|ml|ml
KWH|kWh|kWh|kWh
KWT|kW|kW|kW
MWH|MWh|MWh|MWh
P1|Prozent|pour cent|percent
E48|Serviceeinheit|unité de service|service unit
XBX|Karton|boîte|box
XCT|Karton|carton|carton
XPK|Packung|paquet|package
XPA|Päckchen|paquet|packet
XPX|Palette|palette|pallet
XRO|Rolle|rouleau|roll
XBO|Flasche|bouteille|bottle
XSA|Sack|sac|sack
XBG|Beutel|sac|bag
XCR|Kiste|caisse|crate
XTU|Tube|tube|tube
XCA|Dose|boîte métallique|can
XBE|Bündel|botte|bundle
XST|Blatt|feuille|sheet
XSX|Satz|ensemble|set
XKI|Bausatz|kit|kit
D63|Buch|livre|book
"""

# Ländernamen deutsch (Englisch/Französisch aus der Excel-Datei)
COUNTRIES_DE = r"""
DE|Deutschland
AT|Österreich
CH|Schweiz
LI|Liechtenstein
FR|Frankreich
BE|Belgien
NL|Niederlande
LU|Luxemburg
IT|Italien
ES|Spanien
PT|Portugal
GB|Vereinigtes Königreich
XI|Vereinigtes Königreich (Nordirland)
IE|Irland
DK|Dänemark
SE|Schweden
NO|Norwegen
FI|Finnland
IS|Island
PL|Polen
CZ|Tschechien
SK|Slowakei
HU|Ungarn
SI|Slowenien
HR|Kroatien
RO|Rumänien
BG|Bulgarien
GR|Griechenland
EL|Griechenland
CY|Zypern
MT|Malta
EE|Estland
LV|Lettland
LT|Litauen
RS|Serbien
BA|Bosnien und Herzegowina
ME|Montenegro
MK|Nordmazedonien
AL|Albanien
XK|Kosovo
UA|Ukraine
MD|Moldau
BY|Belarus
RU|Russland
TR|Türkei
US|Vereinigte Staaten
CA|Kanada
MX|Mexiko
BR|Brasilien
AR|Argentinien
CN|China
JP|Japan
KR|Südkorea
IN|Indien
SG|Singapur
HK|Hongkong
TW|Taiwan
AU|Australien
NZ|Neuseeland
ZA|Südafrika
AE|Vereinigte Arabische Emirate
IL|Israel
SA|Saudi-Arabien
EG|Ägypten
MA|Marokko
TN|Tunesien
MC|Monaco
SM|San Marino
VA|Vatikanstadt
AD|Andorra
"""


def table(text, minlen):
    for line in text.strip().splitlines():
        line = line.strip()
        if not line or line.startswith("#"):
            continue
        parts = [p.strip() for p in line.split("|")]
        if len(parts) < minlen:
            sys.exit("Zeile unvollständig: " + line)
        yield parts


def clean(v):
    if v is None:
        return ""
    v = str(v).replace("\r", " ").replace("\n", " ").strip()
    if v in ("None",) or v.startswith("="):
        return ""
    v = re.sub(r"\s+", " ", v)
    return v


def code_str(v):
    if v is None:
        return ""
    if isinstance(v, float) and v.is_integer():
        v = int(v)
    return clean(v)


def main():
    wb = openpyxl.load_workbook(XLSX, read_only=True, data_only=True)

    # ---------------- Codelisten aus Excel
    codes = {}  # (list, code) -> dict(en=, fr=, de=)

    def put(lst, code, en=None, fr=None, de=None, override=False):
        code = code_str(code)
        if not code:
            return
        e = codes.setdefault((lst, code), {})
        for lang, val in (("en", en), ("fr", fr), ("de", de)):
            val = clean(val)
            if val and (override or not e.get(lang)):
                e[lang] = val

    rows = list(wb["Codelists for XML"].iter_rows(values_only=True))
    data = rows[5:]

    def col(c, n):
        return [(r[c], r[c + n] if c + n < len(r) else None) for r in data if c < len(r)]

    simple = {"1001": (1, 1), "7161": (9, 1), "5189": (13, 1), "4451": (20, 1), "1153": (35, 1),
              "7143": (38, 1), "eas": (48, 1), "vatex": (51, 1), "5305": (62, 1), "5153": (69, 1),
              "linereason": (77, 1), "nonvat": (80, 1), "incoterms": (84, 1), "1229": (92, 1),
              "lang": (96, 1), "8067": (99, 1)}
    for lst, (c, n) in simple.items():
        for code, name in col(c, n):
            put(lst, code, en=name)
    for r in data:  # 4461 mit FR
        if len(r) > 7:
            put("4461", r[5], en=r[6], fr=r[7])
    for r in data:  # Rec 20
        if len(r) > 18 and clean(r[16]).lower().startswith("rec2"):
            put("rec20", r[17], en=r[18])
    for r in data:  # Länder EN/FR
        if len(r) > 26:
            fr = re.sub(r"\s*\((l'|la|le|les)\)\s*$", "", clean(r[25]))
            en = re.sub(r"\s*\(the\)\s*$", "", clean(r[24]))
            put("country", r[26], en=en, fr=fr)
    for r in data:  # ISO 6523 ICD: Kurzname (Spalte 41) oder Organisation (43)
        if len(r) > 43 and code_str(r[42]):
            name = clean(r[41]) or clean(r[43])
            if len(name) > 60:
                name = name[:57] + "..."
            put("icd", r[42], en=name)
    for r in data:  # 6313
        if len(r) > 89:
            put("6313", r[88], en=r[89])
    # 2475 / 2005 teilen sich die Spalte 56
    current = None
    for r in rows:
        v = clean(r[56]) if len(r) > 56 else ""
        if "2475" in v:
            current = "2475"
            continue
        if "2005" in v:
            current = "2005"
            continue
        if current and code_str(r[56]).isdigit():
            put(current, r[56], en=r[57])

    # ---------------- Ergänzungen
    for p in table(CODES, 4):
        lst, code, de, fr = p[:4]
        en = p[4] if len(p) > 4 else None
        put(lst, code, en=en, fr=fr, de=de, override=True)
    for code, de, fr, en in table(UNITS, 4):
        put("rec20", code, de=de, fr=fr, en=en, override=True)
    for code, de in table(COUNTRIES_DE, 2):
        put("country", code, de=de, override=True)
    # Griechenland: EL als Präfix der USt-IdNr.
    if ("country", "GR") in codes:
        for lang, v in codes[("country", "GR")].items():
            codes.setdefault(("country", "EL"), {}).setdefault(lang, v)

    # ---------------- BT-Zuordnung
    ws = wb["Factur-X CII D22B EXTENDED"]
    bt = {}
    for i, r in enumerate(ws.iter_rows(values_only=True)):
        if i < 4:
            continue
        bid = clean(r[5])
        xp = r[17] if r[17] and not str(r[17]).startswith("=") else r[18]
        if not bid or not xp or str(xp).startswith("="):
            continue
        xp = "".join(l.strip() for l in str(xp).splitlines() if l.strip())
        xp = re.sub(r"\[[^\]]*\]", "", xp)
        if "/@" in xp:
            continue
        steps = [s.split(":")[-1] for s in xp.split("/") if s]
        if not steps or steps[0] != "CrossIndustryInvoice":
            continue
        path = "/".join(steps[1:])
        if not path:
            continue
        lst = bt.setdefault(path, [])
        if bid not in [b for b, _ in lst]:
            lst.append((bid, str(r[9] or "")))

    # Mehrdeutige Pfade: Varianten je Kontext (zv:v, vom Stylesheet über
    # ChargeIndicator, schemeID, TypeCode bzw. currencyID ausgewählt)
    variants = {}
    for path, lst in bt.items():
        if len(lst) < 2:
            continue
        ids = [b for b, _ in lst]
        terms = [t.lower() for _, t in lst]
        v = {}
        if "AllowanceCharge/" in path + "/":
            # Abschlag (false) / Zuschlag (true); Codes für sonstige Steuern
            # (non-VAT tax) gehören zum Zuschlag
            ac = [b for b, t in zip(ids, terms) if "non-vat" not in t]
            tx = [b for b, t in zip(ids, terms) if "non-vat" in t]
            if len(ac) == 2:
                v["false"] = ac[0]
                v["true"] = " / ".join([ac[1]] + tx)
        elif "SpecifiedTaxRegistration" in path:
            for b, t in zip(ids, terms):
                v["FC" if ("registration" in t or "local" in t) else "VA"] = b
        elif "AdditionalReferencedDocument" in path and len(ids) == 3:
            v.update(zip(("916", "50", "130"), ids))
        elif path.endswith("TaxTotalAmount") and len(ids) == 2:
            v.update(zip(("inv", "acc"), ids))
        for k, b in v.items():
            variants[(path, k)] = b
    # Kopf-Lieferbedingung: BT-X-145 (BT-X-562 betrifft die Position)
    dt = "SupplyChainTradeTransaction/ApplicableHeaderTradeAgreement/ApplicableTradeDeliveryTerms/DeliveryTypeCode"
    if dt in bt and "BT-X-145" in [b for b, _ in bt[dt]]:
        bt[dt] = [x for x in bt[dt] if x[0] == "BT-X-145"]

    # ---------------- Ausgabe
    out = []
    labels = list(table(LABELS, 4))
    seen = set()
    for k, de, en, fr in labels:
        if k in seen:
            sys.exit("doppelter Label-Schlüssel: " + k)
        seen.add(k)
        out.append("    <zv:l k=%s de=%s en=%s fr=%s/>" % (quoteattr(k), quoteattr(de), quoteattr(en), quoteattr(fr)))
    for (lst, code), e in sorted(codes.items()):
        if not e.get("en"):
            e["en"] = e.get("de") or e.get("fr") or ""
        if not e["en"]:
            continue
        attrs = "".join(" %s=%s" % (lang, quoteattr(e[lang])) for lang in ("de", "en", "fr") if e.get(lang))
        out.append("    <zv:c l=%s k=%s%s/>" % (quoteattr(lst), quoteattr(code), attrs))
    for path, lst in sorted(bt.items()):
        out.append("    <zv:b p=%s id=%s/>" % (quoteattr(path), quoteattr(" / ".join(b for b, _ in lst))))
    for (path, k), b in sorted(variants.items()):
        out.append("    <zv:v p=%s k=%s id=%s/>" % (quoteattr(path), quoteattr(k), quoteattr(b)))

    common = open(COMMON, encoding="utf-8").read()
    b, e = "<!-- COMMON-BEGIN -->", "<!-- COMMON-END -->"
    common = common[common.index(b) + len(b):common.index(e)].strip("\n")
    data = "\n".join(out)
    for tpl_path, out_path in TEMPLATES:
        tpl = open(tpl_path, encoding="utf-8").read()
        for mark in ("<!--@@COMMON@@-->", "<!--@@DATA@@-->"):
            if tpl.count(mark) != 1:
                sys.exit("%s: Markierung %s fehlt oder ist mehrfach vorhanden" % (tpl_path, mark))
        res = tpl.replace("<!--@@COMMON@@-->", common).replace("<!--@@DATA@@-->", data)
        with open(out_path, "w", encoding="utf-8", newline="\n") as f:
            f.write(res)
        print("geschrieben: %s (%d KB)" % (os.path.normpath(out_path), len(res) // 1024))
    print("%d Labels, %d Codes, %d BT-Pfade, %d Varianten" % (len(labels), len(codes), len(bt), len(variants)))


if __name__ == "__main__":
    main()
