<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="2.0">

    <xsl:variable name="i18n.bt10" select="'Identifiant d''itinéraire'"/>
    <xsl:variable name="i18n.bt44" select="'Nom'"/>
    <xsl:variable name="i18n.title" select="'XRechnung'"/>
    <xsl:variable name="i18n.overview" select="'Aperçu'"/>
    <xsl:variable name="i18n.items" select="'Détails'"/>
    <xsl:variable name="i18n.information" select="'Additif'"/>
    <xsl:variable name="i18n.attachments" select="'Pièces jointes'"/>
    <xsl:variable name="i18n.history" select="'Historique de traitement'"/>
    <xsl:variable name="i18n.disclaimer" select="'Nous n''assumons aucune responsabilité quant à l''exactitude des données.'"/>
    <xsl:variable name="i18n.recipientInfo" select="'Informations sur l''acheteur'"/>
    <xsl:variable name="i18n.bt50" select="'Rue / Numéro de maison'"/>
    <xsl:variable name="i18n.bt51" select="'Boîte postale'"/>
    <xsl:variable name="i18n.bt163" select="'Supplément d''adresse'"/>
    <xsl:variable name="i18n.bt53" select="'Code postal'"/>
    <xsl:variable name="i18n.bt52" select="'Lieu'"/>
    <xsl:variable name="i18n.bt54" select="'Région'"/>
    <xsl:variable name="i18n.bt55" select="'Pays'"/>
    <xsl:variable name="i18n.bt46" select="'Identifiant'"/>
    <xsl:variable name="i18n.bt46-id" select="'Schéma de l''Identifiant'"/>
    <xsl:variable name="i18n.bt56" select="'Nom'"/>
    <xsl:variable name="i18n.bt57" select="'Téléphone'"/>
    <xsl:variable name="i18n.bt58" select="'Adresse électronique'"/>
    <xsl:variable name="i18n.bt27" select="'Nom de la société'"/>
    <xsl:variable name="i18n.bt35" select="'Rue / Numéro de maison'"/>
    <xsl:variable name="i18n.bt36" select="'Boîte postale'"/>
    <xsl:variable name="i18n.bt162" select="'Supplément d''adresse'"/>
    <xsl:variable name="i18n.bt38" select="'Code postal'"/>
    <xsl:variable name="i18n.bt37" select="'Lieu'"/>
    <xsl:variable name="i18n.bt39" select="'Région'"/>
    <xsl:variable name="i18n.bt40" select="'Code pays'"/>
    <xsl:variable name="i18n.bt29" select="'Identifiant'"/>
    <xsl:variable name="i18n.bt29-id" select="'Schéma de l''Identifiant'"/>
    <xsl:variable name="i18n.bt41" select="'Nom'"/>
    <xsl:variable name="i18n.bt42" select="'Téléphone'"/>
    <xsl:variable name="i18n.bt43" select="'Adresse électronique'"/>
    <xsl:variable name="i18n.bt1" select="'Informations sur le vendeur'"/>
    <xsl:variable name="i18n.bt2" select="'Date de facture'"/>
    <xsl:variable name="i18n.details" select="'Détails de la facturation'"/>
    <xsl:variable name="i18n.period" select="'Période de facturation'"/>
    <xsl:variable name="i18n.bt3" select="'Type de facture'"/>
    <xsl:variable name="i18n.bt5" select="'Devise'"/>
    <xsl:variable name="i18n.bt73" select="'de'"/>
    <xsl:variable name="i18n.bt74" select="'jusqu''à'"/>
    <xsl:variable name="i18n.bt11" select="'Numéro du projet'"/>
    <xsl:variable name="i18n.bt12" select="'Numéro du contrat'"/>
    <xsl:variable name="i18n.bt13" select="'Numéro de commande'"/>
    <xsl:variable name="i18n.bt14" select="'Numéro de commande'"/>
    <xsl:variable name="i18n.bt25" select="'Numéro de facture'"/>
    <xsl:variable name="i18n.bt26" select="'Date de facture'"/>
    <xsl:variable name="i18n.bg22" select="'Montants totaux de la facture'"/>
    <xsl:variable name="i18n.bt106" select="'Total de toutes les lignes'"/>
    <xsl:variable name="i18n.bt107" select="'Total de remises'"/>
    <xsl:variable name="i18n.bt108" select="'Total de suppléments'"/>
    <xsl:variable name="i18n.bt109" select="'Montant total'"/>
    <xsl:variable name="i18n.bt110" select="'montant de la TVA'"/>
    <xsl:variable name="i18n.bt111" select="'Montant total de TVA'"/>
    <xsl:variable name="i18n.bt112" select="'Montant total'"/>
    <xsl:variable name="i18n.bt113" select="'Montant payé'"/>
    <xsl:variable name="i18n.bt114" select="'Montant arrondi'"/>
    <xsl:variable name="i18n.bt115" select="'Montant dû'"/>
    <xsl:variable name="i18n.bg23" select="'Ventilation de la TVA au niveau de la facture'"/>
    <xsl:variable name="i18n.bt118" select="'Catégorie de TVA'"/>
    <xsl:variable name="i18n.bt116" select="'Montant total'"/>
    <xsl:variable name="i18n.bt119" select="'taux TVA'"/>
    <xsl:variable name="i18n.bt117" select="'montant de la TVA'"/>
    <xsl:variable name="i18n.bt120" select="'Motif d''exemption'"/>
    <xsl:variable name="i18n.bt121" select="'Identifiant pour motif d''exemption'"/>
    <xsl:variable name="i18n.bg20" select="'Allocation au niveau de la facture'"/>
    <xsl:variable name="i18n.bt95" select="'Catégorie de TVA de la remise'"/>
    <xsl:variable name="i18n.bt93" select="'Montant de base'"/>
    <xsl:variable name="i18n.bt94" select="'Pourcentage'"/>
    <xsl:variable name="i18n.bt92" select="'Allocation'"/>
    <xsl:variable name="i18n.bt96" select="'Taux de TVA de la allocation'"/>
    <xsl:variable name="i18n.bt97" select="'Motif de la remise'"/>
    <xsl:variable name="i18n.bt98" select="'Document level allowance reason code'"/>
    <xsl:variable name="i18n.bg21" select="'Supplément au niveau de la facture'"/>
    <xsl:variable name="i18n.bt102" select="'Catégorie de TVA du supplément'"/>
    <xsl:variable name="i18n.bt100" select="'Montant de base'"/>
    <xsl:variable name="i18n.bt101" select="'Pourcentage'"/>
    <xsl:variable name="i18n.bt99" select="'Supplément'"/>
    <xsl:variable name="i18n.bt103" select="'Taux de TVA du supplément'"/>
    <xsl:variable name="i18n.bt104" select="'Raison du supplément'"/>
    <xsl:variable name="i18n.bt105" select="'Document level charge reason code'"/>
    <xsl:variable name="i18n.bgx42" select="'Frais d''expédition'"/>
    <xsl:variable name="i18n.btx274" select="'Catégorie de TVA des frais de port'"/>
    <xsl:variable name="i18n.btx272" select="'Montant'"/>
    <xsl:variable name="i18n.btx273" select="'VAT rate of the shipping cost'"/>
    <xsl:variable name="i18n.btx271" select="'Taux de TVA des frais de port'"/>
    <xsl:variable name="i18n.bt20" select="'Rabais; autres conditions de paiement'"/>
    <xsl:variable name="i18n.bt9" select="'Date d''échéance'"/>
    <xsl:variable name="i18n.bt81" select="'Code du moyen de paiement'"/>
    <xsl:variable name="i18n.bt82" select="'Moyens de paiement'"/>
    <xsl:variable name="i18n.bt83" select="'Utilisation'"/>
    <xsl:variable name="i18n.bg18" select="'Information de la carte'"/>
    <xsl:variable name="i18n.bt87" select="'Numéro de carte'"/>
    <xsl:variable name="i18n.bt88" select="'Titulaire de la carte'"/>
    <xsl:variable name="i18n.bg19" select="'Prélèvement automatique'"/>
    <xsl:variable name="i18n.bt89" select="'Numéro de référence du mandat'"/>
    <xsl:variable name="i18n.bt91" select="'IBAN'"/>
    <xsl:variable name="i18n.bt90" select="'Identifiant du créancier'"/>
    <xsl:variable name="i18n.bg17" select="'Transfert'"/>
    <xsl:variable name="i18n.bt85" select="'Titulaire du compte'"/>
    <xsl:variable name="i18n.bt84" select="'IBAN'"/>
    <xsl:variable name="i18n.bt86" select="'BIC'"/>
    <xsl:variable name="i18n.bg1" select="'Commentaire sur la facture'"/>
    <xsl:variable name="i18n.bt21" select="'Objet'"/>
    <xsl:variable name="i18n.bt22" select="'Commentaire'"/>
    <xsl:variable name="i18n.bt126" select="'Position'"/>
    <xsl:variable name="i18n.bt127" select="'Texte libre'"/>
    <xsl:variable name="i18n.bt128" select="'Identifiant d''objet'"/>
    <xsl:variable name="i18n.bt128-id" select="'Schéma de l''Identifiant objet'"/>
    <xsl:variable name="i18n.bt132" select="'Numéro de ligne de commande'"/>
    <xsl:variable name="i18n.bt133" select="'Information sur l''attribution de compte'"/>
    <xsl:variable name="i18n.bg26" select="'Période de facturation'"/>
    <xsl:variable name="i18n.bt134" select="'de'"/>
    <xsl:variable name="i18n.bt135" select="'jusqu''à'"/>
    <xsl:variable name="i18n.bg29" select="'Détails de prix'"/>
    <xsl:variable name="i18n.bt129" select="'Quantité'"/>
    <xsl:variable name="i18n.bt130" select="'Unité'"/>
    <xsl:variable name="i18n.bt146" select="'Prix unitaire net'"/>
    <xsl:variable name="i18n.bt131" select="'Prix total net'"/>
    <xsl:variable name="i18n.bt147" select="'Remise nette'"/>
    <xsl:variable name="i18n.bt148" select="'Prix catalogue (net)'"/>
    <xsl:variable name="i18n.bt149" select="'Nombre d''unités'"/>
    <xsl:variable name="i18n.bt150" select="'Code de l''unité de mesure '"/>
    <xsl:variable name="i18n.bt151" select="'TVA'"/>
    <xsl:variable name="i18n.bt152" select="'Pourcentage de TVA'"/>
    <xsl:variable name="i18n.bg27" select="'Allocations au niveau de la ligne de facture'"/>
    <xsl:variable name="i18n.bt137" select="'Montant de base net'"/>
    <xsl:variable name="i18n.bt138" select="'Pourcentage'"/>
    <xsl:variable name="i18n.bt136" select="'Allocation nette'"/>
    <xsl:variable name="i18n.bt139" select="'Raison pour l''allocation '"/>
    <xsl:variable name="i18n.bt140" select="'Code de la raison pour l''allocation'"/>
    <xsl:variable name="i18n.bg28" select="'Supplément au niveau de la ligne de facture'"/>
    <xsl:variable name="i18n.bt142" select="'Montant de base net'"/>
    <xsl:variable name="i18n.bt143" select="'Pourcentage'"/>
    <xsl:variable name="i18n.bt141" select="'Supplément net'"/>
    <xsl:variable name="i18n.bt144" select="'Raison du supplément'"/>
    <xsl:variable name="i18n.bt145" select="'Code de la raison du supplément'"/>
    <xsl:variable name="i18n.bg31" select="'Informations sur l''article'"/>
    <xsl:variable name="i18n.bt153" select="'Nom'"/>
    <xsl:variable name="i18n.bt154" select="'Description'"/>
    <xsl:variable name="i18n.bt155" select="'Numéro d''article'"/>
    <xsl:variable name="i18n.bt156" select="'N° client / matériel'"/>
    <xsl:variable name="i18n.bg32" select="'Propriétés de l''article'"/>
    <xsl:variable name="i18n.bt157" select="'Identifiant article'"/>
    <xsl:variable name="i18n.bt157-id" select="'Schéma de l''Identifiant article'"/>
    <xsl:variable name="i18n.bt158" select="'Code de classification des articles'"/>
    <xsl:variable name="i18n.bt158-id" select="'Identifiant pour la création du schéma'"/>
    <xsl:variable name="i18n.bt157-vers-id" select="'Version de création du schéma'"/>
    <xsl:variable name="i18n.bt159" select="'Code du pays d''origine'"/>
    <xsl:variable name="i18n.bg4" select="'Informations sur le vendeur'"/>
    <xsl:variable name="i18n.bt28" select="'Nom commercial différent'"/>
    <xsl:variable name="i18n.bt34" select="'Adresse électronique'"/>
    <xsl:variable name="i18n.bt34-id" select="'Schéma de l''adresse électronique'"/>
    <xsl:variable name="i18n.bt30" select="'Numéro d''enregistrement'"/>
    <xsl:variable name="i18n.bt31" select="'Identifiant TVA'"/>
    <xsl:variable name="i18n.bt32" select="'Numéro fiscale'"/>
    <xsl:variable name="i18n.bt32-schema" select="'Schéma du numéro fiscal'"/>
    <xsl:variable name="i18n.bt33" select="'Autres informations légales'"/>
    <xsl:variable name="i18n.bt6" select="'Code devise de la TVA'"/>
    <xsl:variable name="i18n.bg11" select="'Représentant fiscal du vendeur'"/>
    <xsl:variable name="i18n.bt62" select="'Nom'"/>
    <xsl:variable name="i18n.bt64" select="'Rue / Numéro de maison'"/>
    <xsl:variable name="i18n.bt65" select="'Boîte postale'"/>
    <xsl:variable name="i18n.bt164" select="'Supplément d''adresse'"/>
    <xsl:variable name="i18n.bt67" select="'Code postal'"/>
    <xsl:variable name="i18n.bt66" select="'Lieu'"/>
    <xsl:variable name="i18n.bt68" select="'Région'"/>
    <xsl:variable name="i18n.bt69" select="'Code pays'"/>
    <xsl:variable name="i18n.bt63" select="'Identifiant TVA'"/>
    <xsl:variable name="i18n.bg7" select="'Informations sur l''acheteur'"/>
    <xsl:variable name="i18n.bt45" select="'Nom commercial différent '"/>
    <xsl:variable name="i18n.bt49" select="'Adresse électronique'"/>
    <xsl:variable name="i18n.bt49-id" select="'Schéma de l''adresse électronique'"/>
    <xsl:variable name="i18n.bt47" select="'Numéro d''enregistrement'"/>
    <xsl:variable name="i18n.bt47-id" select="'Schéma du numéro d''enregistrement'"/>
    <xsl:variable name="i18n.bt48" select="'Identifiant TVA'"/>
    <xsl:variable name="i18n.bt7" select="'Date de facturation de la TVA'"/>
    <xsl:variable name="i18n.bt8" select="'Code de date de règlement de la TVA'"/>
    <xsl:variable name="i18n.bt19" select="'Informations sur l''attribution de compte'"/>
    <xsl:variable name="i18n.bg13" select="'Informations de livraison'"/>
    <xsl:variable name="i18n.bt71" select="'Identification du lieu de livraison'"/>
    <xsl:variable name="i18n.bt71-id" select="'Schéma de l''Identifiant'"/>
    <xsl:variable name="i18n.bt72" select="'Date de livraison'"/>
    <xsl:variable name="i18n.bt70" select="'Nom du destinataire'"/>
    <xsl:variable name="i18n.bt75" select="'Rue / Numéro de maison'"/>
    <xsl:variable name="i18n.bt76" select="'Boîte postale'"/>
    <xsl:variable name="i18n.bt165" select="'Supplément d''adresse'"/>
    <xsl:variable name="i18n.bt78" select="'Code postal'"/>
    <xsl:variable name="i18n.bt77" select="'Lieu'"/>
    <xsl:variable name="i18n.bt79" select="'Région'"/>
    <xsl:variable name="i18n.bt80" select="'Pays'"/>
    <xsl:variable name="i18n.bt17" select="'Numéro d''attribution'"/>
    <xsl:variable name="i18n.bt15" select="'Identifiant de l''accusé de réception'"/>
    <xsl:variable name="i18n.bt16" select="'Identifiant du  bordereau d''expédition'"/>
    <xsl:variable name="i18n.bt23" select="'Identifiant processus'"/>
    <xsl:variable name="i18n.bt24" select="'Identifiant spécification'"/>
    <xsl:variable name="i18n.bt18" select="'Identifiant objet'"/>
    <xsl:variable name="i18n.bt18-id" select="'Schéma de l''Identifiant objet'"/>
    <xsl:variable name="i18n.bg10" select="'bénéficiaire autre que le vendeur'"/>
    <xsl:variable name="i18n.bt59" select="'Nom'"/>
    <xsl:variable name="i18n.bt60" select="'Identifiant'"/>
    <xsl:variable name="i18n.bt60-id" select="'Schéma de l''Identifiant'"/>
    <xsl:variable name="i18n.bt61" select="'Numéro d''enregistrement'"/>
    <xsl:variable name="i18n.bt61-id" select="'Schéma du numéro d''enregistrement'"/>
    <xsl:variable name="i18n.bg24" select="'Documents justificatifs'"/>
    <xsl:variable name="i18n.bt122" select="'Identifiant'"/>
    <xsl:variable name="i18n.bt123" select="'Description'"/>
    <xsl:variable name="i18n.bt124" select="'Référence (par exemple l''adresse Internet)'"/>
    <xsl:variable name="i18n.bt125" select="'Document joint'"/>
    <xsl:variable name="i18n.bt125-format" select="'Format du document joint'"/>
    <xsl:variable name="i18n.bt125-name" select="'Nom du document joint '"/>
    <xsl:variable name="i18n.historyDate" select="'Date/heure'"/>
    <xsl:variable name="i18n.historySubject" select="'Objet'"/>
    <xsl:variable name="i18n.historyText" select="'Texte'"/>
    <xsl:variable name="i18n.historyDetails" select="'Détails'"/>
    <xsl:variable name="i18n.payment" select="'Détails de paiement'"/>
    <xsl:variable name="i18n.contract_information" select="'Informations sur le contrat'"/>
    <xsl:variable name="i18n.preceding_invoice_reference" select="'Factures précédentes'"/>

    <xsl:include href="xrechnung-html.univ.xsl"/>

</xsl:stylesheet>
