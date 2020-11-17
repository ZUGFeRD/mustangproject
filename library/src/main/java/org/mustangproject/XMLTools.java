package org.mustangproject;

import java.io.ByteArrayInputStream;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.logging.Level;
import java.util.logging.Logger;

import org.dom4j.io.XMLWriter;
import org.mustangproject.ZUGFeRD.ZUGFeRD2PullProvider;

public class XMLTools extends XMLWriter {
	public String escapeAttributeEntities(String s) {
		return super.escapeAttributeEntities(s);
	}

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
		StringBuilder sb = new StringBuilder();
		int len = s.length();
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


	/**
	 * Returns the Byte Order Mark size and thus allows to skips over a BOM
	 * at the beginning of the given ByteArrayInputStream, if one exists.
	 *
	 * @param is the ByteArrayInputStream used
	 * @throws IOException if can not be read from is
	 * @see <a href="https://www.w3.org/TR/xml/#sec-guessing">Autodetection of Character Encodings</a>
	 *
	public static int guessBOMSize(ByteArrayInputStream is) throws IOException {
		byte[] pad = new byte[4];
		is.read(pad);
		is.reset();
		int test2 = ((pad[0] & 0xFF) << 8) | (pad[1] & 0xFF);
		int test3 = ((test2 & 0xFFFF) << 8) | (pad[2] & 0xFF);
		int test4 = ((test3 & 0xFFFFFF) << 8) | (pad[3] & 0xFF);
		//
		if (test4 == 0x0000FEFF || test4 == 0xFFFE0000 || test4 == 0x0000FFFE || test4 == 0xFEFF0000) {
			// UCS-4: BOM takes 4 bytes
			return 4;
		} else if (test3 == 0xEFBBFF) {
			// UTF-8: BOM takes 3 bytes
			return 3;
		} else if (test2 == 0xFEFF || test2 == 0xFFFE) {
			// UTF-16: BOM takes 2 bytes
			return 2;
		}
		return 0;
	}*/

	/***
	 * removes utf8 byte order marks from byte arrays, in case one is there
	 * @param zugferdRaw the CII XML
	 * @return the byte array without bom
	 */
	public static byte[] removeBOM(byte[] zugferdRaw) {
		byte[] zugferdData;
		if ((zugferdRaw[0] == (byte) 0xEF) && (zugferdRaw[1] == (byte) 0xBB) && (zugferdRaw[2] == (byte) 0xBF)) {
			// I don't like BOMs, lets remove it
			zugferdData = new byte[zugferdRaw.length - 3];
			System.arraycopy(zugferdRaw, 3, zugferdData, 0, zugferdRaw.length - 3);
		} else {
			zugferdData = zugferdRaw;
		}
		return zugferdData;
	}


}
