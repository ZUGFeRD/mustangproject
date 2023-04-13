<?xml version="1.0"?>
<xsl:stylesheet version="2.0"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

    <xsl:import href="UNECE-RE-20.xsl" /> 

	<xsl:template name="code.rec21">
		<xsl:param name="myparam"/>
		<xsl:variable name="myparam.upper" select="upper-case($myparam)"/>
		<xsl:choose>
      		<xsl:when test="$myparam.upper='X1A'"><xsl:value-of select="$myparam"/> (Drum, steel)</xsl:when>
      		<xsl:when test="$myparam.upper='X1B'"><xsl:value-of select="$myparam"/> (Drum, aluminium)</xsl:when>
      		<xsl:when test="$myparam.upper='X1D'"><xsl:value-of select="$myparam"/> (Drum, plywood)</xsl:when>
      		<xsl:when test="$myparam.upper='X1F'"><xsl:value-of select="$myparam"/> (Container, flexible)</xsl:when>
      		<xsl:when test="$myparam.upper='X1G'"><xsl:value-of select="$myparam"/> (Drum, fibre)</xsl:when>
      		<xsl:when test="$myparam.upper='X1W'"><xsl:value-of select="$myparam"/> (Drum, wooden)</xsl:when>
      		<xsl:when test="$myparam.upper='X2C'"><xsl:value-of select="$myparam"/> (Barrel, wooden)</xsl:when>
      		<xsl:when test="$myparam.upper='X3A'"><xsl:value-of select="$myparam"/> (Jerrican, steel)</xsl:when>
      		<xsl:when test="$myparam.upper='X3H'"><xsl:value-of select="$myparam"/> (Jerrican, plastic)</xsl:when>
      		<xsl:when test="$myparam.upper='X43'"><xsl:value-of select="$myparam"/> (Bag, super bulk)</xsl:when>
      		<xsl:when test="$myparam.upper='X44'"><xsl:value-of select="$myparam"/> (Bag, polybag)</xsl:when>
      		<xsl:when test="$myparam.upper='X4A'"><xsl:value-of select="$myparam"/> (Box, steel)</xsl:when>
      		<xsl:when test="$myparam.upper='X4B'"><xsl:value-of select="$myparam"/> (Box, aluminium)</xsl:when>
      		<xsl:when test="$myparam.upper='X4C'"><xsl:value-of select="$myparam"/> (Box, natural wood)</xsl:when>
      		<xsl:when test="$myparam.upper='X4D'"><xsl:value-of select="$myparam"/> (Box, plywood)</xsl:when>
      		<xsl:when test="$myparam.upper='X4F'"><xsl:value-of select="$myparam"/> (Box, reconstituted wood)</xsl:when>
      		<xsl:when test="$myparam.upper='X4G'"><xsl:value-of select="$myparam"/> (Box, fibreboard)</xsl:when>
      		<xsl:when test="$myparam.upper='X4H'"><xsl:value-of select="$myparam"/> (Box, plastic)</xsl:when>
      		<xsl:when test="$myparam.upper='X5H'"><xsl:value-of select="$myparam"/> (Bag, woven plastic)</xsl:when>
      		<xsl:when test="$myparam.upper='X5L'"><xsl:value-of select="$myparam"/> (Bag, textile)</xsl:when>
      		<xsl:when test="$myparam.upper='X5M'"><xsl:value-of select="$myparam"/> (Bag, paper)</xsl:when>
      		<xsl:when test="$myparam.upper='X6H'"><xsl:value-of select="$myparam"/> (Composite packaging, plastic receptacle)</xsl:when>
      		<xsl:when test="$myparam.upper='X6P'"><xsl:value-of select="$myparam"/> (Composite packaging, glass receptacle)</xsl:when>
      		<xsl:when test="$myparam.upper='X7A'"><xsl:value-of select="$myparam"/> (Case, car)</xsl:when>
      		<xsl:when test="$myparam.upper='X7B'"><xsl:value-of select="$myparam"/> (Case, wooden)</xsl:when>
      		<xsl:when test="$myparam.upper='X8A'"><xsl:value-of select="$myparam"/> (Pallet, wooden)</xsl:when>
      		<xsl:when test="$myparam.upper='X8B'"><xsl:value-of select="$myparam"/> (Crate, wooden)</xsl:when>
      		<xsl:when test="$myparam.upper='X8C'"><xsl:value-of select="$myparam"/> (Bundle, wooden)</xsl:when>
      		<xsl:when test="$myparam.upper='XAA'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, rigid plastic)</xsl:when>
      		<xsl:when test="$myparam.upper='XAB'"><xsl:value-of select="$myparam"/> (Receptacle, fibre)</xsl:when>
      		<xsl:when test="$myparam.upper='XAC'"><xsl:value-of select="$myparam"/> (Receptacle, paper)</xsl:when>
      		<xsl:when test="$myparam.upper='XAD'"><xsl:value-of select="$myparam"/> (Receptacle, wooden)</xsl:when>
      		<xsl:when test="$myparam.upper='XAE'"><xsl:value-of select="$myparam"/> (Aerosol)</xsl:when>
      		<xsl:when test="$myparam.upper='XAF'"><xsl:value-of select="$myparam"/> (Pallet, modular, collars 80cms * 60cms)</xsl:when>
      		<xsl:when test="$myparam.upper='XAG'"><xsl:value-of select="$myparam"/> (Pallet, shrinkwrapped)</xsl:when>
      		<xsl:when test="$myparam.upper='XAH'"><xsl:value-of select="$myparam"/> (Pallet, 100cms * 110cms)</xsl:when>
      		<xsl:when test="$myparam.upper='XAI'"><xsl:value-of select="$myparam"/> (Clamshell)</xsl:when>
      		<xsl:when test="$myparam.upper='XAJ'"><xsl:value-of select="$myparam"/> (Cone)</xsl:when>
      		<xsl:when test="$myparam.upper='XAL'"><xsl:value-of select="$myparam"/> (Ball)</xsl:when>
      		<xsl:when test="$myparam.upper='XAM'"><xsl:value-of select="$myparam"/> (Ampoule, non-protected)</xsl:when>
      		<xsl:when test="$myparam.upper='XAP'"><xsl:value-of select="$myparam"/> (Ampoule, protected)</xsl:when>
      		<xsl:when test="$myparam.upper='XAT'"><xsl:value-of select="$myparam"/> (Atomizer)</xsl:when>
      		<xsl:when test="$myparam.upper='XAV'"><xsl:value-of select="$myparam"/> (Capsule)</xsl:when>
      		<xsl:when test="$myparam.upper='XB4'"><xsl:value-of select="$myparam"/> (Belt)</xsl:when>
      		<xsl:when test="$myparam.upper='XBA'"><xsl:value-of select="$myparam"/> (Barrel)</xsl:when>
      		<xsl:when test="$myparam.upper='XBB'"><xsl:value-of select="$myparam"/> (Bobbin)</xsl:when>
      		<xsl:when test="$myparam.upper='XBC'"><xsl:value-of select="$myparam"/> (Bottlecrate / bottlerack)</xsl:when>
      		<xsl:when test="$myparam.upper='XBD'"><xsl:value-of select="$myparam"/> (Board)</xsl:when>
      		<xsl:when test="$myparam.upper='XBE'"><xsl:value-of select="$myparam"/> (Bundle)</xsl:when>
      		<xsl:when test="$myparam.upper='XBF'"><xsl:value-of select="$myparam"/> (Balloon, non-protected)</xsl:when>
      		<xsl:when test="$myparam.upper='XBG'"><xsl:value-of select="$myparam"/> (Bag)</xsl:when>
      		<xsl:when test="$myparam.upper='XBH'"><xsl:value-of select="$myparam"/> (Bunch)</xsl:when>
      		<xsl:when test="$myparam.upper='XBI'"><xsl:value-of select="$myparam"/> (Bin)</xsl:when>
      		<xsl:when test="$myparam.upper='XBJ'"><xsl:value-of select="$myparam"/> (Bucket)</xsl:when>
      		<xsl:when test="$myparam.upper='XBK'"><xsl:value-of select="$myparam"/> (Basket)</xsl:when>
      		<xsl:when test="$myparam.upper='XBL'"><xsl:value-of select="$myparam"/> (Bale, compressed)</xsl:when>
      		<xsl:when test="$myparam.upper='XBM'"><xsl:value-of select="$myparam"/> (Basin)</xsl:when>
      		<xsl:when test="$myparam.upper='XBN'"><xsl:value-of select="$myparam"/> (Bale, non-compressed)</xsl:when>
      		<xsl:when test="$myparam.upper='XBO'"><xsl:value-of select="$myparam"/> (Bottle, non-protected, cylindrical)</xsl:when>
      		<xsl:when test="$myparam.upper='XBP'"><xsl:value-of select="$myparam"/> (Balloon, protected)</xsl:when>
      		<xsl:when test="$myparam.upper='XBQ'"><xsl:value-of select="$myparam"/> (Bottle, protected cylindrical)</xsl:when>
      		<xsl:when test="$myparam.upper='XBR'"><xsl:value-of select="$myparam"/> (Bar)</xsl:when>
      		<xsl:when test="$myparam.upper='XBS'"><xsl:value-of select="$myparam"/> (Bottle, non-protected, bulbous)</xsl:when>
      		<xsl:when test="$myparam.upper='XBT'"><xsl:value-of select="$myparam"/> (Bolt)</xsl:when>
      		<xsl:when test="$myparam.upper='XBU'"><xsl:value-of select="$myparam"/> (Butt)</xsl:when>
      		<xsl:when test="$myparam.upper='XBV'"><xsl:value-of select="$myparam"/> (Bottle, protected bulbous)</xsl:when>
      		<xsl:when test="$myparam.upper='XBW'"><xsl:value-of select="$myparam"/> (Box, for liquids)</xsl:when>
      		<xsl:when test="$myparam.upper='XBX'"><xsl:value-of select="$myparam"/> (Box)</xsl:when>
      		<xsl:when test="$myparam.upper='XBY'"><xsl:value-of select="$myparam"/> (Board, in bundle/bunch/truss)</xsl:when>
      		<xsl:when test="$myparam.upper='XBZ'"><xsl:value-of select="$myparam"/> (Bars, in bundle/bunch/truss)</xsl:when>
      		<xsl:when test="$myparam.upper='XCA'"><xsl:value-of select="$myparam"/> (Can, rectangular)</xsl:when>
      		<xsl:when test="$myparam.upper='XCB'"><xsl:value-of select="$myparam"/> (Crate, beer)</xsl:when>
      		<xsl:when test="$myparam.upper='XCC'"><xsl:value-of select="$myparam"/> (Churn)</xsl:when>
      		<xsl:when test="$myparam.upper='XCD'"><xsl:value-of select="$myparam"/> (Can, with handle and spout)</xsl:when>
      		<xsl:when test="$myparam.upper='XCE'"><xsl:value-of select="$myparam"/> (Creel)</xsl:when>
      		<xsl:when test="$myparam.upper='XCF'"><xsl:value-of select="$myparam"/> (Coffer)</xsl:when>
      		<xsl:when test="$myparam.upper='XCG'"><xsl:value-of select="$myparam"/> (Cage)</xsl:when>
      		<xsl:when test="$myparam.upper='XCH'"><xsl:value-of select="$myparam"/> (Chest)</xsl:when>
      		<xsl:when test="$myparam.upper='XCI'"><xsl:value-of select="$myparam"/> (Canister)</xsl:when>
      		<xsl:when test="$myparam.upper='XCJ'"><xsl:value-of select="$myparam"/> (Coffin)</xsl:when>
      		<xsl:when test="$myparam.upper='XCK'"><xsl:value-of select="$myparam"/> (Cask)</xsl:when>
      		<xsl:when test="$myparam.upper='XCL'"><xsl:value-of select="$myparam"/> (Coil)</xsl:when>
      		<xsl:when test="$myparam.upper='XCM'"><xsl:value-of select="$myparam"/> (Card)</xsl:when>
      		<xsl:when test="$myparam.upper='XCN'"><xsl:value-of select="$myparam"/> (Container, not otherwise specified as transport equipment)</xsl:when>
      		<xsl:when test="$myparam.upper='XCO'"><xsl:value-of select="$myparam"/> (Carboy, non-protected)</xsl:when>
      		<xsl:when test="$myparam.upper='XCP'"><xsl:value-of select="$myparam"/> (Carboy, protected)</xsl:when>
      		<xsl:when test="$myparam.upper='XCQ'"><xsl:value-of select="$myparam"/> (Cartridge)</xsl:when>
      		<xsl:when test="$myparam.upper='XCR'"><xsl:value-of select="$myparam"/> (Crate)</xsl:when>
      		<xsl:when test="$myparam.upper='XCS'"><xsl:value-of select="$myparam"/> (Case)</xsl:when>
      		<xsl:when test="$myparam.upper='XCT'"><xsl:value-of select="$myparam"/> (Carton)</xsl:when>
      		<xsl:when test="$myparam.upper='XCU'"><xsl:value-of select="$myparam"/> (Cup)</xsl:when>
      		<xsl:when test="$myparam.upper='XCV'"><xsl:value-of select="$myparam"/> (Cover)</xsl:when>
      		<xsl:when test="$myparam.upper='XCW'"><xsl:value-of select="$myparam"/> (Cage, roll)</xsl:when>
      		<xsl:when test="$myparam.upper='XCX'"><xsl:value-of select="$myparam"/> (Can, cylindrical)</xsl:when>
      		<xsl:when test="$myparam.upper='XCY'"><xsl:value-of select="$myparam"/> (Cylinder)</xsl:when>
      		<xsl:when test="$myparam.upper='XCZ'"><xsl:value-of select="$myparam"/> (Canvas)</xsl:when>
      		<xsl:when test="$myparam.upper='XDA'"><xsl:value-of select="$myparam"/> (Crate, multiple layer, plastic)</xsl:when>
      		<xsl:when test="$myparam.upper='XDB'"><xsl:value-of select="$myparam"/> (Crate, multiple layer, wooden)</xsl:when>
      		<xsl:when test="$myparam.upper='XDC'"><xsl:value-of select="$myparam"/> (Crate, multiple layer, cardboard)</xsl:when>
      		<xsl:when test="$myparam.upper='XDG'"><xsl:value-of select="$myparam"/> (Cage, Commonwealth Handling Equipment Pool (CHEP))</xsl:when>
      		<xsl:when test="$myparam.upper='XDH'"><xsl:value-of select="$myparam"/> (Box, Commonwealth Handling Equipment Pool (CHEP), Eurobox)</xsl:when>
      		<xsl:when test="$myparam.upper='XDI'"><xsl:value-of select="$myparam"/> (Drum, iron)</xsl:when>
      		<xsl:when test="$myparam.upper='XDJ'"><xsl:value-of select="$myparam"/> (Demijohn, non-protected)</xsl:when>
      		<xsl:when test="$myparam.upper='XDK'"><xsl:value-of select="$myparam"/> (Crate, bulk, cardboard)</xsl:when>
      		<xsl:when test="$myparam.upper='XDL'"><xsl:value-of select="$myparam"/> (Crate, bulk, plastic)</xsl:when>
      		<xsl:when test="$myparam.upper='XDM'"><xsl:value-of select="$myparam"/> (Crate, bulk, wooden)</xsl:when>
      		<xsl:when test="$myparam.upper='XDN'"><xsl:value-of select="$myparam"/> (Dispenser)</xsl:when>
      		<xsl:when test="$myparam.upper='XDP'"><xsl:value-of select="$myparam"/> (Demijohn, protected)</xsl:when>
      		<xsl:when test="$myparam.upper='XDR'"><xsl:value-of select="$myparam"/> (Drum)</xsl:when>
      		<xsl:when test="$myparam.upper='XDS'"><xsl:value-of select="$myparam"/> (Tray, one layer no cover, plastic)</xsl:when>
      		<xsl:when test="$myparam.upper='XDT'"><xsl:value-of select="$myparam"/> (Tray, one layer no cover, wooden)</xsl:when>
      		<xsl:when test="$myparam.upper='XDU'"><xsl:value-of select="$myparam"/> (Tray, one layer no cover, polystyrene)</xsl:when>
      		<xsl:when test="$myparam.upper='XDV'"><xsl:value-of select="$myparam"/> (Tray, one layer no cover, cardboard)</xsl:when>
      		<xsl:when test="$myparam.upper='XDW'"><xsl:value-of select="$myparam"/> (Tray, two layers no cover, plastic tray)</xsl:when>
      		<xsl:when test="$myparam.upper='XDX'"><xsl:value-of select="$myparam"/> (Tray, two layers no cover, wooden)</xsl:when>
      		<xsl:when test="$myparam.upper='XDY'"><xsl:value-of select="$myparam"/> (Tray, two layers no cover, cardboard)</xsl:when>
      		<xsl:when test="$myparam.upper='XEC'"><xsl:value-of select="$myparam"/> (Bag, plastic)</xsl:when>
      		<xsl:when test="$myparam.upper='XED'"><xsl:value-of select="$myparam"/> (Case, with pallet base)</xsl:when>
      		<xsl:when test="$myparam.upper='XEE'"><xsl:value-of select="$myparam"/> (Case, with pallet base, wooden)</xsl:when>
      		<xsl:when test="$myparam.upper='XEF'"><xsl:value-of select="$myparam"/> (Case, with pallet base, cardboard)</xsl:when>
      		<xsl:when test="$myparam.upper='XEG'"><xsl:value-of select="$myparam"/> (Case, with pallet base, plastic)</xsl:when>
      		<xsl:when test="$myparam.upper='XEH'"><xsl:value-of select="$myparam"/> (Case, with pallet base, metal)</xsl:when>
      		<xsl:when test="$myparam.upper='XEI'"><xsl:value-of select="$myparam"/> (Case, isothermic)</xsl:when>
      		<xsl:when test="$myparam.upper='XEN'"><xsl:value-of select="$myparam"/> (Envelope)</xsl:when>
      		<xsl:when test="$myparam.upper='XFB'"><xsl:value-of select="$myparam"/> (Flexibag)</xsl:when>
      		<xsl:when test="$myparam.upper='XFC'"><xsl:value-of select="$myparam"/> (Crate, fruit)</xsl:when>
      		<xsl:when test="$myparam.upper='XFD'"><xsl:value-of select="$myparam"/> (Crate, framed)</xsl:when>
      		<xsl:when test="$myparam.upper='XFE'"><xsl:value-of select="$myparam"/> (Flexitank)</xsl:when>
      		<xsl:when test="$myparam.upper='XFI'"><xsl:value-of select="$myparam"/> (Firkin)</xsl:when>
      		<xsl:when test="$myparam.upper='XFL'"><xsl:value-of select="$myparam"/> (Flask)</xsl:when>
      		<xsl:when test="$myparam.upper='XFO'"><xsl:value-of select="$myparam"/> (Footlocker)</xsl:when>
      		<xsl:when test="$myparam.upper='XFP'"><xsl:value-of select="$myparam"/> (Filmpack)</xsl:when>
      		<xsl:when test="$myparam.upper='XFR'"><xsl:value-of select="$myparam"/> (Frame)</xsl:when>
      		<xsl:when test="$myparam.upper='XFT'"><xsl:value-of select="$myparam"/> (Foodtainer)</xsl:when>
      		<xsl:when test="$myparam.upper='XFW'"><xsl:value-of select="$myparam"/> (Cart, flatbed)</xsl:when>
      		<xsl:when test="$myparam.upper='XFX'"><xsl:value-of select="$myparam"/> (Bag, flexible container)</xsl:when>
      		<xsl:when test="$myparam.upper='XGB'"><xsl:value-of select="$myparam"/> (Bottle, gas)</xsl:when>
      		<xsl:when test="$myparam.upper='XGI'"><xsl:value-of select="$myparam"/> (Girder)</xsl:when>
      		<xsl:when test="$myparam.upper='XGL'"><xsl:value-of select="$myparam"/> (Container, gallon)</xsl:when>
      		<xsl:when test="$myparam.upper='XGR'"><xsl:value-of select="$myparam"/> (Receptacle, glass)</xsl:when>
      		<xsl:when test="$myparam.upper='XGU'"><xsl:value-of select="$myparam"/> (Tray, containing horizontally stacked flat items)</xsl:when>
      		<xsl:when test="$myparam.upper='XGY'"><xsl:value-of select="$myparam"/> (Bag, gunny)</xsl:when>
      		<xsl:when test="$myparam.upper='XGZ'"><xsl:value-of select="$myparam"/> (Girders, in bundle/bunch/truss)</xsl:when>
      		<xsl:when test="$myparam.upper='XHA'"><xsl:value-of select="$myparam"/> (Basket, with handle, plastic)</xsl:when>
      		<xsl:when test="$myparam.upper='XHB'"><xsl:value-of select="$myparam"/> (Basket, with handle, wooden)</xsl:when>
      		<xsl:when test="$myparam.upper='XHC'"><xsl:value-of select="$myparam"/> (Basket, with handle, cardboard)</xsl:when>
      		<xsl:when test="$myparam.upper='XHG'"><xsl:value-of select="$myparam"/> (Hogshead)</xsl:when>
      		<xsl:when test="$myparam.upper='XHN'"><xsl:value-of select="$myparam"/> (Hanger)</xsl:when>
      		<xsl:when test="$myparam.upper='XHR'"><xsl:value-of select="$myparam"/> (Hamper)</xsl:when>
      		<xsl:when test="$myparam.upper='XIA'"><xsl:value-of select="$myparam"/> (Package, display, wooden)</xsl:when>
      		<xsl:when test="$myparam.upper='XIB'"><xsl:value-of select="$myparam"/> (Package, display, cardboard)</xsl:when>
      		<xsl:when test="$myparam.upper='XIC'"><xsl:value-of select="$myparam"/> (Package, display, plastic)</xsl:when>
      		<xsl:when test="$myparam.upper='XID'"><xsl:value-of select="$myparam"/> (Package, display, metal)</xsl:when>
      		<xsl:when test="$myparam.upper='XIE'"><xsl:value-of select="$myparam"/> (Package, show)</xsl:when>
      		<xsl:when test="$myparam.upper='XIF'"><xsl:value-of select="$myparam"/> (Package, flow)</xsl:when>
      		<xsl:when test="$myparam.upper='XIG'"><xsl:value-of select="$myparam"/> (Package, paper wrapped)</xsl:when>
      		<xsl:when test="$myparam.upper='XIH'"><xsl:value-of select="$myparam"/> (Drum, plastic)</xsl:when>
      		<xsl:when test="$myparam.upper='XIK'"><xsl:value-of select="$myparam"/> (Package, cardboard, with bottle grip-holes)</xsl:when>
      		<xsl:when test="$myparam.upper='XIL'"><xsl:value-of select="$myparam"/> (Tray, rigid, lidded stackable (CEN TS 14482:2002))</xsl:when>
      		<xsl:when test="$myparam.upper='XIN'"><xsl:value-of select="$myparam"/> (Ingot)</xsl:when>
      		<xsl:when test="$myparam.upper='XIZ'"><xsl:value-of select="$myparam"/> (Ingots, in bundle/bunch/truss)</xsl:when>
      		<xsl:when test="$myparam.upper='XJB'"><xsl:value-of select="$myparam"/> (Bag, jumbo)</xsl:when>
      		<xsl:when test="$myparam.upper='XJC'"><xsl:value-of select="$myparam"/> (Jerrican, rectangular)</xsl:when>
      		<xsl:when test="$myparam.upper='XJG'"><xsl:value-of select="$myparam"/> (Jug)</xsl:when>
      		<xsl:when test="$myparam.upper='XJR'"><xsl:value-of select="$myparam"/> (Jar)</xsl:when>
      		<xsl:when test="$myparam.upper='XJT'"><xsl:value-of select="$myparam"/> (Jutebag)</xsl:when>
      		<xsl:when test="$myparam.upper='XJY'"><xsl:value-of select="$myparam"/> (Jerrican, cylindrical)</xsl:when>
      		<xsl:when test="$myparam.upper='XKG'"><xsl:value-of select="$myparam"/> (Keg)</xsl:when>
      		<xsl:when test="$myparam.upper='XKI'"><xsl:value-of select="$myparam"/> (Kit)</xsl:when>
      		<xsl:when test="$myparam.upper='XLE'"><xsl:value-of select="$myparam"/> (Luggage)</xsl:when>
      		<xsl:when test="$myparam.upper='XLG'"><xsl:value-of select="$myparam"/> (Log)</xsl:when>
      		<xsl:when test="$myparam.upper='XLT'"><xsl:value-of select="$myparam"/> (Lot)</xsl:when>
      		<xsl:when test="$myparam.upper='XLU'"><xsl:value-of select="$myparam"/> (Lug)</xsl:when>
      		<xsl:when test="$myparam.upper='XLV'"><xsl:value-of select="$myparam"/> (Liftvan)</xsl:when>
      		<xsl:when test="$myparam.upper='XLZ'"><xsl:value-of select="$myparam"/> (Logs, in bundle/bunch/truss)</xsl:when>
      		<xsl:when test="$myparam.upper='XMA'"><xsl:value-of select="$myparam"/> (Crate, metal)</xsl:when>
      		<xsl:when test="$myparam.upper='XMB'"><xsl:value-of select="$myparam"/> (Bag, multiply)</xsl:when>
      		<xsl:when test="$myparam.upper='XMC'"><xsl:value-of select="$myparam"/> (Crate, milk)</xsl:when>
      		<xsl:when test="$myparam.upper='XME'"><xsl:value-of select="$myparam"/> (Container, metal)</xsl:when>
      		<xsl:when test="$myparam.upper='XMR'"><xsl:value-of select="$myparam"/> (Receptacle, metal)</xsl:when>
      		<xsl:when test="$myparam.upper='XMS'"><xsl:value-of select="$myparam"/> (Sack, multi-wall)</xsl:when>
      		<xsl:when test="$myparam.upper='XMT'"><xsl:value-of select="$myparam"/> (Mat)</xsl:when>
      		<xsl:when test="$myparam.upper='XMW'"><xsl:value-of select="$myparam"/> (Receptacle, plastic wrapped)</xsl:when>
      		<xsl:when test="$myparam.upper='XMX'"><xsl:value-of select="$myparam"/> (Matchbox)</xsl:when>
      		<xsl:when test="$myparam.upper='XNA'"><xsl:value-of select="$myparam"/> (Not available)</xsl:when>
      		<xsl:when test="$myparam.upper='XNE'"><xsl:value-of select="$myparam"/> (Unpacked or unpackaged)</xsl:when>
      		<xsl:when test="$myparam.upper='XNF'"><xsl:value-of select="$myparam"/> (Unpacked or unpackaged, single unit)</xsl:when>
      		<xsl:when test="$myparam.upper='XNG'"><xsl:value-of select="$myparam"/> (Unpacked or unpackaged, multiple units)</xsl:when>
      		<xsl:when test="$myparam.upper='XNS'"><xsl:value-of select="$myparam"/> (Nest)</xsl:when>
      		<xsl:when test="$myparam.upper='XNT'"><xsl:value-of select="$myparam"/> (Net)</xsl:when>
      		<xsl:when test="$myparam.upper='XNU'"><xsl:value-of select="$myparam"/> (Net, tube, plastic)</xsl:when>
      		<xsl:when test="$myparam.upper='XNV'"><xsl:value-of select="$myparam"/> (Net, tube, textile)</xsl:when>
      		<xsl:when test="$myparam.upper='XOA'"><xsl:value-of select="$myparam"/> (Pallet, CHEP 40 cm x 60 cm)</xsl:when>
      		<xsl:when test="$myparam.upper='XOB'"><xsl:value-of select="$myparam"/> (Pallet, CHEP 80 cm x 120 cm)</xsl:when>
      		<xsl:when test="$myparam.upper='XOC'"><xsl:value-of select="$myparam"/> (Pallet, CHEP 100 cm x 120 cm)</xsl:when>
      		<xsl:when test="$myparam.upper='XOD'"><xsl:value-of select="$myparam"/> (Pallet, AS 4068-1993)</xsl:when>
      		<xsl:when test="$myparam.upper='XOE'"><xsl:value-of select="$myparam"/> (Pallet, ISO T11)</xsl:when>
      		<xsl:when test="$myparam.upper='XOF'"><xsl:value-of select="$myparam"/> (Platform, unspecified weight or dimension)</xsl:when>
      		<xsl:when test="$myparam.upper='XOK'"><xsl:value-of select="$myparam"/> (Block)</xsl:when>
      		<xsl:when test="$myparam.upper='XOT'"><xsl:value-of select="$myparam"/> (Octabin)</xsl:when>
      		<xsl:when test="$myparam.upper='XOU'"><xsl:value-of select="$myparam"/> (Container, outer)</xsl:when>
      		<xsl:when test="$myparam.upper='XOG'"><xsl:value-of select="$myparam"/> (Pallet ISO 0 - 1/2 EURO Pallet)</xsl:when>
      		<xsl:when test="$myparam.upper='XOH'"><xsl:value-of select="$myparam"/> (Pallet ISO 1 - 1/1 EURO Pallet)</xsl:when>
      		<xsl:when test="$myparam.upper='XOI'"><xsl:value-of select="$myparam"/> (Pallet ISO 2 – 2/1 EURO Pallet)</xsl:when>
      		<xsl:when test="$myparam.upper='XOJ'"><xsl:value-of select="$myparam"/> (1/4 EURO Pallet)</xsl:when>
      		<xsl:when test="$myparam.upper='XOL'"><xsl:value-of select="$myparam"/> (1/8 EURO Pallet)</xsl:when>
      		<xsl:when test="$myparam.upper='XOM'"><xsl:value-of select="$myparam"/> (Synthetic pallet ISO 1)</xsl:when>
      		<xsl:when test="$myparam.upper='XON'"><xsl:value-of select="$myparam"/> (Synthetic pallet ISO 2)</xsl:when>
      		<xsl:when test="$myparam.upper='XOP'"><xsl:value-of select="$myparam"/> (Wholesaler pallet)</xsl:when>
      		<xsl:when test="$myparam.upper='XOQ'"><xsl:value-of select="$myparam"/> (Pallet 80 X 100 cm)</xsl:when>
      		<xsl:when test="$myparam.upper='XOR'"><xsl:value-of select="$myparam"/> (Pallet 60 X 100 cm)</xsl:when>
      		<xsl:when test="$myparam.upper='XOS'"><xsl:value-of select="$myparam"/> (Oneway pallet)</xsl:when>
      		<xsl:when test="$myparam.upper='XOV'"><xsl:value-of select="$myparam"/> (Returnable pallet)</xsl:when>
      		<xsl:when test="$myparam.upper='XOW'"><xsl:value-of select="$myparam"/> (Large bag, pallet sized)</xsl:when>
      		<xsl:when test="$myparam.upper='XOX'"><xsl:value-of select="$myparam"/> (A wheeled pallet with raised rim (81 x 67 x 135))</xsl:when>
      		<xsl:when test="$myparam.upper='XOY'"><xsl:value-of select="$myparam"/> (A Wheeled pallet with raised rim (81 x 72 x 135))</xsl:when>
      		<xsl:when test="$myparam.upper='XOZ'"><xsl:value-of select="$myparam"/> (Wheeled pallet with raised rim ( 81 x 60 x 16))</xsl:when>
      		<xsl:when test="$myparam.upper='XO1'"><xsl:value-of select="$myparam"/> (Two sided cage on wheels with fixing strap)</xsl:when>
      		<xsl:when test="$myparam.upper='XO2'"><xsl:value-of select="$myparam"/> (Trolley)</xsl:when>
      		<xsl:when test="$myparam.upper='XO3'"><xsl:value-of select="$myparam"/> (Oneway pallet ISO 0 - 1/2 EURO Pallet)</xsl:when>
      		<xsl:when test="$myparam.upper='XO4'"><xsl:value-of select="$myparam"/> (Oneway pallet ISO 1 - 1/1 EURO Pallet)</xsl:when>
      		<xsl:when test="$myparam.upper='XO5'"><xsl:value-of select="$myparam"/> (Oneway pallet ISO 2 - 2/1 EURO Pallet)</xsl:when>
      		<xsl:when test="$myparam.upper='XO6'"><xsl:value-of select="$myparam"/> (Pallet with exceptional dimensions)</xsl:when>
      		<xsl:when test="$myparam.upper='XO7'"><xsl:value-of select="$myparam"/> (Wooden pallet 40 cm x 80 cm)</xsl:when>
      		<xsl:when test="$myparam.upper='XO8'"><xsl:value-of select="$myparam"/> (Plastic pallet SRS 60 cm x 80 cm)</xsl:when>
      		<xsl:when test="$myparam.upper='XO9'"><xsl:value-of select="$myparam"/> (Plastic pallet SRS 80 cm x 120 cm)</xsl:when>
      		<xsl:when test="$myparam.upper='XP1'"><xsl:value-of select="$myparam"/> (CHEP pallet 60 cm x 80 cm)</xsl:when>
      		<xsl:when test="$myparam.upper='XP3'"><xsl:value-of select="$myparam"/> (LPR pallet 60 cm x 80 cm)</xsl:when>
      		<xsl:when test="$myparam.upper='XP4'"><xsl:value-of select="$myparam"/> (LPR pallet 80 cm x 120 cm)</xsl:when>
      		<xsl:when test="$myparam.upper='XP2'"><xsl:value-of select="$myparam"/> (Pan)</xsl:when>
      		<xsl:when test="$myparam.upper='XPA'"><xsl:value-of select="$myparam"/> (Packet)</xsl:when>
      		<xsl:when test="$myparam.upper='XPB'"><xsl:value-of select="$myparam"/> (Pallet, box Combined open-ended box and pallet)</xsl:when>
      		<xsl:when test="$myparam.upper='XPC'"><xsl:value-of select="$myparam"/> (Parcel)</xsl:when>
      		<xsl:when test="$myparam.upper='XPD'"><xsl:value-of select="$myparam"/> (Pallet, modular, collars 80cms * 100cms)</xsl:when>
      		<xsl:when test="$myparam.upper='XPE'"><xsl:value-of select="$myparam"/> (Pallet, modular, collars 80cms * 120cms)</xsl:when>
      		<xsl:when test="$myparam.upper='XPF'"><xsl:value-of select="$myparam"/> (Pen)</xsl:when>
      		<xsl:when test="$myparam.upper='XPG'"><xsl:value-of select="$myparam"/> (Plate)</xsl:when>
      		<xsl:when test="$myparam.upper='XPH'"><xsl:value-of select="$myparam"/> (Pitcher)</xsl:when>
      		<xsl:when test="$myparam.upper='XPI'"><xsl:value-of select="$myparam"/> (Pipe)</xsl:when>
      		<xsl:when test="$myparam.upper='XPJ'"><xsl:value-of select="$myparam"/> (Punnet)</xsl:when>
      		<xsl:when test="$myparam.upper='XPK'"><xsl:value-of select="$myparam"/> (Package)</xsl:when>
      		<xsl:when test="$myparam.upper='XPL'"><xsl:value-of select="$myparam"/> (Pail)</xsl:when>
      		<xsl:when test="$myparam.upper='XPN'"><xsl:value-of select="$myparam"/> (Plank)</xsl:when>
      		<xsl:when test="$myparam.upper='XPO'"><xsl:value-of select="$myparam"/> (Pouch)</xsl:when>
      		<xsl:when test="$myparam.upper='XPP'"><xsl:value-of select="$myparam"/> (Piece)</xsl:when>
      		<xsl:when test="$myparam.upper='XPR'"><xsl:value-of select="$myparam"/> (Receptacle, plastic)</xsl:when>
      		<xsl:when test="$myparam.upper='XPT'"><xsl:value-of select="$myparam"/> (Pot)</xsl:when>
      		<xsl:when test="$myparam.upper='XPU'"><xsl:value-of select="$myparam"/> (Tray)</xsl:when>
      		<xsl:when test="$myparam.upper='XPV'"><xsl:value-of select="$myparam"/> (Pipes, in bundle/bunch/truss)</xsl:when>
      		<xsl:when test="$myparam.upper='XPX'"><xsl:value-of select="$myparam"/> (Pallet)</xsl:when>
      		<xsl:when test="$myparam.upper='XPY'"><xsl:value-of select="$myparam"/> (Plates, in bundle/bunch/truss)</xsl:when>
      		<xsl:when test="$myparam.upper='XPZ'"><xsl:value-of select="$myparam"/> (Planks, in bundle/bunch/truss)</xsl:when>
      		<xsl:when test="$myparam.upper='XQA'"><xsl:value-of select="$myparam"/> (Drum, steel, non-removable head)</xsl:when>
      		<xsl:when test="$myparam.upper='XQB'"><xsl:value-of select="$myparam"/> (Drum, steel, removable head)</xsl:when>
      		<xsl:when test="$myparam.upper='XQC'"><xsl:value-of select="$myparam"/> (Drum, aluminium, non-removable head)</xsl:when>
      		<xsl:when test="$myparam.upper='XQD'"><xsl:value-of select="$myparam"/> (Drum, aluminium, removable head)</xsl:when>
      		<xsl:when test="$myparam.upper='XQF'"><xsl:value-of select="$myparam"/> (Drum, plastic, non-removable head)</xsl:when>
      		<xsl:when test="$myparam.upper='XQG'"><xsl:value-of select="$myparam"/> (Drum, plastic, removable head)</xsl:when>
      		<xsl:when test="$myparam.upper='XQH'"><xsl:value-of select="$myparam"/> (Barrel, wooden, bung type)</xsl:when>
      		<xsl:when test="$myparam.upper='XQJ'"><xsl:value-of select="$myparam"/> (Barrel, wooden, removable head)</xsl:when>
      		<xsl:when test="$myparam.upper='XQK'"><xsl:value-of select="$myparam"/> (Jerrican, steel, non-removable head)</xsl:when>
      		<xsl:when test="$myparam.upper='XQL'"><xsl:value-of select="$myparam"/> (Jerrican, steel, removable head)</xsl:when>
      		<xsl:when test="$myparam.upper='XQM'"><xsl:value-of select="$myparam"/> (Jerrican, plastic, non-removable head)</xsl:when>
      		<xsl:when test="$myparam.upper='XQN'"><xsl:value-of select="$myparam"/> (Jerrican, plastic, removable head)</xsl:when>
      		<xsl:when test="$myparam.upper='XQP'"><xsl:value-of select="$myparam"/> (Box, wooden, natural wood, ordinary)</xsl:when>
      		<xsl:when test="$myparam.upper='XQQ'"><xsl:value-of select="$myparam"/> (Box, wooden, natural wood, with sift proof walls)</xsl:when>
      		<xsl:when test="$myparam.upper='XQR'"><xsl:value-of select="$myparam"/> (Box, plastic, expanded)</xsl:when>
      		<xsl:when test="$myparam.upper='XQS'"><xsl:value-of select="$myparam"/> (Box, plastic, solid)</xsl:when>
      		<xsl:when test="$myparam.upper='XRD'"><xsl:value-of select="$myparam"/> (Rod)</xsl:when>
      		<xsl:when test="$myparam.upper='XRG'"><xsl:value-of select="$myparam"/> (Ring)</xsl:when>
      		<xsl:when test="$myparam.upper='XRJ'"><xsl:value-of select="$myparam"/> (Rack, clothing hanger)</xsl:when>
      		<xsl:when test="$myparam.upper='XRK'"><xsl:value-of select="$myparam"/> (Rack)</xsl:when>
      		<xsl:when test="$myparam.upper='XRL'"><xsl:value-of select="$myparam"/> (Reel)</xsl:when>
      		<xsl:when test="$myparam.upper='XRO'"><xsl:value-of select="$myparam"/> (Roll)</xsl:when>
      		<xsl:when test="$myparam.upper='XRT'"><xsl:value-of select="$myparam"/> (Rednet)</xsl:when>
      		<xsl:when test="$myparam.upper='XRZ'"><xsl:value-of select="$myparam"/> (Rods, in bundle/bunch/truss)</xsl:when>
      		<xsl:when test="$myparam.upper='XSA'"><xsl:value-of select="$myparam"/> (Sack)</xsl:when>
      		<xsl:when test="$myparam.upper='XSB'"><xsl:value-of select="$myparam"/> (Slab)</xsl:when>
      		<xsl:when test="$myparam.upper='XSC'"><xsl:value-of select="$myparam"/> (Crate, shallow)</xsl:when>
      		<xsl:when test="$myparam.upper='XSD'"><xsl:value-of select="$myparam"/> (Spindle)</xsl:when>
      		<xsl:when test="$myparam.upper='XSE'"><xsl:value-of select="$myparam"/> (Sea-chest)</xsl:when>
      		<xsl:when test="$myparam.upper='XSH'"><xsl:value-of select="$myparam"/> (Sachet)</xsl:when>
      		<xsl:when test="$myparam.upper='XSI'"><xsl:value-of select="$myparam"/> (Skid)</xsl:when>
      		<xsl:when test="$myparam.upper='XSK'"><xsl:value-of select="$myparam"/> (Case, skeleton)</xsl:when>
      		<xsl:when test="$myparam.upper='XSL'"><xsl:value-of select="$myparam"/> (Slipsheet)</xsl:when>
      		<xsl:when test="$myparam.upper='XSM'"><xsl:value-of select="$myparam"/> (Sheetmetal)</xsl:when>
      		<xsl:when test="$myparam.upper='XSO'"><xsl:value-of select="$myparam"/> (Spool)</xsl:when>
      		<xsl:when test="$myparam.upper='XSP'"><xsl:value-of select="$myparam"/> (Sheet, plastic wrapping)</xsl:when>
      		<xsl:when test="$myparam.upper='XSS'"><xsl:value-of select="$myparam"/> (Case, steel)</xsl:when>
      		<xsl:when test="$myparam.upper='XST'"><xsl:value-of select="$myparam"/> (Sheet)</xsl:when>
      		<xsl:when test="$myparam.upper='XSU'"><xsl:value-of select="$myparam"/> (Suitcase)</xsl:when>
      		<xsl:when test="$myparam.upper='XSV'"><xsl:value-of select="$myparam"/> (Envelope, steel)</xsl:when>
      		<xsl:when test="$myparam.upper='XSW'"><xsl:value-of select="$myparam"/> (Shrinkwrapped)</xsl:when>
      		<xsl:when test="$myparam.upper='XSX'"><xsl:value-of select="$myparam"/> (Set)</xsl:when>
      		<xsl:when test="$myparam.upper='XSY'"><xsl:value-of select="$myparam"/> (Sleeve)</xsl:when>
      		<xsl:when test="$myparam.upper='XSZ'"><xsl:value-of select="$myparam"/> (Sheets, in bundle/bunch/truss)</xsl:when>
      		<xsl:when test="$myparam.upper='XT1'"><xsl:value-of select="$myparam"/> (Tablet)</xsl:when>
      		<xsl:when test="$myparam.upper='XTB'"><xsl:value-of select="$myparam"/> (Tub)</xsl:when>
      		<xsl:when test="$myparam.upper='XTC'"><xsl:value-of select="$myparam"/> (Tea-chest)</xsl:when>
      		<xsl:when test="$myparam.upper='XTD'"><xsl:value-of select="$myparam"/> (Tube, collapsible)</xsl:when>
      		<xsl:when test="$myparam.upper='XTE'"><xsl:value-of select="$myparam"/> (Tyre)</xsl:when>
      		<xsl:when test="$myparam.upper='XTG'"><xsl:value-of select="$myparam"/> (Tank container, generic)</xsl:when>
      		<xsl:when test="$myparam.upper='XTI'"><xsl:value-of select="$myparam"/> (Tierce)</xsl:when>
      		<xsl:when test="$myparam.upper='XTK'"><xsl:value-of select="$myparam"/> (Tank, rectangular)</xsl:when>
      		<xsl:when test="$myparam.upper='XTL'"><xsl:value-of select="$myparam"/> (Tub, with lid)</xsl:when>
      		<xsl:when test="$myparam.upper='XTN'"><xsl:value-of select="$myparam"/> (Tin)</xsl:when>
      		<xsl:when test="$myparam.upper='XTO'"><xsl:value-of select="$myparam"/> (Tun)</xsl:when>
      		<xsl:when test="$myparam.upper='XTR'"><xsl:value-of select="$myparam"/> (Trunk)</xsl:when>
      		<xsl:when test="$myparam.upper='XTS'"><xsl:value-of select="$myparam"/> (Truss)</xsl:when>
      		<xsl:when test="$myparam.upper='XTT'"><xsl:value-of select="$myparam"/> (Bag, tote)</xsl:when>
      		<xsl:when test="$myparam.upper='XTU'"><xsl:value-of select="$myparam"/> (Tube)</xsl:when>
      		<xsl:when test="$myparam.upper='XTV'"><xsl:value-of select="$myparam"/> (Tube, with nozzle)</xsl:when>
      		<xsl:when test="$myparam.upper='XTW'"><xsl:value-of select="$myparam"/> (Pallet, triwall)</xsl:when>
      		<xsl:when test="$myparam.upper='XTY'"><xsl:value-of select="$myparam"/> (Tank, cylindrical)</xsl:when>
      		<xsl:when test="$myparam.upper='XTZ'"><xsl:value-of select="$myparam"/> (Tubes, in bundle/bunch/truss)</xsl:when>
      		<xsl:when test="$myparam.upper='XUC'"><xsl:value-of select="$myparam"/> (Uncaged)</xsl:when>
      		<xsl:when test="$myparam.upper='XUN'"><xsl:value-of select="$myparam"/> (Unit)</xsl:when>
      		<xsl:when test="$myparam.upper='XVA'"><xsl:value-of select="$myparam"/> (Vat)</xsl:when>
      		<xsl:when test="$myparam.upper='XVG'"><xsl:value-of select="$myparam"/> (Bulk, gas (at 1031 mbar and 15°C))</xsl:when>
      		<xsl:when test="$myparam.upper='XVI'"><xsl:value-of select="$myparam"/> (Vial)</xsl:when>
      		<xsl:when test="$myparam.upper='XVK'"><xsl:value-of select="$myparam"/> (Vanpack)</xsl:when>
      		<xsl:when test="$myparam.upper='XVL'"><xsl:value-of select="$myparam"/> (Bulk, liquid)</xsl:when>
      		<xsl:when test="$myparam.upper='XVO'"><xsl:value-of select="$myparam"/> (Bulk, solid, large particles (“nodules”))</xsl:when>
      		<xsl:when test="$myparam.upper='XVP'"><xsl:value-of select="$myparam"/> (Vacuum-packed)</xsl:when>
      		<xsl:when test="$myparam.upper='XVQ'"><xsl:value-of select="$myparam"/> (Bulk, liquefied gas (at abnormal temperature/pressure))</xsl:when>
      		<xsl:when test="$myparam.upper='XVN'"><xsl:value-of select="$myparam"/> (Vehicle)</xsl:when>
      		<xsl:when test="$myparam.upper='XVR'"><xsl:value-of select="$myparam"/> (Bulk, solid, granular particles (“grains”))</xsl:when>
      		<xsl:when test="$myparam.upper='XVS'"><xsl:value-of select="$myparam"/> (Bulk, scrap metal)</xsl:when>
      		<xsl:when test="$myparam.upper='XVY'"><xsl:value-of select="$myparam"/> (Bulk, solid, fine particles (“powders”))</xsl:when>
      		<xsl:when test="$myparam.upper='XWA'"><xsl:value-of select="$myparam"/> (Intermediate bulk container)</xsl:when>
      		<xsl:when test="$myparam.upper='XWB'"><xsl:value-of select="$myparam"/> (Wickerbottle)</xsl:when>
      		<xsl:when test="$myparam.upper='XWC'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, steel)</xsl:when>
      		<xsl:when test="$myparam.upper='XWD'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, aluminium)</xsl:when>
      		<xsl:when test="$myparam.upper='XWF'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, metal)</xsl:when>
      		<xsl:when test="$myparam.upper='XWG'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, steel, pressurised > 10 kpa)</xsl:when>
      		<xsl:when test="$myparam.upper='XWH'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, aluminium, pressurised > 10 kpa)</xsl:when>
      		<xsl:when test="$myparam.upper='XWJ'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, metal, pressure 10 kpa)</xsl:when>
      		<xsl:when test="$myparam.upper='XWK'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, steel, liquid)</xsl:when>
      		<xsl:when test="$myparam.upper='XWL'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, aluminium, liquid)</xsl:when>
      		<xsl:when test="$myparam.upper='XWM'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, metal, liquid)</xsl:when>
      		<xsl:when test="$myparam.upper='XWN'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, woven plastic, without coat/liner)</xsl:when>
      		<xsl:when test="$myparam.upper='XWP'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, woven plastic, coated)</xsl:when>
      		<xsl:when test="$myparam.upper='XWQ'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, woven plastic, with liner)</xsl:when>
      		<xsl:when test="$myparam.upper='XWR'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, woven plastic, coated and liner)</xsl:when>
      		<xsl:when test="$myparam.upper='XWS'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, plastic film)</xsl:when>
      		<xsl:when test="$myparam.upper='XWT'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, textile with out coat/liner)</xsl:when>
      		<xsl:when test="$myparam.upper='XWU'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, natural wood, with inner liner)</xsl:when>
      		<xsl:when test="$myparam.upper='XWV'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, textile, coated)</xsl:when>
      		<xsl:when test="$myparam.upper='XWW'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, textile, with liner)</xsl:when>
      		<xsl:when test="$myparam.upper='XWX'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, textile, coated and liner)</xsl:when>
      		<xsl:when test="$myparam.upper='XWY'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, plywood, with inner liner)</xsl:when>
      		<xsl:when test="$myparam.upper='XWZ'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, reconstituted wood, with inner liner)</xsl:when>
      		<xsl:when test="$myparam.upper='XXA'"><xsl:value-of select="$myparam"/> (Bag, woven plastic, without inner coat/liner)</xsl:when>
      		<xsl:when test="$myparam.upper='XXB'"><xsl:value-of select="$myparam"/> (Bag, woven plastic, sift proof)</xsl:when>
      		<xsl:when test="$myparam.upper='XXC'"><xsl:value-of select="$myparam"/> (Bag, woven plastic, water resistant)</xsl:when>
      		<xsl:when test="$myparam.upper='XXD'"><xsl:value-of select="$myparam"/> (Bag, plastics film)</xsl:when>
      		<xsl:when test="$myparam.upper='XXF'"><xsl:value-of select="$myparam"/> (Bag, textile, without inner coat/liner)</xsl:when>
      		<xsl:when test="$myparam.upper='XXG'"><xsl:value-of select="$myparam"/> (Bag, textile, sift proof)</xsl:when>
      		<xsl:when test="$myparam.upper='XXH'"><xsl:value-of select="$myparam"/> (Bag, textile, water resistant)</xsl:when>
      		<xsl:when test="$myparam.upper='XXJ'"><xsl:value-of select="$myparam"/> (Bag, paper, multi-wall)</xsl:when>
      		<xsl:when test="$myparam.upper='XXK'"><xsl:value-of select="$myparam"/> (Bag, paper, multi-wall, water resistant)</xsl:when>
      		<xsl:when test="$myparam.upper='XYA'"><xsl:value-of select="$myparam"/> (Composite packaging, plastic receptacle in steel drum)</xsl:when>
      		<xsl:when test="$myparam.upper='XYB'"><xsl:value-of select="$myparam"/> (Composite packaging, plastic receptacle in steel crate box)</xsl:when>
      		<xsl:when test="$myparam.upper='XYC'"><xsl:value-of select="$myparam"/> (Composite packaging, plastic receptacle in aluminium drum)</xsl:when>
      		<xsl:when test="$myparam.upper='XYD'"><xsl:value-of select="$myparam"/> (Composite packaging, plastic receptacle in aluminium crate)</xsl:when>
      		<xsl:when test="$myparam.upper='XYF'"><xsl:value-of select="$myparam"/> (Composite packaging, plastic receptacle in wooden box)</xsl:when>
      		<xsl:when test="$myparam.upper='XYG'"><xsl:value-of select="$myparam"/> (Composite packaging, plastic receptacle in plywood drum)</xsl:when>
      		<xsl:when test="$myparam.upper='XYH'"><xsl:value-of select="$myparam"/> (Composite packaging, plastic receptacle in plywood box)</xsl:when>
      		<xsl:when test="$myparam.upper='XYJ'"><xsl:value-of select="$myparam"/> (Composite packaging, plastic receptacle in fibre drum)</xsl:when>
      		<xsl:when test="$myparam.upper='XYK'"><xsl:value-of select="$myparam"/> (Composite packaging, plastic receptacle in fibreboard box)</xsl:when>
      		<xsl:when test="$myparam.upper='XYL'"><xsl:value-of select="$myparam"/> (Composite packaging, plastic receptacle in plastic drum)</xsl:when>
      		<xsl:when test="$myparam.upper='XYM'"><xsl:value-of select="$myparam"/> (Composite packaging, plastic receptacle in solid plastic box)</xsl:when>
      		<xsl:when test="$myparam.upper='XYN'"><xsl:value-of select="$myparam"/> (Composite packaging, glass receptacle in steel drum)</xsl:when>
      		<xsl:when test="$myparam.upper='XYP'"><xsl:value-of select="$myparam"/> (Composite packaging, glass receptacle in steel crate box)</xsl:when>
      		<xsl:when test="$myparam.upper='XYQ'"><xsl:value-of select="$myparam"/> (Composite packaging, glass receptacle in aluminium drum)</xsl:when>
      		<xsl:when test="$myparam.upper='XYR'"><xsl:value-of select="$myparam"/> (Composite packaging, glass receptacle in aluminium crate)</xsl:when>
      		<xsl:when test="$myparam.upper='XYS'"><xsl:value-of select="$myparam"/> (Composite packaging, glass receptacle in wooden box)</xsl:when>
      		<xsl:when test="$myparam.upper='XYT'"><xsl:value-of select="$myparam"/> (Composite packaging, glass receptacle in plywood drum)</xsl:when>
      		<xsl:when test="$myparam.upper='XYV'"><xsl:value-of select="$myparam"/> (Composite packaging, glass receptacle in wickerwork hamper)</xsl:when>
      		<xsl:when test="$myparam.upper='XYW'"><xsl:value-of select="$myparam"/> (Composite packaging, glass receptacle in fibre drum)</xsl:when>
      		<xsl:when test="$myparam.upper='XYX'"><xsl:value-of select="$myparam"/> (Composite packaging, glass receptacle in fibreboard box)</xsl:when>
      		<xsl:when test="$myparam.upper='XYY'"><xsl:value-of select="$myparam"/> (Composite packaging, glass receptacle in expandable plastic pack)</xsl:when>
      		<xsl:when test="$myparam.upper='XYZ'"><xsl:value-of select="$myparam"/> (Composite packaging, glass receptacle in solid plastic pack)</xsl:when>
      		<xsl:when test="$myparam.upper='XZA'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, paper, multi-wall)</xsl:when>
      		<xsl:when test="$myparam.upper='XZB'"><xsl:value-of select="$myparam"/> (Bag, large)</xsl:when>
      		<xsl:when test="$myparam.upper='XZC'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, paper, multi-wall, water resistant)</xsl:when>
      		<xsl:when test="$myparam.upper='XZD'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, rigid plastic, with structural equipment, solids)</xsl:when>
      		<xsl:when test="$myparam.upper='XZF'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, rigid plastic, freestanding, solids)</xsl:when>
      		<xsl:when test="$myparam.upper='XZG'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, rigid plastic, with structural equipment, pressurised)</xsl:when>
      		<xsl:when test="$myparam.upper='XZH'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, rigid plastic, freestanding, pressurised)</xsl:when>
      		<xsl:when test="$myparam.upper='XZJ'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, rigid plastic, with structural equipment, liquids)</xsl:when>
      		<xsl:when test="$myparam.upper='XZK'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, rigid plastic, freestanding, liquids)</xsl:when>
      		<xsl:when test="$myparam.upper='XZL'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, composite, rigid plastic, solids)</xsl:when>
      		<xsl:when test="$myparam.upper='XZM'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, composite, flexible plastic, solids)</xsl:when>
      		<xsl:when test="$myparam.upper='XZN'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, composite, rigid plastic, pressurised)</xsl:when>
      		<xsl:when test="$myparam.upper='XZP'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, composite, flexible plastic, pressurised)</xsl:when>
      		<xsl:when test="$myparam.upper='XZQ'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, composite, rigid plastic, liquids)</xsl:when>
      		<xsl:when test="$myparam.upper='XZR'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, composite, flexible plastic, liquids)</xsl:when>
      		<xsl:when test="$myparam.upper='XZS'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, composite)</xsl:when>
      		<xsl:when test="$myparam.upper='XZT'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, fibreboard)</xsl:when>
      		<xsl:when test="$myparam.upper='XZU'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, flexible)</xsl:when>
      		<xsl:when test="$myparam.upper='XZV'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, metal, other than steel)</xsl:when>
      		<xsl:when test="$myparam.upper='XZW'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, natural wood)</xsl:when>
      		<xsl:when test="$myparam.upper='XZX'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, plywood)</xsl:when>
      		<xsl:when test="$myparam.upper='XZY'"><xsl:value-of select="$myparam"/> (Intermediate bulk container, reconstituted wood)</xsl:when>
      		<xsl:when test="$myparam.upper='XZZ'"><xsl:value-of select="$myparam"/> (Mutually defined)</xsl:when>
			<xsl:otherwise>
				<xsl:call-template name="code.rec20">
					<xsl:with-param name="myparam" select="."/>			
				</xsl:call-template>			
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>

</xsl:stylesheet>