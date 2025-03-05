<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xr="urn:ce.eu:en16931:2017:xoev-de:kosit:standard:xrechnung-1"
                xmlns:xrv="http://www.example.org/XRechnung-Viewer"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:xrf="https://projekte.kosit.org/xrechnung/xrechnung-visualization/functions">
  
  <xsl:decimal-format name="de" decimal-separator="," grouping-separator="." NaN="" />
  <xsl:decimal-format name="en" decimal-separator="." grouping-separator="," NaN="" />
  
  <xsl:template name="uebersicht">
    <xsl:call-template name="page">
      <xsl:with-param name="identifier" select="'uebersicht'"/>
      <xsl:with-param name="content">
        <xsl:call-template name="uebersicht_Content"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="uebersicht_Content">
    <xsl:call-template name="uebersichtKaeufer"/>
    <xsl:call-template name="uebersichtVerkaeufer"/>
    <xsl:call-template name="uebersichtRechnungsInfo"/>
    <xsl:call-template name="uebersichtFremdleistungen"/>
    <xsl:call-template name="uebersichtRechnungsuebersicht"/>
    <xsl:call-template name="uebersichtUmsatzsteuer"/>
    <xsl:call-template name="uebersichtNachlass"/>
    <xsl:call-template name="uebersichtZuschlaege"/>
    <xsl:call-template name="uebersichtZahlungInfo"/>
    <xsl:call-template name="uebersichtBemerkungen"/>
  </xsl:template>

  <xsl:template name="uebersichtKaeufer">
    <xsl:call-template name="box">
      <xsl:with-param name="identifier" select="'uebersichtKaeufer'"/>
      <xsl:with-param name="content">
        <xsl:call-template name="list">
          <xsl:with-param name="content">
            <xsl:apply-templates mode="list-entry" select="xr:Buyer_reference"/>
            <xsl:apply-templates mode="list-entry" select="xr:BUYER/xr:Buyer_name"/>
            <xsl:apply-templates mode="list-entry" select="xr:BUYER/xr:BUYER_POSTAL_ADDRESS/xr:Buyer_address_line_1"/>
            <xsl:apply-templates mode="list-entry" select="xr:BUYER/xr:BUYER_POSTAL_ADDRESS/xr:Buyer_address_line_2"/>
            <xsl:apply-templates mode="list-entry" select="xr:BUYER/xr:BUYER_POSTAL_ADDRESS/xr:Buyer_address_line_3"/>
            <xsl:apply-templates mode="list-entry" select="xr:BUYER/xr:BUYER_POSTAL_ADDRESS/xr:Buyer_post_code"/>
            <xsl:apply-templates mode="list-entry" select="xr:BUYER/xr:BUYER_POSTAL_ADDRESS/xr:Buyer_city"/>
            <xsl:apply-templates mode="list-entry" select="xr:BUYER/xr:BUYER_POSTAL_ADDRESS/xr:Buyer_country_subdivision"/>
            <xsl:apply-templates mode="list-entry" select="xr:BUYER/xr:BUYER_POSTAL_ADDRESS/xr:Buyer_country_code"/>
            <xsl:apply-templates mode="list-entry" select="xr:BUYER/xr:Buyer_identifier"/>
            <xsl:apply-templates mode="list-entry" select="xr:BUYER/xr:Buyer_identifier/@scheme_identifier">
              <xsl:with-param name="field-mapping-identifier" select="'xr:Buyer_identifier/@scheme_identifier'"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="list-entry" select="xr:BUYER/xr:BUYER_CONTACT/xr:Buyer_contact_point"/>
            <xsl:apply-templates mode="list-entry" select="xr:BUYER/xr:BUYER_CONTACT/xr:Buyer_contact_telephone_number"/>
            <xsl:apply-templates mode="list-entry" select="xr:BUYER/xr:BUYER_CONTACT/xr:Buyer_contact_email_address"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="uebersichtVerkaeufer">
    <xsl:call-template name="box">
      <xsl:with-param name="identifier" select="'uebersichtVerkaeufer'"/>
      <xsl:with-param name="content">
        <xsl:call-template name="list">
          <xsl:with-param name="content">
            <xsl:apply-templates mode="list-entry" select="xr:SELLER/xr:Seller_name"/>
            <xsl:apply-templates mode="list-entry" select="xr:SELLER/xr:SELLER_POSTAL_ADDRESS/xr:Seller_address_line_1"/>
            <xsl:apply-templates mode="list-entry" select="xr:SELLER/xr:SELLER_POSTAL_ADDRESS/xr:Seller_address_line_2"/>
            <xsl:apply-templates mode="list-entry" select="xr:SELLER/xr:SELLER_POSTAL_ADDRESS/xr:Seller_address_line_3"/>
            <xsl:apply-templates mode="list-entry" select="xr:SELLER/xr:SELLER_POSTAL_ADDRESS/xr:Seller_post_code"/>
            <xsl:apply-templates mode="list-entry" select="xr:SELLER/xr:SELLER_POSTAL_ADDRESS/xr:Seller_city"/>
            <xsl:apply-templates mode="list-entry" select="xr:SELLER/xr:SELLER_POSTAL_ADDRESS/xr:Seller_country_subdivision"/>
            <xsl:apply-templates mode="list-entry" select="xr:SELLER/xr:SELLER_POSTAL_ADDRESS/xr:Seller_country_code"/>
            <xsl:for-each select="xr:SELLER/xr:Seller_identifier">
              <xsl:apply-templates mode="list-entry" select="."/>
              <xsl:apply-templates mode="list-entry" select="./@scheme_identifier">
                <xsl:with-param name="field-mapping-identifier" select="'xr:Seller_identifier/@scheme_identifier'"/>
              </xsl:apply-templates>
            </xsl:for-each>
            <xsl:apply-templates mode="list-entry" select="xr:SELLER/xr:SELLER_CONTACT/xr:Seller_contact_point"/>
            <xsl:apply-templates mode="list-entry" select="xr:SELLER/xr:SELLER_CONTACT/xr:Seller_contact_telephone_number"/>
            <xsl:apply-templates mode="list-entry" select="xr:SELLER/xr:SELLER_CONTACT/xr:Seller_contact_email_address"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="uebersichtRechnungsInfo">
    <xsl:call-template name="box">
      <xsl:with-param name="identifier" select="'uebersichtRechnungsInfo'"/>
      <xsl:with-param name="content">
        <xsl:call-template name="uebersichtRechnungsInfo_Content"/>
        <xsl:call-template name="uebersichtRechnungAbrechnungszeitraum_Content"/>
        <xsl:call-template name="uebersichtRechnungVorausgegangeneRechnungen_Content"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="uebersichtRechnungsInfo_Content">
    <xsl:call-template name="list">
      <xsl:with-param name="content">
        <xsl:apply-templates select="xr:Invoice_number" mode="list-entry"/>
        <xsl:apply-templates select="xr:Invoice_issue_date" mode="list-entry">
          <xsl:with-param name="value" select="if (matches(
            normalize-space(
            replace(xr:Invoice_issue_date, '-', '')
            ),
            $datepattern)
            )
            then
            format-date(xr:Invoice_issue_date, xrf:_('date-format'))
            else
            xr:Invoice_issue_date/text()"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="xr:Invoice_type_code" mode="list-entry"/>
        <xsl:apply-templates select="xr:Invoice_currency_code" mode="list-entry"/>
        <xsl:for-each select="tokenize(xr:Value_added_tax_point_date,';')">             
          <xsl:call-template name="list-entry-bt-7">
            <xsl:with-param name="value" select="format-date(xs:date(.),xrf:_('date-format'))"/>
            <xsl:with-param name="field-mapping-identifier" select="'xr:Value_added_tax_point_date'"/>
          </xsl:call-template>
        </xsl:for-each>
        <xsl:apply-templates select="xr:Value_added_tax_point_date_code" mode="list-entry"/>
        <xsl:apply-templates select="xr:Project_reference" mode="list-entry"/>
        <xsl:apply-templates select="xr:Contract_reference" mode="list-entry"/>
        <xsl:apply-templates select="xr:Purchase_order_reference" mode="list-entry"/>
        <xsl:apply-templates select="xr:Sales_order_reference" mode="list-entry"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="uebersichtRechnungAbrechnungszeitraum_Content">
    <xsl:call-template name="list">
      <xsl:with-param name="headingId" select="'uebersichtRechnungAbrechnungszeitraum'"/>
      <xsl:with-param name="content">
        <xsl:apply-templates select="xr:INVOICING_PERIOD/xr:Invoicing_period_start_date" mode="list-entry">
          <xsl:with-param name="value" select="format-date(xr:INVOICING_PERIOD/xr:Invoicing_period_start_date, xrf:_('date-format'))"/>
        </xsl:apply-templates>
        <xsl:apply-templates select="xr:INVOICING_PERIOD/xr:Invoicing_period_end_date" mode="list-entry">
          <xsl:with-param name="value" select="format-date(xr:INVOICING_PERIOD/xr:Invoicing_period_end_date, xrf:_('date-format'))"/>
        </xsl:apply-templates>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="uebersichtRechnungVorausgegangeneRechnungen_Content">
    <xsl:call-template name="list">
      <xsl:with-param name="headingId" select="'uebersichtRechnungVorausgegangeneRechnungen'"/>
      <xsl:with-param name="content">
        <xsl:for-each select="xr:PRECEDING_INVOICE_REFERENCE">
          <xsl:call-template name="sub-list">
            <xsl:with-param name="content">
              <xsl:apply-templates select="xr:Preceding_Invoice_reference" mode="list-entry"/>
              <xsl:apply-templates select="xr:Preceding_Invoice_issue_date" mode="list-entry">
                <xsl:with-param name="value" select="format-date(xr:Preceding_Invoice_issue_date, xrf:_('date-format'))"/>
              </xsl:apply-templates>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="uebersichtFremdleistungen">
    <xsl:for-each select="xr:THIRD_PARTY_PAYMENT">
      <xsl:call-template name="spanned-box">
        <xsl:with-param name="identifier" select="'uebersichtFremdleistungen'"/>
        <xsl:with-param name="content">
          <xsl:call-template name="list">
            <xsl:with-param name="layout" select="'einspaltig'"/>
            <xsl:with-param name="content">
              <xsl:apply-templates mode="list-entry" select="xr:Third_party_payment_type"/>
            </xsl:with-param>
          </xsl:call-template>
          <xsl:call-template name="list">
            <xsl:with-param name="layout" select="'einspaltig'"/>
            <xsl:with-param name="content">
              <xsl:apply-templates mode="list-entry" select="xr:Third_party_payment_description"/>
            </xsl:with-param>
          </xsl:call-template>
          <xsl:call-template name="value-list">
            <xsl:with-param name="content">
              <xsl:apply-templates mode="sum-list-entry" select="xr:Third_party_payment_amount">
                <xsl:with-param name="value" select="xr:Third_party_payment_amount"/>
              </xsl:apply-templates>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:with-param>
      </xsl:call-template>
    </xsl:for-each>
  </xsl:template>

  <xsl:template name="uebersichtRechnungsuebersicht">
    <xsl:call-template name="spanned-box">
      <xsl:with-param name="identifier" select="'uebersichtRechnungsuebersicht'"/>
      <xsl:with-param name="content">
        <xsl:call-template name="value-list">
          <xsl:with-param name="content">
            <xsl:apply-templates mode="value-list-entry" select="xr:DOCUMENT_TOTALS/xr:Sum_of_Invoice_line_net_amount">
              <xsl:with-param name="value" select="format-number(xr:DOCUMENT_TOTALS/xr:Sum_of_Invoice_line_net_amount,$amount-picture,$lang)"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="value-list-entry" select="xr:DOCUMENT_TOTALS/xr:Sum_of_allowances_on_document_level">
              <xsl:with-param name="value" select="format-number(xr:DOCUMENT_TOTALS/xr:Sum_of_allowances_on_document_level,$amount-picture,$lang)"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="value-list-entry" select="xr:DOCUMENT_TOTALS/xr:Sum_of_charges_on_document_level">
              <xsl:with-param name="value" select="format-number(xr:DOCUMENT_TOTALS/xr:Sum_of_charges_on_document_level,$amount-picture,$lang)"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="sum-list-entry" select="xr:DOCUMENT_TOTALS/xr:Invoice_total_amount_without_VAT">
              <xsl:with-param name="value" select="format-number(xr:DOCUMENT_TOTALS/xr:Invoice_total_amount_without_VAT,$amount-picture,$lang)"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="value-list-entry" select="xr:DOCUMENT_TOTALS/xr:Invoice_total_VAT_amount">
              <xsl:with-param name="value" select="format-number(xr:DOCUMENT_TOTALS/xr:Invoice_total_VAT_amount,$amount-picture,$lang)"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="value-list-entry" select="xr:DOCUMENT_TOTALS/xr:Invoice_total_VAT_amount_in_accounting_currency">
              <xsl:with-param name="value" select="format-number(xr:DOCUMENT_TOTALS/xr:Invoice_total_VAT_amount_in_accounting_currency,$amount-picture,$lang)"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="sum-list-entry" select="xr:DOCUMENT_TOTALS/xr:Invoice_total_amount_with_VAT">
              <xsl:with-param name="value" select="format-number(xr:DOCUMENT_TOTALS/xr:Invoice_total_amount_with_VAT,$amount-picture,$lang)"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="value-list-entry" select="xr:DOCUMENT_TOTALS/xr:Paid_amount">
              <xsl:with-param name="value" select="format-number(xr:DOCUMENT_TOTALS/xr:Paid_amount,$amount-picture,$lang)"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="value-list-entry" select="xr:DOCUMENT_TOTALS/xr:Rounding_amount">
              <xsl:with-param name="value" select="format-number(xr:DOCUMENT_TOTALS/xr:Rounding_amount,$amount-picture,$lang)"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="value-list-entry" select="/xr:invoice">
              <xsl:with-param name="field-mapping-identifier" select="'sum-of-third-party-payment-amounts'"/>
              <xsl:with-param name="value" select="format-number(sum(xr:THIRD_PARTY_PAYMENT/xr:Third_party_payment_amount),$amount-picture,$lang)"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="sum-list-entry" select="xr:DOCUMENT_TOTALS/xr:Amount_due_for_payment">
              <xsl:with-param name="level" select="'final'"/>
              <xsl:with-param name="value" select="format-number(xr:DOCUMENT_TOTALS/xr:Amount_due_for_payment,$amount-picture,$lang)"/>
            </xsl:apply-templates>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="uebersichtUmsatzsteuer">
    <xsl:call-template name="spanned-box">
      <xsl:with-param name="identifier" select="'uebersichtUmsatzsteuer'"/>
      <xsl:with-param name="content">
        <xsl:for-each select="xr:VAT_BREAKDOWN">
          <xsl:call-template name="value-list">
            <xsl:with-param name="headingId" select="'xr:VAT_category_code'"/>
            <xsl:with-param name="headingValue" select="xr:VAT_category_code"/>
            <xsl:with-param name="content">
              <xsl:apply-templates mode="value-list-entry" select="xr:VAT_category_taxable_amount">
                <xsl:with-param name="value" select="format-number(xr:VAT_category_taxable_amount,$amount-picture,$lang)"/>
              </xsl:apply-templates>
              <xsl:apply-templates mode="value-list-entry" select="xr:VAT_category_rate">
                <xsl:with-param name="value" select="concat(format-number(xr:VAT_category_rate,$percentage-picture,$lang), '%')"/>
              </xsl:apply-templates>
              <xsl:apply-templates mode="sum-list-entry" select="xr:VAT_category_tax_amount">
                <xsl:with-param name="value" select="format-number(xr:VAT_category_tax_amount,$amount-picture,$lang)"/>
              </xsl:apply-templates>
            </xsl:with-param>
          </xsl:call-template>
          <xsl:call-template name="list">
            <xsl:with-param name="content">
              <xsl:apply-templates mode="list-entry" select="xr:VAT_exemption_reason_text"/>
              <xsl:apply-templates mode="list-entry" select="xr:VAT_exemption_reason_code"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="uebersichtNachlass">
    <xsl:call-template name="box">
      <xsl:with-param name="identifier" select="'uebersichtNachlass'"/>
      <xsl:with-param name="content">
        <xsl:for-each select="xr:DOCUMENT_LEVEL_ALLOWANCES">
          <xsl:call-template name="section">
            <xsl:with-param name="layout" select="'einspaltig'"/>
            <xsl:with-param name="content">
              <xsl:call-template name="value-list">
                <xsl:with-param name="headingId" select="'xr:Document_level_allowance_VAT_category_code'"/>
                <xsl:with-param name="headingValue" select="xr:Document_level_allowance_VAT_category_code"/>
                <xsl:with-param name="content">
                  <xsl:apply-templates mode="value-list-entry" select="xr:Document_level_allowance_base_amount">
                    <xsl:with-param name="value" select="format-number(xr:Document_level_allowance_base_amount,$amount-picture,$lang)"/>
                  </xsl:apply-templates>
                  <xsl:apply-templates mode="value-list-entry" select="xr:Document_level_allowance_percentage">
                    <xsl:with-param name="value" select="concat(format-number(xr:Document_level_allowance_percentage,$percentage-picture,$lang), '%')"/>
                  </xsl:apply-templates>
                  <xsl:apply-templates mode="sum-list-entry" select="xr:Document_level_allowance_amount">
                    <xsl:with-param name="value" select="format-number(xr:Document_level_allowance_amount,$amount-picture,$lang)"/>
                  </xsl:apply-templates>
                  <xsl:apply-templates mode="value-list-entry" select="xr:Document_level_allowance_VAT_rate">
                    <xsl:with-param name="value" select="concat(format-number(xr:Document_level_allowance_VAT_rate,$percentage-picture,$lang), '%')"/>
                  </xsl:apply-templates>
                </xsl:with-param>
              </xsl:call-template>
              <xsl:call-template name="list">
                <xsl:with-param name="content">
                  <xsl:apply-templates mode="list-entry" select="xr:Document_level_allowance_reason"/>
                  <xsl:apply-templates mode="list-entry" select="xr:Document_level_allowance_reason_code"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="uebersichtZuschlaege">
      <xsl:call-template name="box">
        <xsl:with-param name="identifier" select="'uebersichtZuschlaege'"/>
        <xsl:with-param name="content">
          <xsl:for-each select="xr:DOCUMENT_LEVEL_CHARGES">
            <xsl:call-template name="section">
              <xsl:with-param name="layout" select="'einspaltig'"/>
              <xsl:with-param name="content">
                <xsl:call-template name="value-list">
                  <xsl:with-param name="headingId" select="'xr:Document_level_charge_VAT_category_code'"/>
                  <xsl:with-param name="headingValue" select="xr:Document_level_charge_VAT_category_code"/>
                  <xsl:with-param name="content">
                    <xsl:apply-templates mode="value-list-entry" select="xr:Document_level_charge_base_amount">
                      <xsl:with-param name="value" select="format-number(xr:Document_level_charge_base_amount,$amount-picture,$lang)"/>
                    </xsl:apply-templates>
                    <xsl:apply-templates mode="value-list-entry" select="xr:Document_level_charge_percentage">
                      <xsl:with-param name="value" select="concat(format-number(xr:Document_level_charge_percentage,$percentage-picture,$lang), '%')"/>
                    </xsl:apply-templates>
                    <xsl:apply-templates mode="sum-list-entry" select="xr:Document_level_charge_amount">
                      <xsl:with-param name="value" select="format-number(xr:Document_level_charge_amount,$amount-picture,$lang)"/>
                    </xsl:apply-templates>
                    <xsl:apply-templates mode="value-list-entry" select="xr:Document_level_charge_VAT_rate">
                      <xsl:with-param name="value" select="concat(format-number(xr:Document_level_charge_VAT_rate,$percentage-picture,$lang), '%')"/>
                    </xsl:apply-templates>
                  </xsl:with-param>
                </xsl:call-template>
                <xsl:call-template name="list">
                  <xsl:with-param name="content">
                    <xsl:apply-templates mode="list-entry" select="xr:Document_level_charge_reason"/>
                    <xsl:apply-templates mode="list-entry" select="xr:Document_level_charge_reason_code"/>
                  </xsl:with-param>
                </xsl:call-template>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:for-each>
        </xsl:with-param>
      </xsl:call-template>
  </xsl:template>

  <xsl:template name="uebersichtZahlungInfo">
    <xsl:call-template name="box">
      <xsl:with-param name="identifier" select="'uebersichtZahlungInfo'"/>
      <xsl:with-param name="content">
        <xsl:call-template name="uebersichtZahlungInfo_Content"/>
        <xsl:call-template name="uebersichtZahlungKarte_Content"/>
        <xsl:call-template name="uebersichtZahlungLastschrift_Content"/>
        <fo:block xsl:use-attribute-sets="separator" span="all" line-height="0pt"/>
        <xsl:call-template name="uebersichtZahlungUeberweisung_Content"/>        
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="uebersichtZahlungInfo_Content">
    <xsl:call-template name="list">
      <xsl:with-param name="content">        
        <xsl:apply-templates mode="list-entry" select="xr:Payment_terms"/>        
        <xsl:apply-templates mode="list-entry" select="xr:Payment_due_date"/>       
        <xsl:apply-templates mode="list-entry" select="xr:PAYMENT_INSTRUCTIONS/xr:Payment_means_type_code"/>
        <xsl:apply-templates mode="list-entry" select="xr:PAYMENT_INSTRUCTIONS/xr:Payment_means_text"/>
        <xsl:apply-templates mode="list-entry" select="xr:PAYMENT_INSTRUCTIONS/xr:Remittance_information"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="uebersichtZahlungKarte_Content">
    <xsl:call-template name="list">
      <xsl:with-param name="headingId" select="'uebersichtZahlungKarte'"/>
      <xsl:with-param name="content">
        <xsl:apply-templates mode="list-entry" select="xr:PAYMENT_INSTRUCTIONS/xr:PAYMENT_CARD_INFORMATION/xr:Payment_card_primary_account_number"/>
        <xsl:apply-templates mode="list-entry" select="xr:PAYMENT_INSTRUCTIONS/xr:PAYMENT_CARD_INFORMATION/xr:Payment_card_holder_name"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="uebersichtZahlungLastschrift_Content">
    <xsl:call-template name="list">
      <xsl:with-param name="headingId" select="'uebersichtZahlungLastschrift'"/>
      <xsl:with-param name="content">
        <xsl:apply-templates mode="list-entry" select="xr:PAYMENT_INSTRUCTIONS/xr:DIRECT_DEBIT/xr:Mandate_reference_identifier"/>
        <xsl:apply-templates mode="list-entry" select="xr:PAYMENT_INSTRUCTIONS/xr:DIRECT_DEBIT/xr:Debited_account_identifier"/>
        <xsl:apply-templates mode="list-entry" select="xr:PAYMENT_INSTRUCTIONS/xr:DIRECT_DEBIT/xr:Bank_assigned_creditor_identifier"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="uebersichtZahlungUeberweisung_Content">
    <xsl:call-template name="list">
      <xsl:with-param name="layout" select="'einspaltig'"/>
      <xsl:with-param name="headingId" select="'uebersichtZahlungUeberweisung'"/>
      <xsl:with-param name="content">
        <xsl:for-each select="xr:PAYMENT_INSTRUCTIONS/xr:CREDIT_TRANSFER">
          <xsl:call-template name="sub-list">
            <xsl:with-param name="content">
              <xsl:apply-templates mode="list-entry" select="xr:Payment_account_name"/>
              <xsl:apply-templates mode="list-entry" select="xr:Payment_account_identifier"/>
              <xsl:apply-templates mode="list-entry" select="xr:Payment_service_provider_identifier"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>        
      </xsl:with-param>      
    </xsl:call-template>    
  </xsl:template>

  <xsl:template name="uebersichtBemerkungen">
    <xsl:call-template name="spanned-box">
      <xsl:with-param name="identifier" select="'uebersichtBemerkungen'"/>
      <xsl:with-param name="content">
        <xsl:for-each select="xr:INVOICE_NOTE">
          <xsl:call-template name="list">
            <xsl:with-param name="layout" select="'einspaltig'"/>
            <xsl:with-param name="content">
              <xsl:apply-templates mode="list-entry" select="xr:Invoice_note_subject_code"/>
              <xsl:apply-templates mode="list-entry" select="xr:Invoice_note"/>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="details">
    <xsl:choose>
      <xsl:when test="$invoiceline-layout = 'normal'">
        <xsl:call-template name="page">
          <xsl:with-param name="identifier" select="'details'"/>
          <xsl:with-param name="content">
            <xsl:apply-templates select="xr:INVOICE_LINE"/>    
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
        <fo:block span="all">
          <xsl:call-template name="page">
            <xsl:with-param name="identifier" select="'details'"/>
            <xsl:with-param name="content">
              <fo:table xsl:use-attribute-sets="invoicelines-table" span="all">
                <xsl:for-each select="tokenize($tabular-layout-widths, '\s+')">
                  <fo:table-column column-width="proportional-column-width({.})"/>
                </xsl:for-each>
                <fo:table-header xsl:use-attribute-sets="invoicelines-table-header">
                  <fo:table-row>
                    <fo:table-cell>
                      <fo:block>#</fo:block>
                    </fo:table-cell>
                    <fo:table-cell>
                      <fo:block><xsl:value-of select="xrf:_('_description')"/></fo:block>
                    </fo:table-cell>
                    <fo:table-cell text-align="center">
                      <fo:block><xsl:value-of select="xrf:_('xr:Invoiced_quantity')"/></fo:block>
                    </fo:table-cell>
                    <fo:table-cell text-align="right" padding-right="1em">
                      <fo:block><xsl:value-of select="xrf:_('_price')"/></fo:block>
                    </fo:table-cell>
                    <fo:table-cell text-align="center">
                      <fo:block><xsl:value-of select="xrf:_('_price-unit')"/></fo:block>
                    </fo:table-cell>
                    <fo:table-cell text-align="center">
                      <fo:block><xsl:value-of select="xrf:_('_vat')"/></fo:block>
                    </fo:table-cell>
                    <fo:table-cell text-align="center">
                      <fo:block><xsl:value-of select="xrf:_('_tax-code')"/></fo:block>
                    </fo:table-cell>
                    <fo:table-cell text-align="right">
                      <fo:block><xsl:value-of select="xrf:_('_total')"/></fo:block>
                    </fo:table-cell>
                  </fo:table-row>
                </fo:table-header>      
                <fo:table-body>
                  <xsl:apply-templates select="xr:INVOICE_LINE" mode="invoiceline-tabular"/>
                </fo:table-body>
              </fo:table>
            </xsl:with-param>
          </xsl:call-template>
        </fo:block>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <xsl:template name="detailsPosition">    
    <xsl:call-template name="detailsPosition_Content"/>    
    <xsl:call-template name="detailsPositionAbrechnungszeitraum"/>
    <xsl:call-template name="detailsPositionPreiseinzelheiten"/>
    <xsl:call-template name="detailsPositionNachlaesse"/>
    <xsl:call-template name="detailsPositionZuschlaege"/>
    <xsl:call-template name="detailsPositionArtikelinformationen"/>
    <xsl:call-template name="detailsPositionArtikeleigenschaften"/>
  </xsl:template>

  <xsl:template name="detailsPosition_Content">
    <xsl:variable name="content">
      <xsl:apply-templates mode="list-entry" select="xr:Invoice_line_identifier"/>
      <xsl:apply-templates mode="list-entry" select="xr:Invoice_line_note"/>
      <xsl:apply-templates mode="list-entry" select="xr:Invoice_line_object_identifier"/>      
      <xsl:apply-templates mode="list-entry" select="xr:Invoice_line_object_identifier/@scheme_identifier">
        <xsl:with-param name="field-mapping-identifier" select="'xr:Invoice_line_object_identifier/@scheme_identifier'"/>
      </xsl:apply-templates>
      <xsl:apply-templates mode="list-entry" select="xr:Referenced_purchase_order_line_reference"/>
      <xsl:apply-templates mode="list-entry" select="xr:Invoice_line_Buyer_accounting_reference"/>
    </xsl:variable>
    <xsl:call-template name="list">
      <xsl:with-param name="content" select="$content"/>      
    </xsl:call-template>
    <xsl:if test="normalize-space($content)">
      <fo:block xsl:use-attribute-sets="separator" span="all"/>
    </xsl:if>
  </xsl:template>
  

  <xsl:template name="detailsPositionAbrechnungszeitraum">
    <xsl:variable name="content">
      <xsl:apply-templates mode="list-entry" select="xr:INVOICE_LINE_PERIOD/xr:Invoice_line_period_start_date">
        <xsl:with-param name="value" select="format-date(xr:INVOICE_LINE_PERIOD/xr:Invoice_line_period_start_date, xrf:_('date-format'))"/>
      </xsl:apply-templates>
      <xsl:apply-templates mode="list-entry" select="xr:INVOICE_LINE_PERIOD/xr:Invoice_line_period_end_date">
        <xsl:with-param name="value" select="format-date(xr:INVOICE_LINE_PERIOD/xr:Invoice_line_period_end_date, xrf:_('date-format'))"/>
      </xsl:apply-templates>
    </xsl:variable>    
    <xsl:call-template name="list">
      <xsl:with-param name="headingId" select="'detailsPositionAbrechnungszeitraum'"/>
      <xsl:with-param name="content" select="$content"/>      
    </xsl:call-template>
    <xsl:if test="normalize-space($content)">
      <fo:block xsl:use-attribute-sets="separator" span="all"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="detailsPositionPreiseinzelheiten">
    <xsl:call-template name="section">
      <xsl:with-param name="headingId" select="'detailsPositionPreiseinzelheiten'"/>
      <xsl:with-param name="content">
        <xsl:call-template name="value-list">
          <xsl:with-param name="content">
            <xsl:apply-templates mode="value-list-entry" select="xr:Invoiced_quantity"/>
            <xsl:apply-templates mode="value-list-entry" select="xr:Invoiced_quantity_unit_of_measure_code"/>
            <xsl:apply-templates mode="value-list-entry" select="xr:PRICE_DETAILS/xr:Item_net_price">
              <xsl:with-param name="value" select="format-number(xr:PRICE_DETAILS/xr:Item_net_price,$at-least-two-picture,$lang)"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="sum-list-entry" select="xr:Invoice_line_net_amount">
              <xsl:with-param name="value" select="format-number(xr:Invoice_line_net_amount,$amount-picture,$lang)"/>
            </xsl:apply-templates>
          </xsl:with-param>
        </xsl:call-template>
        <xsl:call-template name="list">
          <xsl:with-param name="layout" select="'einspaltig'"/>
          <xsl:with-param name="content">
            <xsl:apply-templates mode="list-entry" select="xr:PRICE_DETAILS/xr:Item_price_discount">
              <xsl:with-param name="value" select="format-number(xr:PRICE_DETAILS/xr:Item_price_discount,$at-least-two-picture,$lang)"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="list-entry" select="xr:PRICE_DETAILS/xr:Item_gross_price">
              <xsl:with-param name="value" select="format-number(xr:PRICE_DETAILS/xr:Item_gross_price,$at-least-two-picture,$lang)"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="list-entry" select="xr:PRICE_DETAILS/xr:Item_price_base_quantity"/>
            <xsl:apply-templates mode="list-entry" select="xr:PRICE_DETAILS/xr:Item_price_base_quantity_unit_of_measure"/>
            <xsl:apply-templates mode="list-entry" select="xr:LINE_VAT_INFORMATION/xr:Invoiced_item_VAT_category_code"/>
            <xsl:apply-templates mode="list-entry" select="xr:LINE_VAT_INFORMATION/xr:Invoiced_item_VAT_rate">
              <xsl:with-param name="value" select="concat(format-number(xr:LINE_VAT_INFORMATION/xr:Invoiced_item_VAT_rate,$percentage-picture,$lang), '%')"/>
            </xsl:apply-templates>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="detailsPositionNachlaesse">    
    <xsl:call-template name="section">      
      <xsl:with-param name="headingId" select="'detailsPositionNachlaesse'"/>
      <xsl:with-param name="content">
        <xsl:for-each select="xr:INVOICE_LINE_ALLOWANCES">          
          <xsl:call-template name="section">
            <xsl:with-param name="layout" select="'einspaltig'"/>
            <xsl:with-param name="content">
              <xsl:call-template name="value-list">
                <xsl:with-param name="content">
                  <xsl:apply-templates mode="value-list-entry" select="xr:Invoice_line_allowance_base_amount">
                    <xsl:with-param name="value" select="format-number(xr:Invoice_line_allowance_base_amount,$amount-picture,$lang)"/>
                  </xsl:apply-templates>
                  <xsl:apply-templates mode="value-list-entry" select="xr:Invoice_line_allowance_percentage">
                    <xsl:with-param name="value" select="concat(format-number(xr:Invoice_line_allowance_percentage,$percentage-picture,$lang), '%')"/>
                  </xsl:apply-templates>
                  <xsl:apply-templates mode="sum-list-entry" select="xr:Invoice_line_allowance_amount">
                    <xsl:with-param name="value" select="format-number(xr:Invoice_line_allowance_amount,$amount-picture,$lang)"/>
                  </xsl:apply-templates>
                </xsl:with-param>
              </xsl:call-template>
              <xsl:call-template name="list">
                <xsl:with-param name="layout" select="'einspaltig'"/>
                <xsl:with-param name="content">
                  <xsl:apply-templates mode="list-entry" select="xr:Invoice_line_allowance_reason"/>
                  <xsl:apply-templates mode="list-entry" select="xr:Invoice_line_allowance_reason_code"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:with-param>
          </xsl:call-template>
        </xsl:for-each>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="detailsPositionZuschlaege">
    <xsl:variable name="content">
      <xsl:for-each select="xr:INVOICE_LINE_CHARGES">
        <xsl:call-template name="section">
          <xsl:with-param name="layout" select="'einspaltig'"/>
          <xsl:with-param name="content">
            <xsl:call-template name="value-list">
              <xsl:with-param name="content">
                <xsl:apply-templates mode="value-list-entry" select="xr:Invoice_line_charge_base_amount">
                  <xsl:with-param name="value" select="format-number(xr:Invoice_line_charge_base_amount,$amount-picture,$lang)"/>
                </xsl:apply-templates>
                <xsl:apply-templates mode="value-list-entry" select="xr:Invoice_line_charge_percentage">
                  <xsl:with-param name="value" select="concat(format-number(xr:Invoice_line_charge_percentage,$percentage-picture,$lang), '%')"/>
                </xsl:apply-templates>
                <xsl:apply-templates mode="sum-list-entry" select="xr:Invoice_line_charge_amount">
                  <xsl:with-param name="value" select="format-number(xr:Invoice_line_charge_amount,$amount-picture,$lang)"/>
                </xsl:apply-templates>
              </xsl:with-param>
            </xsl:call-template>
            <xsl:call-template name="list">
              <xsl:with-param name="layout" select="'einspaltig'"/>
              <xsl:with-param name="content">
                <xsl:apply-templates mode="list-entry" select="xr:Invoice_line_charge_reason"/>
                <xsl:apply-templates mode="list-entry" select="xr:Invoice_line_charge_reason_code"/>
              </xsl:with-param>
            </xsl:call-template>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:for-each>
    </xsl:variable>
    <xsl:call-template name="section">
      <xsl:with-param name="headingId" select="'detailsPositionZuschlaege'"/>
      <xsl:with-param name="content" select="$content"/>      
    </xsl:call-template>
    <xsl:if test="normalize-space($content)">
      <fo:block xsl:use-attribute-sets="separator" span="all"/>
    </xsl:if>
  </xsl:template>

  <xsl:template name="detailsPositionArtikelinformationen">
    <xsl:call-template name="list">
      <xsl:with-param name="headingId" select="'detailsPositionArtikelinformationen'"/>
      <xsl:with-param name="content">
        <xsl:apply-templates mode="list-entry" select="xr:ITEM_INFORMATION/xr:Item_name"/>
        <xsl:apply-templates mode="list-entry" select="xr:ITEM_INFORMATION/xr:Item_description"/>
        <xsl:apply-templates mode="list-entry" select="xr:ITEM_INFORMATION/xr:Item_Sellers_identifier"/>
        <xsl:apply-templates mode="list-entry" select="xr:ITEM_INFORMATION/xr:Item_Buyers_identifier"/>
        <xsl:apply-templates mode="list-entry" select="xr:ITEM_INFORMATION/xr:Item_standard_identifier"/>
        <xsl:apply-templates mode="list-entry" select="xr:ITEM_INFORMATION/xr:Item_standard_identifier/@scheme_identifier">
          <xsl:with-param name="field-mapping-identifier" select="'xr:Item_standard_identifier/@scheme_identifier'"/>
        </xsl:apply-templates>
        <xsl:for-each select="xr:ITEM_INFORMATION/xr:Item_classification_identifier">
          <xsl:apply-templates mode="list-entry" select="."/>
          <xsl:apply-templates mode="list-entry" select="./@scheme_identifier">
            <xsl:with-param name="field-mapping-identifier" select="'xr:Item_classification_identifier/@scheme_identifier'"/>
          </xsl:apply-templates>
          <xsl:apply-templates mode="list-entry" select="./@scheme_version_identifier">
            <xsl:with-param name="field-mapping-identifier" select="'xr:Item_classification_identifier/@scheme_version_identifier'"/>
          </xsl:apply-templates>
        </xsl:for-each>
        <xsl:apply-templates mode="list-entry" select="xr:ITEM_INFORMATION/xr:Item_country_of_origin"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="detailsPositionArtikeleigenschaften">
    <xsl:call-template name="list">
      <xsl:with-param name="headingId" select="'detailsPositionArtikeleigenschaften'"/>
      <xsl:with-param name="content">
        <xsl:apply-templates select="xr:ITEM_INFORMATION/xr:ITEM_ATTRIBUTES"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template name="zusaetze">
    <xsl:call-template name="page">
      <xsl:with-param name="identifier" select="'zusaetze'"/>
      <xsl:with-param name="content">
        <xsl:call-template name="zusaetze_Content"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="zusaetze_Content">
    <xsl:call-template name="zusaetzeVerkaeufer"/>
    <xsl:call-template name="zusaetzeSteuervertreter"/>
    <xsl:call-template name="zusaetzeKaeufer"/>
    <xsl:call-template name="zusaetzeLieferung"/>
    <xsl:call-template name="zusaetzeVertrag"/>
    <xsl:call-template name="zusaetzeZahlungsempfaenger"/>
  </xsl:template>

  <xsl:template name="zusaetzeVerkaeufer">
    <xsl:call-template name="box">
      <xsl:with-param name="identifier" select="'zusaetzeVerkaeufer'"/>
      <xsl:with-param name="content">
        <xsl:call-template name="list">
          <xsl:with-param name="content">
            <xsl:apply-templates mode="list-entry" select="xr:SELLER/xr:Seller_trading_name"/>
            <xsl:apply-templates mode="list-entry" select="xr:SELLER/xr:SELLER_POSTAL_ADDRESS/xr:Seller_country_subdivision"/>
            <xsl:apply-templates mode="list-entry" select="xr:SELLER/xr:Seller_electronic_address"/>
            <xsl:apply-templates mode="list-entry" select="xr:SELLER/xr:Seller_electronic_address/@scheme_identifier">
              <xsl:with-param name="field-mapping-identifier" select="'xr:Seller_electronic_address/@scheme_identifier'"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="list-entry" select="xr:SELLER/xr:Seller_legal_registration_identifier"/>
            <xsl:apply-templates mode="list-entry" select="xr:SELLER/xr:Seller_legal_registration_identifier/@scheme_identifier">
              <xsl:with-param name="field-mapping-identifier" select="'xr:Seller_legal_registration_identifier/@scheme_identifier'"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="list-entry" select="xr:SELLER/xr:Seller_VAT_identifier"/>
            <xsl:apply-templates mode="list-entry" select="xr:SELLER/xr:Seller_tax_registration_identifier"/>
            <xsl:apply-templates mode="list-entry" select="xr:SELLER/xr:Seller_additional_legal_information"/>
            <xsl:apply-templates mode="list-entry" select="xr:VAT_accounting_currency_code"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="zusaetzeSteuervertreter">
    <xsl:call-template name="box">
      <xsl:with-param name="identifier" select="'zusaetzeSteuervertreter'"/>
      <xsl:with-param name="content">
        <xsl:call-template name="list">
          <xsl:with-param name="content">            
            <xsl:apply-templates mode="list-entry" select="xr:SELLER_TAX_REPRESENTATIVE_PARTY/xr:Seller_tax_representative_name"/>
            <xsl:apply-templates mode="list-entry" select="xr:SELLER_TAX_REPRESENTATIVE_PARTY/xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_address_line_1"/>
            <xsl:apply-templates mode="list-entry" select="xr:SELLER_TAX_REPRESENTATIVE_PARTY/xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_address_line_2"/>
            <xsl:apply-templates mode="list-entry" select="xr:SELLER_TAX_REPRESENTATIVE_PARTY/xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_address_line_3"/>
            <xsl:apply-templates mode="list-entry" select="xr:SELLER_TAX_REPRESENTATIVE_PARTY/xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_post_code"/>
            <xsl:apply-templates mode="list-entry" select="xr:SELLER_TAX_REPRESENTATIVE_PARTY/xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_city"/>
            <xsl:apply-templates mode="list-entry" select="xr:SELLER_TAX_REPRESENTATIVE_PARTY/xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_country_subdivision"/>
            <xsl:apply-templates mode="list-entry" select="xr:SELLER_TAX_REPRESENTATIVE_PARTY/xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_country_code"/>
            <xsl:apply-templates mode="list-entry" select="xr:SELLER_TAX_REPRESENTATIVE_PARTY/xr:Seller_tax_representative_VAT_identifier"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="zusaetzeKaeufer">
    <xsl:call-template name="box">
      <xsl:with-param name="identifier" select="'zusaetzeKaeufer'"/>
      <xsl:with-param name="content">
        <xsl:call-template name="list">
          <xsl:with-param name="content">            
            <xsl:apply-templates mode="list-entry" select="xr:BUYER/xr:Buyer_trading_name"/>
            <xsl:apply-templates mode="list-entry" select="xr:BUYER/xr:BUYER_POSTAL_ADDRESS/xr:Buyer_country_subdivision"/>
            <xsl:apply-templates mode="list-entry" select="xr:BUYER/xr:Buyer_electronic_address"/>
            <xsl:apply-templates mode="list-entry" select="xr:BUYER/xr:Buyer_electronic_address/@scheme_identifier">
              <xsl:with-param name="field-mapping-identifier" select="'xr:Buyer_electronic_address/@scheme_identifier'"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="list-entry" select="xr:BUYER/xr:Buyer_legal_registration_identifier"/>
            <xsl:apply-templates mode="list-entry" select="xr:BUYER/xr:Buyer_legal_registration_identifier/@scheme_identifier">
              <xsl:with-param name="field-mapping-identifier" select="'xr:Buyer_legal_registration_identifier/@scheme_identifier'"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="list-entry" select="xr:BUYER/xr:Buyer_VAT_identifier"/>
            <xsl:for-each select="tokenize(xr:Value_added_tax_point_date,';')">             
              <xsl:call-template name="list-entry-bt-7">
                <xsl:with-param name="value" select="format-date(xs:date(.), xrf:_('date-format'))"/>
               <xsl:with-param name="field-mapping-identifier" select="'xr:Value_added_tax_point_date'"/>
             </xsl:call-template>
            </xsl:for-each>
            <xsl:apply-templates mode="list-entry" select="xr:BUYER/xr:Value_added_tax_point_date_code"/>
            <xsl:apply-templates mode="list-entry" select="xr:Buyer_accounting_reference"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="zusaetzeLieferung">
    <xsl:call-template name="box">
      <xsl:with-param name="identifier" select="'zusaetzeLieferung'"/>
      <xsl:with-param name="content">
        <xsl:call-template name="list">
          <xsl:with-param name="content">            
            <xsl:apply-templates mode="list-entry" select="xr:DELIVERY_INFORMATION/xr:Deliver_to_location_identifier"/>
            <xsl:apply-templates mode="list-entry" select="xr:DELIVERY_INFORMATION/xr:Deliver_to_location_identifier/@scheme_identifier">
              <xsl:with-param name="field-mapping-identifier" select="'xr:Deliver_to_location_identifier/@scheme_identifier'"/>
            </xsl:apply-templates>
             <xsl:apply-templates mode="list-entry" select="xr:DELIVERY_INFORMATION/xr:Actual_delivery_date">
              <xsl:with-param name="value" select="format-date(xr:DELIVERY_INFORMATION/xr:Actual_delivery_date, xrf:_('date-format'))"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="list-entry" select="xr:DELIVERY_INFORMATION/xr:Deliver_to_party_name"/>
            <xsl:apply-templates mode="list-entry" select="xr:DELIVERY_INFORMATION/xr:DELIVER_TO_ADDRESS/xr:Deliver_to_address_line_1"/>
            <xsl:apply-templates mode="list-entry" select="xr:DELIVERY_INFORMATION/xr:DELIVER_TO_ADDRESS/xr:Deliver_to_address_line_2"/>
            <xsl:apply-templates mode="list-entry" select="xr:DELIVERY_INFORMATION/xr:DELIVER_TO_ADDRESS/xr:Deliver_to_address_line_3"/>
            <xsl:apply-templates mode="list-entry" select="xr:DELIVERY_INFORMATION/xr:DELIVER_TO_ADDRESS/xr:Deliver_to_post_code"/>
            <xsl:apply-templates mode="list-entry" select="xr:DELIVERY_INFORMATION/xr:DELIVER_TO_ADDRESS/xr:Deliver_to_city"/>
            <xsl:apply-templates mode="list-entry" select="xr:DELIVERY_INFORMATION/xr:DELIVER_TO_ADDRESS/xr:Deliver_to_country_subdivision"/>
            <xsl:apply-templates mode="list-entry" select="xr:DELIVERY_INFORMATION/xr:DELIVER_TO_ADDRESS/xr:Deliver_to_country_code"/>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="zusaetzeVertrag">
    <xsl:call-template name="spanned-box">
      <xsl:with-param name="identifier" select="'zusaetzeVertrag'"/>
      <xsl:with-param name="content">
        <xsl:call-template name="list">
          <xsl:with-param name="layout" select="'einspaltig'"/>
          <xsl:with-param name="content">            
            <xsl:apply-templates mode="list-entry" select="xr:Tender_or_lot_reference"/>
            <xsl:apply-templates mode="list-entry" select="xr:Receiving_advice_reference"/>
            <xsl:apply-templates mode="list-entry" select="xr:Despatch_advice_reference"/>
            <xsl:apply-templates mode="list-entry" select="xr:PROCESS_CONTROL/xr:Business_process_type"/>
            <xsl:apply-templates mode="list-entry" select="xr:PROCESS_CONTROL/xr:Specification_identifier"/>
            <xsl:apply-templates mode="list-entry" select="xr:Invoiced_object_identifier"/>
            <xsl:apply-templates mode="list-entry" select="xr:Invoiced_object_identifier/@scheme_identifier">
              <xsl:with-param name="field-mapping-identifier" select="'xr:Invoiced_object_identifier/@scheme_identifier'"/>
            </xsl:apply-templates>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="zusaetzeZahlungsempfaenger">
    <xsl:call-template name="box">
      <xsl:with-param name="identifier" select="'zusaetzeZahlungsempfaenger'"/>
      <xsl:with-param name="content">
        <xsl:call-template name="list">
          <xsl:with-param name="content">            
            <xsl:apply-templates mode="list-entry" select="xr:PAYEE/xr:Payee_name"/>
            <xsl:apply-templates mode="list-entry" select="xr:PAYEE/xr:Payee_identifier"/>
            <xsl:apply-templates mode="list-entry" select="xr:PAYEE/xr:Payee_identifier/@scheme_identifier">
              <xsl:with-param name="field-mapping-identifier" select="'xr:Payee_identifier/@scheme_identifier'"/>
            </xsl:apply-templates>
            <xsl:apply-templates mode="list-entry" select="xr:PAYEE/xr:Payee_legal_registration_identifier"/>
            <xsl:apply-templates mode="list-entry" select="xr:PAYEE/xr:Payee_legal_registration_identifier/@scheme_identifier">
              <xsl:with-param name="field-mapping-identifier" select="'xr:Payee_legal_registration_identifier/@scheme_identifier'"/>
            </xsl:apply-templates>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="anlagen">
    <xsl:call-template name="page">
      <xsl:with-param name="identifier" select="'anlagen'"/>
      <xsl:with-param name="content">
        <xsl:call-template name="anlagen_Content"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template name="anlagen_Content">
    <xsl:call-template name="box">
      <xsl:with-param name="identifier" select="'anlagenListe'"/>
      <xsl:with-param name="content">
        <xsl:call-template name="list">
          <xsl:with-param name="layout" select="'einspaltig'"/>
          <xsl:with-param name="content">              
            <xsl:for-each select="xr:ADDITIONAL_SUPPORTING_DOCUMENTS">
              <xsl:call-template name="sub-list">
                <xsl:with-param name="content">
                  <xsl:apply-templates mode="list-entry" select="xr:Supporting_document_reference"/>
                  <xsl:apply-templates mode="list-entry" select="xr:Supporting_document_description"/>
                  <xsl:apply-templates mode="list-entry" select="xr:External_document_location">
                    <xsl:with-param name="value">
                      <xsl:apply-templates mode="internet-link" select="xr:External_document_location"/>
                    </xsl:with-param>
                  </xsl:apply-templates>
                  <xsl:apply-templates mode="list-entry" select="xr:Attached_document">
                    <xsl:with-param name="value">                      
                      <xsl:apply-templates mode="binary" select="xr:Attached_document">
                        <xsl:with-param name="identifier" select="xr:Attached_document/@filename"/>
                      </xsl:apply-templates>
                    </xsl:with-param>
                  </xsl:apply-templates>
                  <xsl:apply-templates mode="list-entry" select="xr:Attached_document/@mime_code">
                    <xsl:with-param name="field-mapping-identifier" select="'xr:Attached_document/@mime_code'"/>
                  </xsl:apply-templates>
                  <xsl:apply-templates mode="list-entry" select="xr:Attached_document/@filename">
                    <xsl:with-param name="field-mapping-identifier" select="'xr:Attached_document/@filename'"/>
                  </xsl:apply-templates>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

  <xsl:template name="laufzettel">
    <xsl:call-template name="page">
      <xsl:with-param name="identifier" select="'laufzettel'"/>
      <xsl:with-param name="content">
        <xsl:call-template name="laufzettel_Content"/>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>
  
  <xsl:template name="laufzettel_Content">
    <xsl:call-template name="box">
      <xsl:with-param name="identifier" select="'laufzettelHistorie'"/>
      <xsl:with-param name="content">
        <xsl:call-template name="list">
          <xsl:with-param name="layout" select="'einspaltig'"/>
          <xsl:with-param name="content">
            <xsl:for-each select="//xrv:laufzettel/xrv:laufzettelEintrag">          
              <xsl:call-template name="sub-list">
                <xsl:with-param name="layout" select="'einspaltig'"/>
                <xsl:with-param name="content">
                  <xsl:apply-templates mode="list-entry" select="xrv:zeitstempel">
                    <xsl:with-param name="value" select="format-dateTime(xrv:zeitstempel, xrf:_('datetime-format'))"/>
                  </xsl:apply-templates>
                  <xsl:apply-templates mode="list-entry" select="xrv:betreff"/>
                  <xsl:apply-templates mode="list-entry" select="xrv:text"/>
                  <xsl:apply-templates mode="list-entry" select="xrv:details"/>
                </xsl:with-param>
              </xsl:call-template>
            </xsl:for-each>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:with-param>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
