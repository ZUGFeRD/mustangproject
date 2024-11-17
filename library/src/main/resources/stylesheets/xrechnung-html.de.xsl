<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

	<xsl:variable name="i18n.bt10" select="'Leitweg-ID'"/>
    <xsl:variable name="i18n.bt44" select="'Name'"/>
    <xsl:variable name="i18n.title" select="'XRechnung'"/>
    <xsl:variable name="i18n.overview" select="'Übersicht'"/>
    <xsl:variable name="i18n.items" select="'Positionen'"/>
    <xsl:variable name="i18n.information" select="'Informationen'"/>
    <xsl:variable name="i18n.attachments" select="'Anhänge'"/>
    <xsl:variable name="i18n.history" select="'Bearbeitungshistorie'"/>
    <xsl:variable name="i18n.disclaimer" select="'Wir übernehmen keine Haftung für die Richtigkeit der Daten.'"/>
    <xsl:variable name="i18n.recipientInfo" select="'Informationen zum Käufer'"/>
    <xsl:variable name="i18n.bt50" select="'Straße / Haus-Nr.'"/>
    <xsl:variable name="i18n.bt51" select="'Postfach'"/>
    <xsl:variable name="i18n.bt163" select="'Adresszusatz'"/>
    <xsl:variable name="i18n.bt53" select="'PLZ'"/>
    <xsl:variable name="i18n.bt52" select="'Ort'"/>
    <xsl:variable name="i18n.bt54" select="'Bundesland'"/>
    <xsl:variable name="i18n.bt55" select="'Land'"/>
    <xsl:variable name="i18n.bt46" select="'Kennung / Kunden-Nr.'"/>
    <xsl:variable name="i18n.bt46-id" select="'Schema der Kennung'"/>
    <xsl:variable name="i18n.bt56" select="'Name'"/>
    <xsl:variable name="i18n.bt57" select="'Telefon'"/>
    <xsl:variable name="i18n.bt58" select="'E-Mail-Adresse'"/>
    <xsl:variable name="i18n.bt27" select="'Firmenname'"/>
    <xsl:variable name="i18n.bt35" select="'Straße / Haus-Nr.'"/>
    <xsl:variable name="i18n.bt36" select="'Postfach'"/>
    <xsl:variable name="i18n.bt162" select="'Adresszusatz'"/>
    <xsl:variable name="i18n.bt38" select="'PLZ'"/>
    <xsl:variable name="i18n.bt37" select="'Ort'"/>
    <xsl:variable name="i18n.bt39" select="'Bundesland'"/>
    <xsl:variable name="i18n.bt40" select="'Ländercode'"/>
    <xsl:variable name="i18n.bt29" select="'Kennung'"/>
    <xsl:variable name="i18n.bt29-id" select="'Schema der Kennung'"/>
    <xsl:variable name="i18n.bt41" select="'Name'"/>
    <xsl:variable name="i18n.bt42" select="'Telefon'"/>
    <xsl:variable name="i18n.bt43" select="'E-Mail-Adresse'"/>
    <xsl:variable name="i18n.bt1" select="'Rechnungsnummer'"/>
    <xsl:variable name="i18n.bt2" select="'Rechnungsdatum'"/>
    <xsl:variable name="i18n.details" select="'Rechnungsdaten'"/>
    <xsl:variable name="i18n.period" select="'Abrechnungszeitraum'"/>
    <xsl:variable name="i18n.bt3" select="'Rechnungsart'"/>
    <xsl:variable name="i18n.bt5" select="'Währung'"/>
    <xsl:variable name="i18n.bt73" select="'von'"/>
    <xsl:variable name="i18n.bt74" select="'bis'"/>
    <xsl:variable name="i18n.bt11" select="'Projektnummer'"/>
    <xsl:variable name="i18n.bt12" select="'Vertragsnummer'"/>
    <xsl:variable name="i18n.bt13" select="'Bestellnummer'"/>
    <xsl:variable name="i18n.bt14" select="'Auftragsnummer'"/>
    <xsl:variable name="i18n.bt25" select="'Rechnungsnummer'"/>
    <xsl:variable name="i18n.bt26" select="'Rechnungsdatum'"/>
    <xsl:variable name="i18n.bg22" select="'Gesamtbeträge der Rechnung'"/>
    <xsl:variable name="i18n.bt106" select="'Summe aller Positionen'"/>
    <xsl:variable name="i18n.bt107" select="'Summe Nachlässe'"/>
    <xsl:variable name="i18n.bt108" select="'Summe Zuschläge'"/>
    <xsl:variable name="i18n.bt109" select="'Gesamtsumme'"/>
    <xsl:variable name="i18n.bt110" select="'Summe Umsatzsteuer'"/>
    <xsl:variable name="i18n.bt111" select="'Summe Umsatzsteuer in Abrechnungswährung'"/>
    <xsl:variable name="i18n.bt112" select="'Gesamtsumme'"/>
    <xsl:variable name="i18n.bt113" select="'Gezahlter Betrag'"/>
    <xsl:variable name="i18n.bt114" select="'Rundungsbetrag'"/>
    <xsl:variable name="i18n.bt115" select="'Fälliger Betrag'"/>
    <xsl:variable name="i18n.bg23" select="'Aufschlüsselung der Umsatzsteuer auf Ebene der Rechnung'"/>
    <xsl:variable name="i18n.bt118" select="'Umsatzsteuerkategorie'"/>
    <xsl:variable name="i18n.bt116" select="'Gesamtsumme'"/>
    <xsl:variable name="i18n.bt119" select="'Umsatzsteuersatz'"/>
    <xsl:variable name="i18n.bt117" select="'Umsatzsteuerbetrag'"/>
    <xsl:variable name="i18n.bt120" select="'Befreiungsgrund'"/>
    <xsl:variable name="i18n.bt121" select="'Kennung für den Befreiungsgrund'"/>
    <xsl:variable name="i18n.bg20" select="'Nachlass auf Ebene der Rechnung'"/>
    <xsl:variable name="i18n.bt95" select="'Umsatzsteuerkategorie des Nachlasses'"/>
    <xsl:variable name="i18n.bt93" select="'Grundbetrag'"/>
    <xsl:variable name="i18n.bt94" select="'Prozentsatz'"/>
    <xsl:variable name="i18n.bt92" select="'Nachlass'"/>
    <xsl:variable name="i18n.bt96" select="'Umsatzsteuersatz des Nachlasses'"/>
    <xsl:variable name="i18n.bt97" select="'Grund für den Nachlass'"/>
    <xsl:variable name="i18n.bt98" select="'Document level allowance reason code'"/>
    <xsl:variable name="i18n.bg21" select="'Zuschlag auf Ebene der Rechnung'"/>
    <xsl:variable name="i18n.bt102" select="'Umsatzsteuerkategorie des Zuschlages'"/>
    <xsl:variable name="i18n.bt100" select="'Grundbetrag'"/>
    <xsl:variable name="i18n.bt101" select="'Prozentsatz'"/>
    <xsl:variable name="i18n.bt99" select="'Zuschlag'"/>
    <xsl:variable name="i18n.bt103" select="'Umsatzsteuersatz des Zuschlages'"/>
    <xsl:variable name="i18n.bt104" select="'Grund für den Zuschlag'"/>
    <xsl:variable name="i18n.bt105" select="'Document level charge reason code'"/>
    <xsl:variable name="i18n.bgx42" select="'Versandkosten'"/>
    <xsl:variable name="i18n.btx274" select="'Umsatzsteuerkategorie der Versandkosten'"/>
    <xsl:variable name="i18n.btx272" select="'Betrag'"/>
    <xsl:variable name="i18n.btx273" select="'Umsatzsteuersatz der Versandkosten'"/>
    <xsl:variable name="i18n.btx271" select="'Versandkostenbeschreibung'"/>
    <xsl:variable name="i18n.bt20" select="'Skonto; weitere Zahlungsbed.'"/>
    <xsl:variable name="i18n.bt9" select="'Fälligkeitsdatum'"/>
    <xsl:variable name="i18n.bt81" select="'Code für das Zahlungsmittel'"/>
    <xsl:variable name="i18n.bt82" select="'Zahlungsmittel'"/>
    <xsl:variable name="i18n.bt83" select="'Verwendungszweck'"/>
    <xsl:variable name="i18n.bg18" select="'Karteninformation'"/>
    <xsl:variable name="i18n.bt87" select="'Kartennummer'"/>
    <xsl:variable name="i18n.bt88" select="'Karteninhaber'"/>
    <xsl:variable name="i18n.bg19" select="'Lastschrift'"/>
    <xsl:variable name="i18n.bt89" select="'Mandatsreferenznr.'"/>
    <xsl:variable name="i18n.bt91" select="'IBAN'"/>
    <xsl:variable name="i18n.bt90" select="'Gläubiger-ID'"/>
    <xsl:variable name="i18n.bg17" select="'Überweisung'"/>
    <xsl:variable name="i18n.bt85" select="'Kontoinhaber'"/>
    <xsl:variable name="i18n.bt84" select="'IBAN'"/>
    <xsl:variable name="i18n.bt86" select="'BIC'"/>
    <xsl:variable name="i18n.bg1" select="'Bemerkung zur Rechnung'"/>
    <xsl:variable name="i18n.bt21" select="'Betreff'"/>
    <xsl:variable name="i18n.bt22" select="'Bemerkung'"/>
    <xsl:variable name="i18n.bt126" select="'Position'"/>
    <xsl:variable name="i18n.bt127" select="'Freitext'"/>
    <xsl:variable name="i18n.bt128" select="'Objektkennung'"/>
    <xsl:variable name="i18n.bt128-id" select="'Schema der Objektkennung'"/>
    <xsl:variable name="i18n.bt132" select="'Nummer der Auftragsposition'"/>
    <xsl:variable name="i18n.bt133" select="'Kontierungshinweis /Kostenstelle'"/>
    <xsl:variable name="i18n.bg26" select="'Abrechnungszeitraum'"/>
    <xsl:variable name="i18n.bt134" select="'von'"/>
    <xsl:variable name="i18n.bt135" select="'bis'"/>
    <xsl:variable name="i18n.bg29" select="'Preiseinzelheiten'"/>
    <xsl:variable name="i18n.bt129" select="'Menge'"/>
    <xsl:variable name="i18n.bt130" select="'Einheit'"/>
    <xsl:variable name="i18n.bt146" select="'Preis pro Einheit (netto)'"/>
    <xsl:variable name="i18n.bt131" select="'Gesamtpreis (netto)'"/>
    <xsl:variable name="i18n.bt147" select="'Rabatt (netto)'"/>
    <xsl:variable name="i18n.bt148" select="'Listenpreis (netto)'"/>
    <xsl:variable name="i18n.bt149" select="'Anzahl der Einheit'"/>
    <xsl:variable name="i18n.bt150" select="'Code der Maßeinheit'"/>
    <xsl:variable name="i18n.bt151" select="'Umsatzsteuer'"/>
    <xsl:variable name="i18n.bt152" select="'Umsatzsteuersatz in %'"/>
    <xsl:variable name="i18n.bg27" select="'Nachlässe auf Ebene der Rechnungsposition'"/>
    <xsl:variable name="i18n.bt137" select="'Grundbetrag (netto)'"/>
    <xsl:variable name="i18n.bt138" select="'Prozentsatz'"/>
    <xsl:variable name="i18n.bt136" select="'Nachlass'"/>
    <xsl:variable name="i18n.bt139" select="'Grund des Nachlasses'"/>
    <xsl:variable name="i18n.bt140" select="'Code für den Nachlassgrund'"/>
    <xsl:variable name="i18n.bg28" select="'Zuschläge auf Ebene der Rechnungsposition'"/>
    <xsl:variable name="i18n.bt142" select="'Grundbetrag (netto)'"/>
    <xsl:variable name="i18n.bt143" select="'Prozentsatz'"/>
    <xsl:variable name="i18n.bt141" select="'Zuschlag (netto)'"/>
    <xsl:variable name="i18n.bt144" select="'Grund des Zuschlags'"/>
    <xsl:variable name="i18n.bt145" select="'Code für den Zuschlagsgrund'"/>
    <xsl:variable name="i18n.bg31" select="'Artikelinformationen'"/>
    <xsl:variable name="i18n.bt153" select="'Bezeichnung'"/>
    <xsl:variable name="i18n.bt154" select="'Beschreibung'"/>
    <xsl:variable name="i18n.bt155" select="'Artikelnummer'"/>
    <xsl:variable name="i18n.bt156" select="'Kunden-Material-Nr.'"/>
    <xsl:variable name="i18n.bg32" select="'Eigenschaften des Artikels'"/>
    <xsl:variable name="i18n.bt157" select="'Artikelkennung (EAN)'"/>
    <xsl:variable name="i18n.bt157-id" select="'Schema der Artikelkennung'"/>
    <xsl:variable name="i18n.bt158" select="'Code der Artikelklassifizierung'"/>
    <xsl:variable name="i18n.bt158-id" select="'Kennung zur Bildung des Schemas'"/>
    <xsl:variable name="i18n.bt157-vers-id" select="'Version zur Bildung des Schemas'"/>
    <xsl:variable name="i18n.bt159" select="'Code des Herkunftslandes'"/>
    <xsl:variable name="i18n.bg4" select="'Informationen zum Verkäufer'"/>
    <xsl:variable name="i18n.bt28" select="'Abweichender Handelsname'"/>
    <xsl:variable name="i18n.bt34" select="'Elektronische Adresse'"/>
    <xsl:variable name="i18n.bt34-id" select="'Schema der elektronischen Adresse'"/>
    <xsl:variable name="i18n.bt30" select="'Register-/Registriernummer'"/>
    <xsl:variable name="i18n.bt31" select="'Umsatzsteuer-ID'"/>
    <xsl:variable name="i18n.bt32" select="'Steuernummer'"/>
    <xsl:variable name="i18n.bt32-schema" select="'Schema der Steuernummer'"/>
    <xsl:variable name="i18n.bt33" select="'Weitere rechtliche Informationen'"/>
    <xsl:variable name="i18n.bt6" select="'Code der Umsatzsteuerwährung'"/>
    <xsl:variable name="i18n.bg11" select="'Steuervertreter des Verkäufers'"/>
    <xsl:variable name="i18n.bt62" select="'Name'"/>
    <xsl:variable name="i18n.bt64" select="'Straße / Hausnummer'"/>
    <xsl:variable name="i18n.bt65" select="'Postfach'"/>
    <xsl:variable name="i18n.bt164" select="'Adresszusatz'"/>
    <xsl:variable name="i18n.bt67" select="'PLZ'"/>
    <xsl:variable name="i18n.bt66" select="'Ort'"/>
    <xsl:variable name="i18n.bt68" select="'Bundesland'"/>
    <xsl:variable name="i18n.bt69" select="'Ländercode'"/>
    <xsl:variable name="i18n.bt63" select="'Umsatzsteuer-ID'"/>
    <xsl:variable name="i18n.bg7" select="'Informationen zum Käufer'"/>
    <xsl:variable name="i18n.bt45" select="'Abweichender Handelsname'"/>
    <xsl:variable name="i18n.bt49" select="'Elektronische Adresse'"/>
    <xsl:variable name="i18n.bt49-id" select="'Schema der elektronischen Adresse'"/>
    <xsl:variable name="i18n.bt47" select="'Register-/Registriernummer'"/>
    <xsl:variable name="i18n.bt47-id" select="'Schema der Register-/Registriernummer'"/>
    <xsl:variable name="i18n.bt48" select="'Umsatzsteuer-ID'"/>
    <xsl:variable name="i18n.bt7" select="'Abrechnungsdatum der Umsatzsteuer'"/>
    <xsl:variable name="i18n.bt8" select="'Code des Umsatzsteuer-Abrechnungsdatums'"/>
    <xsl:variable name="i18n.bt19" select="'Kontierungsinformation / Kostenstelle'"/>
    <xsl:variable name="i18n.bg13" select="'Lieferinformationen'"/>
    <xsl:variable name="i18n.bt71" select="'Kennung des Lieferorts'"/>
    <xsl:variable name="i18n.bt71-id" select="'Schema der Kennung'"/>
    <xsl:variable name="i18n.bt72" select="'Lieferdatum'"/>
    <xsl:variable name="i18n.bt70" select="'Name des Empfängers'"/>
    <xsl:variable name="i18n.bt75" select="'Straße / Haus-Nr.'"/>
    <xsl:variable name="i18n.bt76" select="'Postfach'"/>
    <xsl:variable name="i18n.bt165" select="'Adresszusatz'"/>
    <xsl:variable name="i18n.bt78" select="'PLZ'"/>
    <xsl:variable name="i18n.bt77" select="'Ort'"/>
    <xsl:variable name="i18n.bt79" select="'Bundesland'"/>
    <xsl:variable name="i18n.bt80" select="'Land'"/>
    <xsl:variable name="i18n.bt17" select="'Vergabenummer'"/>
    <xsl:variable name="i18n.bt15" select="'Kennung der Empfangsbestätigung'"/>
    <xsl:variable name="i18n.bt16" select="'Kennung der Versandanzeige'"/>
    <xsl:variable name="i18n.bt23" select="'Prozesskennung'"/>
    <xsl:variable name="i18n.bt24" select="'Spezifikationskennung'"/>
    <xsl:variable name="i18n.bt18" select="'Objektkennung'"/>
    <xsl:variable name="i18n.bt18-id" select="'Schema der Objektkennung'"/>
    <xsl:variable name="i18n.bg10" select="'Vom Verkäufer abweichender Zahlungsempfänger'"/>
    <xsl:variable name="i18n.bt59" select="'Name'"/>
    <xsl:variable name="i18n.bt60" select="'Kennung'"/>
    <xsl:variable name="i18n.bt60-id" select="'Schema der Kennung'"/>
    <xsl:variable name="i18n.bt61" select="'Register-/Registriernummer'"/>
    <xsl:variable name="i18n.bt61-id" select="'Schema der Register-/Registriernummer'"/>
    <xsl:variable name="i18n.bg24" select="'Rechnungsbegründende Unterlagen'"/>
    <xsl:variable name="i18n.bt122" select="'Kennung'"/>
    <xsl:variable name="i18n.bt123" select="'Beschreibung'"/>
    <xsl:variable name="i18n.bt124" select="'Verweis (z.B. Internetadresse)'"/>
    <xsl:variable name="i18n.bt125" select="'Anhangsdokument'"/>
    <xsl:variable name="i18n.bt125-format" select="'Format des Anhangdokuments'"/>
    <xsl:variable name="i18n.bt125-name" select="'Name des Anhangsdokuments'"/>
    <xsl:variable name="i18n.historyDate" select="'Datum/Uhrzeit'"/>
    <xsl:variable name="i18n.historySubject" select="'Betreff'"/>
    <xsl:variable name="i18n.historyText" select="'Text'"/>
    <xsl:variable name="i18n.historyDetails" select="'Details'"/>
    <xsl:variable name="i18n.payment" select="'Zahlungsdaten'"/>
    <xsl:variable name="i18n.contract_information" select="'Vertragsdaten'"/>
    <xsl:variable name="i18n.preceding_invoice_reference" select="'Vorausgegangene Rechnungen'"/>

    <xsl:include href="xrechnung-html.univ.xsl"/>

</xsl:stylesheet>
