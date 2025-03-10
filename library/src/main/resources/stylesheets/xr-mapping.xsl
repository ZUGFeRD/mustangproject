<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xr="urn:ce.eu:en16931:2017:xoev-de:kosit:standard:xrechnung-1"
                xmlns:xrv="http://www.example.org/XRechnung-Viewer">

  <xsl:template name="field-mapping">
    <xsl:param name="identifier"/>
    <xsl:choose>
      <xsl:when test="$identifier = 'xr:Buyer_reference'">
        <label>Leitweg-ID</label>
        <nummer>BT-10</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Buyer_name'">
        <label>Name</label>
        <nummer>BT-44</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Buyer_address_line_1'">
        <label>Adresszeile 1</label>
        <nummer>BT-50</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Buyer_address_line_2'">
        <label>Adresszeile 2</label>
        <nummer>BT-51</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Buyer_address_line_3'">
        <label>Adresszeile 3</label>
        <nummer>BT-163</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Buyer_post_code'">
        <label>PLZ</label>
        <nummer>BT-53</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Buyer_city'">
        <label>Ort</label>
        <nummer>BT-52</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Buyer_country_code'">
        <label>Land</label>
        <nummer>BT-55</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Buyer_identifier'">
        <label>Kennung</label>
        <nummer>BT-46</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Buyer_identifier/@scheme_identifier'">
        <label>Schema der Kennung</label>
        <nummer>BT-46</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Buyer_contact_point'">
        <label>Name</label>
        <nummer>BT-56</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Buyer_contact_telephone_number'">
        <label>Telefon</label>
        <nummer>BT-57</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Buyer_contact_email_address'">
        <label>E-Mail-Adresse</label>
        <nummer>BT-58</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Seller_name'">
        <label>Firmenname</label>
        <nummer>BT-27</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Seller_address_line_1'">
        <label>Adresszeile 1</label>
        <nummer>BT-35</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Seller_address_line_2'">
        <label>Adresszeile 2</label>
        <nummer>BT-36</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Seller_address_line_3'">
        <label>Adresszeile 3</label>
        <nummer></nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Seller_post_code'">
        <label>PLZ</label>
        <nummer>BT-38</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Seller_city'">
        <label>Ort</label>
        <nummer>BT-37</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Seller_country_subdivision'">
        <label>Bundesland</label>
        <nummer>BT-39</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Seller_country_code'">
        <label>Ländercode</label>
        <nummer>BT-40</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Seller_identifier'">
        <label>Kennung</label>
        <nummer>BT-29</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Seller_identifier/@scheme_identifier'">
        <label>Schema der Kennung</label>
        <nummer>BT-29</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Seller_contact_point'">
        <label>Name</label>
        <nummer>BT-41</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Seller_contact_telephone_number'">
        <label>Telefon</label>
        <nummer>BT-42</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Seller_contact_email_address'">
        <label>E-Mail-Adresse</label>
        <nummer>BT-43</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_number'">
        <label>Rechnungsnummer</label>
        <nummer>BT-1</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_issue_date'">
        <label>Rechnungsdatum</label>
        <nummer>BT-2</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_type_code'">
        <label>Rechnungsart</label>
        <nummer>BT-3</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_currency_code'">
        <label>Währung</label>
        <nummer>BT-5</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Project_reference'">
        <label>Projektnummer</label>
        <nummer>BT-11</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Contract_reference'">
        <label>Vertragsnummer</label>
        <nummer>BT-12</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Purchase_order_reference'">
        <label>Bestellnummer</label>
        <nummer>BT-13</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Sales_order_reference'">
        <label>Auftragsnummer</label>
        <nummer>BT-14</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoicing_period_start_date'">
        <label>von</label>
        <nummer>BT-73</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoicing_period_end_date'">
        <label>bis</label>
        <nummer>BT-74</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Preceding_Invoice_reference'">
        <label>Rechnungsnummer</label>
        <nummer>BT-25</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Preceding_Invoice_issue_date'">
        <label>Rechnungsdatum</label>
        <nummer>BT-26</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Sum_of_Invoice_line_net_amount'">
        <label>Summe aller Positionen</label>
        <nummer>BT-106</nummer>
        <art>netto</art>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Sum_of_allowances_on_document_level'">
        <label>Summe Nachlässe</label>
        <nummer>BT-107</nummer>
        <art>netto</art>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Sum_of_charges_on_document_level'">
        <label>Summe Zuschläge</label>
        <nummer>BT-108</nummer>
        <art>netto</art>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_total_amount_without_VAT'">
        <label>Gesamtsumme</label>
        <nummer>BT-109</nummer>
        <art>netto</art>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_total_VAT_amount'">
        <label>Summe Umsatzsteuer</label>
        <nummer>BT-110</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_total_VAT_amount_in_accounting_currency'">
        <label>Summe Umsatzsteuer in Abrechnungswährung</label>
        <nummer>BT-111</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_total_amount_with_VAT'">
        <label>Gesamtsumme</label>
        <nummer>BT-112</nummer>
        <art>brutto</art>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Paid_amount'">
        <label>Gezahlter Betrag</label>
        <nummer>BT-113</nummer>
        <art>brutto</art>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Rounding_amount'">
        <label>Rundungsbetrag</label>
        <nummer>BT-114</nummer>
        <art>brutto</art>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Amount_due_for_payment'">
        <label>Fälliger Betrag</label>
        <nummer>BT-115</nummer>
        <art>brutto</art>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:VAT_category_code'">
        <label>Umsatzsteuerkategorie</label>
        <nummer>BT-118</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:VAT_category_taxable_amount'">
        <label>Gesamtsumme</label>
        <nummer>BT-116</nummer>
        <art>netto</art>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:VAT_category_rate'">
        <label>Umsatzsteuersatz</label>
        <nummer>BT-119</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:VAT_category_tax_amount'">
        <label>Umsatzsteuerbetrag</label>
        <nummer>BT-117</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:VAT_exemption_reason_text'">
        <label>Befreiungsgrund</label>
        <nummer>BT-120</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:VAT_exemption_reason_code'">
        <label>Kennung für den Befreiungsgrund</label>
        <nummer>BT-121</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Document_level_allowance_VAT_category_code'">
        <label>Umsatzsteuerkategorie des Nachlasses</label>
        <nummer>BT-95</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Document_level_allowance_base_amount'">
        <label>Grundbetrag</label>
        <nummer>BT-93</nummer>
        <art>netto</art>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Document_level_allowance_percentage'">
        <label>Prozentsatz</label>
        <nummer>BT-94%</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Document_level_allowance_amount'">
        <label>Nachlass</label>
        <nummer>BT-92</nummer>
        <art>netto</art>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Document_level_allowance_VAT_rate'">
        <label>Umsatzsteuersatz des Nachlasses</label>
        <nummer>BT-96</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Document_level_allowance_reason'">
        <label>Grund für den Nachlass</label>
        <nummer>BT-97</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Document_level_allowance_reason_code'">
        <label>Document level allowance reason code</label>
        <nummer>BT-98</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Document_level_charge_VAT_category_code'">
        <label>Umsatzsteuerkategorie des Zuschlages</label>
        <nummer>BT-102</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Document_level_charge_base_amount'">
        <label>Grundbetrag</label>
        <nummer>BT-100</nummer>
        <art>netto</art>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Document_level_charge_percentage'">
        <label>Prozentsatz</label>
        <nummer>BT-101</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Document_level_charge_amount'">
        <label>Zuschlag</label>
        <nummer>BT-99</nummer>
        <art>netto</art>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Document_level_charge_VAT_rate'">
        <label>Umsatzsteuersatz des Zuschlages</label>
        <nummer>BT-103</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Document_level_charge_reason'">
        <label>Grund für den Zuschlag</label>
        <nummer>BT-104</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Document_level_charge_reason_code'">
        <label>Document level charge reason code</label>
        <nummer>BT-105</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Payment_terms'">
        <label>Skonto; weitere Zahlungsbedingungen</label>
        <nummer>BT-20</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Payment_due_date'">
        <label>Fälligkeitsdatum</label>
        <nummer>BT-9</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Payment_means_type_code'">
        <label>Code für das Zahlungsmittel</label>
        <nummer>BT-81</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Payment_means_text'">
        <label>Zahlungsmittel</label>
        <nummer>BT-82</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Remittance_information'">
        <label>Verwendungszweck</label>
        <nummer>BT-83</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Payment_card_primary_account_number'">
        <label>Kartennummer</label>
        <nummer>BT-87</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Payment_card_holder_name'">
        <label>Karteninhaber</label>
        <nummer>BT-88</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Mandate_reference_identifier'">
        <label>Mandatsreferenznr.</label>
        <nummer>BT-89</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Debited_account_identifier'">
        <label>IBAN</label>
        <nummer>BT-91</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Bank_assigned_creditor_identifier'">
        <label>Gläubiger-ID</label>
        <nummer>BT-90</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Payment_account_name'">
        <label>Kontoinhaber</label>
        <nummer>BT-85</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Payment_account_identifier'">
        <label>IBAN</label>
        <nummer>BT-84</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Payment_service_provider_identifier'">
        <label>BIC</label>
        <nummer>BT-86</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_note_subject_code'">
        <label>Betreff</label>
        <nummer>BT-21</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_note'">
        <label>Bemerkung</label>
        <nummer>BT-22</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Seller_trading_name'">
        <label>Abweichender Handelsname</label>
        <nummer>BT-28</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Seller_electronic_address'">
        <label>Elektronische Adresse</label>
        <nummer>BT-34</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Seller_electronic_address/@scheme_identifier'">
        <label>Schema der elektronischen Adresse</label>
        <nummer>BT-34</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Seller_legal_registration_identifier'">
        <label>Register-/Registriernummer</label>
        <nummer>BT-30</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Seller_VAT_identifier'">
        <label>Umsatzsteuer-ID</label>
        <nummer>BT-31</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Seller_tax_registration_identifier'">
        <label>Steuernummer</label>
        <nummer>BT-32</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Seller_tax_registration_identifier/@scheme_identifier'">
        <label>Schema der Steuernummer</label>
        <nummer>BT-32</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Seller_additional_legal_information'">
        <label>Weitere rechtliche Informationen</label>
        <nummer>BT-33</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:VAT_accounting_currency_code'">
        <label>Code der Umsatzsteuerwährung</label>
        <nummer>BT-6</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Seller_tax_representative_name'">
        <label>Name</label>
        <nummer>BT-62</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Tax_representative_address_line_1'">
        <label>Straße / Hausnummer</label>
        <nummer>BT-64</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Tax_representative_address_line_2'">
        <label>Adresszusatz</label>
        <nummer>BT-65</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Tax_representative_address_line_3'">
        <label>Adresszusatz</label>
        <nummer>BT-164</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Tax_representative_post_code'">
        <label>PLZ</label>
        <nummer>BT-67</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Tax_representative_city'">
        <label>Ort</label>
        <nummer>BT-66</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Tax_representative_country_subdivision'">
        <label>Bundesland</label>
        <nummer>BT-68</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Tax_representative_country_code'">
        <label>Ländercode</label>
        <nummer>BT-69</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Seller_tax_representative_VAT_identifier'">
        <label>Umsatzsteuer-ID</label>
        <nummer>BT-63</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Buyer_trading_name'">
        <label>Abweichender Handelsname</label>
        <nummer>BT-45</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Buyer_country_subdivision'">
        <label>Bundesland</label>
        <nummer>BT-54</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Buyer_electronic_address'">
        <label>Elektronische Adresse</label>
        <nummer>BT-49</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Buyer_electronic_address/@scheme_identifier'">
        <label>Schema der elektronischen Adresse</label>
        <nummer>BT-49</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Buyer_legal_registration_identifier'">
        <label>Register-/Registriernummer</label>
        <nummer>BT-47</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Buyer_legal_registration_identifier/@scheme_identifier'">
        <label>Schema der Register-/Registriernummer</label>
        <nummer>BT-47</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Buyer_VAT_identifier'">
        <label>Umsatzsteuer-ID</label>
        <nummer>BT-48</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Value_added_tax_point_date'">
        <label>Abrechnungsdatum der Umsatzsteuer</label>
        <nummer>BT-7</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Value_added_tax_point_date_code'">
        <label>Code des Umsatzsteuer-Abrechnungsdatums</label>
        <nummer>BT-8</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Buyer_accounting_reference'">
        <label>Kontierungsinformation</label>
        <nummer>BT-19</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Deliver_to_location_identifier'">
        <label>Kennung des Lieferorts</label>
        <nummer>BT-71</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Deliver_to_location_identifier/@scheme_identifier'">
        <label>Schema der Kennung</label>
        <nummer>BT-71</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Actual_delivery_date'">
        <label>Lieferdatum</label>
        <nummer>BT-72</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Deliver_to_party_name'">
        <label>Name des Empfängers</label>
        <nummer>BT-70</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Deliver_to_address_line_1'">
        <label>Straße / Hausnummer</label>
        <nummer>BT-75</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Deliver_to_address_line_2'">
        <label>Adresszusatz</label>
        <nummer>BT-76</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Deliver_to_address_line_3'">
        <label>Adresszusatz</label>
        <nummer>BT-165</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Deliver_to_post_code'">
        <label>PLZ</label>
        <nummer>BT-78</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Deliver_to_city'">
        <label>Ort</label>
        <nummer>BT-77</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Deliver_to_country_subdivision'">
        <label>Bundesland</label>
        <nummer>BT-79</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Deliver_to_country_code'">
        <label>Land</label>
        <nummer>BT-80</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Tender_or_lot_reference'">
        <label>Vergabenummer</label>
        <nummer>BT-17</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Receiving_advice_reference'">
        <label>Kennung der Empfangsbestätigung</label>
        <nummer>BT-15</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Despatch_advice_reference'">
        <label>Kennung der Versandanzeige</label>
        <nummer>BT-16</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Business_process_type'">
        <label>Prozesskennung</label>
        <nummer>BT-23</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Specification_identifier'">
        <label>Spezifikationskennung</label>
        <nummer>BT-24</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoiced_object_identifier'">
        <label>Objektkennung</label>
        <nummer>BT-18</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoiced_object_identifier/@scheme_identifier'">
        <label>Schema der Objektkennung</label>
        <nummer>BT-18</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Payee_name'">
        <label>Name</label>
        <nummer>BT-59</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Payee_identifier'">
        <label>Kennung</label>
        <nummer>BT-60</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Payee_identifier/@scheme_identifier'">
        <label>Schema der Kennung</label>
        <nummer>BT-60</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Payee_legal_registration_identifier'">
        <label>Register-/Registriernummer</label>
        <nummer>BT-61</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Payee_legal_registration_identifier/@scheme_identifier'">
        <label>Schema der Register-/Registriernummer</label>
        <nummer>BT-61</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Supporting_document_reference'">
        <label>Kennung</label>
        <nummer>BT-122</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Supporting_document_description'">
        <label>Beschreibung</label>
        <nummer>BT-123</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:External_document_location'">
        <label>Verweis (z.B. Internetadresse)</label>
        <nummer>BT-124</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Attached_document'">
        <label>Anhangsdokument</label>
        <nummer>BT-125</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Attached_document/@mime_code'">
        <label>Format des Anhangdokuments</label>
        <nummer>BT-125</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Attached_document/@filename'">
        <label>Name des Anhangsdokuments</label>
        <nummer>BT-125</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xrv:zeitstempel'">
        <label>Datum/Uhrzeit</label>
        <nummer></nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xrv:betreff'">
        <label>Betreff</label>
        <nummer></nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xrv:text'">
        <label>Text</label>
        <nummer></nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xrv:details'">
        <label>Details</label>
        <nummer></nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_line_note'">
        <label>Freitext</label>
        <nummer>BT-127</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_line_object_identifier'">
        <label>Objektkennung</label>
        <nummer>BT-128</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_line_object_identifier/@scheme_identifier'">
        <label>Schema der Objektkennung</label>
        <nummer>BT-128</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Referenced_purchase_order_line_reference'">
        <label>Nummer der Auftragsposition</label>
        <nummer>BT-132</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_line_Buyer_accounting_reference'">
        <label>Kontierungshinweis</label>
        <nummer>BT-133</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_line_Buyer_accounting_reference'">
        <label>Kontierungshinweis</label>
        <nummer>BT-133</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_line_period_start_date'">
        <label>von</label>
        <nummer>BT-134</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_line_period_end_date'">
        <label>bis</label>
        <nummer>BT-135</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_line_period_end_date'">
        <label>bis</label>
        <nummer>BT-135</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoiced_quantity'">
        <label>Menge</label>
        <nummer>BT-129</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoiced_quantity_unit_of_measure_code'">
        <label>Einheit</label>
        <nummer>BT-130</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Item_net_price'">
        <label>Preis pro Einheit (netto)</label>
        <nummer>BT-146</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_line_net_amount'">
        <label>Gesamtpreis (netto)</label>
        <nummer>BT-131</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Item_price_discount'">
        <label>Rabatt (netto)</label>
        <nummer>BT-147</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Item_gross_price'">
        <label>Listenpreis (netto)</label>
        <nummer>BT-148</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Item_price_base_quantity'">
        <label>Anzahl der Einheit</label>
        <nummer>BT-149</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Item_price_base_quantity_unit_of_measure'">
        <label>Code der Maßeinheit</label>
        <nummer>BT-150</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoiced_item_VAT_category_code'">
        <label>Umsatzsteuer</label>
        <nummer>BT-151</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoiced_item_VAT_rate'">
        <label>Umsatzsteuersatz in Prozent</label>
        <nummer>BT-152</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Item_name'">
        <label>Bezeichnung</label>
        <nummer>BT-153</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Item_description'">
        <label>Beschreibung</label>
        <nummer>BT-154</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Item_Sellers_identifier'">
        <label>Artikelnummer</label>
        <nummer>BT-155</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Item_Buyers_identifier'">
        <label>Artikelkennung des Käufers</label>
        <nummer>BT-156</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Item_standard_identifier'">
        <label>Artikelkennung</label>
        <nummer>BT-157</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Item_standard_identifier/@scheme_identifier'">
        <label>Schema der Artikelkennung</label>
        <nummer>BT-157</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Item_classification_identifier'">
        <label>Code der Artikelklassifizierung</label>
        <nummer>BT-158</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Item_classification_identifier/@scheme_identifier'">
        <label>Kennung zur Bildung des Schemas</label>
        <nummer>BT-158</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Item_classification_identifier/@scheme_version_identifier'">
        <label>Version zur Bildung des Schemas</label>
        <nummer>BT-158</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Item_country_of_origin'">
        <label>Code des Herkunftslandes</label>
        <nummer>BT-159</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_line_allowance_base_amount'">
        <label>Grundbetrag (netto)</label>
        <nummer>BT-137</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_line_allowance_percentage'">
        <label>Prozentsatz</label>
        <nummer>BT-138</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_line_allowance_amount'">
        <label>Nachlass (netto)</label>
        <nummer>BT-136</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_line_allowance_reason'">
        <label>Grund des Nachlasses</label>
        <nummer>BT-139</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_line_allowance_reason_code'">
        <label>Code für den Nachlassgrund</label>
        <nummer>BT-140</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_line_charge_base_amount'">
        <label>Grundbetrag (netto)</label>
        <nummer>BT-142</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_line_charge_percentage'">
        <label>Prozentsatz</label>
        <nummer>BT-143</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_line_charge_amount'">
        <label>Zuschlag (netto)</label>
        <nummer>BT-141</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_line_charge_reason'">
        <label>Grund des Zuschlags</label>
        <nummer>BT-144</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'xr:Invoice_line_charge_reason_code'">
        <label>Code für den Zuschlagsgrund</label>
        <nummer>BT-145</nummer>
      </xsl:when>


      
      <xsl:when test="$identifier = 'uebersicht'">
        <label>Übersicht</label>
        <nummer></nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'uebersichtKaeufer'">
        <label>Informationen zum Käufer</label>
        <nummer>BG-7</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'uebersichtVerkaeufer'">
        <label>Informationen zum Verkäufer</label>
        <nummer>BG-4</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'uebersichtRechnungsInfo'">
        <label>Rechnungsdaten</label>
        <nummer>BG-4</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'uebersichtRechnungsuebersicht'">
        <label>Gesamtbeträge der Rechnung</label>
        <nummer>BG-22</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'uebersichtUmsatzsteuer'">
        <label>Aufschlüsselung der Umsatzsteuer auf Ebene der Rechnung</label>
        <nummer>BG-23</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'uebersichtNachlass'">
        <label>Nachlässe auf Ebene der Rechnung</label>
        <nummer>BG-20</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'uebersichtZuschlaege'">
        <label>Zuschläge auf Ebene der Rechnung</label>
        <nummer>BG-21</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'uebersichtRechnungAbrechnungszeitraum'">
        <label>Abrechnungszeitraum</label>
      </xsl:when>
      <xsl:when test="$identifier = 'uebersichtRechnungVorausgegangeneRechnungen'">
        <label>Vorausgegangene Rechnungen</label>
      </xsl:when>
      <xsl:when test="$identifier = 'uebersichtZahlungInfo'">
        <label>Zahlungsdaten</label>
        <nummer>BG-4</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'uebersichtZahlungKarte'">
        <label>Karteninformationen</label>
        <nummer>BG-18</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'uebersichtZahlungLastschrift'">
        <label>Lastschrift</label>
        <nummer>BG-19</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'uebersichtZahlungUeberweisung'">
        <label>Überweisung</label>
        <nummer>BG-17</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'uebersichtBemerkungen'">
        <label>Bemerkungen zur Rechnung</label>
        <nummer>BG-1</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'details'">
        <label>Details</label>
        <nummer></nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'detailsPositionAbrechnungszeitraum'">
        <label>Abrechnungszeitraum</label>
        <nummer>BG-26</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'detailsPositionPreiseinzelheiten'">
        <label>Preiseinzelheiten</label>
        <nummer>BG-29</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'detailsPositionNachlaesse'">
        <label>Nachlässe auf Ebene der Rechnungsposition</label>
        <nummer>BG-27</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'detailsPositionZuschlaege'">
        <label>Zuschläge auf Ebene der Rechnungsposition</label>
        <nummer>BG-28</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'detailsPositionArtikelinformationen'">
        <label>Artikelinformationen</label>
        <nummer>BG-31</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'detailsPositionArtikeleigenschaften'">
        <label>Eigenschaften des Artikels</label>
        <nummer>BG-32</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'zusaetze'">
        <label>Zusätze</label>
        <nummer></nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'zusaetzeVerkaeufer'">
        <label>Informationen zum Verkäufer</label>
        <nummer>BG-4</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'zusaetzeSteuervertreter'">
        <label>Steuervertreter des Verkäufers</label>
        <nummer>BG-11</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'zusaetzeKaeufer'">
        <label>Informationen zum Käufer</label>
        <nummer>BG-7</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'zusaetzeLieferung'">
        <label>Lieferinformationen</label>
        <nummer>BG-13</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'zusaetzeVertrag'">
        <label>Informationen zum Vertrag</label>
        <nummer></nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'zusaetzeZahlungsempfaenger'">
        <label>Vom Verkäufer abweichender Zahlungsempfänger</label>
        <nummer>BG-10</nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'laufzettel'">
        <label>Laufzettel</label>
        <nummer></nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'laufzettelHistorie'">
        <label>Bearbeitungshistorie</label>
        <nummer></nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'anlagen'">
        <label>Anlagen</label>
        <nummer></nummer>
      </xsl:when>
      <xsl:when test="$identifier = 'anlagenListe'">
        <label>Rechnungsbegründende Unterlagen</label>
        <nummer></nummer>
      </xsl:when>
      

      <xsl:otherwise>
        <label>Unbekannt</label>
        <nummer>unknown</nummer>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

</xsl:stylesheet>
