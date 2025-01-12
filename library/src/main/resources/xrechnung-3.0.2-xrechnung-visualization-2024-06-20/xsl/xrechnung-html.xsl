<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" 
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:xs="http://www.w3.org/2001/XMLSchema" 
  xmlns:xr="urn:ce.eu:en16931:2017:xoev-de:kosit:standard:xrechnung-1"
  xmlns:xrf="https://projekte.kosit.org/xrechnung/xrechnung-visualization/functions"
  xmlns:xrv="http://www.example.org/XRechnung-Viewer" exclude-result-prefixes="#all">

    <xsl:output indent="yes" method="html" encoding="UTF-8" include-content-type="no" media-type="text/html" undeclare-prefixes="yes"/>

  <xsl:import href="common-xr.xsl" />

  <xsl:param name="l10n-nl-lookup" select="true()" />

  <xsl:decimal-format name="de" decimal-separator="," grouping-separator="." NaN="" />
  <xsl:decimal-format name="en" decimal-separator="." grouping-separator="," NaN="" />
  <xsl:decimal-format name="fr" decimal-separator="," grouping-separator="." NaN="" />

    <!-- MAIN HTML -->
  <xsl:template match="/xr:invoice">
     <!-- <xsl:text disable-output-escaping='yes'>&lt;!DOCTYPE html&gt;</xsl:text>-->
    <html lang="{$lang}">
      <head>
        <meta charset="UTF-8" />
        <title>XRechnung</title>
        <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0" />
        <style>
          <xsl:value-of select="unparsed-text('xrechnung-viewer.css')" />
        </style>
        <script>
          <xsl:value-of select="unparsed-text('FileSaver-v2.0.5.js')" />
        </script>
        <!-- according to https://stackoverflow.com/questions/436411/where-should-i-put-script-tags-in-html-markup -->
        <script>
          <xsl:value-of select="unparsed-text('xrechnung-viewer.js')" />
        </script>
      </head>
      <body>
        <div role="main">
          <form>
            <div class="menue" role="navigation">
              <div role="tablist" class="innen">
                <div role="none">
                  <button role="tab" aria-controls="uebersicht" tabindex="0" aria-selected="true" type="button"
                    class="tab btnAktiv" id="menueUebersicht" onclick="show(this);">
                    <span><xsl:value-of select="xrf:_('uebersicht')" /></span>
                  </button>
                </div>
                <div role="none">
                  <button role="tab" aria-controls="details" tabindex="0" aria-selected="false" type="button"
                    class="tab" id="menueDetails" onclick="show(this);">
                    <span><xsl:value-of select="xrf:_('details')" /></span>
                  </button>
                </div>
                <div role="none">
                  <button role="tab" aria-controls="zusaetze" tabindex="0" aria-selected="false" type="button"
                    class="tab" id="menueZusaetze" onclick="show(this)">
                    <span><xsl:value-of select="xrf:_('zusaetze')" /></span>
                  </button>
                </div>
                <div role="none">
                  <button role="tab" aria-controls="anlagen" tabindex="0" aria-selected="false" type="button"
                    class="tab" id="menueAnlagen" onclick="show(this)">
                    <span><xsl:value-of select="xrf:_('anlagen')" /></span>
                  </button>
                </div>
                <div role="none">
                  <button role="tab" aria-controls="laufzettel" tabindex="0" aria-selected="false" type="button"
                    class="tab" id="menueLaufzettel" onclick="show(this)">
                    <span><xsl:value-of select="xrf:_('laufzettel')" /></span>
                  </button>
                </div>
              </div>
            </div>
          </form>
          <div class="inhalt">
            <div class="innen">
              <xsl:call-template name="uebersicht" />
              <xsl:call-template name="details" />
              <xsl:call-template name="zusaetze" />
              <xsl:call-template name="anlagen" />
              <xsl:call-template name="laufzettel" />
            </div>
          </div>
        </div>

      </body>
    </html>
  </xsl:template>


  <xsl:template name="uebersicht">
    <div id="uebersicht" class="divShow" role="tabpanel" aria-labelledby="menueUebersicht" tabindex="0">
      <noscript>
        <div class="noscript">
        <xsl:value-of select="xrf:_('no-script')"/>
        </div>
      </noscript>
      <div class="haftungausschluss">
        <xsl:value-of select="xrf:_('_disclaimer')" />
      </div>
      <div class="boxtabelle boxtabelleZweispaltig">
        <div class="boxzeile">

          <xsl:apply-templates select="./xr:BUYER" />

          <div class="boxabstand"></div>

          <xsl:apply-templates select="./xr:SELLER" />

        </div>
      </div>

      <div class="boxtabelle boxabstandtop boxtabelleZweispaltig">
        <xsl:call-template name="uebersichtRechnungsinfo" />
      </div>

      <div class="boxtabelle boxabstandtop boxtabelleZweispaltig">
        <xsl:apply-templates select="./xr:THIRD_PARTY_PAYMENT" />
      </div>

      <div class="boxtabelle boxabstandtop boxtabelleZweispaltig">
        <xsl:call-template name="uebersichtRechnungsuebersicht" />
      </div>

      <div class="boxtabelle boxabstandtop boxtabelleZweispaltig">
        <xsl:apply-templates select="./xr:VAT_BREAKDOWN" />
      </div>

      <div class="boxtabelle boxabstandtop boxtabelleZweispaltig">
        <xsl:apply-templates select="./xr:DOCUMENT_LEVEL_ALLOWANCES" />
      </div>

      <div class="boxtabelle boxabstandtop boxtabelleZweispaltig">
        <xsl:apply-templates select="./xr:DOCUMENT_LEVEL_CHARGES" />
      </div>

      <div class="boxtabelle boxabstandtop boxtabelleZweispaltig first">
        <div class="boxzeile">
          <xsl:call-template name="uebersichtZahlungsinformationen" />
          <xsl:call-template name="uebersichtCard" />
        </div>
      </div>

      <div class="boxtabelle">
        <div class="boxzeile">
          <xsl:call-template name="uebersichtLastschrift" />
          <xsl:call-template name="uebersichtUeberweisung" />
        </div>
      </div>

      <div class="boxtabelle boxabstandtop">
        <div class="boxzeile">
          <xsl:apply-templates select="./xr:INVOICE_NOTE" />
        </div>
      </div>
    </div>
  </xsl:template>


  <xsl:template name="uebersichtKaeufer" match="xr:BUYER">
    <div id="uebersichtKaeufer" class="box boxZweispaltig">
      <div data-title="BG-7" class="BG-7 boxtitel" role="heading" aria-level="2">
        <xsl:value-of select="xrf:_('uebersichtKaeufer')" />
      </div>
      <div class="boxtabelle boxinhalt borderSpacing" role="list">
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Buyer_reference')" />:
          </div>
          <div data-title="BT-10" class="BT-10 boxdaten wert">
            <xsl:value-of select="../xr:Buyer_reference" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Buyer_name')" />:
          </div>
          <div data-title="BT-44" class="BT-44 boxdaten wert">
            <xsl:value-of select="xr:Buyer_name" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Buyer_address_line_1')" />:
          </div>
          <div data-title="BT-50" class="BT-50 boxdaten wert">
            <xsl:value-of select="xr:BUYER_POSTAL_ADDRESS/xr:Buyer_address_line_1" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Buyer_address_line_2')" />:
          </div>
          <div data-title="BT-51" class="BT-51 boxdaten wert">
            <xsl:value-of select="xr:BUYER_POSTAL_ADDRESS/xr:Buyer_address_line_2" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Buyer_address_line_3')" />:
          </div>
          <div data-title="BT-163" class="BT-163 boxdaten wert">
            <xsl:value-of select="xr:BUYER_POSTAL_ADDRESS/xr:Buyer_address_line_3" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Buyer_post_code')" />:
          </div>
          <div data-title="BT-53" class="BT-53 boxdaten wert">
            <xsl:value-of select="xr:BUYER_POSTAL_ADDRESS/xr:Buyer_post_code" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Buyer_city')" />:
          </div>
          <div data-title="BT-52" class="BT-52 boxdaten wert">
            <xsl:value-of select="xr:BUYER_POSTAL_ADDRESS/xr:Buyer_city" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Buyer_country_subdivision')" />:
          </div>
          <div data-title="BT-54" class="BT-54 boxdaten wert">
            <xsl:value-of select="xr:BUYER_POSTAL_ADDRESS/xr:Buyer_country_subdivision" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Buyer_country_code')" />:
          </div>
          <div data-title="BT-55" class="BT-55 boxdaten wert">
            <xsl:value-of select="xr:BUYER_POSTAL_ADDRESS/xr:Buyer_country_code" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Buyer_identifier')" />:
          </div>
          <div data-title="BT-46" class="BT-46 boxdaten wert">
            <xsl:value-of select="xr:Buyer_identifier" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Buyer_identifier/@scheme_identifier')" />:
          </div>
          <div data-title="BT-46-scheme-id" class="BT-46-scheme-id boxdaten wert">
            <xsl:value-of select="xr:Buyer_identifier/@scheme_identifier" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Buyer_contact_point')" />:
          </div>
          <div data-title="BT-56" class="BT-56 boxdaten wert">
            <xsl:value-of select="xr:BUYER_CONTACT/xr:Buyer_contact_point" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Buyer_contact_telephone_number')" />:
          </div>
          <div data-title="BT-57" class="BT-57 boxdaten wert">
            <xsl:value-of select="xr:BUYER_CONTACT/xr:Buyer_contact_telephone_number" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Buyer_contact_email_address')" />:
          </div>
          <div data-title="BT-58" class="BT-58 boxdaten wert">
            <xsl:value-of select="xr:BUYER_CONTACT/xr:Buyer_contact_email_address" />
          </div>
        </div>
      </div>
    </div>
  </xsl:template>


  <xsl:template name="uebersichtVerkaeufer" match="xr:SELLER">
    <div id="uebersichtVerkaeufer" class="box boxZweispaltig">
      <div data-title="BG-4" class="BG-4 boxtitel" role="heading" aria-level="2">
        <xsl:value-of select="xrf:_('uebersichtVerkaeufer')" />
      </div>
      <div class="boxtabelle boxinhalt borderSpacing" role="list">
        <div class="boxzeile">
          <div class="boxdaten legende"></div>
          <div class="boxdaten wert" style="background-color: white;"></div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Seller_name')" />:
          </div>
          <div data-title="BT-27" class="BT-27 boxdaten wert">
            <xsl:value-of select="xr:Seller_name" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Seller_address_line_1')" />:
          </div>
          <div data-title="BT-35" class="BT-35 boxdaten wert">
            <xsl:value-of select="xr:SELLER_POSTAL_ADDRESS/xr:Seller_address_line_1" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Seller_address_line_2')" />:
          </div>
          <div data-title="BT-36" class="BT-36 boxdaten wert">
            <xsl:value-of select="xr:SELLER_POSTAL_ADDRESS/xr:Seller_address_line_2" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Seller_address_line_3')" />:
          </div>
          <div data-title="BT-162" class="BT-162 boxdaten wert">
            <xsl:value-of select="xr:SELLER_POSTAL_ADDRESS/xr:Seller_address_line_3" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Seller_post_code')" />:
          </div>
          <div data-title="BT-38" class="BT-38 boxdaten wert">
            <xsl:value-of select="xr:SELLER_POSTAL_ADDRESS/xr:Seller_post_code" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Seller_city')" />:
          </div>
          <div data-title="BT-37" class="BT-37 boxdaten wert">
            <xsl:value-of select="xr:SELLER_POSTAL_ADDRESS/xr:Seller_city" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Seller_country_subdivision')" />:
          </div>
          <div data-title="BT-39" class="BT-39 boxdaten wert">
            <xsl:value-of select="xr:SELLER_POSTAL_ADDRESS/xr:Seller_country_subdivision" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Seller_country_code')" />:
          </div>
          <div data-title="BT-40" class="BT-40 boxdaten wert">
            <xsl:value-of select="xr:SELLER_POSTAL_ADDRESS/xr:Seller_country_code" />
          </div>
        </div>
        <xsl:for-each select="xr:Seller_identifier">
          <div class="boxzeile" role="listitem">
            <div class="boxdaten legende">
              <xsl:value-of select="xrf:_('xr:Seller_identifier')" />:
            </div>
            <div data-title="BT-29" class="BT-29 boxdaten wert">
              <xsl:value-of select="." />
            </div>
          </div>
          <div class="boxzeile" role="listitem">
            <div class="boxdaten legende">
              <xsl:value-of select="xrf:_('xr:Seller_identifier/@scheme_identifier')" />:
            </div>
            <div data-title="BT-29-scheme-id" class="BT-29-scheme-id boxdaten wert">
              <xsl:value-of select="./@scheme_identifier" />
            </div>
          </div>
        </xsl:for-each>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Seller_contact_point')" />:
          </div>
          <div data-title="BT-41" class="BT-41 boxdaten wert">
            <xsl:value-of select="xr:SELLER_CONTACT/xr:Seller_contact_point" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Seller_contact_telephone_number')" />:
          </div>
          <div data-title="BT-42" class="BT-42 boxdaten wert">
            <xsl:value-of select="xr:SELLER_CONTACT/xr:Seller_contact_telephone_number" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Seller_contact_email_address')" />:
          </div>
          <div data-title="BT-43" class="BT-43 boxdaten wert">
            <xsl:value-of select="xr:SELLER_CONTACT/xr:Seller_contact_email_address" />
          </div>
        </div>
      </div>
    </div>
  </xsl:template>


  <xsl:template name="uebersichtRechnungsinfo">
    <div class="boxzeile">
      <div id="uebersichtRechnungsinfo" class="box box1v2">
        <div class="boxtitel" role="heading" aria-level="2">
          <xsl:value-of select="xrf:_('uebersichtRechnungsInfo')" />
        </div>
        <div class="boxtabelle boxinhalt">
          <div class="boxcell boxZweispaltig">
            <div class="boxtabelle borderSpacing" role="list">
              <div class="boxzeile" role="listitem">
                <div class="boxdaten legende">
                  <xsl:value-of select="xrf:_('xr:Invoice_number')" />:
                </div>
                <div data-title="BT-1" class="BT-1 boxdaten wert">
                  <xsl:value-of select="xr:Invoice_number" />
                </div>
              </div>
              <div class="boxzeile" role="listitem">
                <div class="boxdaten legende">
                  <xsl:value-of select="xrf:_('xr:Invoice_issue_date')" />:
                </div>
                <div data-title="BT-2" class="BT-2 boxdaten wert">
                  <xsl:value-of select="
                    if (matches(
                    normalize-space(
                    replace(xr:Invoice_issue_date, '-', '')
                    ),
                    $datepattern)
                    )
                    then
                    format-date(xr:Invoice_issue_date, xrf:_('date-format'))
                    else
                    xr:Invoice_issue_date"
                  />
                </div>
              </div>
              <div class="boxzeile" role="listitem">
                <div class="boxdaten legende">
                  <xsl:value-of select="xrf:_('xr:Invoice_type_code')" />:
                </div>
                <div data-title="BT-3" class="BT-3 boxdaten wert">
                  <xsl:value-of select="xr:Invoice_type_code" />
                </div>
              </div>
              <div class="boxzeile" role="listitem">
                <div class="boxdaten legende">
                  <xsl:value-of select="xrf:_('xr:Invoice_currency_code')"
                  />:
                </div>
                <div data-title="BT-5" class="BT-5 boxdaten wert">
                  <xsl:value-of select="xr:Invoice_currency_code" />
                </div>
              </div>
              <div class="boxzeile" role="listitem">
                <div class="boxdaten legende">
                  <xsl:value-of select="xrf:_('xr:Value_added_tax_point_date')"
                  />:
                </div>
                <div data-title="BT-7" class="BT-7 boxdaten wert">
                  <xsl:for-each
                    select="tokenize(xr:Value_added_tax_point_date, ';')">
                    <xsl:value-of
                      select="format-date(xs:date(.), xrf:_('date-format'))" />
                    <xsl:if test="position() != last()">
                      <br />
                    </xsl:if>
                  </xsl:for-each>
                </div>
              </div>
              <div class="boxzeile" role="listitem">
                <div class="boxdaten legende">
                  <xsl:value-of
                    select="xrf:_('xr:Value_added_tax_point_date_code')"
                  />:
                </div>
                <div data-title="BT-8" class="BT-8 boxdaten wert">
                  <xsl:value-of select="xr:Value_added_tax_point_date_code" />
                </div>
              </div>
              <div role="listitem">
                <strong>
                  <xsl:value-of
                    select="xrf:_('uebersichtRechnungAbrechnungszeitraum')"
                  />:
                </strong>
                <div class="boxtabelle borderSpacing" role="list">
                  <div class="boxzeile" role="listitem">
                    <div class="boxdaten legende">
                      <xsl:value-of
                        select="xrf:_('xr:Invoicing_period_start_date')"
                      />:
                    </div>
                    <div data-title="BT-73" class="BT-73 boxdaten wert">
                      <xsl:value-of
                        select="format-date(xr:INVOICING_PERIOD/xr:Invoicing_period_start_date, xrf:_('date-format'))"
                      />
                    </div>
                  </div>
                  <div class="boxzeile" role="listitem">
                    <div class="boxdaten legende">
                      <xsl:value-of
                        select="xrf:_('xr:Invoicing_period_end_date')"
                      />:
                    </div>
                    <div data-title="BT-74" class="BT-74 boxdaten wert">
                      <xsl:value-of
                        select="format-date(xr:INVOICING_PERIOD/xr:Invoicing_period_end_date, xrf:_('date-format'))"
                      />
                    </div>
                  </div>
                </div>
              </div>
            </div>
          </div>
          <div class="boxabstand" />
          <div class="boxcell boxZweispaltig">
            <div class="boxtabelle borderSpacing" role="list">
              <div class="boxzeile" role="listitem">
                <div class="boxdaten legende">
                  <xsl:value-of select="xrf:_('xr:Project_reference')" />:
                </div>
                <div data-title="BT-11" class="BT-11 boxdaten wert">
                  <xsl:value-of select="xr:Project_reference" />
                </div>
              </div>
              <div class="boxzeile" role="listitem">
                <div class="boxdaten legende">
                  <xsl:value-of select="xrf:_('xr:Contract_reference')" />:
                </div>
                <div data-title="BT-12" class="BT-12 boxdaten wert">
                  <xsl:value-of select="xr:Contract_reference" />
                </div>
              </div>
              <div class="boxzeile" role="listitem">
                <div class="boxdaten legende">
                  <xsl:value-of select="xrf:_('xr:Purchase_order_reference')"
                  />:
                </div>
                <div data-title="BT-13" class="BT-13 boxdaten wert">
                  <xsl:value-of select="xr:Purchase_order_reference" />
                </div>
              </div>
              <div class="boxzeile" role="listitem">
                <div class="boxdaten legende">
                  <xsl:value-of select="xrf:_('xr:Sales_order_reference')"
                  />:
                </div>
                <div data-title="BT-14" class="BT-14 boxdaten wert">
                  <xsl:value-of select="xr:Sales_order_reference" />
                </div>
              </div>
            </div>
            <xsl:apply-templates select="./xr:PRECEDING_INVOICE_REFERENCE" />
          </div>
        </div>
      </div>
    </div>
  </xsl:template>
  

  <xsl:template match="xr:PRECEDING_INVOICE_REFERENCE">
    <div role="list">
      <strong>
        <xsl:value-of select="xrf:_('uebersichtRechnungVorausgegangeneRechnungen')" />:
      </strong>
      <div class="boxtabelle borderSpacing" role="list">
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Preceding_Invoice_reference')" />:
          </div>
          <div data-title="BT-25" class="BT-25 boxdaten wert">
            <xsl:value-of select="xr:Preceding_Invoice_reference" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Preceding_Invoice_issue_date')" />:
          </div>
          <div data-title="BT-26" class="BT-26 boxdaten wert">
            <xsl:value-of select="format-date(xr:Preceding_Invoice_issue_date,xrf:_('date-format'))" />
          </div>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="uebersichtFremdleistungen" match="xr:THIRD_PARTY_PAYMENT">
    <div class="boxzeile">
      <div class="uebersichtUmsatzsteuer box">
        <div data-title="BG-DEX-09" class="BG-DEX-09 boxtitel" role="heading" aria-level="2">
          <xsl:value-of select="xrf:_('uebersichtFremdleistungen')" />
        </div>
        <div class="boxtabelle boxinhalt" role="table">
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1" role="rowheader">
              <xsl:value-of select="xrf:_('xr:Third_party_payment_type')" />
            </div>
            <div data-title="BT-DEX-002" class="BT-DEX-001 boxdaten rechnungSp1" role="cell">
              <xsl:value-of select="xr:Third_party_payment_type" />
            </div>
          </div>
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1" role="rowheader">
              <xsl:value-of select="xrf:_('xr:Third_party_payment_description')" />
            </div>
            <div data-title="BT-DEX-002" class="BT-DEX-002 boxdaten rechnungSp1" role="cell">
              <xsl:value-of select="xr:Third_party_payment_description" />
            </div>
          </div>
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1" role="rowheader">
              <xsl:value-of select="xrf:_('xr:Third_party_payment_amount')" />
            </div>
            <div data-title="BT-DEX-003" class="BT-DEX-003 boxdaten rechnungSp3" role="cell">
              <xsl:value-of select="xrf:format-with-at-least-two-digits(xr:Third_party_payment_amount,$lang)" />
            </div>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="uebersichtRechnungsuebersicht">
    <div class="boxzeile">
      <div id="uebersichtRechnungsuebersicht" class="box">
        <div data-title="BG-22" class="BG-22 boxtitel" role="heading" aria-level="2">
          <xsl:value-of select="xrf:_('uebersichtRechnungsuebersicht')" />
        </div>
        <div class="boxtabelle boxinhalt" role="table">
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1" role="rowheader">
              <xsl:value-of select="xrf:_('xr:Sum_of_Invoice_line_net_amount')" />
            </div>
            <div class="boxdaten rechnungSp2 color2" role="cell">
              <xsl:value-of select="xrf:_('_net')" />
            </div>
            <div data-title="BT-106" class="BT-106 boxdaten rechnungSp3" role="cell">
              <xsl:value-of
                select="xrf:format-with-at-least-two-digits(xr:DOCUMENT_TOTALS/xr:Sum_of_Invoice_line_net_amount,$lang)" />
            </div>
          </div>
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1" role="rowheader">
              <xsl:value-of select="xrf:_('xr:Sum_of_allowances_on_document_level')" />
            </div>
            <div class="boxdaten rechnungSp2 color2" role="cell">
              <xsl:value-of select="xrf:_('_net')" />
            </div>
            <div data-title="BT-107" class="BT-107 boxdaten rechnungSp3" role="cell">
              <xsl:value-of
                select="xrf:format-with-at-least-two-digits(xr:DOCUMENT_TOTALS/xr:Sum_of_allowances_on_document_level,$lang)" />
            </div>
          </div>
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1 paddingBottom line1Bottom" role="rowheader">
              <xsl:value-of select="xrf:_('xr:Sum_of_charges_on_document_level')" />
            </div>
            <div class="boxdaten rechnungSp2 paddingBottom line1Bottom color2" role="cell">
              <xsl:value-of select="xrf:_('_net')" />
            </div>
            <div data-title="BT-108" class="BT-108 boxdaten rechnungSp3 paddingBottom line1Bottom" role="cell">
              <xsl:value-of
                select="xrf:format-with-at-least-two-digits(xr:DOCUMENT_TOTALS/xr:Sum_of_charges_on_document_level,$lang)" />
            </div>
          </div>
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1 paddingTop" role="rowheader">
              <xsl:value-of select="xrf:_('xr:Invoice_total_amount_without_VAT')" />
            </div>
            <div class="boxdaten rechnungSp2 paddingTop color2" role="cell">
              <xsl:value-of select="xrf:_('_net')" />
            </div>
            <div data-title="BT-109" class="BT-109 boxdaten rechnungSp3 paddingTop" role="cell">
              <xsl:value-of
                select="xrf:format-with-at-least-two-digits(xr:DOCUMENT_TOTALS/xr:Invoice_total_amount_without_VAT,$lang)" />
            </div>
          </div>
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1" role="rowheader">
              <xsl:value-of select="xrf:_('xr:Invoice_total_VAT_amount')" />
            </div>
            <div class="boxdaten rechnungSp2 color2" role="cell"></div>
            <div data-title="BT-110" class="BT-110 boxdaten rechnungSp3" role="cell">
              <xsl:value-of
                select="xrf:format-with-at-least-two-digits(xr:DOCUMENT_TOTALS/xr:Invoice_total_VAT_amount,$lang)" />
            </div>
          </div>
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1 paddingBottom line1Bottom" role="rowheader">
              <xsl:value-of select="xrf:_('xr:Invoice_total_VAT_amount_in_accounting_currency')" />
            </div>
            <div class="boxdaten rechnungSp2 paddingBottom line1Bottom color2" role="cell"></div>
            <div data-title="BT-111" class="BT-111 boxdaten rechnungSp3 paddingBottom line1Bottom" role="cell">
              <xsl:value-of
                select="xrf:format-with-at-least-two-digits(xr:DOCUMENT_TOTALS/xr:Invoice_total_VAT_amount_in_accounting_currency,$lang)" />
            </div>
          </div>
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1 paddingTop" role="rowheader">
              <xsl:value-of select="xrf:_('xr:Invoice_total_amount_with_VAT')" />
            </div>
            <div class="boxdaten rechnungSp2 paddingTop color2" role="cell">
              <xsl:value-of select="xrf:_('_gross')" />
            </div>
            <div data-title="BT-112" class="BT-112 boxdaten rechnungSp3 paddingTop" role="cell">
              <xsl:value-of
                select="xrf:format-with-at-least-two-digits(xr:DOCUMENT_TOTALS/xr:Invoice_total_amount_with_VAT,$lang)" />
            </div>
          </div>
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1" role="rowheader">
              <xsl:value-of select="xrf:_('xr:Paid_amount')" />
            </div>
            <div class="boxdaten rechnungSp2 color2" role="cell">
              <xsl:value-of select="xrf:_('_gross')" />
            </div>
            <div data-title="BT-113" class="BT-113 boxdaten rechnungSp3" role="cell">
              <xsl:value-of
                select="xrf:format-with-at-least-two-digits(xr:DOCUMENT_TOTALS/xr:Paid_amount,$lang)" />
            </div>
          </div>
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1 paddingBottom line1Bottom" role="rowheader">
              <xsl:value-of select="xrf:_('xr:Rounding_amount')" />
            </div>
            <div class="boxdaten rechnungSp2 paddingBottom line1Bottom color2" role="cell">
              <xsl:value-of select="xrf:_('_gross')" />
            </div>
            <div data-title="BT-114" class="BT-114 boxdaten rechnungSp3 paddingBottom line1Bottom" role="cell">
              <xsl:value-of
                select="xrf:format-with-at-least-two-digits(xr:DOCUMENT_TOTALS/xr:Rounding_amount,$lang)" />
            </div>
          </div>
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1 paddingTop paddingBottom line2Bottom" role="rowheader">
              <xsl:value-of select="xrf:_('sum-of-third-party-payment-amounts')" />
            </div>
            <div class="boxdaten rechnungSp2 paddingTop paddingBottom line2Bottom" role="cell"></div>
            <div class="boxdaten rechnungSp3 paddingTop paddingBottom line2Bottom" role="cell">
              <xsl:value-of
                select="xrf:format-with-at-least-two-digits(sum(xr:THIRD_PARTY_PAYMENT/xr:Third_party_payment_amount),$lang)" />
            </div>
          </div>
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1 paddingTop bold" role="rowheader">
              <xsl:value-of select="xrf:_('xr:Amount_due_for_payment')" />
            </div>
            <div class="boxdaten rechnungSp2 paddingTop color2" role="cell">
              <xsl:value-of select="xrf:_('_gross')" />
            </div>
            <div data-title="BT-115" class="BT-115 boxdaten rechnungSp3 paddingTop bold" role="cell">
              <xsl:value-of
                select="xrf:format-with-at-least-two-digits(xr:DOCUMENT_TOTALS/xr:Amount_due_for_payment,$lang)" />
            </div>
          </div>
        </div>
      </div>
    </div>
  </xsl:template>

  <xsl:template name="uebersichtUmsatzsteuer" match="xr:VAT_BREAKDOWN">
    <div class="boxzeile">
      <div class="uebersichtUmsatzsteuer box">
        <div data-title="BG-23" class="BG-23 boxtitel" role="heading" aria-level="2">
          <xsl:value-of select="xrf:_('uebersichtUmsatzsteuer')" />
        </div>
        <div class="boxtabelle boxinhalt" role="table">
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1 bold" role="rowheader">
              <xsl:value-of select="xrf:_('xr:VAT_category_code')" />:
              <span class="BT-118" data-title="BT-118">
                <xsl:value-of select="xr:VAT_category_code" />
              </span>
            </div>
            <div class="boxdaten rechnungSp2" role="cell"></div>
            <div class="boxdaten rechnungSp3" role="cell"></div>
          </div>
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1" role="rowheader">
              <xsl:value-of select="xrf:_('xr:VAT_category_taxable_amount')" />
            </div>
            <div class="boxdaten rechnungSp2 color2" role="cell">
              <xsl:value-of select="xrf:_('_net')" />
            </div>
            <div data-title="BT-116" class="BT-116 boxdaten rechnungSp3" role="cell">
              <xsl:value-of select="xrf:format-with-at-least-two-digits(xr:VAT_category_taxable_amount,$lang)" />
            </div>
          </div>
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1 line1Bottom" role="rowheader">
              <xsl:value-of select="xrf:_('xr:VAT_category_rate')" />
            </div>
            <div class="boxdaten rechnungSp2 color2 line1Bottom" role="cell"></div>
            <div data-title="BT-119" class="BT-119 boxdaten rechnungSp3 line1Bottom" role="cell">
              <xsl:value-of select="xr:VAT_category_rate" /> %
            </div>
          </div>
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1" role="rowheader">
              <xsl:value-of select="xrf:_('xr:VAT_category_tax_amount')" />
            </div>
            <div class="boxdaten rechnungSp2 color2" role="cell"></div>
            <div data-title="BT-117" class="BT-117 boxdaten rechnungSp3 bold" role="cell">
              <xsl:value-of select="xrf:format-with-at-least-two-digits(xr:VAT_category_tax_amount,$lang)" />
            </div>
          </div>
        </div>

        <xsl:if test="not(xr:VAT_category_code = ('S', 'Z', 'IGIC', 'IPSI' ))">
        <div class="grund" role="list">
          <div role="listitem">
            <xsl:value-of select="xrf:_('xr:VAT_exemption_reason_text')" />:
            <span data-title="BT-120" class="BT-120 bold">
              <xsl:value-of select="xr:VAT_exemption_reason_text" />
            </span>
          </div>
          <div role="listitem">
            <xsl:value-of select="xrf:_('xr:VAT_exemption_reason_code')" />:
            <span data-title="BT-121" class="BT-121 bold">
              <xsl:value-of select="xr:VAT_exemption_reason_code" />
            </span>
          </div>
        </div>
        </xsl:if>
      </div>
    </div>
  </xsl:template>


  <xsl:template name="uebersichtNachlass" match="xr:DOCUMENT_LEVEL_ALLOWANCES">
    <div class="boxzeile">
      <div class="uebersichtNachlass box">
        <div data-title="BG-20" class="BG-20 boxtitel" role="heading" aria-level="2">
          <xsl:value-of select="xrf:_('uebersichtNachlass')" />
        </div>
        <div class="boxtabelle boxinhalt" role="table">
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1 bold" role="rowheader">
              <xsl:value-of select="xrf:_('xr:Document_level_allowance_VAT_category_code')" />:
              <span data-title="BT-95">
                <xsl:value-of select="xr:Document_level_allowance_VAT_category_code" />
              </span>
            </div>
            <div class="boxdaten rechnungSp2" role="cell"></div>
            <div class="boxdaten rechnungSp3" role="cell"></div>
          </div>
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1" role="rowheader">
              <xsl:value-of select="xrf:_('xr:Document_level_allowance_base_amount')" />
            </div>
            <div class="boxdaten rechnungSp2 color2" role="cell">
              <xsl:value-of select="xrf:_('_net')" />
            </div>
            <div data-title="BT-93" class="BT-93 boxdaten rechnungSp3" role="cell">
              <xsl:value-of
                select="xrf:format-with-at-least-two-digits(xr:Document_level_allowance_base_amount,$lang)" />
            </div>
          </div>
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1 line1Bottom" role="rowheader">
              <xsl:value-of select="xrf:_('xr:Document_level_allowance_percentage')" />
            </div>
            <div class="boxdaten rechnungSp2 color2 line1Bottom" role="cell"></div>
            <div data-title="BT-94" class="BT-94 boxdaten rechnungSp3 line1Bottom" role="cell">
              <xsl:value-of select="xr:Document_level_allowance_percentage" /> %
            </div>
          </div>
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1" role="rowheader">
              <xsl:value-of select="xrf:_('xr:Document_level_allowance_amount')" />
            </div>
            <div class="boxdaten rechnungSp2 color2" role="cell">
              <xsl:value-of select="xrf:_('_net')" />
            </div>
            <div data-title="BT-92" class="BT-92 boxdaten rechnungSp3 bold" role="cell">
              <xsl:value-of
                select="xrf:format-with-at-least-two-digits(xr:Document_level_allowance_amount,$lang)" />
            </div>
          </div>
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1" role="rowheader">
              <xsl:value-of select="xrf:_('xr:Document_level_allowance_VAT_rate')" />
            </div>
            <div class="boxdaten rechnungSp2 color2" role="cell"></div>
            <div data-title="BT-96" class="BT-96 boxdaten rechnungSp3" role="cell">
              <xsl:value-of select="xr:Document_level_allowance_VAT_rate" />
            </div>
          </div>
        </div>
        <div class="grund" role="list">
          <div role="listitem">
            <xsl:value-of select="xrf:_('xr:Document_level_allowance_reason')" />:
            <span data-title="BT-97" class="BT-97 bold">
              <xsl:value-of select="xr:Document_level_allowance_reason" />
            </span>
          </div>
          <div role="listitem">
            <xsl:value-of select="xrf:_('xr:Document_level_allowance_reason_code')" />:
            <span data-title="BT-98" class="BT-98 bold">
              <xsl:value-of select="xr:Document_level_allowance_reason_code" />
            </span>
          </div>
        </div>
      </div>
    </div>
    <div class="boxabstand"></div>
  </xsl:template>


  <xsl:template name="uebersichtZuschlaege" match="xr:DOCUMENT_LEVEL_CHARGES">
    <div class="boxzeile">
      <div id="uebersichtZuschlaege" class="box">
        <div data-title="BG-21" class="BG-21 boxtitel" role="heading" aria-level="2">
          <xsl:value-of select="xrf:_('uebersichtZuschlaege')" />
        </div>
        <div class="boxtabelle boxinhalt" role="table">
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1 bold" role="rowheader">
              <xsl:value-of select="xrf:_('xr:Document_level_charge_VAT_category_code')" />:
              <span data-title="BT-102" class="BT-102">
                <xsl:value-of select="xr:Document_level_charge_VAT_category_code" />
              </span>
            </div>
            <div class="boxdaten rechnungSp2" role="cell"></div>
            <div class="boxdaten rechnungSp3" role="cell"></div>
          </div>
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1" role="rowheader">
              <xsl:value-of select="xrf:_('xr:Document_level_charge_base_amount')" />
            </div>
            <div class="boxdaten rechnungSp2 color2" role="cell">
              <xsl:value-of select="xrf:_('_net')" />
            </div>
            <div data-title="BT-100" class="BT-100 boxdaten rechnungSp3" role="cell">
              <xsl:value-of
                select="xrf:format-with-at-least-two-digits(xr:Document_level_charge_base_amount,$lang)" />
            </div>
          </div>
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1 line1Bottom" role="rowheader">
              <xsl:value-of select="xrf:_('xr:Document_level_charge_percentage')" />
            </div>
            <div class="boxdaten rechnungSp2 color2 line1Bottom" role="cell"></div>
            <div data-title="BT-101" class="BT-101 boxdaten rechnungSp3 line1Bottom" role="cell">
              <xsl:value-of select="xr:Document_level_charge_percentage" /> %
            </div>
          </div>
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1" role="rowheader">
              <xsl:value-of select="xrf:_('xr:Document_level_charge_amount')" />
            </div>
            <div class="boxdaten rechnungSp2 color2" role="cell">
              <xsl:value-of select="xrf:_('_net')" />
            </div>
            <div data-title="BT-99" class="BT-99 boxdaten rechnungSp3 bold" role="cell">
              <xsl:value-of select="xrf:format-with-at-least-two-digits(xr:Document_level_charge_amount,$lang)" />
            </div>
          </div>
          <div class="rechnungsZeile" role="row">
            <div class="boxdaten rechnungSp1" role="rowheader">
              <xsl:value-of select="xrf:_('xr:Document_level_charge_VAT_rate')" />
            </div>
            <div class="boxdaten rechnungSp2 color2" role="cell"></div>
            <div data-title="BT-103" class="BT-103 boxdaten rechnungSp3" role="cell">
              <xsl:value-of select="xr:Document_level_charge_VAT_rate" />
            </div>
          </div>
        </div>
        <div class="grund" role="list">
            <div role="listitem">
              <xsl:value-of select="xrf:_('xr:Document_level_charge_reason')" />:
              <span data-title="BT-104" class="BT-104 bold" >
              <xsl:value-of select="xr:Document_level_charge_reason" />
            </span>
          </div>
            <div role="listitem">
              <xsl:value-of select="xrf:_('xr:Document_level_charge_reason_code')" />:
            <span data-title="BT-105" class="BT-105 bold">
              <xsl:value-of select="xr:Document_level_charge_reason_code" />
            </span>
          </div>
        </div>
      </div>
    </div>
    <div class="boxabstand"></div>
  </xsl:template>


  <xsl:template name="uebersichtZahlungsinformationen">
    <div id="uebersichtZahlungsinformationen" class="box subBox">
      <div data-title="" class="boxtitel" role="heading" aria-level="2">
        <xsl:value-of select="xrf:_('uebersichtZahlungInfo')" />
      </div>
      <div class="boxtabelle boxinhalt borderSpacing" role="list">
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Payment_terms')" />:
          </div>
          <div data-title="BT-20" class="BT-20 boxdaten wert">
            <xsl:for-each select="tokenize(xr:Payment_terms,';')">
              <xsl:value-of select="." />
              <xsl:if test="position() != last()">
                <br />
              </xsl:if>
            </xsl:for-each>
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Payment_due_date')" />:
          </div>
          <div data-title="BT-9" class="BT-9 boxdaten wert">
            <xsl:for-each select="tokenize(xr:Payment_due_date,';')">
              <xsl:value-of select="format-date(xs:date(.),xrf:_('date-format'))" />
              <xsl:if test="position() != last()">
                <br />
              </xsl:if>
            </xsl:for-each>
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Payment_means_type_code')" />:
          </div>
          <div data-title="BT-81" class="BT-81 boxdaten wert">
            <xsl:value-of select="xr:PAYMENT_INSTRUCTIONS/xr:Payment_means_type_code" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Payment_means_text')" />:
          </div>
          <div data-title="BT-82" class="BT-82 boxdaten wert">
            <xsl:value-of select="xr:PAYMENT_INSTRUCTIONS/xr:Payment_means_text" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Remittance_information')" />:
          </div>
          <div data-title="BT-83" class="BT-83 boxdaten wert">
            <xsl:value-of select="xr:PAYMENT_INSTRUCTIONS/xr:Remittance_information" />
          </div>
        </div>
      </div>
    </div>
  </xsl:template>


  <xsl:template name="uebersichtCard">
    <div id="uebersichtCard" class="box subBox">
      <div data-title="BG-18" class="BG-18 boxtitel boxtitelSub" role="heading" aria-level="3">
        <xsl:value-of select="xrf:_('uebersichtZahlungKarte')" />
      </div>
      <div class="boxtabelle boxinhalt borderSpacing" role="list">
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Payment_card_primary_account_number')" />:
          </div>
          <div data-title="BT-87" class="BT-87 boxdaten wert">
            <xsl:value-of
              select="xr:PAYMENT_INSTRUCTIONS/xr:PAYMENT_CARD_INFORMATION/xr:Payment_card_primary_account_number" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Payment_card_holder_name')" />:
          </div>
          <div data-title="BT-88" class="BT-88 boxdaten wert">
            <xsl:value-of
              select="xr:PAYMENT_INSTRUCTIONS/xr:PAYMENT_CARD_INFORMATION/xr:Payment_card_holder_name" />
          </div>
        </div>
      </div>
    </div>
  </xsl:template>


  <xsl:template name="uebersichtLastschrift">
    <div id="uebersichtLastschrift" class="box subBox">
      <div data-title="BG-19" class="BG-19 boxtitel boxtitelSub" role="heading" aria-level="3">
        <xsl:value-of select="xrf:_('uebersichtZahlungLastschrift')" />
      </div>
      <div class="boxtabelle boxinhalt borderSpacing" role="list">
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Mandate_reference_identifier')" />:
          </div>
          <div data-title="BT-89" class="BT-89 boxdaten wert">
            <xsl:value-of select="xr:PAYMENT_INSTRUCTIONS/xr:DIRECT_DEBIT/xr:Mandate_reference_identifier" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Debited_account_identifier')" />:
          </div>
          <div data-title="BT-91" class="BT-91 boxdaten wert">
            <xsl:value-of select="xr:PAYMENT_INSTRUCTIONS/xr:DIRECT_DEBIT/xr:Debited_account_identifier" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Bank_assigned_creditor_identifier')" />:
          </div>
          <div data-title="BT-90" class="BT-90 boxdaten wert">
            <xsl:value-of
              select="xr:PAYMENT_INSTRUCTIONS/xr:DIRECT_DEBIT/xr:Bank_assigned_creditor_identifier" />
          </div>
        </div>
      </div>
    </div>
  </xsl:template>


  <xsl:template name="uebersichtUeberweisung">
    <div id="uebersichtUeberweisung" class="box subBox">
      <div data-title="BG-17" class="BG-17 boxtitel boxtitelSub" role="heading" aria-level="3">
        <xsl:value-of select="xrf:_('uebersichtZahlungUeberweisung')" />
      </div>
      <xsl:for-each select="xr:PAYMENT_INSTRUCTIONS/xr:CREDIT_TRANSFER">
        <div class="boxtabelle boxinhalt borderSpacing" role="list">
          <div class="boxzeile" role="listitem">
            <div class="boxdaten legende">
              <xsl:value-of select="xrf:_('xr:Payment_account_name')" />:
            </div>
            <div data-title="BT-85" class="BT-85 boxdaten wert">
              <xsl:value-of select="xr:Payment_account_name" />
            </div>
          </div>
          <div class="boxzeile" role="listitem">
            <div class="boxdaten legende">
              <xsl:value-of select="xrf:_('xr:Payment_account_identifier')" />:
            </div>
            <div data-title="BT-84" class="BT-84 boxdaten wert">
              <xsl:value-of select="xr:Payment_account_identifier" />
            </div>
          </div>
          <div class="boxzeile" role="listitem">
            <div class="boxdaten legende">
              <xsl:value-of select="xrf:_('xr:Payment_service_provider_identifier')" />:
            </div>
            <div data-title="BT-86" class="BT-86 boxdaten wert">
              <xsl:value-of select="xr:Payment_service_provider_identifier" />
            </div>
          </div>
        </div>
      </xsl:for-each>
    </div>
  </xsl:template>


  <xsl:template name="uebersichtBemerkungen" match="xr:INVOICE_NOTE">
    <div class="uebersichtBemerkungen box">
      <div data-title="BG-1" class="BG-1 boxtitel" role="heading" aria-level="2">
        <xsl:value-of select="xrf:_('_invoice-note-group')" />
      </div>
      <div class="boxtabelle boxinhalt borderSpacing" role="list">
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Invoice_note_subject_code')" />:
          </div>
          <div data-title="BT-21" class="BT-21 boxdaten wert">
            <xsl:value-of select="xr:Invoice_note_subject_code" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Invoice_note')" />:
          </div>
          <div data-title="BT-22" class="BT-22 boxdaten wert">
            <xsl:value-of select="xr:Invoice_note" />
          </div>
        </div>
      </div>
    </div>
  </xsl:template>


  <xsl:template name="details">
    <div id="details" class="divHide" role="tabpanel" aria-labelledby="menueDetails" tabindex="0">
      <div class="haftungausschluss">
        <xsl:value-of select="xrf:_('_disclaimer')" />
      </div>
      <xsl:apply-templates select="./xr:INVOICE_LINE" /> <!-- many -->
    </div>
  </xsl:template>


  <xsl:template match="xr:INVOICE_LINE | xr:SUB_INVOICE_LINE">
    <div class="boxtabelle boxabstandtop boxtabelleZweispaltig first">
      <div class="boxzeile">
        <div class="box subBox">
          <div data-title="BT-126" class="BT-126 boxtitel" role="heading" aria-level="2">
            <xsl:value-of select="concat( xrf:_('xr:Invoice_line_identifier') , ': ', xr:Invoice_line_identifier)" />
          </div>
          <div class="boxtabelle boxinhalt borderSpacing" role="list">
            <div class="boxzeile" role="listitem">
              <div class="boxdaten legende">
                <xsl:value-of select="xrf:_('xr:Invoice_line_note')" />:
              </div>
              <div data-title="BT-127" class="BT-127 boxdaten wert">
                <xsl:value-of select="xr:Invoice_line_note" />
              </div>
            </div>
            <div class="boxzeile" role="listitem">
              <div class="boxdaten legende">
                <xsl:value-of select="xrf:_('xr:Invoice_line_object_identifier')" />:
              </div>
              <div data-title="BT-128" class="BT-128 boxdaten wert">
                <xsl:value-of select="xr:Invoice_line_object_identifier" />
              </div>  
            </div>
            <div class="boxzeile" role="listitem">
              <div class="boxdaten legende">
                <xsl:value-of select="xrf:_('xr:Invoice_line_object_identifier/@scheme_identifier')" />:
              </div>
              <div data-title="BT-128-scheme-id" class="BT-128-scheme-id boxdaten wert">
                <xsl:value-of select="xr:Invoice_line_object_identifier/@scheme_identifier" />
              </div>
            </div>
            <div class="boxzeile" role="listitem">
              <div class="boxdaten legende">
                <xsl:value-of select="xrf:_('xr:Referenced_purchase_order_line_reference')" />:
              </div>
              <div data-title="BT-132" class="BT-132 boxdaten wert">
                <xsl:value-of select="xr:Referenced_purchase_order_line_reference" />
              </div>
            </div>
            <div class="boxzeile" role="listitem">
              <div class="boxdaten legende">
                <xsl:value-of select="xrf:_('xr:Invoice_line_Buyer_accounting_reference')" />:
              </div>
              <div data-title="BT-133" class="BT-133 boxdaten wert">
                <xsl:value-of select="xr:Invoice_line_Buyer_accounting_reference" />
              </div>
            </div>
            <div role="listitem">
              <strong class="BG-26" data-title="BG-26">
                <xsl:value-of select="xrf:_('detailsPositionAbrechnungszeitraum')" />:
              </strong>
              <div class="boxtabelle borderSpacing" role="list">
                <div class="boxzeile" role="listitem">
                  <div class="boxdaten legende">
                    <xsl:value-of select="xrf:_('xr:Invoice_line_period_start_date')" />:
                  </div>
                  <div data-title="BT-134" class="BT-134 boxdaten wert">
                    <xsl:value-of
                      select="format-date(xr:INVOICE_LINE_PERIOD/xr:Invoice_line_period_start_date,xrf:_('date-format'))" />
                  </div>
                </div>
                <div class="boxzeile" role="listitem">
                  <div class="boxdaten legende">
                    <xsl:value-of select="xrf:_('xr:Invoice_line_period_end_date')" />:
                  </div>
                  <div data-title="BT-135" class="BT-135 boxdaten wert">
                    <xsl:value-of
                      select="format-date(xr:INVOICE_LINE_PERIOD/xr:Invoice_line_period_end_date,xrf:_('date-format'))" />
                  </div>
                </div>
              </div>
            </div>
          </div>
        </div>
        <div class="box subBox">
          <div data-title="BG-29" class="BG-29 boxtitel boxtitelSub" role="heading" aria-level="3">
            <xsl:value-of select="xrf:_('detailsPositionPreiseinzelheiten')" />
          </div>
          <div class="boxtabelle boxinhalt" role="table">
            <div class="rechnungsZeile" role="row">
              <div class="boxdaten detailSp1 color2" role="rowheader">
                <xsl:value-of select="xrf:_('xr:Invoiced_quantity')" />
              </div>
              <div data-title="BT-129" class="BT-129 boxdaten detailSp2" role="cell">
                <xsl:value-of select="xr:Invoiced_quantity" />
              </div>
            </div>
            <div class="rechnungsZeile" role="row">
              <div class="boxdaten detailSp1 color2" role="rowheader">
                <xsl:value-of select="xrf:_('xr:Invoiced_quantity_unit_of_measure_code')" />
              </div>
              <div data-title="BT-130" class="BT-130 boxdaten detailSp2" role="cell">
                <xsl:value-of select="xr:Invoiced_quantity_unit_of_measure_code" />
              </div>
            </div>
            <div class="rechnungsZeile" role="row">
              <div class="boxdaten detailSp1 line1Bottom color2" role="rowheader">
                <xsl:value-of select="xrf:_('xr:Item_net_price')" />
              </div>
              <div data-title="BT-146" class="BT-146 boxdaten detailSp2 line1Bottom" role="cell">
                <xsl:value-of
                  select="xrf:format-with-at-least-two-digits(xr:PRICE_DETAILS/xr:Item_net_price,$lang)" />
              </div>
            </div>
            <div class="rechnungsZeile" role="row">
              <div class="boxdaten detailSp1 color2" role="rowheader">
                <xsl:value-of select="xrf:_('xr:Invoice_line_net_amount')" />
              </div>
              <div data-title="BT-131" class="BT-131 boxdaten detailSp2 bold" role="cell">
                <xsl:value-of select="xrf:format-with-at-least-two-digits(xr:Invoice_line_net_amount,$lang)" />
              </div>
            </div>
          </div>
          <div class="boxtabelle boxinhalt noPaddingTop borderSpacing" role="list">
            <div class="boxzeile" role="listitem">
              <div class="boxdaten legende">
                <xsl:value-of select="xrf:_('xr:Item_price_discount')" />:
              </div>
              <div data-title="BT-147" class="BT-147 boxdaten wert">
                <xsl:value-of
                  select="xrf:format-with-at-least-two-digits(xr:PRICE_DETAILS/xr:Item_price_discount,$lang)" />
              </div>
            </div>
            <div class="boxzeile" role="listitem">
              <div class="boxdaten legende">
                <xsl:value-of select="xrf:_('xr:Item_gross_price')" />:
              </div>
              <div data-title="BT-148" class="BT-148 boxdaten wert">
                <xsl:value-of
                  select="xrf:format-with-at-least-two-digits(xr:PRICE_DETAILS/xr:Item_gross_price,$lang)" />
              </div>
            </div>
            <div class="boxzeile" role="listitem">
              <div class="boxdaten legende">
                <xsl:value-of select="xrf:_('xr:Item_price_base_quantity')" />:
              </div>
              <div data-title="BT-149" class="BT-149 boxdaten wert">
                <xsl:value-of select="xr:PRICE_DETAILS/xr:Item_price_base_quantity" />
              </div>
            </div>
            <div class="boxzeile" role="listitem">
              <div class="boxdaten legende">
                <xsl:value-of select="xrf:_('xr:Item_price_base_quantity_unit_of_measure')" />:
              </div>
              <div data-title="BT-150" class="BT-150 boxdaten wert">
                <xsl:value-of select="xr:PRICE_DETAILS/xr:Item_price_base_quantity_unit_of_measure" />
              </div>
            </div>
            <div class="boxzeile" role="listitem">
              <div class="boxdaten legende">
                <xsl:value-of select="xrf:_('xr:Invoiced_item_VAT_category_code')" />:
              </div>
              <div data-title="BT-151" class="BT-151 boxdaten wert">
                <xsl:value-of select="xr:LINE_VAT_INFORMATION/xr:Invoiced_item_VAT_category_code" />
              </div>
            </div>
            <div class="boxzeile" role="listitem">
              <div class="boxdaten legende">
                <xsl:value-of select="xrf:_('xr:Invoiced_item_VAT_rate')" />:
              </div>
              <div data-title="BT-152" class="BT-152 boxdaten wert">
                <xsl:value-of
                  select="xrf:format-with-at-least-two-digits(xr:LINE_VAT_INFORMATION/xr:Invoiced_item_VAT_rate,$lang)" /> %
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <div class="boxtabelle">
      <div class="boxzeile">
        <div class="box subBox">
          <div data-title="BG-27" class="BG-27 boxtitel boxtitelSub" role="heading" aria-level="3">
            <xsl:value-of select="xrf:_('detailsPositionNachlaesse')" />
          </div>
          <xsl:for-each select="xr:INVOICE_LINE_ALLOWANCES">
            <div class="boxtabelle boxinhalt " role="table">
              <div class="rechnungsZeile" role="row">
                <div class="boxdaten detailSp1 color2" role="rowheader">
                  <xsl:value-of select="xrf:_('xr:Invoice_line_allowance_base_amount')" />
                </div>
                <div data-title="BT-137" class="BT-137 boxdaten detailSp2" role="cell">
                  <xsl:value-of
                    select="xrf:format-with-at-least-two-digits(xr:Invoice_line_allowance_base_amount,$lang)" />
                </div>
              </div>
              <div class="rechnungsZeile" role="row">
                <div class="boxdaten detailSp1 line1Bottom color2" role="rowheader">
                  <xsl:value-of select="xrf:_('xr:Invoice_line_allowance_percentage')" />
                </div>
                <div data-title="BT-138" class="BT-138 boxdaten detailSp2 line1Bottom" role="cell">
                  <xsl:value-of
                    select="xrf:format-with-at-least-two-digits(xr:Invoice_line_allowance_percentage,$lang)" /> %
                </div>
              </div>
              <div class="rechnungsZeile" role="row">
                <div class="boxdaten detailSp1 color2" role="rowheader">
                  <xsl:value-of select="xrf:_('xr:Invoice_line_allowance_amount')" />
                </div>
                <div data-title="BT-136" class="BT-136 boxdaten detailSp2 bold" role="cell">
                  <xsl:value-of
                    select="xrf:format-with-at-least-two-digits(xr:Invoice_line_allowance_amount,$lang)" />
                </div>
              </div>
            </div>
            <div class="grundDetail" role="list">
              <div class="color2" role="listitem">
                <xsl:value-of select="xrf:_('xr:Invoice_line_allowance_reason')" />:
                <span data-title="BT-139" class="BT-139 bold">
                  <xsl:value-of select="xr:Invoice_line_allowance_reason" />
                </span>
              </div>
              <div class="color2" role="listitem">
                <xsl:value-of select="xrf:_('xr:Invoice_line_allowance_reason_code')" />:
                <span data-title="BT-140" class="BT-140 bold">
                  <xsl:value-of select="xr:Invoice_line_allowance_reason_code" />
                </span>
              </div>
            </div>
          </xsl:for-each>
        </div>
        <div class="box subBox">
          <div data-title="BG-28" class="BG-28 boxtitel boxtitelSub" role="heading" aria-level="3">
            <xsl:value-of select="xrf:_('detailsPositionZuschlaege')" />
          </div>
          <xsl:for-each select="xr:INVOICE_LINE_CHARGES">
            <div class="boxtabelle boxinhalt " role="table">
              <div class="rechnungsZeile" role="row">
                <div class="boxdaten detailSp1 color2" role="rowheader">
                  <xsl:value-of select="xrf:_('xr:Invoice_line_charge_base_amount')" />
                </div>
                <div data-title="BT-142" class="BT-142 boxdaten detailSp2" role="cell">
                  <xsl:value-of
                    select="xrf:format-with-at-least-two-digits(xr:Invoice_line_charge_base_amount,$lang)" />
                </div>
              </div>
              <div class="rechnungsZeile" role="row">
                <div class="boxdaten detailSp1 line1Bottom color2" role="rowheader">
                  <xsl:value-of select="xrf:_('xr:Invoice_line_charge_percentage')" />
                </div>
                <div data-title="BT-143" class="BT-143 boxdaten detailSp2 line1Bottom" role="cell">
                  <xsl:value-of
                    select="xrf:format-with-at-least-two-digits(xr:Invoice_line_charge_percentage,$lang)" /> %
                </div>
              </div>
              <div class="rechnungsZeile" role="row">
                <div class="boxdaten detailSp1 color2" role="rowheader">
                  <xsl:value-of select="xrf:_('xr:Invoice_line_charge_amount')" />
                </div>
                <div data-title="BT-141" class="BT-141 boxdaten detailSp2 bold" role="cell">
                  <xsl:value-of
                    select="xrf:format-with-at-least-two-digits(xr:Invoice_line_charge_amount,$lang)" />
                </div>
              </div>
            </div>
            <div class="grundDetail" role="list">
              <div class="color2" role="listitem">
                <xsl:value-of select="xrf:_('xr:Invoice_line_charge_reason')" />:
                <span data-title="BT-144" class="BT-144 bold">
                  <xsl:value-of select="xr:Invoice_line_charge_reason" />
                </span>
              </div>
              <div class="color2" role="listitem">
                <xsl:value-of select="xrf:_('xr:Invoice_line_charge_reason_code')" />:
                <span data-title="BT-145" class="BT-145 bold">
                  <xsl:value-of select="xr:Invoice_line_charge_reason_code" />
                </span>
              </div>
            </div>
          </xsl:for-each>
        </div>
      </div>
    </div>
    <div class="boxtabelle">
      <div class="boxzeile">
        <div class="box subBox">
          <div data-title="BG-31" class="BG-31 boxtitel boxtitelSub" role="heading" aria-level="3">
            <xsl:value-of select="xrf:_('detailsPositionArtikelinformationen')" />
          </div>
          <div class="boxtabelle boxinhalt ">
            <div class="boxzeile">
              <div class="boxcell boxZweispaltig">
                <div class="boxtabelle borderSpacing" role="list">
                  <div class="boxzeile" role="listitem">
                    <div class="boxdaten legende">
                      <xsl:value-of select="xrf:_('xr:Item_name')" />:
                    </div>
                    <div data-title="BT-153" class="BT-153 boxdaten wert bold">
                      <xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_name" />
                    </div>
                  </div>
                  <div class="boxzeile" role="listitem">
                    <div class="boxdaten legende">
                      <xsl:value-of select="xrf:_('xr:Item_description')" />:
                    </div>
                    <div data-title="BT-154" class="BT-154 boxdaten wert">
                      <xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_description" />
                    </div>
                  </div>
                  <div class="boxzeile" role="listitem">
                    <div class="boxdaten legende">
                      <xsl:value-of select="xrf:_('xr:Item_Sellers_identifier')" />:
                    </div>
                    <div data-title="BT-155" class="BT-155 boxdaten wert">
                      <xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_Sellers_identifier" />
                    </div>
                  </div>
                  <div class="boxzeile" role="listitem">
                    <div class="boxdaten legende">
                      <xsl:value-of select="xrf:_('xr:Item_Buyers_identifier')" />:
                    </div>
                    <div data-title="BT-156" class="BT-156 boxdaten wert">
                      <xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_Buyers_identifier" />
                    </div>
                  </div>
                  <div class="boxtabelle borderSpacing" role="listitem">
                    <strong class="BG-32" data-title="BG-32">
                      <xsl:value-of select="xrf:_('detailsPositionArtikeleigenschaften')" />:
                    </strong>
                    <xsl:apply-templates select="xr:ITEM_INFORMATION/xr:ITEM_ATTRIBUTES" />
                  </div>
                </div>
              </div>
              <div class="boxabstand"></div>
              <div class="boxcell boxZweispaltig">
                <div class="boxtabelle borderSpacing" role="list">
                  <div class="boxzeile">
                    <div class="boxdaten legende">
                      <xsl:value-of select="xrf:_('xr:Item_standard_identifier')" />:
                    </div>
                    <div data-title="BT-157" class="BT-157 boxdaten wert">
                      <xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_standard_identifier" />
                    </div>
                  </div>
                  <div class="boxzeile" role="listitem">
                    <div class="boxdaten legende">
                      <xsl:value-of select="xrf:_('xr:Item_standard_identifier/@scheme_identifier')" />:
                    </div>
                    <div data-title="BT-157-scheme-id" class="BT-157-scheme-id boxdaten wert">
                      <xsl:value-of
                        select="xr:ITEM_INFORMATION/xr:Item_standard_identifier/@scheme_identifier" />
                    </div>
                  </div>
                  <div class="boxzeile" role="listitem">
                    <div class="boxdaten legende">
                      <xsl:value-of select="xrf:_('xr:Item_country_of_origin')" />:
                    </div>
                    <div data-title="BT-159" class="BT-159 boxdaten wert">
                      <xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_country_of_origin" />
                    </div>
                  </div>
                  <xsl:for-each select="xr:ITEM_INFORMATION/xr:Item_classification_identifier">
                    <div class="boxzeile" role="listitem">
                      <div class="boxdaten legende"><b><xsl:value-of select="xrf:_('artikelklassifizierung')" /></b>
                      </div>                                          
                    </div>
                    <div class="boxzeile" role="listitem">
                      <div class="boxdaten legende">
                        <xsl:value-of select="xrf:_('xr:Item_classification_identifier')" />:
                      </div>
                      <div data-title="BT-158" class="BT-158 boxdaten wert">
                        <xsl:value-of select="." />
                      </div>
                    </div>
                    <div class="boxzeile" role="listitem">
                      <div class="boxdaten legende">
                        <xsl:value-of select="xrf:_('xr:Item_classification_identifier/@scheme_identifier')" />:
                      </div>
                      <div data-title="BT-158-scheme-id" class="BT-158-scheme-id boxdaten wert">
                        <xsl:value-of
                          select="./@scheme_identifier" />
                      </div>
                    </div>
                    <div class="boxzeile" role="listitem">
                      <div class="boxdaten legende">
                        <xsl:value-of select="xrf:_('xr:Item_classification_identifier/@scheme_version_identifier')" />:
                      </div>
                      <div data-title="BT-158-scheme-version-id" class="BT-158-scheme-version-id boxdaten wert">
                        <xsl:value-of
                          select="./@scheme_version_identifier" />
                      </div>
                    </div>
                  </xsl:for-each>                  
                </div>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    <xsl:apply-templates select="xr:SUB_INVOICE_LINE" />
  </xsl:template>

  <xsl:template name="eigenschaft" match="xr:ITEM_ATTRIBUTES">
    <div class="boxzeile">
      <div data-title="BT-160" class="BT-160 boxdaten wert">
        <xsl:value-of select="xr:Item_attribute_name" />:
      </div>
      <div data-title="BT-161" class="BT-161 boxdaten wert">
        <xsl:value-of select="xr:Item_attribute_value" />
      </div>
    </div>
  </xsl:template>

    <xsl:template name="sub_invoice_eigenschaft" match="xr:SUB_INVOICE_ITEM_ATTRIBUTES">
        <div class="boxzeile" role="listitem">
            <div data-title="BT-160" class="BT-160 boxdaten wert">
                <xsl:value-of select="xr:Item_attribute_name" />:
            </div>
            <div data-title="BT-161" class="BT-161 boxdaten wert">
                <xsl:value-of select="xr:Item_attribute_value" />
            </div>
        </div>
    </xsl:template>
    
    
    <xsl:template name="zusaetze">
        <div id="zusaetze" class="divHide" role="tabpanel" aria-labelledby="menueZusaetze" tabindex="0">
            <div class="haftungausschluss">
                <xsl:value-of select="xrf:_('_disclaimer')" />
            </div>
            <div class="boxtabelle boxtabelleZweispaltig">
                <div class="boxzeile">
                    <xsl:apply-templates select="./xr:SELLER" mode="zusaetze" />
                    <div class="boxabstand"></div>
                    <xsl:apply-templates select="./xr:SELLER_TAX_REPRESENTATIVE_PARTY" />
                </div>
            </div>
            <div class="boxtabelle boxabstandtop boxtabelleZweispaltig">
                <div class="boxzeile">
                    <xsl:apply-templates select="./xr:BUYER" mode="zusaetze" />
                    <div class="boxabstand"></div>
                    <xsl:apply-templates select="./xr:DELIVERY_INFORMATION" />
                </div>
            </div>
            <div class="boxtabelle boxabstandtop boxtabelleZweispaltig">
                <div class="boxzeile">
                    <xsl:call-template name="zusaetzeVertrag" />
                    <div class="boxabstand"></div>
                    <xsl:apply-templates select="./xr:PAYEE" />
                </div>
            </div>
        </div>
    </xsl:template>
    
    
    <xsl:template name="zusaetzeVerkaeufer" match="xr:SELLER" mode="zusaetze">
        <div id="zusaetzeVerkaeufer" class="box boxZweispaltig">
            <div data-title="BG-4" class="BG-4 boxtitel" role="heading" aria-level="2">
                <xsl:value-of select="xrf:_('uebersichtVerkaeufer')" />
            </div>
            <div class="boxtabelle boxinhalt borderSpacing" role="list">
                <div class="boxzeile" role="listitem">
                    <div class="boxdaten legende">
                        <xsl:value-of select="xrf:_('xr:Seller_trading_name')" />:
                    </div>
                    <div data-title="BT-28" class="BT-28 boxdaten wert">
                        <xsl:value-of select="xr:Seller_trading_name" />
                    </div>
                </div>
                <div class="boxzeile" role="listitem">
                    <div class="boxdaten legende">
                        <xsl:value-of select="xrf:_('xr:Seller_country_subdivision')" />:
                    </div>
                    <div data-title="BT-39" class="BT-39 boxdaten wert">
                        <xsl:value-of select="xr:SELLER_POSTAL_ADDRESS/xr:Seller_country_subdivision" />
                    </div>
                </div>
                <div class="boxzeile" role="listitem">
                    <div class="boxdaten legende">
                        <xsl:value-of select="xrf:_('xr:Seller_electronic_address')" />:
                    </div>
                    <div data-title="BT-34" class="BT-34 boxdaten wert">
                        <xsl:value-of select="xr:Seller_electronic_address" />
                    </div>
                </div>
                <div class="boxzeile" role="listitem">
                    <div class="boxdaten legende">
                        <xsl:value-of select="xrf:_('xr:Seller_electronic_address/@scheme_identifier')" />:
                    </div>
                    <div data-title="BT-34-scheme-id" class="BT-34-scheme-id boxdaten wert">
                        <xsl:value-of select="xr:Seller_electronic_address/@scheme_identifier" />
                    </div>
                </div>
                <div class="boxzeile" role="listitem">
                    <div class="boxdaten legende">
                        <xsl:value-of select="xrf:_('xr:Seller_legal_registration_identifier')" />:
                    </div>
                    <div data-title="BT-30" class="BT-30 boxdaten wert">
                        <xsl:value-of select="xr:Seller_legal_registration_identifier" />
                    </div>
                </div>
                <div class="boxzeile" role="listitem">
                    <div class="boxdaten legende">
                        <xsl:value-of select="xrf:_('xr:Seller_legal_registration_identifier/@scheme_identifier')" />:
                    </div>
                    <div data-title="BT-30-scheme-id" class="BT-30-scheme-id boxdaten wert">
                        <xsl:value-of select="xr:Seller_legal_registration_identifier/@scheme_identifier" />
                    </div>
                </div>
                
                <div class="boxzeile" role="listitem">
                    <div class="boxdaten legende">
                        <xsl:value-of select="xrf:_('xr:Seller_VAT_identifier')" />:
                    </div>
                    <div data-title="BT-31" class="BT-31 boxdaten wert">
                        <xsl:value-of select="xr:Seller_VAT_identifier" />
                    </div>
                </div>
                <div class="boxzeile" role="listitem">
                    <div class="boxdaten legende">
                        <xsl:value-of select="xrf:_('xr:Seller_tax_registration_identifier')" />:
                    </div>
                    <div data-title="BT-32" class="BT-32 boxdaten wert">
                        <xsl:value-of select="xr:Seller_tax_registration_identifier" />
                    </div>
                </div>
                <div class="boxzeile" role="listitem">
                    <div class="boxdaten legende">
                        <xsl:value-of select="xrf:_('xr:Seller_additional_legal_information')" />:
                    </div>
                    <div data-title="BT-33" class="BT-33 boxdaten wert">
                        <xsl:value-of select="xr:Seller_additional_legal_information" />
                    </div>
                </div>
                <div class="boxzeile" role="listitem">
                    <div class="boxdaten legende">
                        <xsl:value-of select="xrf:_('xr:VAT_accounting_currency_code')" />:
                    </div>
                    <div data-title="BT-6" class="BT-6 boxdaten wert">
                        <xsl:value-of select="../xr:VAT_accounting_currency_code" />
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>
    

  <xsl:template name="zusaetzeSteuervertreter" match="xr:SELLER_TAX_REPRESENTATIVE_PARTY">
    <div id="zusaetzeSteuervertreter" class="box boxZweispaltig">
      <div data-title="BG-11" class="BG-11 boxtitel" role="heading" aria-level="2">
        <xsl:value-of select="xrf:_('zusaetzeSteuervertreter')" />
      </div>
      <div class="boxtabelle boxinhalt borderSpacing" role="list">
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Seller_tax_representative_name')" />:
          </div>
          <div data-title="BT-62" class="BT-62 boxdaten wert">
            <xsl:value-of select="xr:Seller_tax_representative_name" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Tax_representative_address_line_1')" />:
          </div>
          <div data-title="BT-64" class="BT-64 boxdaten wert">
            <xsl:value-of
              select="xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_address_line_1" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Tax_representative_address_line_2')" />:
          </div>
          <div data-title="BT-65" class="BT-65boxdaten wert">
            <xsl:value-of
              select="xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_address_line_2" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Tax_representative_address_line_3')" />:
          </div>
          <div data-title="BT-164" class="BT-164 boxdaten wert">
            <xsl:value-of
              select="xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_address_line_3" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Tax_representative_post_code')" />:
          </div>
          <div data-title="BT-67" class="BT-67 boxdaten wert">
            <xsl:value-of
              select="xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_post_code" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Tax_representative_city')" />:
          </div>
          <div data-title="BT-66" class="BT-66 boxdaten wert">
            <xsl:value-of select="xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_city" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Tax_representative_country_subdivision')" />:
          </div>
          <div data-title="BT-68" class="BT-68 boxdaten wert">
            <xsl:value-of
              select="xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_country_subdivision" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Tax_representative_country_code')" />:
          </div>
          <div data-title="BT-69" class="BT-69 boxdaten wert">
            <xsl:value-of
              select="xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_country_code" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Seller_tax_representative_VAT_identifier')" />:
          </div>
          <div data-title="BT-63" class="BT-63 boxdaten wert">
            <xsl:value-of select="xr:Seller_tax_representative_VAT_identifier" />
          </div>
        </div>
      </div>
    </div>
  </xsl:template>


  <xsl:template name="zusaetzeKaeufer" match="xr:BUYER" mode="zusaetze">
    <div id="zusaetzeKaeufer" class="box boxZweispaltig">
      <div data-title="BG-7" class="BG-7 boxtitel" role="heading" aria-level="2">
        <xsl:value-of select="xrf:_('zusaetzeKaeufer')" />
      </div>
      <div class="boxtabelle boxinhalt borderSpacing" role="list">
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Buyer_trading_name')" />:
          </div>
          <div data-title="BT-45" class="BT-45 boxdaten wert">
            <xsl:value-of select="xr:Buyer_trading_name" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Buyer_country_subdivision')" />:
          </div>
          <div data-title="BT-54" class="BT-54 boxdaten wert">
            <xsl:value-of select="xr:BUYER_POSTAL_ADDRESS/xr:Buyer_country_subdivision" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Buyer_electronic_address')" />:
          </div>
          <div data-title="BT-49" class="BT-49 boxdaten wert">
            <xsl:value-of select="xr:Buyer_electronic_address" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Buyer_electronic_address/@scheme_identifier')" />:
          </div>
          <div data-title="BT-49-scheme-id" class="BT-49-scheme-id boxdaten wert">
            <xsl:value-of select="xr:Buyer_electronic_address/@scheme_identifier" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Buyer_legal_registration_identifier')" />:
          </div>
          <div data-title="BT-47" class="BT-47 boxdaten wert">
            <xsl:value-of select="xr:Buyer_legal_registration_identifier" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Buyer_legal_registration_identifier/@scheme_identifier')" />:
          </div>
          <div data-title="BT-47-scheme-id" class="BT-47-scheme-id boxdaten wert">
            <xsl:value-of select="xr:Buyer_legal_registration_identifier/@scheme_identifier" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Buyer_VAT_identifier')" />:
          </div>
          <div data-title="BT-48" class="BT-48 boxdaten wert">
            <xsl:value-of select="xr:Buyer_VAT_identifier" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Buyer_accounting_reference')" />:
          </div>
          <div data-title="BT-19" class="BT-19 boxdaten wert">
            <xsl:value-of select="../xr:Buyer_accounting_reference" />
          </div>
        </div>
      </div>
    </div>
  </xsl:template>


  <xsl:template name="zusaetzeLieferung" match="xr:DELIVERY_INFORMATION">
    <div id="zusaetzeLieferung" class="box boxZweispaltig">
      <div data-title="BG-13" class="BG-13 boxtitel" role="heading" aria-level="2">
        <xsl:value-of select="xrf:_('zusaetzeLieferung')" />
      </div>
      <div class="boxtabelle boxinhalt borderSpacing" role="list">
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Deliver_to_location_identifier')" />:
          </div>
          <div data-title="BT-71" class="BT-71 boxdaten wert">
            <xsl:value-of select="xr:Deliver_to_location_identifier" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Deliver_to_location_identifier/@scheme_identifier')" />:
          </div>
          <div data-title="BT-71-scheme-id" class="BT-71-scheme-id boxdaten wert">
            <xsl:value-of select="xr:Deliver_to_location_identifier/@scheme_identifier" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Actual_delivery_date')" />:
          </div>
          <div data-title="BT-72" class="BT-72 boxdaten wert">
            <xsl:value-of select="format-date(xr:Actual_delivery_date,xrf:_('date-format'))" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Deliver_to_party_name')" />:
          </div>
          <div data-title="BT-70" class="BT-70 boxdaten wert">
            <xsl:value-of select="xr:Deliver_to_party_name" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Deliver_to_address_line_1')" />:
          </div>
          <div data-title="BT-75" class="BT-75 boxdaten wert">
            <xsl:value-of select="xr:DELIVER_TO_ADDRESS/xr:Deliver_to_address_line_1" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Deliver_to_address_line_2')" />:
          </div>
          <div data-title="BT-76" class="BT-76 boxdaten wert">
            <xsl:value-of select="xr:DELIVER_TO_ADDRESS/xr:Deliver_to_address_line_2" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Deliver_to_address_line_3')" />:
          </div>
          <div data-title="BT-165" class="BT-165 boxdaten wert">
            <xsl:value-of select="xr:DELIVER_TO_ADDRESS/xr:Deliver_to_address_line_3" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Deliver_to_post_code')" />:
          </div>
          <div data-itle="BT-78" class="BT-78 boxdaten wert">
            <xsl:value-of select="xr:DELIVER_TO_ADDRESS/xr:Deliver_to_post_code" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Deliver_to_city')" />:
          </div>
          <div data-title="BT-77" class="BT-77 boxdaten wert">
            <xsl:value-of select="xr:DELIVER_TO_ADDRESS/xr:Deliver_to_city" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Deliver_to_country_subdivision')" />:
          </div>
          <div data-title="BT-79" class="BT-79 boxdaten wert">
            <xsl:value-of select="xr:DELIVER_TO_ADDRESS/xr:Deliver_to_country_subdivision" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Deliver_to_country_code')" />:
          </div>
          <div data-title="BT-80" class="BT-80 boxdaten wert">
            <xsl:value-of select="xr:DELIVER_TO_ADDRESS/xr:Deliver_to_country_code" />
          </div>
        </div>
      </div>
    </div>
  </xsl:template>


  <xsl:template name="zusaetzeVertrag">
    <div id="zusaetzeVertrag" class="box boxZweispaltig">
      <div class="boxtitel" role="heading" aria-level="2">
        <xsl:value-of select="xrf:_('zusaetzeVertrag')" />
      </div>
      <div class="boxtabelle boxinhalt borderSpacing" role="list">
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Tender_or_lot_reference')" />:
          </div>
          <div data-title="BT-17" class="BT-17 boxdaten wert">
            <xsl:value-of select="xr:Tender_or_lot_reference" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Receiving_advice_reference')" />:
          </div>
          <div data-title="BT-15" class="BT-15 boxdaten wert">
            <xsl:value-of select="xr:Receiving_advice_reference" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Despatch_advice_reference')" />:
          </div>
          <div data-title="BT-16" class="BT-16 boxdaten wert">
            <xsl:value-of select="xr:Despatch_advice_reference" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Business_process_type_identifier')" />:
          </div>
          <div data-title="BT-23" class="BT-23 boxdaten wert">
            <xsl:value-of select="xr:PROCESS_CONTROL/xr:Business_process_type_identifier" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Specification_identifier')" />:
          </div>
          <div data-title="BT-24" class="BT-24 boxdaten wert">
            <xsl:value-of select="xr:PROCESS_CONTROL/xr:Specification_identifier" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Invoiced_object_identifier')" />:
          </div>
          <div data-title="BT-18" class="BT-18 boxdaten wert">
            <xsl:value-of select="xr:Invoiced_object_identifier" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Invoiced_object_identifier/@scheme_identifier')" />:
          </div>
          <div data-title="BT-18-scheme-id" class="BT-18-scheme-id boxdaten wert">
            <xsl:value-of select="xr:Invoiced_object_identifier/@scheme_identifier" />
          </div>
        </div>
      </div>
    </div>
  </xsl:template>


  <xsl:template name="zusaetzeZahlungsempfaenger" match="xr:PAYEE">
    <div id="zusaetzeZahlungsempfaenger" class="box boxZweispaltig">
      <div data-title="BG-10" class="BG-10 boxtitel" role="heading" aria-level="2">
        <xsl:value-of select="xrf:_('zusaetzeZahlungsempfaenger')" />
      </div>
      <div class="boxtabelle boxinhalt borderSpacing" role="list">
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Payee_name')" />:
          </div>
          <div data-title="BT-59" class="BT-59 boxdaten wert">
            <xsl:value-of select="xr:Payee_name" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Payee_identifier')" />:
          </div>
          <div data-title="BT-60" class="BT-60 boxdaten wert">
            <xsl:value-of select="xr:Payee_identifier" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Payee_identifier/@scheme_identifier')" />:
          </div>
          <div data-title="BT-60-scheme-id" class="BT-60-scheme-id boxdaten wert">
            <xsl:value-of select="xr:Payee_identifier/@scheme_identifier" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Payee_legal_registration_identifier')" />:
          </div>
          <div data-title="BT-61" class="BT-61 boxdaten wert">
            <xsl:value-of select="xr:Payee_legal_registration_identifier" />
          </div>
        </div>
        <div class="boxzeile" role="listitem">
          <div class="boxdaten legende">
            <xsl:value-of select="xrf:_('xr:Payee_legal_registration_identifier/@scheme_identifier')" />:
          </div>
          <div data-title="BT-61-scheme-id" class="BT-61-scheme-id boxdaten wert">
            <xsl:value-of select="xr:Payee_legal_registration_identifier/@scheme_identifier" />
          </div>
        </div>
      </div>
    </div>
  </xsl:template>


  <xsl:template name="anlagen">
    <div id="anlagen" class="divHide" role="tabpanel" aria-labelledby="menueAnlagen" tabindex="0">
      <div class="haftungausschluss">
        <xsl:value-of select="xrf:_('_disclaimer')" />
      </div>
      <div class="boxtabelle boxabstandtop">
        <div class="boxzeile">
          <div id="anlagenListe" class="box">
            <div data-title="BG-24" class="BG-24 boxtitel" role="heading" aria-level="2">
              <xsl:value-of select="xrf:_('anlagenListe')" />
            </div>
            <xsl:apply-templates select="./xr:ADDITIONAL_SUPPORTING_DOCUMENTS" />
          </div>
        </div>
      </div>
    </div>
  </xsl:template>


  <xsl:template match="xr:ADDITIONAL_SUPPORTING_DOCUMENTS">
    <div class="boxtabelle boxinhalt borderSpacing" role="list">
      <div class="boxzeile" role="listitem">
        <div class="boxdaten legende">
          <xsl:value-of select="xrf:_('xr:Supporting_document_reference')" />:
        </div>
        <div data-title="BT-122" class="BT-122 boxdaten wert">
          <xsl:value-of select="xr:Supporting_document_reference" />
        </div>
      </div>
      <div class="boxzeile" role="listitem">
        <div class="boxdaten legende">
          <xsl:value-of select="xrf:_('xr:Supporting_document_description')" />:
        </div>
        <div data-title="BT-123" class="BT-123 boxdaten wert">
          <xsl:value-of select="xr:Supporting_document_description" />
        </div>
      </div>
      <div class="boxzeile" role="listitem">
        <div class="boxdaten legende">
          <xsl:value-of select="xrf:_('xr:External_document_location')" />:
        </div>
        <div data-title="BT-124" class="BT-124 boxdaten wert">
          <a href="{xr:External_document_location}" target="_blank">
            <xsl:value-of select="xr:External_document_location" />
          </a>
        </div>
      </div>
        
      <div class="boxzeile" role="listitem">
        <div class="boxdaten legende">
          <xsl:value-of select="xrf:_('xr:Attached_document')" />:
        </div>
        <!-- HTML5 restrictions for id attribute: must contain at least 1 character, can't contain any space characters -->
        <!-- JS restrictions for param in getElementById(id), in this case $doc-ref-id: case-sensitive string unique within the document -->
          <xsl:variable name="doc-ref-id" as="xs:string" select="translate(normalize-space(xr:Supporting_document_reference), ' ', '-')"/>
        <div data-title="BT-125" class="BT-125 boxdaten wert">
        <xsl:choose>
            <xsl:when test="empty(xr:Attached_document/text())">
                <xsl:value-of select="xrf:_('no-data')" />
            </xsl:when>
            <xsl:otherwise>
                <a href="#{$doc-ref-id}" onClick="downloadData('{$doc-ref-id}', '{xr:Attached_document/@mime_code}', '{xr:Attached_document/@filename}')">
                    <xsl:value-of select="xrf:_('_open')" />
                </a>    
            </xsl:otherwise>
        </xsl:choose>    
        </div>
          <div id="{$doc-ref-id}" style="display:none;">
          <xsl:value-of select="xr:Attached_document" />
        </div>

      </div>
        
        
      <div class="boxzeile" role="listitem">
        <div class="boxdaten legende">
          <xsl:value-of select="xrf:_('xr:Attached_document/@mime_code')" />:
        </div>
        <div data-title="BT-125" class="BT-125 boxdaten wert">
          <xsl:value-of select="xr:Attached_document/@mime_code" />
        </div>
      </div>
      <div class="boxzeile" role="listitem">
        <div class="boxdaten legende">
          <xsl:value-of select="xrf:_('xr:Attached_document/@filename')" />:
        </div>
        <div data-title="BT-125" class="BT-125 boxdaten wert">
          <xsl:value-of select="xr:Attached_document/@filename" />
        </div>
      </div>
    </div>
  </xsl:template>


  <xsl:template name="laufzettel">
    <div id="laufzettel" class="divHide" role="tabpanel" aria-labelledby="menueLaufzettel" tabindex="0">
      <div class="boxtabelle boxabstandtop">
        <div class="boxzeile">
          <div id="laufzettelHistorie" class="box">
            <div class="boxtitel" role="heading" aria-level="2">
              <xsl:value-of select="xrf:_('laufzettelHistorie')" />
            </div>
            <xsl:apply-templates select="./xrv:laufzettel/xrv:laufzettelEintrag" />
          </div>
        </div>
      </div>
    </div>
  </xsl:template>


  <xsl:template match="xrv:laufzettelEintrag">
    <div class="boxtabelle boxinhalt borderSpacing" role="list">
      <div class="boxzeile" role="listitem">
        <div class="boxdaten legende">
          <xsl:value-of select="xrf:_('xrv:zeitstempel')" />:
        </div>
        <div class="boxdaten wert">
          <xsl:value-of select="format-dateTime(xrv:zeitstempel,xrf:_('datetime-format'))" />
        </div>
      </div>
      <div class="boxzeile" role="listitem">
        <div class="boxdaten legende">
          <xsl:value-of select="xrf:_('xrv:betreff')" />:
        </div>
        <div class="boxdaten wert">
          <xsl:value-of select="xrv:betreff" />
        </div>
      </div>
      <div class="boxzeile" role="listitem">
        <div class="boxdaten legende">
          <xsl:value-of select="xrf:_('xrv:text')" />:
        </div>
        <div class="boxdaten wert">
          <xsl:value-of select="xrv:text" />
        </div>
      </div>
      <div class="boxzeile" role="listitem">
        <div class="boxdaten legende">
          <xsl:value-of select="xrf:_('xrv:details')" />:
        </div>
        <div class="boxdaten wert">
          <xsl:value-of select="xrv:details" />
        </div>
      </div>
    </div>
  </xsl:template>

</xsl:stylesheet>
