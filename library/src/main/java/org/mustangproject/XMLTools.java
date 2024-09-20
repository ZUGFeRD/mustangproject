package org.mustangproject;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;

import org.apache.commons.io.IOUtils;
import org.dom4j.io.XMLWriter;

public class XMLTools extends XMLWriter {
	@Override
	public String escapeAttributeEntities(String s) {
		return super.escapeAttributeEntities(s);
	}

	@Override
	public String escapeElementEntities(String s) {
		return super.escapeElementEntities(s);
	}

	public static String nDigitFormat(BigDecimal value, int scale) {
		/*
		 * I needed 123,45, locale independent.I tried
		 * NumberFormat.getCurrencyInstance().format( 12345.6789 ); but that is locale
		 * specific.I also tried DecimalFormat df = new DecimalFormat( "0,00" );
		 * df.setDecimalSeparatorAlwaysShown(true); df.setGroupingUsed(false);
		 * DecimalFormatSymbols symbols = new DecimalFormatSymbols();
		 * symbols.setDecimalSeparator(','); symbols.setGroupingSeparator(' ');
		 * df.setDecimalFormatSymbols(symbols);
		 *
		 * but that would not switch off grouping. Although I liked very much the
		 * (incomplete) "BNF diagram" in
		 * http://docs.oracle.com/javase/tutorial/i18n/format/decimalFormat.html in the
		 * end I decided to calculate myself and take eur+sparator+cents
		 *
		 */
		return value.setScale(scale, RoundingMode.HALF_UP).toPlainString();

	}

	public static String encodeXML(CharSequence s) {
		if (s == null) {
			return "";
		}
		final StringBuilder sb = new StringBuilder();
		final int len = s.length();
		for (int i = 0; i < len; i++) {
			int c = s.charAt(i);
			if (c >= 0xd800 && c <= 0xdbff && i + 1 < len) {
				c = ((c - 0xd7c0) << 10) | (s.charAt(++i) & 0x3ff);    // UTF16 decode
			}
			if (c < 0x80) {      // ASCII range: test most common case first
				if (c < 0x20 && (c != '\t' && c != '\r' && c != '\n')) {
					// Illegal XML character, even encoded. Skip or substitute
					sb.append("&#xfffd;");   // Unicode replacement character
				} else {
					switch (c) {
						case '&':
							sb.append("&amp;");
							break;
						case '>':
							sb.append("&gt;");
							break;
						case '<':
							sb.append("&lt;");
							break;
						// Uncomment next two if encoding for an XML attribute
//	                  case '\''  sb.append("&apos;"); break;
//	                  case '\"'  sb.append("&quot;"); break;
						// Uncomment next three if you prefer, but not required
//	                  case '\n'  sb.append("&#10;"); break;
//	                  case '\r'  sb.append("&#13;"); break;
//	                  case '\t'  sb.append("&#9;"); break;

						default:
							sb.append((char) c);
					}
				}
			} else if ((c >= 0xd800 && c <= 0xdfff) || c == 0xfffe || c == 0xffff) {
				// Illegal XML character, even encoded. Skip or substitute
				sb.append("&#xfffd;");   // Unicode replacement character
			} else {
				sb.append("&#x");
				sb.append(Integer.toHexString(c));
				sb.append(';');
			}
		}
		return sb.toString();
	}

	/***
	 * removes utf8 byte order marks from byte arrays, in case one is there
	 * @param zugferdRaw the CII XML
	 * @return the byte array without bom
	 */
	public static byte[] removeBOM(byte[] zugferdRaw) {
		final byte[] zugferdData;
		// This handles the UTF-8 BOM 
		if ((zugferdRaw[0] == (byte) 0xEF) && (zugferdRaw[1] == (byte) 0xBB) && (zugferdRaw[2] == (byte) 0xBF)) {
			// I don't like BOMs, lets remove it
			zugferdData = new byte[zugferdRaw.length - 3];
			System.arraycopy(zugferdRaw, 3, zugferdData, 0, zugferdRaw.length - 3);
		} else {
			zugferdData = zugferdRaw;
		}
		return zugferdData;
	}

	public static byte[] getBytesFromStream(InputStream fileinput) throws IOException {
	  return IOUtils.toByteArray (fileinput);
	}

}
