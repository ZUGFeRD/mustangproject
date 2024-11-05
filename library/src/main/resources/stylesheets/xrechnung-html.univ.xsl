<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xr="urn:ce.eu:en16931:2017:xoev-de:kosit:standard:xrechnung-1"
                xmlns:xrv="http://www.example.org/XRechnung-Viewer">

    <xsl:output indent="yes" method="html" encoding="UTF-8" />
    <xsl:decimal-format name="decimal" decimal-separator="," grouping-separator="." NaN="" />


    <!-- MAIN HTML -->
    <xsl:template match="/xr:invoice">

        <html lang="de">
            <head>
                <meta charset="UTF-8"/>
                <title><xsl:value-of select="$i18n.title"/></title>
                <meta name="viewport" content="width=device-width, user-scalable=yes, initial-scale=1.0"/>
                <style>


                    /* Grundformatierung ********************************************/

                    *,
                    *:after,
                    *:before
                    {
                    box-sizing: border-box;
                    -moz-box-sizing: border-box;
                    }

                    .clear:after
                    {
                    content: ".";
                    clear: both;
                    display: block;
                    visibility: hidden;
                    height: 0;
                    }

                    html,
                    body
                    {
                    height: 100%;
                    min-width: 320px;
                    margin: 0;
                    padding: 0;
                    color: #000;
                    font-size: 14px;
                    }

                    body
                    {
                    overflow-y: scroll;
                    background-color: rgba(4, 101, 161, 0.08);
                    }

                    h4
                    {
                    color: inherit;
                    font-size: inherit;
                    margin-bottom: 0.5rem;
                    }


                    /* Grundaufbau *************************************************/

                    .menue
                    {
                    position: relative;
                    z-index: 2000;
                    background-color: #000;
                    margin-bottom: 30px;
                    }

                    .innen
                    {
                    max-width: 1080px;
                    margin: 0 auto;
                    padding: 0 2%;
                    }



                    /* Formatierungen *************************************************/

                    .color2
                    {
                    color: rgba(0, 0, 0, 0.6);
                    }

                    .schwarz
                    {
                    color: #555 !important;
                    }

                    .normal
                    {
                    font-weight: normal;
                    }

                    .bold
                    {
                    font-weight: bold;
                    }

                    .abstandUnten
                    {
                    margin-bottom: 5px;
                    }

                    .abstandUntenKlein
                    {
                    margin-bottom: 10px;
                    }

                    .noPaddingTop
                    {
                    padding-top: 0 !important;
                    }

                    .ausrichtungRechts
                    {
                    text-align: right;
                    }




                    /* Menü ********************************************************/

                    button
                    {
                    position: relative;
                    font-family: serif;
                    padding-top: 15px;
                    padding-left: 0;
                    padding-right: 0;
                    margin-right: 2%;
                    }

                    .btnAktiv
                    {
                    font-size: 22px;
                    color: #ffb619;
                    height: 50px;
                    outline: none;
                    border: none;
                    background: none;
                    }

                    .btnAktiv:after
                    {
                    content: "";
                    display: block;
                    position: absolute;
                    top: 50px;
                    left: 50%;
                    z-index: 10;
                    font-size: 0;
                    line-height: 0;
                    height: 0;
                    padding: 0;
                    margin: 0;
                    transform: translateX(-50%);
                    border: 15px solid #000;
                    border-right-color: transparent;
                    border-bottom-color: transparent;
                    border-left-color: transparent;
                    }

                    .btnInaktiv,
                    .tab
                    {
                    font-size: 22px;
                    color: #fff;
                    height: 50px;
                    z-index: 0;
                    outline: none;
                    border: none;
                    background: none;
                    transition: color 0.3s ease;
                    }

                    .btnInaktiv:hover,
                    .tab:hover
                    {
                    color: #ffb619;
                    cursor: pointer;
                    }

                    .divHide
                    {
                    display: none;
                    }

                    /* Content *********************************************************************/

                    .inhalt
                    {
                    font-family: sans-serif;
                    margin-bottom: 30px;
                    }

                    .haftungausschluss
                    {
                    color: #000;
                    text-align: center;
                    padding: 7px;
                    margin-bottom: 30px;
                    width: 100%;
                    border: 1px solid #ffb619;
                    background-color: #fff;
                    }

                    .box
                    {
                    position: relative;
                    display: table-cell;
                    padding: 0;
                    border: 1px solid rgba(4, 101, 161, 0.2);
                    background-color: #fff;
                    }

                    .subBox
                    {
                    border-top: none;
                    width: 50%;
                    }

                    .subBox:last-child
                    {
                    border-left: none;
                    }

                    .first > .boxzeile > .subBox
                    {
                    border-top: 1px solid rgba(4, 101, 161, 0.2) !important;
                    }

                    .boxtitel
                    {
                    display: inline-block;
                    background-color: #0465A1;
                    padding: 7px 10px;
                    color: #fff;
                    font-weight: bold;
                    }

                    .boxBorderTop
                    {
                    border-top: none;
                    }

                    .boxBorderLeft
                    {
                    border-left: none;
                    }

                    .boxtitelSub
                    {
                    color: #000;
                    background-color: rgba(4, 101, 161, 0.1);
                    border-right: 1px solid rgba(4, 101, 161, 0.2);
                    border-bottom: 1px solid rgba(4, 101, 161, 0.2);
                    }

                    .boxinhalt
                    {
                    padding: 15px 20px;
                    }

                    .boxtabelle
                    {
                    display: table;
                    width: 100%;
                    }

                    .borderSpacing
                    {
                    border-spacing: 0 5px;
                    }

                    .boxabstandtop
                    {
                    margin-top: 30px;
                    }

                    .boxzeile
                    {
                    display: table-row;
                    }

                    .boxzeile .box:last-child
                    {
                    margin-bottom: 0;
                    }

                    .boxdaten
                    {
                    display: table-cell;
                    padding: 5px 0;
                    vertical-align: middle;
                    height: 38px;
                    /*
                    -ms-word-break: break-all;
                    word-break: break-all;
                    word-break: break-word;
                    -webkit-hyphens: auto;
                    -moz-hyphens: auto;
                    hyphens: auto;
                    */
                    }

                    .boxdaten.wert
                    {
                    padding: 5px 10px;
                    }

                    .boxcell
                    {
                    display: table-cell;
                    }

                    .boxdatenBlock
                    {
                    display: block;
                    padding: 3px 0;
                    /*
                    -ms-word-break: break-all;
                    word-break: break-all;
                    word-break: break-word;
                    -webkit-hyphens: auto;
                    -moz-hyphens: auto;
                    hyphens: auto;
                    */
                    }

                    .noBreak
                    {
                    -ms-word-break: keep-all;
                    word-break: keep-all;
                    word-break: keep-all;
                    -webkit-hyphens: none;
                    -moz-hyphens: none;
                    hyphens: none;
                    }

                    .boxabstand
                    {
                    display: table-cell;
                    width: 30px;
                    }

                    .legende
                    {
                    color: rgba(0, 0, 0, 0.6);
                    width: 170px;
                    font-size: 13px;
                    line-height: 16px;
                    padding-right: 5px;
                    }

                    .wert
                    {
                    background-color: rgba(4, 101, 161, 0.03);
                    }

                    .boxtabelleEinspaltig
                    {
                    width: 49%;
                    }

                    .boxtabelleZweispaltig,
                    .boxtabelleDreispaltig
                    {
                    width: 100%;
                    }

                    .box5050
                    {
                    width: 50%;
                    }

                    .boxEinspaltig
                    {
                    width: 100%;
                    }

                    .boxZweispaltig
                    {
                    width: 48.5%;
                    }

                    .boxSpalte1 {
                    width: 50%;
                    }

                    .boxSpalte2 {
                    width: 50%;
                    padding-left: 20px;
                    }

                    .paddingLeft {
                    padding-left: 0.1em;
                    }

                    .noPadding {
                    padding-top: 0 !important;
                    padding-bottom: 0 !important;
                    }

                    .rechnungsZeile
                    {
                    display: table-row;
                    }

                    .rechnungsZeile .boxdaten
                    {
                    height: auto;
                    }

                    .rechnungSp1
                    {
                    width: 65%;
                    font-size: 16px;
                    }

                    .rechnungSp2
                    {
                    width: 10%;
                    }

                    .rechnungSp3
                    {
                    width: 25%;
                    font-size: 16px;
                    text-align: right;
                    }

                    .detailSp1,
                    .detailSp2
                    {
                    width: 50%;
                    }

                    .detailSp2
                    {
                    text-align: right;
                    }

                    .line1Bottom
                    {
                    border-bottom: 1px solid #000;
                    }

                    .line1BottomLight
                    {
                    padding-bottom: 5px;
                    border-bottom: 1px solid #f0f0f0;
                    margin-bottom: 5px;
                    }

                    .line2Bottom
                    {
                    border-bottom: 2px solid #000;
                    }

                    .paddingTop
                    {
                    padding-top: 10px;
                    }

                    .paddingBottom
                    {
                    padding-bottom: 10px;
                    }

                    .grund
                    {
                    font-size: 16px;
                    display: block;
                    width: 100%;
                    padding: 0 20px 15px 20px;
                    }

                    .grundDetail
                    {
                    display: block;
                    width: 100%;
                    padding: 0 20px 15px 20px;
                    }

                    /* Übersichtformatierungen */
                    #uebersichtLastschrift.box,
                    #uebersichtUeberweisung.box
                    {
                    border-top: none;
                    }

                    #uebersichtUeberweisung.box
                    {
                    border-left: none;
                    }


                    /* Formatierungen Detailseite */

                    .detailsSpalte1,
                    .detailsSpalte2
                    {
                    width: 30%;
                    float: left;
                    font-size: 90%;
                    line-height: 115%;
                    margin-right: 5%;
                    }

                    .detailsSpalte3
                    {
                    width: 30%;
                    float: left;
                    font-size: 90%;
                    line-height: 115%;
                    }

                    .detailsSpalte1 .legende,
                    .detailsSpalte2 .legende,
                    .detailsSpalte3 .legende
                    {
                    width: 145px;
                    }

                    .titelPosition
                    {
                    font-size: 17px;
                    font-weight: bold;
                    }


                    /* Laufzettelformatierungen */
                    #laufzettelHistorie .boxtabelle:not(:nth-child(2))
                    {
                    border-top: 1px solid rgba(4, 101, 161, 0.2);
                    padding-top: 10px;
                    margin-top: 10px;
                    }





                    /* 1023px und kleiner ************************************************/

                    @media screen and (max-width : 1023px) {

                    .box
                    {
                    display: block;
                    width: 100%;
                    margin-bottom: 20px;
                    }

                    .boxabstandtop
                    {
                    margin-top: 15px;
                    }

                    .subBox:first-child
                    {
                    margin-bottom: 0 !important;
                    }

                    .subBox:last-child
                    {
                    border-left: 1px solid rgba(4, 101, 161, 0.2);
                    }

                    .first > .boxzeile > .subBox
                    {
                    border-top: none !important;
                    }

                    .first > .boxzeile > .subBox:first-child
                    {
                    border-top: 1px solid rgba(4, 101, 161, 0.2) !important;
                    }

                    .first > .boxzeile
                    {
                    margin-bottom: 0;
                    }

                    #uebersichtUeberweisung.box
                    {
                    border-left: 1px solid rgba(4, 101, 161, 0.2);
                    }

                    #uebersichtLastschrift.box
                    {
                    margin-bottom: 0;
                    }

                    .boxzeile
                    {
                    display: block;
                    margin-bottom: 5px;
                    }

                    .boxzeile:after
                    {
                    visibility: hidden;
                    display: block;
                    font-size: 0;
                    content: " ";
                    clear: both;
                    height: 0;
                    }

                    #details > .boxtabelle > .boxzeile
                    {
                    margin-bottom: 0px;
                    }

                    .boxcell
                    {
                    display: block;
                    }

                    .boxcell:last-child
                    {
                    margin-top: 20px;
                    }

                    .boxZweispaltig
                    {
                    width: 100%;
                    }

                    .legende
                    {
                    display: block;
                    float: left;
                    width: 170px;
                    padding: 5px 0;
                    height: auto;
                    }

                    .wert
                    {
                    display: block;
                    float: left;
                    width: calc(100% - 170px);
                    padding: 11px 10px !important;
                    line-height: 1.3;
                    min-height: 38px;
                    height: auto;
                    }

                    .boxdaten .legende
                    {
                    height: auto;
                    }

                    .rechnungsZeile .boxdaten
                    {
                    padding: 5px 0;
                    }

                    .boxabstand
                    {
                    display: none;
                    }

                    .boxtabelleEinspaltig {
                    width: 100%;
                    }

                    .boxSpalte1 {
                    display: block;
                    width: auto;
                    }

                    .boxSpalte2 {
                    display: block;
                    width: auto;
                    padding-left: 0px;
                    margin-top: 1.2rem;
                    }

                    .detailsSpalte1,
                    .detailsSpalte2,
                    .detailsSpalte3
                    {
                    width: 100%;
                    float: none;
                    padding-right: 0px;
                    }

                    .detailsSpalte2,
                    .detailsSpalte3
                    {
                    margin-top: 15px;
                    }

                    .detailsSpalte2,
                    .detailsSpalte3
                    {
                    margin-top: 10px;
                    }

                    .tableNumberAlignRight
                    {
                    display: block;
                    width: 130px;
                    text-align: right;
                    }
                    }



                    /* 800px und kleiner ************************************************/

                    @media screen and (max-width : 800px) {

                    button
                    {
                    padding-top: 10px;
                    }

                    .btnAktiv,
                    .btnInaktiv,
                    .tab
                    {
                    font-size: 20px;
                    height: 40px;
                    }

                    .btnAktiv:after
                    {
                    top: 40px;
                    }

                    .rechnungSp1
                    {
                    width: 55%;
                    font-size: 15px;
                    }

                    .rechnungSp2
                    {
                    width: 10%;
                    }

                    .rechnungSp3
                    {
                    width: 35%;
                    text-align: right;
                    font-size: 15px;
                    }

                    .grund
                    {
                    font-size: 15px;
                    }
                    }

                    /* 450px und kleiner ************************************************/

                    @media screen and (max-width : 450px)
                    {

                    html,
                    body
                    {
                    font-size: 12px;
                    }

                    .menue
                    {
                    margin-bottom: 20px;
                    }

                    button
                    {
                    padding-top: 5px;
                    }

                    .btnAktiv,
                    .btnInaktiv,
                    .tab
                    {
                    font-size: 17px;
                    height: 35px;
                    }

                    .btnAktiv:after
                    {
                    top: 35px;
                    }

                    .legende
                    {
                    font-size: 12px;
                    width: 100%;
                    }

                    .wert
                    {
                    font-size: 12px;
                    line-height: 1.3;
                    width: 100%;
                    margin-bottom: 10px
                    }

                    .boxzeile
                    {
                    margin-bottom: 0px
                    }

                    .boxdaten
                    {
                    height: auto;
                    }

                    .haftungausschluss
                    {
                    margin-bottom: 20px;
                    }

                    .boxinhalt
                    {
                    margin-top: 0px;
                    }

                    .boxabstandtop
                    {
                    margin-top: 20px;
                    }

                    .boxtitel
                    {
                    padding: 7px 8px;
                    }

                    .box
                    {
                    margin-bottom: 10px;
                    padding: 0;
                    }

                    .boxabstandtop
                    {
                    margin-top: 10px;
                    }

                    .boxdaten,
                    .boxdatenBlock
                    {
                    padding: 2px 0;
                    }

                    .rechnungSp1
                    {
                    width: 50%;
                    font-size: inherit;
                    }

                    .rechnungSp2
                    {
                    width: 15%;
                    }

                    .rechnungSp3
                    {
                    width: 35%;
                    font-size: inherit;
                    text-align: right;
                    }

                    .grund
                    {
                    font-size: inherit;
                    }

                    .titelPosition
                    {
                    font-size: 15px;
                    }

                    .abstandUnten
                    {
                    margin-bottom: 5px;
                    }

                    .detailsSpalte1,
                    .detailsSpalte2,
                    .detailsSpalte3
                    {
                    font-size: inherit;
                    line-height: inherit;
                    }
                    }

                    /* 380px und kleiner ************************************************/

                    @media screen and (max-width : 380px) {

                    html,
                    body
                    {
                    font-size: 11px;
                    line-height: 100%;
                    }

                    .btnAktiv,
                    .btnInaktiv,
                    .tab
                    {
                    font-size: 15px;
                    }

                    .boxdaten
                    .boxdatenBlock
                    {
                    padding: 2px 0;
                    }

                    .boxinhalt
                    {
                    margin-top: 0px;
                    }

                    .boxtitel
                    {
                    padding: 5px 7px;
                    }
                    }


                </style>
            </head>
            <body>
                <form>
                    <div class="menue">
                        <div class="innen">
                            <button type="button" class="tab" id="menueUebersicht" onclick="show(this);"><xsl:value-of select="$i18n.overview"/></button>
                            <button type="button" class="tab" id="menueDetails" onclick="show(this);"><xsl:value-of select="$i18n.items"/></button>
                            <button type="button" class="tab" id="menueZusaetze" onclick="show(this)"><xsl:value-of select="$i18n.information"/></button>
                            <button type="button" class="tab" id="menueAnlagen" onclick="show(this)"><xsl:value-of select="$i18n.attachments"/></button>
                            <button type="button" class="tab" id="menueLaufzettel" onclick="show(this)"><xsl:value-of select="$i18n.history"/></button>
                        </div>
                    </div>
                </form>
                <div class="inhalt">
                    <div class="innen">
                        <xsl:call-template name="uebersicht"/>
                        <xsl:call-template name="details"/>
                        <xsl:call-template name="zusaetze"/>
                        <xsl:call-template name="anlagen"/>
                        <xsl:call-template name="laufzettel"/>
                    </div>
                </div>
            </body>
            <script>
                //<![CDATA[

/* Tab-Container aufbauen **************************************************/

var a = new Array("uebersicht", "details", "zusaetze", "anlagen", "laufzettel");
var b = new Array("menueUebersicht", "menueDetails", "menueZusaetze", "menueAnlagen", "menueLaufzettel");

function show(e) {
  var i = 0;
  var j = 1;
  for (var t = 0; t < b.length; t++) {
    if (b[t] === e.id) {
      i = t;
      if (i > 0) {
        j = 0;
      } else {
        j = i + 1;
      }
      break;
    }
  }
  e.setAttribute("class", "btnAktiv");
  for (var k = 0; k < b.length; k++) {
    if (k === i && (document.getElementById(a[k]) != null)) {
      document.getElementById(a[k]).style.display = "block";
      if (i === j)
      j = i + 1;
    } else {
      if (document.getElementById(a[k]) != null) {
        document.getElementById(a[j]).style.display = "none";
        document.getElementById(b[j]).setAttribute("class", "btnInaktiv");
        j += 1;
      }
    }
  }
}
window.onload = function () {
  document.getElementById(b[0]).setAttribute("class", "btnAktiv");
}

/* Eingebettete Binaerdaten runterladen   ************************************/


function base64_to_binary (data) {
  var chars = atob(data);
  var bytes = new Array(chars.length);
  for (var i = 0; i < chars.length; i++) {
    bytes[i] = chars.charCodeAt(i);
  }
  return new Uint8Array(bytes);
}

function downloadData (element_id) {
  var data_element = document.getElementById(element_id);
  var mimetype = data_element.getAttribute('mimeType');
  var filename = data_element.getAttribute('filename');
  var text = data_element.innerHTML;
  var binary = base64_to_binary(text);
  var blob = new Blob([binary], {
    type: mimetype, size: binary.length
  });

  if (window.navigator && window.navigator.msSaveOrOpenBlob) {
    // IE
    window.navigator.msSaveOrOpenBlob(blob, filename);
  } else {
    // Non-IE
    var url = window.URL.createObjectURL(blob);
    window.open(url);
  }
}


/* Polyfill IE atob/btoa   ************************************/

(function (root, factory) {
  if (typeof define === 'function' && define.amd) {
    // AMD. Register as an anonymous module.
    define([], function () {
      factory(root);
    });
  } else factory(root);
  // node.js has always supported base64 conversions, while browsers that support
  // web workers support base64 too, but you may never know.
})(typeof exports !== "undefined" ? exports: this, function (root) {
  if (root.atob) {
    // Some browsers' implementation of atob doesn't support whitespaces
    // in the encoded string (notably, IE). This wraps the native atob
    // in a function that strips the whitespaces.
    // The original function can be retrieved in atob.original
    try {
      root.atob(" ");
    }
    catch (e) {
      root.atob = (function (atob) {
        var func = function (string) {
          return atob(String(string).replace(/[\t\n\f\r ]+/g, ""));
        };
        func.original = atob;
        return func;
      })(root.atob);
    }
    return;
  }

  // base64 character set, plus padding character (=)
  var b64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",
  // Regular expression to check formal correctness of base64 encoded strings
  b64re = /^(?:[A-Za-z\d+\/]{4})*?(?:[A-Za-z\d+\/]{2}(?:==)?|[A-Za-z\d+\/]{3}=?)?$/;

  root.btoa = function (string) {
    string = String(string);
    var bitmap, a, b, c,
    result = "", i = 0,
    rest = string.length % 3; // To determine the final padding

    for (; i < string.length;) {
      if ((a = string.charCodeAt(i++)) > 255 || (b = string.charCodeAt(i++)) > 255 || (c = string.charCodeAt(i++)) > 255)
      throw new TypeError("Failed to execute 'btoa' on 'Window': The string to be encoded contains characters outside of the Latin1 range.");

      bitmap = (a << 16) | (b << 8) | c;
      result += b64.charAt(bitmap >> 18 & 63) + b64.charAt(bitmap >> 12 & 63) + b64.charAt(bitmap >> 6 & 63) + b64.charAt(bitmap & 63);
    }

    // If there's need of padding, replace the last 'A's with equal signs
    return rest ? result.slice(0, rest - 3) + "===".substring(rest): result;
  };

  root.atob = function (string) {
    // atob can work with strings with whitespaces, even inside the encoded part,
    // but only \t, \n, \f, \r and ' ', which can be stripped.
    string = String(string).replace(/[\t\n\f\r ]+/g, "");
    if (! b64re.test(string))
    throw new TypeError("Failed to execute 'atob' on 'Window': The string to be decoded is not correctly encoded.");

    // Adding the padding if missing, for semplicity
    string += "==".slice(2 - (string.length & 3));
    var bitmap, result = "", r1, r2, i = 0;
    for (; i < string.length;) {
      bitmap = b64.indexOf(string.charAt(i++)) << 18 | b64.indexOf(string.charAt(i++)) << 12 | (r1 = b64.indexOf(string.charAt(i++))) << 6 | (r2 = b64.indexOf(string.charAt(i++)));

      result += r1 === 64 ? String.fromCharCode(bitmap >> 16 & 255): r2 === 64 ? String.fromCharCode(bitmap >> 16 & 255, bitmap >> 8 & 255): String.fromCharCode(bitmap >> 16 & 255, bitmap >> 8 & 255, bitmap & 255);
    }
    return result;
  };
});
//]]>

            </script>
        </html>
    </xsl:template>


    <xsl:template name="uebersicht">
        <div id="uebersicht" class="divShow">
            <div class="haftungausschluss"><xsl:value-of select="$i18n.disclaimer"/></div>
            <div class="boxtabelle boxtabelleZweispaltig">
                <div class="boxzeile">

                    <xsl:apply-templates select="./xr:BUYER"/>

                    <div class="boxabstand"></div>

                    <xsl:apply-templates select="./xr:SELLER"/>

                </div>
            </div>

            <div class="boxtabelle boxabstandtop boxtabelleZweispaltig">
                <xsl:call-template name="uebersichtRechnungsinfo"/>
            </div>

            <div class="boxtabelle boxabstandtop boxtabelleZweispaltig">
                <xsl:call-template name="uebersichtRechnungsuebersicht"/>
            </div>

            <div class="boxtabelle boxabstandtop boxtabelleZweispaltig">
                <xsl:apply-templates select="./xr:VAT_BREAKDOWN"/>
            </div>

            <div class="boxtabelle boxabstandtop boxtabelleZweispaltig">
                <xsl:apply-templates select="./xr:DOCUMENT_LEVEL_ALLOWANCES"/>
            </div>

            <div class="boxtabelle boxabstandtop boxtabelleZweispaltig">
                <xsl:apply-templates select="./xr:DOCUMENT_LEVEL_CHARGES"/>
            </div>
            
            <div class="boxtabelle boxabstandtop boxtabelleZweispaltig">
            	<xsl:apply-templates select="./xr:LOGISTICS_SERVICE_CHARGES"/>
            </div>

            <div class="boxtabelle boxabstandtop boxtabelleZweispaltig first">
                <div class="boxzeile">
                    <xsl:call-template name="uebersichtZahlungsinformationen"/>
                    <xsl:call-template name="uebersichtCard"/>
                </div>
            </div>

            <div class="boxtabelle">
                <div class="boxzeile">
                    <xsl:call-template name="uebersichtLastschrift"/>
                    <xsl:call-template name="uebersichtUeberweisung"/>
                </div>
            </div>

            <div class="boxtabelle boxabstandtop">
                <div class="boxzeile">
                    <xsl:apply-templates select="./xr:INVOICE_NOTE"/>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="uebersichtKaeufer" match="xr:BUYER">
        <div id="uebersichtKaeufer" class="box boxZweispaltig">
            <div id="BG-7" title="BG-7" class="boxtitel"><xsl:value-of select="$i18n.recipientInfo"/></div>
            <div class="boxtabelle boxinhalt borderSpacing">
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt10"/>:</div>
                    <div id="BT-10" title="BT-10" class="boxdaten wert"><xsl:value-of select="../xr:Buyer_reference"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt44"/>:</div>
                    <div id="BT-44" title="BT-44" class="boxdaten wert"><xsl:value-of select="xr:Buyer_name"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt50"/>:</div>
                    <div id="BT-50" title="BT-50" class="boxdaten wert"><xsl:value-of select="xr:BUYER_POSTAL_ADDRESS/xr:Buyer_address_line_1"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt51"/>:</div>
                    <div id="BT-51" title="BT-51" class="boxdaten wert"><xsl:value-of select="xr:BUYER_POSTAL_ADDRESS/xr:Buyer_address_line_2"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt163"/>:</div>
                    <div id="BT-163" title="BT-163" class="boxdaten wert"><xsl:value-of select="xr:BUYER_POSTAL_ADDRESS/xr:Buyer_address_line_3"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt53"/>:</div>
                    <div id="BT-53" title="BT-53" class="boxdaten wert"><xsl:value-of select="xr:BUYER_POSTAL_ADDRESS/xr:Buyer_post_code"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt52"/>:</div>
                    <div id="BT-52" title="BT-52" class="boxdaten wert"><xsl:value-of select="xr:BUYER_POSTAL_ADDRESS/xr:Buyer_city"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt54"/>:</div>
                    <div id="BT-54" title="BT-54" class="boxdaten wert"><xsl:value-of select="xr:BUYER_POSTAL_ADDRESS/xr:Buyer_country_subdivision"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt55"/>:</div>
                    <div id="BT-55" title="BT-55" class="boxdaten wert"><xsl:value-of select="xr:BUYER_POSTAL_ADDRESS/xr:Buyer_country_code"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt46"/>:</div>
                    <div id="BT-46" title="BT-46" class="boxdaten wert"><xsl:value-of select="xr:Buyer_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt46-id"/>:</div>
                    <div id="BT-46-scheme-id" title="BT-46-scheme-id" class="boxdaten wert"><xsl:value-of select="xr:Buyer_identifier/@scheme_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt56"/>:</div>
                    <div id="BT-56" title="BT-56" class="boxdaten wert"><xsl:value-of select="xr:BUYER_CONTACT/xr:Buyer_contact_point"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt57"/>:</div>
                    <div id="BT-57" title="BT-57" class="boxdaten wert"><xsl:value-of select="xr:BUYER_CONTACT/xr:Buyer_contact_telephone_number"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt58"/>:</div>
                    <div id="BT-58" title="BT-58" class="boxdaten wert"><xsl:value-of select="xr:BUYER_CONTACT/xr:Buyer_contact_email_address"/></div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="uebersichtVerkaeufer" match="xr:SELLER">
        <div id="uebersichtVerkaeufer" class="box boxZweispaltig">
            <div id="BG-4" title="BG-4" class="boxtitel"><xsl:value-of select="$i18n.bg4"/></div>
            <div class="boxtabelle boxinhalt borderSpacing">
                <div class="boxzeile">
                    <div class="boxdaten legende"> </div>
                    <div class="boxdaten wert" style="background-color: white;"> </div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt27"/>:</div>
                    <div id="BT-27" title="BT-27" class="boxdaten wert"><xsl:value-of select="xr:Seller_name"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt35"/>:</div>
                    <div id="BT-35" title="BT-35" class="boxdaten wert"><xsl:value-of select="xr:SELLER_POSTAL_ADDRESS/xr:Seller_address_line_1"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt36"/>:</div>
                    <div id="BT-36" title="BT-36" class="boxdaten wert"><xsl:value-of select="xr:SELLER_POSTAL_ADDRESS/xr:Seller_address_line_2"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt162"/>:</div>
                    <div id="BT-162" title="BT-162" class="boxdaten wert"><xsl:value-of select="xr:SELLER_POSTAL_ADDRESS/xr:Seller_address_line_3"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt38"/>:</div>
                    <div id="BT-38" title="BT-38" class="boxdaten wert"><xsl:value-of select="xr:SELLER_POSTAL_ADDRESS/xr:Seller_post_code"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt37"/>:</div>
                    <div id="BT-37" title="BT-37" class="boxdaten wert"><xsl:value-of select="xr:SELLER_POSTAL_ADDRESS/xr:Seller_city"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt39"/>:</div>
                    <div id="BT-39" title="BT-39" class="boxdaten wert"><xsl:value-of select="xr:SELLER_POSTAL_ADDRESS/xr:Seller_country_subdivision"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt40"/>:</div>
                    <div id="BT-40" title="BT-40" class="boxdaten wert"><xsl:value-of select="xr:SELLER_POSTAL_ADDRESS/xr:Seller_country_code"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt29"/>:</div>
                    <div id="BT-29" title="BT-29" class="boxdaten wert"><xsl:value-of select="xr:Seller_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt29-id"/>:</div>
                    <div id="BT-29-scheme-id" title="BT-29-scheme-id" class="boxdaten wert"><xsl:value-of select="xr:Seller_identifier/@scheme_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt41"/>:</div>
                    <div id="BT-41" title="BT-41" class="boxdaten wert"><xsl:value-of select="xr:SELLER_CONTACT/xr:Seller_contact_point"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt42"/>:</div>
                    <div id="BT-42" title="BT-42" class="boxdaten wert"><xsl:value-of select="xr:SELLER_CONTACT/xr:Seller_contact_telephone_number"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt43"/>:</div>
                    <div id="BT-43" title="BT-43" class="boxdaten wert"><xsl:value-of select="xr:SELLER_CONTACT/xr:Seller_contact_email_address"/></div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="uebersichtRechnungsinfo">
        <div class="boxzeile">
            <div id="uebersichtRechnungsinfo" class="box box1v2">
                <div class="boxtitel"><xsl:value-of select="$i18n.details"/></div>
                <div class="boxtabelle boxinhalt">
                    <div class="boxcell boxZweispaltig">
                        <div class="boxtabelle borderSpacing">
                            <div class="boxzeile">
                                <div class="boxdaten legende"><xsl:value-of select="$i18n.bt1"/>:</div>
                                <div id="BT-1" title="BT-1" class="boxdaten wert"><xsl:value-of select="xr:Invoice_number"/></div>
                            </div>
                            <div class="boxzeile">
                                <div class="boxdaten legende"><xsl:value-of select="$i18n.bt2"/>:</div>
                                <div id="BT-2" title="BT-2" class="boxdaten wert"><xsl:value-of select="format-date(xr:Invoice_issue_date,'[D].[M].[Y]')"/></div>
                            </div>
                            <div class="boxzeile">
                                <div class="boxdaten legende"><xsl:value-of select="$i18n.bt3"/>:</div>
                                <div id="BT-3" title="BT-3" class="boxdaten wert"><xsl:value-of select="xr:Invoice_type_code"/></div>
                            </div>
                            <div class="boxzeile">
                                <div class="boxdaten legende"><xsl:value-of select="$i18n.bt5"/></div>
                                <div id="BT-5" title="BT-5" class="boxdaten wert"><xsl:value-of select="xr:Invoice_currency_code"/></div>
                            </div>
                        </div>
                        <h4><xsl:value-of select="$i18n.period"/>:</h4>
                        <div class="boxtabelle borderSpacing">
                            <div class="boxzeile">
                                <div class="boxdaten legende"><xsl:value-of select="$i18n.bt73"/>:</div>
                                <div id="BT-73" title="BT-73" class="boxdaten wert"><xsl:value-of select="format-date(xr:INVOICING_PERIOD/xr:Invoicing_period_start_date,'[D].[M].[Y]')"/></div>
                            </div>
                            <div class="boxzeile">
                                <div class="boxdaten legende"><xsl:value-of select="$i18n.bt74"/>:</div>
                                <div id="BT-74" title="BT-74" class="boxdaten wert"><xsl:value-of select="format-date(xr:INVOICING_PERIOD/xr:Invoicing_period_end_date,'[D].[M].[Y]')"/></div>
                            </div>
                        </div>
                    </div>
                    <div class="boxabstand"></div>
                    <div class="boxcell boxZweispaltig">
                        <div class="boxtabelle borderSpacing">
                            <div class="boxzeile">
                                <div class="boxdaten legende"><xsl:value-of select="$i18n.bt11"/>:</div>
                                <div id="BT-11" title="BT-11" class="boxdaten wert"><xsl:value-of select="xr:Project_reference"/></div>
                            </div>
                            <div class="boxzeile">
                                <div class="boxdaten legende"><xsl:value-of select="$i18n.bt12"/>:</div>
                                <div id="BT-12" title="BT-12" class="boxdaten wert"><xsl:value-of select="xr:Contract_reference"/></div>
                            </div>
                            <div class="boxzeile">
                                <div class="boxdaten legende"><xsl:value-of select="$i18n.bt13"/>:</div>
                                <div id="BT-13" title="BT-13" class="boxdaten wert"><xsl:value-of select="xr:Purchase_order_reference"/></div>
                            </div>
                            <div class="boxzeile">
                                <div class="boxdaten legende"><xsl:value-of select="$i18n.bt14"/>:</div>
                                <div id="BT-14" title="BT-14" class="boxdaten wert"><xsl:value-of select="xr:Sales_order_reference"/></div>
                            </div>
                        </div>
                        <h4><xsl:value-of select="$i18n.preceding_invoice_reference"/>:</h4>
                        <xsl:apply-templates select="./xr:PRECEDING_INVOICE_REFERENCE"/>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>

    <xsl:template match="xr:PRECEDING_INVOICE_REFERENCE">
        <div class="boxtabelle borderSpacing">
            <div class="boxzeile">
                <div class="boxdaten legende"><xsl:value-of select="$i18n.bt25"/>:</div>
                <div id="BT-25" title="BT-25" class="boxdaten wert"><xsl:value-of select="xr:Preceding_Invoice_reference"/></div>
            </div>
            <div class="boxzeile">
                <div class="boxdaten legende"><xsl:value-of select="$i18n.bt26"/>:</div>
                <div id="BT-26" title="BT-26" class="boxdaten wert"><xsl:value-of select="(format-date,xr:Preceding_Invoice_issue_date,'[D].[M].[Y]')"/></div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="uebersichtRechnungsuebersicht">
        <div class="boxzeile">
            <div id="uebersichtRechnungsuebersicht" class="box">
                <div id="BG-22" title="BG-22" class="boxtitel"><xsl:value-of select="$i18n.bg22"/></div>
                <div class="boxtabelle boxinhalt">
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1"><xsl:value-of select="$i18n.bt106"/></div>
                        <div class="boxdaten rechnungSp2 color2">netto</div>
                        <div id="BT-106" title="BT-106" class="boxdaten rechnungSp3"><xsl:value-of select="format-number(xr:DOCUMENT_TOTALS/xr:Sum_of_Invoice_line_net_amount,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1"><xsl:value-of select="$i18n.bt107"/></div>
                        <div class="boxdaten rechnungSp2 color2">netto</div>
                        <div id="BT-107" title="BT-107" class="boxdaten rechnungSp3"><xsl:value-of select="format-number(xr:DOCUMENT_TOTALS/xr:Sum_of_allowances_on_document_level,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1 paddingBottom line1Bottom"><xsl:value-of select="$i18n.bt108"/></div>
                        <div class="boxdaten rechnungSp2 paddingBottom line1Bottom color2">netto</div>
                        <div id="BT-108" title="BT-108" class="boxdaten rechnungSp3 paddingBottom line1Bottom"><xsl:value-of select="format-number(xr:DOCUMENT_TOTALS/xr:Sum_of_charges_on_document_level,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1 paddingTop"><xsl:value-of select="$i18n.bt109"/></div>
                        <div class="boxdaten rechnungSp2 paddingTop color2">netto</div>
                        <div id="BT-109" title="BT-109" class="boxdaten rechnungSp3 paddingTop"><xsl:value-of select="format-number(xr:DOCUMENT_TOTALS/xr:Invoice_total_amount_without_VAT,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1"><xsl:value-of select="$i18n.bt110"/></div>
                        <div class="boxdaten rechnungSp2 color2"></div>
                        <div id="BT-110" title="BT-110" class="boxdaten rechnungSp3"><xsl:value-of select="format-number(xr:DOCUMENT_TOTALS/xr:Invoice_total_VAT_amount,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1 paddingBottom line1Bottom"><xsl:value-of select="$i18n.bt111"/></div>
                        <div class="boxdaten rechnungSp2 paddingBottom line1Bottom color2"></div>
                        <div id="BT-111" title="BT-111" class="boxdaten rechnungSp3 paddingBottom line1Bottom"><xsl:value-of select="format-number(xr:DOCUMENT_TOTALS/xr:Invoice_total_VAT_amount_in_accounting_currency,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1 paddingTop"><xsl:value-of select="$i18n.bt112"/></div>
                        <div class="boxdaten rechnungSp2 paddingTop color2">brutto</div>
                        <div id="BT-112" title="BT-112" class="boxdaten rechnungSp3 paddingTop"><xsl:value-of select="format-number(xr:DOCUMENT_TOTALS/xr:Invoice_total_amount_with_VAT,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1"><xsl:value-of select="$i18n.bt113"/></div>
                        <div class="boxdaten rechnungSp2 color2">brutto</div>
                        <div id="BT-113" title="BT-113" class="boxdaten rechnungSp3"><xsl:value-of select="format-number(xr:DOCUMENT_TOTALS/xr:Paid_amount,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1 paddingBottom line2Bottom"><xsl:value-of select="$i18n.bt114"/></div>
                        <div class="boxdaten rechnungSp2 paddingBottom line2Bottom color2">brutto</div>
                        <div id="BT-114" title="BT-114" class="boxdaten rechnungSp3 paddingBottom line2Bottom"><xsl:value-of select="format-number(xr:DOCUMENT_TOTALS/xr:Rounding_amount,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1 paddingTop bold"><xsl:value-of select="$i18n.bt115"/></div>
                        <div class="boxdaten rechnungSp2 paddingTop color2">brutto</div>
                        <div id="BT-115" title="BT-115" class="boxdaten rechnungSp3 paddingTop bold"><xsl:value-of select="format-number(xr:DOCUMENT_TOTALS/xr:Amount_due_for_payment,'###.##0,00','decimal')"/></div>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="uebersichtUmsatzsteuer" match="xr:VAT_BREAKDOWN">
        <div class="boxzeile">
            <div id="uebersichtUmsatzsteuer" class="box">
                <div id="BG-23" title="BG-23" class="boxtitel"><xsl:value-of select="$i18n.bg23"/></div>
                <div class="boxtabelle boxinhalt">
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1 bold"><xsl:value-of select="$i18n.bt118"/>: <span id="BT-118" title="BT-118"><xsl:value-of select="xr:VAT_category_code"/></span></div>
                        <div class="boxdaten rechnungSp2"></div>
                        <div class="boxdaten rechnungSp3"></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1"><xsl:value-of select="$i18n.bt116"/></div>
                        <div class="boxdaten rechnungSp2 color2">netto</div>
                        <div id="BT-116" title="BT-116" class="boxdaten rechnungSp3"><xsl:value-of select="format-number(xr:VAT_category_taxable_amount,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1 line1Bottom"><xsl:value-of select="$i18n.bt119"/></div>
                        <div class="boxdaten rechnungSp2 color2 line1Bottom"></div>
                        <div id="BT-119" title="BT-119" class="boxdaten rechnungSp3 line1Bottom"><xsl:value-of select="xr:VAT_category_rate"/>%</div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1"><xsl:value-of select="$i18n.bt117"/></div>
                        <div class="boxdaten rechnungSp2 color2"></div>
                        <div id="BT-117" title="BT-117" class="boxdaten rechnungSp3 bold"><xsl:value-of select="format-number(xr:VAT_category_tax_amount,'###.##0,00','decimal')"/></div>
                    </div>
                </div>

                <div class="grund">
                    <div><xsl:value-of select="$i18n.bt120"/>: <span id="BT-120" title="BT-120" class="bold"><xsl:value-of select="xr:VAT_exemption_reason_text"/></span></div>
                    <div><xsl:value-of select="$i18n.bt121"/>: <span id="BT-121"  title="BT-121" class="bold"><xsl:value-of select="xr:VAT_exemption_reason_code"/></span></div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="uebersichtNachlass" match="xr:DOCUMENT_LEVEL_ALLOWANCES">
        <div class="boxzeile">
            <div id="uebersichtNachlass" class="box">
                <div id="BG-20" title="BG-20" class="boxtitel"><xsl:value-of select="$i18n.bg20"/></div>
                <div class="boxtabelle boxinhalt">
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1 bold"><xsl:value-of select="$i18n.bt95"/>: <span title="BT-95"><xsl:value-of select="xr:Document_level_allowance_VAT_category_code"/></span></div>
                        <div class="boxdaten rechnungSp2"></div>
                        <div class="boxdaten rechnungSp3"></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1"><xsl:value-of select="$i18n.bt93"/></div>
                        <div class="boxdaten rechnungSp2 color2">netto</div>
                        <div id="BT-93" title="BT-93" class="boxdaten rechnungSp3"><xsl:value-of select="format-number(xr:Document_level_allowance_base_amount,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1 line1Bottom"><xsl:value-of select="$i18n.bt94"/></div>
                        <div class="boxdaten rechnungSp2 color2 line1Bottom"></div>
                        <div id="BT-94" title="BT-94" class="boxdaten rechnungSp3 line1Bottom"><xsl:value-of select="xr:Document_level_allowance_percentage"/>%</div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1"><xsl:value-of select="$i18n.bt92"/></div>
                        <div class="boxdaten rechnungSp2 color2">netto</div>
                        <div id="BT-92" title="BT-92" class="boxdaten rechnungSp3 bold"><xsl:value-of select="format-number(xr:Document_level_allowance_amount,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1"><xsl:value-of select="$i18n.bt96"/></div>
                        <div class="boxdaten rechnungSp2 color2"></div>
                        <div id="BT-96" title="BT-96" class="boxdaten rechnungSp3"><xsl:value-of select="xr:Document_level_allowance_VAT_rate"/></div>
                    </div>
                </div>
                <div class="grund">
                    <div><xsl:value-of select="$i18n.bt97"/>: <span id="BT-97" title="BT-97" class="bold"><xsl:value-of select="xr:Document_level_allowance_reason"/></span></div>
                    <div><xsl:value-of select="$i18n.bt98"/>: <span id="BT-98" title="BT-98" class="bold"><xsl:value-of select="xr:Document_level_allowance_reason_code"/></span></div>
                </div>
            </div>
        </div>
        <div class="boxabstand"></div>
    </xsl:template>


    <xsl:template name="uebersichtZuschlaege" match="xr:DOCUMENT_LEVEL_CHARGES">
        <div class="boxzeile">
            <div id="uebersichtZuschlaege" class="box">
                <div id="BG-21" title="BG-21" class="boxtitel"><xsl:value-of select="$i18n.bg21"/></div>
                <div class="boxtabelle boxinhalt">
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1 bold"><xsl:value-of select="$i18n.bt102"/>: <span title="BT-102"><xsl:value-of select="xr:Document_level_charge_VAT_category_code"/></span></div>
                        <div class="boxdaten rechnungSp2"></div>
                        <div class="boxdaten rechnungSp3"></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1"><xsl:value-of select="$i18n.bt100"/></div>
                        <div class="boxdaten rechnungSp2 color2">netto</div>
                        <div id="BT-100" title="BT-100" class="boxdaten rechnungSp3"><xsl:value-of select="format-number(xr:Document_level_charge_base_amount,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1 line1Bottom"><xsl:value-of select="$i18n.bt101"/></div>
                        <div class="boxdaten rechnungSp2 color2 line1Bottom"></div>
                        <div id="BT-101" title="BT-101" class="boxdaten rechnungSp3 line1Bottom"><xsl:value-of select="xr:Document_level_charge_percentage"/>%</div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1"><xsl:value-of select="$i18n.bt99"/></div>
                        <div class="boxdaten rechnungSp2 color2">netto</div>
                        <div id="BT-99" title="BT-99" class="boxdaten rechnungSp3 bold"><xsl:value-of select="format-number(xr:Document_level_charge_amount,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1"><xsl:value-of select="$i18n.bt103"/></div>
                        <div class="boxdaten rechnungSp2 color2"></div>
                        <div id="BT-103" title="BT-103" class="boxdaten rechnungSp3"><xsl:value-of select="xr:Document_level_charge_VAT_rate"/></div>
                    </div>
                </div>
                <div class="grund">
                    <div><xsl:value-of select="$i18n.bt104"/>: <span id="BT-104" title="BT-104" class="bold"><xsl:value-of select="xr:Document_level_charge_reason"/></span></div>
                    <div><xsl:value-of select="$i18n.bt105"/>: <span id="BT-105" title="BT-105" class="bold"><xsl:value-of select="xr:Document_level_charge_reason_code"/></span></div>
                </div>
            </div>
        </div>
        <div class="boxabstand"></div>
    </xsl:template>
    
    
    <xsl:template name="uebersichtVersandkosten" match="xr:LOGISTICS_SERVICE_CHARGES">
        <div class="boxzeile">
            <div id="uebersichtVersandkosten" class="box">
                <div id="BG-X-42" title="BG-X-42" class="boxtitel"><xsl:value-of select="$i18n.bgx42"/></div>
                <div class="boxtabelle boxinhalt">
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1 bold"><xsl:value-of select="$i18n.btx274"/>: <span title="BT-X-274"><xsl:value-of select="xr:Logistics_service_charge_VAT_category_code"/></span></div>
                        <div class="boxdaten rechnungSp2"></div>
                        <div class="boxdaten rechnungSp3"></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1"><xsl:value-of select="$i18n.btx272"/></div>
                        <div class="boxdaten rechnungSp2 color2">netto</div>
                        <div id="BT-X-272" title="BT-X-272" class="boxdaten rechnungSp3 bold"><xsl:value-of select="format-number(xr:Logistics_service_charge_amount,'###.##0,00','decimal')"/></div>
                    </div>
                    <div class="rechnungsZeile">
                        <div class="boxdaten rechnungSp1"><xsl:value-of select="$i18n.btx273"/></div>
                        <div class="boxdaten rechnungSp2 color2"></div>
                        <div id="BT-X-273" title="BT-X-273" class="boxdaten rechnungSp3"><xsl:value-of select="xr:Logistics_service_charge_VAT_rate"/></div>
                    </div>
                </div>
                <div class="grund">
                    <div><xsl:value-of select="$i18n.btx271"/>: <span id="BT-X-271" title="BT-X-271" class="bold"><xsl:value-of select="xr:Logistics_service_charge_description"/></span></div>
                </div>
            </div>
        </div>
        <div class="boxabstand"></div>
    </xsl:template>


    <xsl:template name="uebersichtZahlungsinformationen">
        <div id="uebersichtZahlungsinformationen" class="box subBox">
            <div title="" class="boxtitel"><xsl:value-of select="$i18n.payment"/></div>
            <div class="boxtabelle boxinhalt borderSpacing">
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt20"/>:</div>
                    <div id="BT-20" title="BT-20" class="boxdaten wert">
                        <xsl:for-each select="tokenize(xr:Payment_terms,';')">
                            <xsl:value-of select="."/>
                            <xsl:if test="position() != last()">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt9"/>:</div>
                    <div id="BT-9" title="BT-9" class="boxdaten wert">
                        <xsl:for-each select="tokenize(xr:Payment_due_date,';')">
                            <xsl:value-of select="format-date(xs:date(.),'[D].[M].[Y]')"/>
                            <xsl:if test="position() != last()">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt81"/>:</div>
                    <div id="BT-81" title="BT-81" class="boxdaten wert"><xsl:value-of select="xr:PAYMENT_INSTRUCTIONS/xr:Payment_means_type_code"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt82"/>:</div>
                    <div id="BT-82" title="BT-82" class="boxdaten wert"><xsl:value-of select="xr:PAYMENT_INSTRUCTIONS/xr:Payment_means_text"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt83"/>:</div>
                    <div id="BT-83" title="BT-83" class="boxdaten wert"><xsl:value-of select="xr:PAYMENT_INSTRUCTIONS/xr:Remittance_information"/></div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="uebersichtCard">
        <div id="uebersichtCard" class="box subBox">
            <div id="BG-18" title="BG-18" class="boxtitel boxtitelSub"><xsl:value-of select="$i18n.bg18"/></div>
            <div class="boxtabelle boxinhalt borderSpacing">
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt87"/>:</div>
                    <div id="BT-87" title="BT-87" class="boxdaten wert"><xsl:value-of select="xr:PAYMENT_INSTRUCTIONS/xr:PAYMENT_CARD_INFORMATION/xr:Payment_card_primary_account_number"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt88"/>:</div>
                    <div id="BT-88" title="BT-88" class="boxdaten wert"><xsl:value-of select="xr:PAYMENT_INSTRUCTIONS/xr:PAYMENT_CARD_INFORMATION/xr:Payment_card_holder_name"/></div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="uebersichtLastschrift">
        <div id="uebersichtLastschrift" class="box subBox">
            <div id="BG-19" title="BG-19" class="boxtitel boxtitelSub"><xsl:value-of select="$i18n.bg19"/></div>
            <div class="boxtabelle boxinhalt borderSpacing">
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt89"/>:</div>
                    <div id="BT-89" title="BT-89" class="boxdaten wert"><xsl:value-of select="xr:PAYMENT_INSTRUCTIONS/xr:DIRECT_DEBIT/xr:Mandate_reference_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt91"/>:</div>
                    <div id="BT-91" title="BT-91" class="boxdaten wert"><xsl:value-of select="xr:PAYMENT_INSTRUCTIONS/xr:DIRECT_DEBIT/xr:Debited_account_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt90"/>:</div>
                    <div id="BT-90" title="BT-90" class="boxdaten wert"><xsl:value-of select="xr:PAYMENT_INSTRUCTIONS/xr:DIRECT_DEBIT/xr:Bank_assigned_creditor_identifier"/></div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="uebersichtUeberweisung">
        <div id="uebersichtUeberweisung" class="box subBox">
            <div id="BG-17" title="BG-17" class="boxtitel boxtitelSub"><xsl:value-of select="$i18n.bg17"/></div>
            <xsl:for-each select="xr:PAYMENT_INSTRUCTIONS/xr:CREDIT_TRANSFER">
                <div class="boxtabelle boxinhalt borderSpacing">
                    <div class="boxzeile">
                        <div class="boxdaten legende"><xsl:value-of select="$i18n.bt85"/>:</div>
                        <div id="BT-85" title="BT-85" class="boxdaten wert"><xsl:value-of select="xr:Payment_account_name"/></div>
                    </div>
                    <div class="boxzeile">
                        <div class="boxdaten legende"><xsl:value-of select="$i18n.bt84"/>:</div>
                        <div id="BT-84" title="BT-84" class="boxdaten wert"><xsl:value-of select="xr:Payment_account_identifier"/></div>
                    </div>
                    <div class="boxzeile">
                        <div class="boxdaten legende"><xsl:value-of select="$i18n.bt86"/>:</div>
                        <div id="BT-86" title="BT-86" class="boxdaten wert"><xsl:value-of select="xr:Payment_service_provider_identifier"/></div>
                    </div>
                </div>
            </xsl:for-each>
        </div>
    </xsl:template>


    <xsl:template name="uebersichtBemerkungen" match="xr:INVOICE_NOTE">
        <div id="uebersichtBemerkungen" class="box">
            <div id="BG-1" title="BG-1" class="boxtitel"><xsl:value-of select="$i18n.bg1"/></div>
            <div class="boxtabelle boxinhalt borderSpacing">
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt21"/>:</div>
                    <div id="BT-21" title="BT-21" class="boxdaten wert"><xsl:value-of select="xr:Invoice_note_subject_code"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt22"/>:</div>
                    <div id="BT-22" title="BT-22" class="boxdaten wert"><xsl:value-of select="xr:Invoice_note"/></div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="details">
        <div id="details" class="divHide">
            <div class="haftungausschluss"><xsl:value-of select="$i18n.disclaimer"/></div>
            <xsl:apply-templates select="./xr:INVOICE_LINE"/> <!-- many -->
        </div>
    </xsl:template>


    <xsl:template match="xr:INVOICE_LINE | xr:SUB_INVOICE_LINE">
        <div class="boxtabelle boxabstandtop boxtabelleZweispaltig first">
            <div class="boxzeile">
                <div class="box subBox">
                    <div id="BT-126" title="BT-126" class="boxtitel"><xsl:value-of select="$i18n.bt126"/> <xsl:value-of select="xr:Invoice_line_identifier"/></div>
                    <div class="boxtabelle boxinhalt borderSpacing">
                        <div class="boxzeile">
                            <div class="boxdaten legende"><xsl:value-of select="$i18n.bt127"/>:</div>
                            <div id="BT-127" title="BT-127" class="boxdaten wert"><xsl:value-of select="xr:Invoice_line_note"/></div>
                        </div>
                        <div class="boxzeile">
                            <div class="boxdaten legende"><xsl:value-of select="$i18n.bt128"/>:</div>
                            <div id="BT-128" title="BT-128" class="boxdaten wert"><xsl:value-of select="xr:Invoice_line_object_identifier"/></div>
                        </div>
                        <div class="boxzeile">
                            <div class="boxdaten legende"><xsl:value-of select="$i18n.bt128-id"/>:</div>
                            <div id="BT-128-scheme-id" title="BT-128-scheme-id" class="boxdaten wert"><xsl:value-of select="xr:Invoice_line_object_identifier/@scheme_identifier"/></div>
                        </div>
                        <div class="boxzeile">
                            <div class="boxdaten legende"><xsl:value-of select="$i18n.bt132"/>:</div>
                            <div id="BT-132" title="BT-132" class="boxdaten wert"><xsl:value-of select="xr:Referenced_purchase_order_line_reference"/></div>
                        </div>
                        <div class="boxzeile">
                            <div class="boxdaten legende"><xsl:value-of select="$i18n.bt133"/>:</div>
                            <div id="BT-133" title="BT-133" class="boxdaten wert"><xsl:value-of select="xr:Invoice_line_Buyer_accounting_reference"/></div>
                        </div>
                        <h4 id="BG-26" title="BG-26"><xsl:value-of select="$i18n.bg26"/>:</h4>
                        <div class="boxzeile">
                            <div class="boxdaten legende"><xsl:value-of select="$i18n.bt134"/>:</div>
                            <div id="BT-134" title="BT-134" class="boxdaten wert"><xsl:value-of select="format-date(xr:INVOICE_LINE_PERIOD/xr:Invoice_line_period_start_date,'[D].[M].[Y]')"/></div>
                        </div>
                        <div class="boxzeile">
                            <div class="boxdaten legende"><xsl:value-of select="$i18n.bt135"/>:</div>
                            <div id="BT-135" title="BT-135" class="boxdaten wert"><xsl:value-of select="format-date(xr:INVOICE_LINE_PERIOD/xr:Invoice_line_period_end_date,'[D].[M].[Y]')"/></div>
                        </div>
                    </div>
                </div>
                <div class="box subBox">
                    <div id="BG-29" title="BG-29" class="boxtitel boxtitelSub"><xsl:value-of select="$i18n.bg29"/></div>
                    <div class="boxtabelle boxinhalt">
                        <div class="rechnungsZeile">
                            <div class="boxdaten detailSp1 color2"><xsl:value-of select="$i18n.bt129"/></div>
                            <div id="BT-129" title="BT-129" class="boxdaten detailSp2"><xsl:value-of select="xr:Invoiced_quantity"/></div>
                        </div>
                        <div class="rechnungsZeile">
                            <div class="boxdaten detailSp1 color2"><xsl:value-of select="$i18n.bt130"/></div>
                            <div id="BT-130" title="BT-130" class="boxdaten detailSp2"><xsl:value-of select="xr:Invoiced_quantity_unit_of_measure_code"/></div>
                        </div>
                        <div class="rechnungsZeile">
                            <div class="boxdaten detailSp1 line1Bottom color2"><xsl:value-of select="$i18n.bt146"/></div>
                            <div id="BT-146" title="BT-146" class="boxdaten detailSp2 line1Bottom"><xsl:value-of select="format-number(xr:PRICE_DETAILS/xr:Item_net_price,'###.##0,00','decimal')"/></div>
                        </div>
                        <div class="rechnungsZeile">
                            <div class="boxdaten detailSp1 color2"><xsl:value-of select="$i18n.bt131"/></div>
                            <div id="BT-131" title="BT-131" class="boxdaten detailSp2 bold"><xsl:value-of select="format-number(xr:Invoice_line_net_amount,'###.##0,00','decimal')"/></div>
                        </div>
                    </div>
                    <div class="boxtabelle boxinhalt noPaddingTop borderSpacing">
                        <div class="boxzeile">
                            <div class="boxdaten legende "><xsl:value-of select="$i18n.bt147"/>:</div>
                            <div id="BT-147" title="BT-147" class="boxdaten wert"><xsl:value-of select="format-number(xr:PRICE_DETAILS/xr:Item_price_discount,'###.##0,00','decimal')"/></div>
                        </div>
                        <div class="boxzeile">
                            <div class="boxdaten legende "><xsl:value-of select="$i18n.bt148"/>:</div>
                            <div id="BT-148" title="BT-148" class="boxdaten wert"><xsl:value-of select="format-number(xr:PRICE_DETAILS/xr:Item_gross_price,'###.##0,00','decimal')"/></div>
                        </div>
                        <div class="boxzeile">
                            <div class="boxdaten legende "><xsl:value-of select="$i18n.bt149"/>:</div>
                            <div id="BT-149" title="BT-149" class="boxdaten wert"><xsl:value-of select="xr:PRICE_DETAILS/xr:Item_price_base_quantity"/></div>
                        </div>
                        <div class="boxzeile">
                            <div class="boxdaten legende "><xsl:value-of select="$i18n.bt150"/>:</div>
                            <div id="BT-150" title="BT-150" class="boxdaten wert"><xsl:value-of select="xr:PRICE_DETAILS/xr:Item_price_base_quantity_unit_of_measure"/></div>
                        </div>
                        <div class="boxzeile">
                            <div class="boxdaten legende "><xsl:value-of select="$i18n.bt151"/>:</div>
                            <div id="BT-151" title="BT-151" class="boxdaten wert"><xsl:value-of select="xr:LINE_VAT_INFORMATION/xr:Invoiced_item_VAT_category_code"/></div>
                        </div>
                        <div class="boxzeile">
                            <div class="boxdaten legende "><xsl:value-of select="$i18n.bt152"/>:</div>
                            <div id="BT-152" title="BT-152" class="boxdaten wert"><xsl:value-of select="format-number(xr:LINE_VAT_INFORMATION/xr:Invoiced_item_VAT_rate,'##0,##','decimal')"/>%</div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <div class="boxtabelle">
            <div class="boxzeile">
                <div class="box subBox">
                    <div id="BG-27" title="BG-27" class="boxtitel boxtitelSub"><xsl:value-of select="$i18n.bg27"/></div>
                    <xsl:for-each select = "xr:INVOICE_LINE_ALLOWANCES">
                        <div class="boxtabelle boxinhalt ">
                            <div class="rechnungsZeile">
                                <div class="boxdaten detailSp1 color2"><xsl:value-of select="$i18n.bt137"/></div>
                                <div id="BT-137" title="BT-137" class="boxdaten detailSp2"><xsl:value-of select="format-number(xr:Invoice_line_allowance_base_amount,'###.##0,00','decimal')"/></div>
                            </div>
                            <div class="rechnungsZeile">
                                <div class="boxdaten detailSp1 line1Bottom color2"><xsl:value-of select="$i18n.bt138"/></div>
                                <div id="BT-138" title="BT-138" class="boxdaten detailSp2 line1Bottom"><xsl:value-of select="format-number(xr:Invoice_line_allowance_percentage,'##0,00','decimal')"/>%</div>
                            </div>
                            <div class="rechnungsZeile">
                                <div class="boxdaten detailSp1 color2"><xsl:value-of select="$i18n.bt136"/></div>
                                <div id="BT-136" title="BT-136" class="boxdaten detailSp2 bold"><xsl:value-of select="format-number(xr:Invoice_line_allowance_amount,'###.##0,00','decimal')"/></div>
                            </div>
                        </div>
                        <div class="grundDetail">
                            <div class="color2"><xsl:value-of select="$i18n.bt139"/>: <span id="BT-139" title="BT-139" class="bold"><xsl:value-of select="xr:Invoice_line_allowance_reason"/></span></div>
                            <div class="color2"><xsl:value-of select="$i18n.bt140"/>: <span id="BT-140" title="BT-140" class="bold"><xsl:value-of select="xr:Invoice_line_allowance_reason_code"/></span></div>
                        </div>
                    </xsl:for-each>
                </div>
                <div class="box subBox">
                    <div id="BG-28" title="BG-28" class="boxtitel boxtitelSub"><xsl:value-of select="$i18n.bg28"/></div>
                    <xsl:for-each select = "xr:INVOICE_LINE_CHARGES">
                        <div class="boxtabelle boxinhalt ">
                            <div class="rechnungsZeile">
                                <div class="boxdaten detailSp1 color2"><xsl:value-of select="$i18n.bt142"/></div>
                                <div id="BT-142" title="BT-142" class="boxdaten detailSp2"><xsl:value-of select="format-number(xr:Invoice_line_charge_base_amount,'###.##0,00','decimal')"/></div>
                            </div>
                            <div class="rechnungsZeile">
                                <div class="boxdaten detailSp1 line1Bottom color2"><xsl:value-of select="$i18n.bt143"/></div>
                                <div id="BT-143" title="BT-143" class="boxdaten detailSp2 line1Bottom"><xsl:value-of select="format-number(xr:Invoice_line_charge_percentage,'##0,00','decimal')"/>%</div>
                            </div>
                            <div class="rechnungsZeile">
                                <div class="boxdaten detailSp1 color2"><xsl:value-of select="$i18n.bt141"/></div>
                                <div id="BT-141" title="BT-141" class="boxdaten detailSp2 bold"><xsl:value-of select="format-number(xr:Invoice_line_charge_amount,'###.##0,00','decimal')"/></div>
                            </div>
                        </div>
                        <div class="grundDetail">
                            <div class="color2"><xsl:value-of select="$i18n.bt144"/>: <span id="BT-144" title="BT-144" class="bold"><xsl:value-of select="xr:Invoice_line_charge_reason"/></span></div>
                            <div class="color2"><xsl:value-of select="$i18n.bt145"/>: <span id="BT-145" title="BT-145" class="bold"><xsl:value-of select="xr:Invoice_line_charge_reason_code"/></span></div>
                        </div>
                    </xsl:for-each>
                </div>
            </div>
        </div>
        <div class="boxtabelle">
            <div class="boxzeile">
                <div class="box subBox">
                    <div id="BG-31" title="BG-31" class="boxtitel boxtitelSub"><xsl:value-of select="$i18n.bg31"/></div>
                    <div class="boxtabelle boxinhalt ">
                        <div class="boxzeile">
                            <div class="boxcell boxZweispaltig">
                                <div class="boxtabelle borderSpacing">
                                    <div class="boxzeile">
                                        <div class="boxdaten legende "><xsl:value-of select="$i18n.bt153"/>:</div>
                                        <div id="BT-153" title="BT-153" class="boxdaten wert bold"><xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_name"/></div>
                                    </div>
                                    <div class="boxzeile">
                                        <div class="boxdaten legende "><xsl:value-of select="$i18n.bt154"/>:</div>
                                        <div id="BT-154" title="BT-154" class="boxdaten wert"><xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_description"/></div>
                                    </div>
                                    <div class="boxzeile">
                                        <div class="boxdaten legende "><xsl:value-of select="$i18n.bt155"/>:</div>
                                        <div id="BT-155" title="BT-155" class="boxdaten wert"><xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_Sellers_identifier"/></div>
                                    </div>
                                    <div class="boxzeile">
                                        <div class="boxdaten legende "><xsl:value-of select="$i18n.bt156"/>:</div>
                                        <div id="BT-156" title="BT-156" class="boxdaten wert"><xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_Buyers_identifier"/></div>
                                    </div>
                                    <h4 id="BG-32" title="BG-32"><xsl:value-of select="$i18n.bg32"/>:</h4>
                                    <xsl:apply-templates select="xr:ITEM_INFORMATION/xr:ITEM_ATTRIBUTES" />
                                </div>
                            </div>
                            <div class="boxabstand"></div>
                            <div class="boxcell boxZweispaltig">
                                <div class="boxtabelle borderSpacing">
                                    <div class="boxzeile">
                                        <div class="boxdaten legende "><xsl:value-of select="$i18n.bt157"/>:</div>
                                        <div id="BT-157" title="BT-157" class="boxdaten wert"><xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_standard_identifier"/></div>
                                    </div>
                                    <div class="boxzeile">
                                        <div class="boxdaten legende "><xsl:value-of select="$i18n.bt157-id"/>:</div>
                                        <div id="BT-157-scheme-id" title="BT-157-scheme-id" class="boxdaten wert"><xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_standard_identifier/@scheme_identifier"/></div>
                                    </div>
                                    <div class="boxzeile">
                                        <div class="boxdaten legende "><xsl:value-of select="$i18n.bt158"/>:</div>
                                        <div id="BT-158" title="BT-158" class="boxdaten wert"><xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_classification_identifier"/></div>
                                    </div>
                                    <div class="boxzeile">
                                        <div class="boxdaten legende "><xsl:value-of select="$i18n.bt158-id"/>:</div>
                                        <div id="BT-158-scheme-id" title="BT-158-scheme-id" class="boxdaten wert"><xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_classification_identifier/@scheme_identifier"/></div>
                                    </div>
                                    <div class="boxzeile">
                                        <div class="boxdaten legende "><xsl:value-of select="$i18n.bt157-vers-id"/>:</div>
                                        <div id="BT-158-scheme-version-id" title="BT-158-scheme-version-id" class="boxdaten wert"><xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_classification_identifier/@scheme_version_identifier"/></div>
                                    </div>
                                    <div class="boxzeile">
                                        <div class="boxdaten legende "><xsl:value-of select="$i18n.bt159"/>:</div>
                                        <div id="BT-159" title="BT-159" class="boxdaten wert"><xsl:value-of select="xr:ITEM_INFORMATION/xr:Item_country_of_origin"/></div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <xsl:apply-templates select="xr:SUB_INVOICE_LINE"/>
    </xsl:template>

    <xsl:template name="eigenschaft" match="xr:ITEM_ATTRIBUTES">
        <div class="boxzeile">
            <div id="BT-160" title="BT-160" class="boxdaten legende "><xsl:value-of select="xr:Item_attribute_name"/></div>
            <div id="BT-161" title="BT-161" class="boxdaten wert"><xsl:value-of select="xr:Item_attribute_value"/></div>
        </div>
    </xsl:template>

    <xsl:template name="sub_invoice_eigenschaft" match="xr:SUB_INVOICE_ITEM_ATTRIBUTES">
        <div class="boxzeile">
            <div id="BT-160" title="BT-160" class="boxdaten legende "><xsl:value-of select="xr:Item_attribute_name"/></div>
            <div id="BT-161" title="BT-161" class="boxdaten wert"><xsl:value-of select="xr:Item_attribute_value"/></div>
        </div>
    </xsl:template>


    <xsl:template name="zusaetze">
        <div id="zusaetze" class="divHide">
            <div class="haftungausschluss"><xsl:value-of select="$i18n.disclaimer"/></div>
            <div class="boxtabelle boxtabelleZweispaltig">
                <div class="boxzeile">
                    <xsl:apply-templates select="./xr:SELLER" mode="zusaetze"/>
                    <div class="boxabstand"></div>
                    <xsl:apply-templates select="./xr:SELLER_TAX_REPRESENTATIVE_PARTY"/>
                </div>
            </div>
            <div class="boxtabelle boxabstandtop boxtabelleZweispaltig">
                <div class="boxzeile">
                    <xsl:apply-templates select="./xr:BUYER" mode="zusaetze"/>
                    <div class="boxabstand"></div>
                    <xsl:apply-templates select="./xr:DELIVERY_INFORMATION"/>
                </div>
            </div>
            <div class="boxtabelle boxabstandtop boxtabelleZweispaltig">
                <div class="boxzeile">
                    <xsl:call-template name="zusaetzeVertrag"/>
                    <div class="boxabstand"></div>
                    <xsl:apply-templates select="./xr:PAYEE"/>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="zusaetzeVerkaeufer" match="xr:SELLER" mode="zusaetze">
        <div id="zusaetzeVerkaeufer" class="box boxZweispaltig">
            <div id="BG-4" title="BG-4" class="boxtitel"><xsl:value-of select="$i18n.bg4"/></div>
            <div class="boxtabelle boxinhalt borderSpacing">
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt28"/>:</div>
                    <div id="BT-28" title="BT-28" class="boxdaten wert"><xsl:value-of select="xr:Seller_trading_name"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt39"/>:</div>
                    <div id="BT-39" title="BT-39" class="boxdaten wert"><xsl:value-of select="xr:SELLER_POSTAL_ADDRESS/xr:Seller_country_subdivision"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt34"/>:</div>
                    <div id="BT-34" title="BT-34" class="boxdaten wert"><xsl:value-of select="xr:Seller_electronic_address"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt34-id"/>:</div>
                    <div id="BT-34-scheme-id" title="BT-34-scheme-id" class="boxdaten wert"><xsl:value-of select="xr:Seller_electronic_address/@scheme_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt30"/>:</div>
                    <div id="BT-30" title="BT-30" class="boxdaten wert"><xsl:value-of select="xr:Seller_legal_registration_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt31"/>:</div>
                    <div id="BT-31" title="BT-31" class="boxdaten wert"><xsl:value-of select="xr:Seller_VAT_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt32"/>:</div>
                    <div id="BT-32" title="BT-32" class="boxdaten wert"><xsl:value-of select="xr:Seller_tax_registration_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt32-schema"/>:</div>
                    <div id="BT-32-scheme" title="BT-32-scheme" class="boxdaten wert"><xsl:value-of select="xr:Seller_tax_registration_identifier/@scheme_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt33"/>:</div>
                    <div id="BT-33" title="BT-33" class="boxdaten wert"><xsl:value-of select="xr:Seller_additional_legal_information"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt6"/>:</div>
                    <div id="BT-6" title="BT-6" class="boxdaten wert"><xsl:value-of select="../xr:VAT_accounting_currency_code"/></div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="zusaetzeSteuervertreter" match="xr:SELLER_TAX_REPRESENTATIVE_PARTY">
        <div id="zusaetzeSteuervertreter" class="box boxZweispaltig">
            <div id="BG-11" title="BG-11" class="boxtitel"><xsl:value-of select="$i18n.bg11"/></div>
            <div class="boxtabelle boxinhalt borderSpacing">
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt62"/>:</div>
                    <div id="BT-62" title="BT-62" class="boxdaten wert"><xsl:value-of select="xr:Seller_tax_representative_name"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt64"/>:</div>
                    <div id="BT-64" title="BT-64" class="boxdaten wert"><xsl:value-of select="xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_address_line_1"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt65"/>:</div>
                    <div id="BT-65" title="BT-65" class="boxdaten wert"><xsl:value-of select="xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_address_line_2"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt164"/>:</div>
                    <div id="BT-164" title="BT-164" class="boxdaten wert"><xsl:value-of select="xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_address_line_3"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt67"/>:</div>
                    <div id="BT-67" title="BT-67" class="boxdaten wert"><xsl:value-of select="xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_post_code"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt66"/>:</div>
                    <div id="BT-66" title="BT-66" class="boxdaten wert"><xsl:value-of select="xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_city"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt68"/>:</div>
                    <div id="BT-68" title="BT-68" class="boxdaten wert"><xsl:value-of select="xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_country_subdivision"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt69"/>:</div>
                    <div id="BT-69" title="BT-69" class="boxdaten wert"><xsl:value-of select="xr:SELLER_TAX_REPRESENTATIVE_POSTAL_ADDRESS/xr:Tax_representative_country_code"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt63"/>:</div>
                    <div id="BT-63" title="BT-63" class="boxdaten wert"><xsl:value-of select="xr:Seller_tax_representative_VAT_identifier"/></div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="zusaetzeKaeufer" match="xr:BUYER" mode="zusaetze">
        <div id="zusaetzeKaeufer" class="box boxZweispaltig">
            <div id="BG-7" title="BG-7" class="boxtitel"><xsl:value-of select="$i18n.bg7"/></div>
            <div class="boxtabelle boxinhalt borderSpacing">
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt45"/>:</div>
                    <div id="BT-45" title="BT-45" class="boxdaten wert"><xsl:value-of select="xr:Buyer_trading_name"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt54"/>:</div>
                    <div id="BT-54" title="BT-54" class="boxdaten wert"><xsl:value-of select="xr:BUYER_POSTAL_ADDRESS/xr:Buyer_country_subdivision"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt49"/>:</div>
                    <div id="BT-49" title="BT-49" class="boxdaten wert"><xsl:value-of select="xr:Buyer_electronic_address"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt49-id"/>:</div>
                    <div id="BT-49-scheme-id" title="BT-49-scheme-id" class="boxdaten wert"><xsl:value-of select="xr:Buyer_electronic_address/@scheme_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt47"/>:</div>
                    <div id="BT-47" title="BT-47" class="boxdaten wert"><xsl:value-of select="xr:Buyer_legal_registration_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt47-id"/>:</div>
                    <div id="BT-47-scheme-id" title="BT-47-scheme-id" class="boxdaten wert"><xsl:value-of select="xr:Buyer_legal_registration_identifier/@scheme_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt48"/>:</div>
                    <div id="BT-48" title="BT-48" class="boxdaten wert"><xsl:value-of select="xr:Buyer_VAT_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt7"/>:</div>
                    <div id="BT-7" title="BT-7" class="boxdaten wert">
                        <xsl:for-each select="tokenize(../xr:Value_added_tax_point_date,';')">
                            <xsl:value-of select="format-date(xs:date(.),'[D].[M].[Y]')"/>
                            <xsl:if test="position() != last()">
                                <br/>
                            </xsl:if>
                        </xsl:for-each>
                    </div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt8"/>:</div>
                    <div id="BT-8" title="BT-8" class="boxdaten wert"><xsl:value-of select="../xr:Value_added_tax_point_date_code"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt19"/>:</div>
                    <div id="BT-19" title="BT-19" class="boxdaten wert"><xsl:value-of select="../xr:Buyer_accounting_reference"/></div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="zusaetzeLieferung" match="xr:DELIVERY_INFORMATION">
        <div id="zusaetzeLieferung" class="box boxZweispaltig">
            <div id="BG-13" title="BG-13" class="boxtitel"><xsl:value-of select="$i18n.bg13"/></div>
            <div class="boxtabelle boxinhalt borderSpacing">
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt71"/>:</div>
                    <div id="BT-71" title="BT-71" class="boxdaten wert"><xsl:value-of select="xr:Deliver_to_location_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt71-id"/>:</div>
                    <div id="BT-71-scheme-id" title="BT-71-scheme-id" class="boxdaten wert"><xsl:value-of select="xr:Deliver_to_location_identifier/@scheme_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt72"/>:</div>
                    <div id="BT-72" title="BT-72" class="boxdaten wert"><xsl:value-of select="format-date(xr:Actual_delivery_date,'[D].[M].[Y]')"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt70"/>:</div>
                    <div id="BT-70" title="BT-70" class="boxdaten wert"><xsl:value-of select="xr:Deliver_to_party_name"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt75"/>:</div>
                    <div id="BT-75" title="BT-75" class="boxdaten wert"><xsl:value-of select="xr:DELIVER_TO_ADDRESS/xr:Deliver_to_address_line_1"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt76"/>:</div>
                    <div id="BT-76" title="BT-76" class="boxdaten wert"><xsl:value-of select="xr:DELIVER_TO_ADDRESS/xr:Deliver_to_address_line_2"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt165"/>:</div>
                    <div title="BT-165" class="boxdaten wert"><xsl:value-of select="xr:DELIVER_TO_ADDRESS/xr:Deliver_to_address_line_3"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt78"/>:</div>
                    <div id="BT-78" title="BT-78" class="boxdaten wert"><xsl:value-of select="xr:DELIVER_TO_ADDRESS/xr:Deliver_to_post_code"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt77"/>:</div>
                    <div id="BT-77" title="BT-77" class="boxdaten wert"><xsl:value-of select="xr:DELIVER_TO_ADDRESS/xr:Deliver_to_city"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt79"/>:</div>
                    <div id="BT-79" title="BT-79" class="boxdaten wert"><xsl:value-of select="xr:DELIVER_TO_ADDRESS/xr:Deliver_to_country_subdivision"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt80"/>:</div>
                    <div id="BT-80" title="BT-80" class="boxdaten wert"><xsl:value-of select="xr:DELIVER_TO_ADDRESS/xr:Deliver_to_country_code"/></div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="zusaetzeVertrag">
        <div id="zusaetzeVertrag" class="box boxZweispaltig">
            <div class="boxtitel"><xsl:value-of select="$i18n.contract_information"/></div>
            <div class="boxtabelle boxinhalt borderSpacing">
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt17"/>:</div>
                    <div id="BT-17" title="BT-17" class="boxdaten wert"><xsl:value-of select="xr:Tender_or_lot_reference"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt15"/>:</div>
                    <div id="BT-15" title="BT-15" class="boxdaten wert"><xsl:value-of select="xr:Receiving_advice_reference"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt16"/>:</div>
                    <div id="BT-16" title="BT-16" class="boxdaten wert"><xsl:value-of select="xr:Despatch_advice_reference"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt23"/>:</div>
                    <div id="BT-23" title="BT-23" class="boxdaten wert"><xsl:value-of select="xr:PROCESS_CONTROL/xr:Business_process_type"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt24"/>:</div>
                    <div id="BT-24" title="BT-24" class="boxdaten wert"><xsl:value-of select="xr:PROCESS_CONTROL/xr:Specification_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt18"/>:</div>
                    <div id="BT-18" title="BT-18" class="boxdaten wert"><xsl:value-of select="xr:Invoiced_object_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt18-id"/>:</div>
                    <div id="BT-18-scheme-id" title="BT-18-scheme-id" class="boxdaten wert"><xsl:value-of select="xr:Invoiced_object_identifier/@scheme_identifier"/></div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="zusaetzeZahlungsempfaenger" match="xr:PAYEE">
        <div id="zusaetzeZahlungsempfaenger" class="box boxZweispaltig">
            <div id="BG-10" title="BG-10" class="boxtitel"><xsl:value-of select="$i18n.bg10"/></div>
            <div class="boxtabelle boxinhalt borderSpacing">
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt59"/>:</div>
                    <div id="BT-59" title="BT-59" class="boxdaten wert"><xsl:value-of select="xr:Payee_name"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt60"/>:</div>
                    <div id="BT-60" title="BT-60" class="boxdaten wert"><xsl:value-of select="xr:Payee_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt60-id"/>:</div>
                    <div id="BT-60-scheme-id" title="BT-60-scheme-id" class="boxdaten wert"><xsl:value-of select="xr:Payee_identifier/@scheme_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt61"/>:</div>
                    <div id="BT-61" title="BT-61" class="boxdaten wert"><xsl:value-of select="xr:Payee_legal_registration_identifier"/></div>
                </div>
                <div class="boxzeile">
                    <div class="boxdaten legende"><xsl:value-of select="$i18n.bt61-id"/>:</div>
                    <div id="BT-61-scheme-id" title="BT-61-scheme-id" class="boxdaten wert"><xsl:value-of select="xr:Payee_legal_registration_identifier/@scheme_identifier"/></div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="anlagen">
        <div id="anlagen" class="divHide">
            <div class="haftungausschluss"><xsl:value-of select="$i18n.disclaimer"/></div>
            <div class="boxtabelle boxabstandtop">
                <div class="boxzeile">
                    <div id="anlagenListe" class="box">
                        <div id="BG-24" title="BG-24" class="boxtitel"><xsl:value-of select="$i18n.bg24"/></div>
                        <xsl:apply-templates select="./xr:ADDITIONAL_SUPPORTING_DOCUMENTS"/>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template match="xr:ADDITIONAL_SUPPORTING_DOCUMENTS">
        <div class="boxtabelle boxinhalt borderSpacing">
            <div class="boxzeile">
                <div class="boxdaten legende"><xsl:value-of select="$i18n.bt122"/>:</div>
                <div id="BT-122" title="BT-122" class="boxdaten wert"><xsl:value-of select="xr:Supporting_document_reference"/></div>
            </div>
            <div class="boxzeile">
                <div class="boxdaten legende"><xsl:value-of select="$i18n.bt123"/>:</div>
                <div id="BT-123" title="BT-123" class="boxdaten wert"><xsl:value-of select="xr:Supporting_document_description"/></div>
            </div>
            <div class="boxzeile">
                <div class="boxdaten legende"><xsl:value-of select="$i18n.bt124"/>:</div>
                <div id="BT-124" title="BT-124" class="boxdaten wert"><a href="{xr:External_document_location}"><xsl:value-of select="xr:External_document_location"/></a></div>
            </div>
            <div class="boxzeile">
                <div class="boxdaten legende"><xsl:value-of select="$i18n.bt125"/>:</div>
                <div id="BT-125" title="BT-125" class="boxdaten wert">
                    <a href="#"
                       onClick="downloadData('{xr:Supporting_document_reference}')">Öffnen</a>
                </div>
                <div id="{xr:Supporting_document_reference}"
                     mimetype="{xr:Attached_document/@mime_code}"
                     filename="{xr:Attached_document/@filename}"
                     style="display:none;"
                ><xsl:value-of select="xr:Attached_document"/></div>

            </div>
            <div class="boxzeile">
                <div class="boxdaten legende"><xsl:value-of select="$i18n.bt125-format"/>:</div>
                <div id="BT-125" title="BT-125" class="boxdaten wert"><xsl:value-of select="xr:Attached_document/@mime_code"/></div>
            </div>
            <div class="boxzeile">
                <div class="boxdaten legende"><xsl:value-of select="$i18n.bt125-name"/>:</div>
                <div id="BT-125" title="BT-125" class="boxdaten wert"><xsl:value-of select="xr:Attached_document/@filename"/></div>
            </div>
        </div>
    </xsl:template>


    <xsl:template name="laufzettel">
        <div id="laufzettel" class="divHide">
            <div class="boxtabelle boxabstandtop">
                <div class="boxzeile">
                    <div id="laufzettelHistorie" class="box">
                        <div class="boxtitel"><xsl:value-of select="$i18n.history"/></div>
                        <xsl:apply-templates select="./xrv:laufzettel/xrv:laufzettelEintrag"/>
                    </div>
                </div>
            </div>
        </div>
    </xsl:template>


    <xsl:template match="xrv:laufzettelEintrag">
        <div class="boxtabelle boxinhalt borderSpacing">
            <div class="boxzeile">
                <div class="boxdaten legende"><xsl:value-of select="$i18n.historyDate"/></div>
                <div class="boxdaten wert"><xsl:value-of select="format-dateTime(xrv:zeitstempel,'[D].[M].[Y] [H]:[m]:[s]')"/></div>
            </div>
            <div class="boxzeile">
                <div class="boxdaten legende"><xsl:value-of select="$i18n.historySubject"/>:</div>
                <div class="boxdaten wert"><xsl:value-of select="xrv:betreff"/></div>
            </div>
            <div class="boxzeile">
                <div class="boxdaten legende"><xsl:value-of select="$i18n.historyText"/>:</div>
                <div class="boxdaten wert"><xsl:value-of select="xrv:text"/></div>
            </div>
            <div class="boxzeile">
                <div class="boxdaten legende"><xsl:value-of select="$i18n.historyDetails"/>:</div>
                <div class="boxdaten wert"><xsl:value-of select="xrv:details"/></div>
            </div>
        </div>
    </xsl:template>

</xsl:stylesheet>
