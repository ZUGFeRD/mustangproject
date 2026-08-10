package org.mustangproject.ZUGFeRD;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNull;
import static org.junit.Assert.fail;

import java.io.IOException;
import java.nio.charset.Charset;
import java.text.ParseException;
import java.util.Date;

import javax.xml.xpath.XPathExpressionException;

import org.junit.Test;
import org.mustangproject.Invoice;

public class InvoicingPeriodTestCase {
	@Test
	public void readBillingSpecification() throws IOException {
		final String file = ResourceUtilities.readFile(Charset.defaultCharset(), "src/test/resources/factur-x_invoicingPeriod.xml");
		final ZUGFeRDImporter zi = new XRechnungImporter(file.getBytes());

		try {
			Invoice invoice = zi.extractInvoice();

			// Reading ZUGFeRD
			assertEquals(date("20220829"), invoice.getZFItems()[0].getDetailedDeliveryPeriodFrom());
			assertEquals(date("20220831"), invoice.getZFItems()[0].getDetailedDeliveryPeriodTo());

			assertEquals(date("20220901"), invoice.getZFItems()[1].getDetailedDeliveryPeriodFrom());
			assertEquals(date("20220902"), invoice.getZFItems()[1].getDetailedDeliveryPeriodTo());

			assertNull(invoice.getZFItems()[2].getDetailedDeliveryPeriodFrom());
			assertEquals(date("20220909"), invoice.getZFItems()[2].getDetailedDeliveryPeriodTo());

			assertEquals(date("20220826"), zi.getDetailedDeliveryPeriodFrom());
			assertEquals(date("20220902"), zi.getDetailedDeliveryPeriodTo());
			//general asserts
			assertEquals("1634.76", zi.getAmount());
			assertEquals("RE1000", zi.getInvoiceID());
			assertEquals("Sell", zi.getSellerTradePartyAddress().getCityName());
			assertEquals("Beier", zi.getBuyerTradePartyName());
		} catch ( ParseException | XPathExpressionException e ) {
			fail(e.getMessage());
		}
	}

	private Date date(String toParse){
		try {
			return ZUGFeRDDateFormat.DATE.getFormatter().parse(toParse);
		}
		catch (final ParseException e) {
			return null;
		}
	}
}
