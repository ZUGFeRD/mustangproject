package org.mustangproject.ZUGFeRD;

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;

import junit.framework.Test;
import junit.framework.TestCase;
import junit.framework.TestSuite;

import org.junit.FixMethodOrder;
import org.junit.runners.MethodSorters;

@FixMethodOrder(MethodSorters.NAME_ASCENDING)
public class MustangReaderWriterCustomXMLTest extends TestCase {

	/**
	 * Create the test case
	 *
	 * @param testName
	 *            name of the test case
	 */
	public MustangReaderWriterCustomXMLTest(String testName) {
		super(testName);
	}

	/**
	 * @return the suite of tests being tested
	 */
	public static Test suite() {
		return new TestSuite(MustangReaderWriterCustomXMLTest.class);
	}

	// //////// TESTS
	// //////////////////////////////////////////////////////////////////////////////////////////

	/**
	 * The exporter test bases on @{code
	 * ./src/test/MustangGnuaccountingBeispielRE-20140703_502blanko.pdf}, adds
	 * metadata, writes to @{code ./target/testout-*} and then imports to check the
	 * values. It would not make sense to have it run before the less complex
	 * importer test (which is probably redundant) --> as only Name Ascending is
	 * supported for Test Unit sequence, I renamed the Exporter Test test-Z-Export
	 */
	public void testCustomExport() throws Exception {

		final String TARGET_PDF = "./target/testout-MustangGnuaccountingBeispielRE-20170509_505custom.pdf";
		// the writing part

		try {
			InputStream SOURCE_PDF = this.getClass()
					.getResourceAsStream("/MustangGnuaccountingBeispielRE-20170509_505blanko.pdf");

			ZUGFeRDExporter zea1 = new ZUGFeRDExporterFromA1Factory().setProducer("My Application").setCreator("Test")
					.load(SOURCE_PDF);
			String ownZUGFeRDXML = "<rsm:CrossIndustryDocument xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:ram=\"urn:un:unece:uncefact:data:standard:ReusableAggregateBusinessInformationEntity:12\" xmlns:udt=\"urn:un:unece:uncefact:data:standard:UnqualifiedDataType:15\" xmlns:rsm=\"urn:ferd:CrossIndustryDocument:invoice:1p0\">\n"
					+ "<rsm:SpecifiedExchangedDocumentContext>\n" + "<ram:TestIndicator>\n"
					+ "<udt:Indicator>false</udt:Indicator>\n" + "</ram:TestIndicator>\n"
					+ "<ram:GuidelineSpecifiedDocumentContextParameter>\n" + "<ram:ID>\n"
					+ "urn:ferd:CrossIndustryDocument:invoice:1p0:extended\n" + "</ram:ID>\n"
					+ "</ram:GuidelineSpecifiedDocumentContextParameter>\n"
					+ "</rsm:SpecifiedExchangedDocumentContext>\n" + "<rsm:HeaderExchangedDocument>\n"
					+ "<ram:ID>RE-20170509/505</ram:ID>\n" + "<ram:Name>RECHNUNG</ram:Name>\n"
					+ "<ram:TypeCode>380</ram:TypeCode>\n" + "<ram:IssueDateTime>\n"
					+ "<udt:DateTimeString format=\"102\">20170509</udt:DateTimeString>\n" + "</ram:IssueDateTime>\n"
					+ "</rsm:HeaderExchangedDocument>\n" + "<rsm:SpecifiedSupplyChainTradeTransaction>\n"
					+ "<ram:ApplicableSupplyChainTradeAgreement>\n" + "<ram:SellerTradeParty>\n"
					+ "<ram:Name>Bei Spiel GmbH</ram:Name>\n" + "<ram:PostalTradeAddress>\n"
					+ "<ram:PostcodeCode>12345</ram:PostcodeCode>\n" + "<ram:LineOne>Ecke 12</ram:LineOne>\n"
					+ "<ram:CityName>Stadthausen</ram:CityName>\n" + "<ram:CountryID>DE</ram:CountryID>\n"
					+ "</ram:PostalTradeAddress>\n" + "<ram:SpecifiedTaxRegistration>\n"
					+ "<ram:ID schemeID=\"FC\">22/815/0815/4</ram:ID>\n" + "</ram:SpecifiedTaxRegistration>\n"
					+ "<ram:SpecifiedTaxRegistration>\n" + "<ram:ID schemeID=\"VA\">DE136695976</ram:ID>\n"
					+ "</ram:SpecifiedTaxRegistration>\n" + "</ram:SellerTradeParty>\n" + "<ram:BuyerTradeParty>\n"
					+ "<ram:Name>Theodor Est</ram:Name>\n" + "<ram:PostalTradeAddress>\n"
					+ "<ram:PostcodeCode>88802</ram:PostcodeCode>\n" + "<ram:LineOne>Bahnstr. 42</ram:LineOne>\n"
					+ "<ram:CityName>Spielkreis</ram:CityName>\n" + "<ram:CountryID>DE</ram:CountryID>\n"
					+ "</ram:PostalTradeAddress>\n" + "<ram:SpecifiedTaxRegistration>\n"
					+ "<ram:ID schemeID=\"VA\">DE999999999</ram:ID>\n" + "</ram:SpecifiedTaxRegistration>\n"
					+ "</ram:BuyerTradeParty>\n" + "</ram:ApplicableSupplyChainTradeAgreement>\n"
					+ "<ram:ApplicableSupplyChainTradeDelivery>\n" + "<ram:ActualDeliverySupplyChainEvent>\n"
					+ "<ram:OccurrenceDateTime>\n"
					+ "<udt:DateTimeString format=\"102\">20170507</udt:DateTimeString>\n"
					+ "</ram:OccurrenceDateTime>\n" + "</ram:ActualDeliverySupplyChainEvent>\n"
					+ "</ram:ApplicableSupplyChainTradeDelivery>\n" + "<ram:ApplicableSupplyChainTradeSettlement>\n"
					+ "<ram:PaymentReference>RE-20170509/505</ram:PaymentReference>\n"
					+ "<ram:InvoiceCurrencyCode>EUR</ram:InvoiceCurrencyCode>\n"
					+ "<ram:SpecifiedTradeSettlementPaymentMeans>\n" + "<ram:TypeCode>42</ram:TypeCode>\n"
					+ "<ram:Information>Überweisung</ram:Information>\n" + "<ram:PayeePartyCreditorFinancialAccount>\n"
					+ "<ram:IBANID>DE88 2008 0000 0970 3757 00</ram:IBANID>\n"
					+ "</ram:PayeePartyCreditorFinancialAccount>\n"
					+ "<ram:PayeeSpecifiedCreditorFinancialInstitution>\n" + "<ram:BICID>COBADEFFXXX</ram:BICID>\n"
					+ "<ram:Name>Commerzbank</ram:Name>\n" + "</ram:PayeeSpecifiedCreditorFinancialInstitution>\n"
					+ "</ram:SpecifiedTradeSettlementPaymentMeans>\n" + "<ram:ApplicableTradeTax>\n"
					+ "<ram:CalculatedAmount currencyID=\"EUR\">11.20</ram:CalculatedAmount>\n"
					+ "<ram:TypeCode>VAT</ram:TypeCode>\n"
					+ "<ram:BasisAmount currencyID=\"EUR\">160.00</ram:BasisAmount>\n"
					+ "<ram:CategoryCode>S</ram:CategoryCode>\n"
					+ "<ram:ApplicablePercent>7.00</ram:ApplicablePercent>\n" + "</ram:ApplicableTradeTax>\n"
					+ "<ram:ApplicableTradeTax>\n"
					+ "<ram:CalculatedAmount currencyID=\"EUR\">63.84</ram:CalculatedAmount>\n"
					+ "<ram:TypeCode>VAT</ram:TypeCode>\n"
					+ "<ram:BasisAmount currencyID=\"EUR\">336.00</ram:BasisAmount>\n"
					+ "<ram:CategoryCode>S</ram:CategoryCode>\n"
					+ "<ram:ApplicablePercent>19.00</ram:ApplicablePercent>\n" + "</ram:ApplicableTradeTax>\n"
					+ "<ram:SpecifiedTradePaymentTerms>\n"
					+ "<ram:Description>Zahlbar ohne Abzug bis zum 30.05.2017</ram:Description>\n"
					+ "<ram:DueDateDateTime>\n" + "<udt:DateTimeString format=\"102\">20170530</udt:DateTimeString>\n"
					+ "</ram:DueDateDateTime>\n" + "</ram:SpecifiedTradePaymentTerms>\n"
					+ "<ram:SpecifiedTradeSettlementMonetarySummation>\n"
					+ "<ram:LineTotalAmount currencyID=\"EUR\">496.00</ram:LineTotalAmount>\n"
					+ "<ram:ChargeTotalAmount currencyID=\"EUR\">0.00</ram:ChargeTotalAmount>\n"
					+ "<ram:AllowanceTotalAmount currencyID=\"EUR\">0.00</ram:AllowanceTotalAmount>\n"
					+ "<ram:TaxBasisTotalAmount currencyID=\"EUR\">496.00</ram:TaxBasisTotalAmount>\n"
					+ "<ram:TaxTotalAmount currencyID=\"EUR\">75.04</ram:TaxTotalAmount>\n"
					+ "<ram:GrandTotalAmount currencyID=\"EUR\">571.04</ram:GrandTotalAmount>\n"
					+ "<ram:DuePayableAmount currencyID=\"EUR\">571.04</ram:DuePayableAmount>\n"
					+ "</ram:SpecifiedTradeSettlementMonetarySummation>\n"
					+ "</ram:ApplicableSupplyChainTradeSettlement>\n" + "<ram:IncludedSupplyChainTradeLineItem>\n"
					+ "<ram:AssociatedDocumentLineDocument>\n" + "<ram:LineID>1</ram:LineID>\n"
					+ "</ram:AssociatedDocumentLineDocument>\n" + "<ram:SpecifiedSupplyChainTradeAgreement>\n"
					+ "<ram:GrossPriceProductTradePrice>\n"
					+ "<ram:ChargeAmount currencyID=\"EUR\">160.0000</ram:ChargeAmount>\n"
					+ "<ram:BasisQuantity unitCode=\"HUR\">1.0000</ram:BasisQuantity>\n"
					+ "</ram:GrossPriceProductTradePrice>\n" + "<ram:NetPriceProductTradePrice>\n"
					+ "<ram:ChargeAmount currencyID=\"EUR\">160.0000</ram:ChargeAmount>\n"
					+ "<ram:BasisQuantity unitCode=\"HUR\">1.0000</ram:BasisQuantity>\n"
					+ "</ram:NetPriceProductTradePrice>\n" + "</ram:SpecifiedSupplyChainTradeAgreement>\n"
					+ "<ram:SpecifiedSupplyChainTradeDelivery>\n"
					+ "<ram:BilledQuantity unitCode=\"HUR\">1.0000</ram:BilledQuantity>\n"
					+ "</ram:SpecifiedSupplyChainTradeDelivery>\n" + "<ram:SpecifiedSupplyChainTradeSettlement>\n"
					+ "<ram:ApplicableTradeTax>\n" + "<ram:TypeCode>VAT</ram:TypeCode>\n"
					+ "<ram:CategoryCode>S</ram:CategoryCode>\n"
					+ "<ram:ApplicablePercent>7.00</ram:ApplicablePercent>\n" + "</ram:ApplicableTradeTax>\n"
					+ "<ram:SpecifiedTradeSettlementMonetarySummation>\n"
					+ "<ram:LineTotalAmount currencyID=\"EUR\">160.00</ram:LineTotalAmount>\n"
					+ "</ram:SpecifiedTradeSettlementMonetarySummation>\n"
					+ "</ram:SpecifiedSupplyChainTradeSettlement>\n" + "<ram:SpecifiedTradeProduct>\n" + "<ram:Name>\n"
					+ "Künstlerische Gestaltung (Stunde): Einer Beispielrechnung\n" + "</ram:Name>\n"
					+ "<ram:Description/>\n" + "</ram:SpecifiedTradeProduct>\n"
					+ "</ram:IncludedSupplyChainTradeLineItem>\n" + "<ram:IncludedSupplyChainTradeLineItem>\n"
					+ "<ram:AssociatedDocumentLineDocument>\n" + "<ram:LineID>2</ram:LineID>\n"
					+ "</ram:AssociatedDocumentLineDocument>\n" + "<ram:SpecifiedSupplyChainTradeAgreement>\n"
					+ "<ram:GrossPriceProductTradePrice>\n"
					+ "<ram:ChargeAmount currencyID=\"EUR\">0.7900</ram:ChargeAmount>\n"
					+ "<ram:BasisQuantity unitCode=\"C62\">1.0000</ram:BasisQuantity>\n"
					+ "</ram:GrossPriceProductTradePrice>\n" + "<ram:NetPriceProductTradePrice>\n"
					+ "<ram:ChargeAmount currencyID=\"EUR\">0.7900</ram:ChargeAmount>\n"
					+ "<ram:BasisQuantity unitCode=\"C62\">1.0000</ram:BasisQuantity>\n"
					+ "</ram:NetPriceProductTradePrice>\n" + "</ram:SpecifiedSupplyChainTradeAgreement>\n"
					+ "<ram:SpecifiedSupplyChainTradeDelivery>\n"
					+ "<ram:BilledQuantity unitCode=\"C62\">400.0000</ram:BilledQuantity>\n"
					+ "</ram:SpecifiedSupplyChainTradeDelivery>\n" + "<ram:SpecifiedSupplyChainTradeSettlement>\n"
					+ "<ram:ApplicableTradeTax>\n" + "<ram:TypeCode>VAT</ram:TypeCode>\n"
					+ "<ram:CategoryCode>S</ram:CategoryCode>\n"
					+ "<ram:ApplicablePercent>19.00</ram:ApplicablePercent>\n" + "</ram:ApplicableTradeTax>\n"
					+ "<ram:SpecifiedTradeSettlementMonetarySummation>\n"
					+ "<ram:LineTotalAmount currencyID=\"EUR\">316.00</ram:LineTotalAmount>\n"
					+ "</ram:SpecifiedTradeSettlementMonetarySummation>\n"
					+ "</ram:SpecifiedSupplyChainTradeSettlement>\n" + "<ram:SpecifiedTradeProduct>\n"
					+ "<ram:Name>Luftballon: Bunt, ca. 500ml</ram:Name>\n" + "<ram:Description/>\n"
					+ "</ram:SpecifiedTradeProduct>\n" + "</ram:IncludedSupplyChainTradeLineItem>\n"
					+ "<ram:IncludedSupplyChainTradeLineItem>\n" + "<ram:AssociatedDocumentLineDocument>\n"
					+ "<ram:LineID>3</ram:LineID>\n" + "</ram:AssociatedDocumentLineDocument>\n"
					+ "<ram:SpecifiedSupplyChainTradeAgreement>\n" + "<ram:GrossPriceProductTradePrice>\n"
					+ "<ram:ChargeAmount currencyID=\"EUR\">0.1000</ram:ChargeAmount>\n"
					+ "<ram:BasisQuantity unitCode=\"LTR\">1.0000</ram:BasisQuantity>\n"
					+ "</ram:GrossPriceProductTradePrice>\n" + "<ram:NetPriceProductTradePrice>\n"
					+ "<ram:ChargeAmount currencyID=\"EUR\">0.1000</ram:ChargeAmount>\n"
					+ "<ram:BasisQuantity unitCode=\"LTR\">1.0000</ram:BasisQuantity>\n"
					+ "</ram:NetPriceProductTradePrice>\n" + "</ram:SpecifiedSupplyChainTradeAgreement>\n"
					+ "<ram:SpecifiedSupplyChainTradeDelivery>\n"
					+ "<ram:BilledQuantity unitCode=\"LTR\">200.0000</ram:BilledQuantity>\n"
					+ "</ram:SpecifiedSupplyChainTradeDelivery>\n" + "<ram:SpecifiedSupplyChainTradeSettlement>\n"
					+ "<ram:ApplicableTradeTax>\n" + "<ram:TypeCode>VAT</ram:TypeCode>\n"
					+ "<ram:CategoryCode>S</ram:CategoryCode>\n"
					+ "<ram:ApplicablePercent>19.00</ram:ApplicablePercent>\n" + "</ram:ApplicableTradeTax>\n"
					+ "<ram:SpecifiedTradeSettlementMonetarySummation>\n"
					+ "<ram:LineTotalAmount currencyID=\"EUR\">20.00</ram:LineTotalAmount>\n"
					+ "</ram:SpecifiedTradeSettlementMonetarySummation>\n"
					+ "</ram:SpecifiedSupplyChainTradeSettlement>\n" + "<ram:SpecifiedTradeProduct>\n"
					+ "<ram:Name>Heiße Luft pro Liter</ram:Name>\n" + "<ram:Description/>\n"
					+ "</ram:SpecifiedTradeProduct>\n" + "</ram:IncludedSupplyChainTradeLineItem>\n"
					+ "</rsm:SpecifiedSupplyChainTradeTransaction>\n" + "</rsm:CrossIndustryDocument>";
			zea1.setZUGFeRDXMLData(ownZUGFeRDXML.getBytes("UTF-8"));
			zea1.PDFattachZugferdFile(null);

			ByteArrayOutputStream baos=new ByteArrayOutputStream();
			zea1.disableAutoClose(true);
			zea1.export(TARGET_PDF);
			zea1.export(baos);
			zea1.close();
			String pdfContent=baos.toString("UTF-8");
			assertFalse(pdfContent.indexOf("(via mustangproject.org")==-1);
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		// now check the contents (like MustangReaderTest)
		ZUGFeRDImporter zi = new ZUGFeRDImporter();
		zi.extract(TARGET_PDF);
		// Reading ZUGFeRD

		String amount = null;
		String bic = null;
		String iban = null;
		String holder = null;
		String ref = null;

		if (zi.canParse()) {
			zi.parse();
			amount = zi.getAmount();
			bic = zi.getBIC();
			iban = zi.getIBAN();
			holder = zi.getHolder();
			ref = zi.getForeignReference();
		}

		assertEquals(amount, "571.04");
		assertEquals(bic, "COBADEFFXXX");
		assertEquals(iban, "DE88 2008 0000 0970 3757 00");
		assertEquals(holder, "Bei Spiel GmbH");
		assertEquals(ref, "RE-20170509/505");
	}

}
