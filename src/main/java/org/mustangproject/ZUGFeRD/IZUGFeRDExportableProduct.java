package org.mustangproject.ZUGFeRD;
import java.math.BigDecimal;
/**
 * Mustangproject's ZUGFeRD implementation
 * Necessary interface for ZUGFeRD exporter
 * Licensed under the APLv2
 * @date 2014-05-10
 * @version 1.2.0
 * @author jstaerk
 * */

public interface IZUGFeRDExportableProduct {

	/**
	 * Unit code of the product
	 * Most common ones are
			C62	one (piece)
			DAY	day
			HAR	hectare
			HUR	hour
			KGM	kilogram
			KTM	kilometre
			KWH	kilowatt hour
			LS	lump sum
			LTR	litre
			MIN	minute
			MMK	square millimetre
			MMT	millimetre
			MTK	square metre
			MTQ	cubic metre
			MTR	metre
			NAR	number of articles
			NPR	number of pairs
			P1	percent
			SET	set
			TNE	tonne (metric ton)
			WEE	week

	 * @return
	 */
	String getUnit();

	/**
	 * Short name of the product
	 * @return
	 */
	String getName();

	/**
	 * long description of the product
	 * @return
	 */
	String getDescription();

	/**
	 * VAT percent of the product (e.g. 19, or 5.1 if you like)
	 * @return
	 */
	BigDecimal getVATPercent();

}
