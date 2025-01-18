package org.mustangproject.ZUGFeRD;

import static org.junit.Assert.assertEquals;

import java.io.IOException;
import java.nio.charset.Charset;
import java.text.ParseException;
import java.util.Date;

import org.junit.Test;

public class InvoicingPeriodTestCase {
	@Test
	public void readBillingSpecification() throws IOException {
		final String file = ResourceUtilities.readFile(Charset.defaultCharset(),
				"src/test/resources/factur-x_invoicingPeriod.xml");
		final ZUGFeRDImporter zi = new XRechnungImporter(file.getBytes());

		// Reading ZUGFeRD
		assertEquals(date("20220829"), zi.getLineItemList().get(0).getDetailedDeliveryPeriodFrom());
		assertEquals(date("20220831"), zi.getLineItemList().get(0).getDetailedDeliveryPeriodTo());
		assertEquals(date("20220901"), zi.getLineItemList().get(1).getDetailedDeliveryPeriodFrom());
		assertEquals(date("20220902"), zi.getLineItemList().get(1).getDetailedDeliveryPeriodTo());
		assertEquals(null, zi.getLineItemList().get(2).getDetailedDeliveryPeriodFrom());
		assertEquals(date("20220909"), zi.getLineItemList().get(2).getDetailedDeliveryPeriodTo());
		assertEquals(date("20220826"), zi.getDetailedDeliveryPeriodFrom());
		assertEquals(date("20220902"), zi.getDetailedDeliveryPeriodTo());
		//general asserts
		assertEquals("1634.76", zi.getAmount());
		assertEquals("RE1000", zi.getInvoiceID());
		assertEquals("Sell", zi.getSellerTradePartyAddress().getCityName());
		assertEquals("Beier", zi.getBuyerTradePartyName());
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
