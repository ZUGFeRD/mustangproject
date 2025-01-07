package org.mustangproject;

import java.io.IOException;
import java.io.InputStream;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.text.SimpleDateFormat;
import java.util.Date;

import org.apache.commons.io.IOUtils;
import org.dom4j.io.XMLWriter;
import org.mustangproject.ZUGFeRD.ZUGFeRDDateFormat;
import org.w3c.dom.Node;

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
		 * I needed 123.45, locale independent.I tried
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

	/**
	 * returns the value of an node
	 *
	 * @param node the Node to get the value from
	 * @return A String or empty String, if no value was found
	 */
	public static String getNodeValue(Node node) {
		if (node != null && node.getFirstChild() != null) {
			return node.getFirstChild().getNodeValue();
		}
		return "";
	}


	/**
	 * tries to convert a String to BigDecimal.
	 *
	 * @param nodeValue The value as String
	 * @return a BigDecimal with the value provides as String or a BigDecimal with value 0.00 if an error occurs
	 */
	public static BigDecimal tryBigDecimal(String nodeValue) {
		try {
			return new BigDecimal(nodeValue);
		} catch (final Exception e) {
			try {
				return BigDecimal.valueOf(Float.valueOf(nodeValue));
			} catch (final Exception ex) {
				return new BigDecimal("0.00");
			}
		}
	}


	/**
	 * tries to convert a Node to a BigDecimal.
	 *
	 * @param node The value as String
	 * @return a BigDecimal with the value provides as String or a BigDecimal with value 0.00 if an error occurs
	 */
	public static BigDecimal tryBigDecimal(Node node) {
		final String nodeValue = XMLTools.getNodeValue(node);
		if (nodeValue.isEmpty()) {
			return null;
		}
		return XMLTools.tryBigDecimal(nodeValue);
	}
	/***
	 * formats a number so that at least minDecimals are displayed but at the maximum maxDecimals are there, i.e.
	 * cuts potential 0s off the end until minDecimals
	 * @param value the value to be formatted
	 * @param maxDecimals number of maximal scale
	 * @param minDecimals number of minimal scale
	 * @return value as String with decimals in the specified range
	 */
	public static String nDigitFormatDecimalRange(BigDecimal value, int maxDecimals, int minDecimals) {
		if ((maxDecimals<minDecimals)||(maxDecimals<0)||(minDecimals<0)) {
			throw new IllegalArgumentException("Invalid scale range provided");
		}
		int curDecimals=maxDecimals;
		while  ( (curDecimals>minDecimals) && (value.setScale(curDecimals, RoundingMode.HALF_UP).compareTo(value.setScale(curDecimals-1, RoundingMode.HALF_UP))==0)) {
			 curDecimals--;
		}
		return value.setScale(curDecimals, RoundingMode.HALF_UP).toPlainString();

	}


	/***
	 * returns a util.Date from a 102 String yyyymmdd in a node
	 * @param node the node
	 * @return a util.Date, or null, if not parseable
	 */
	public static Date tryDate(Node node) {
		final String nodeValue = XMLTools.getNodeValue(node);
		if (nodeValue.isEmpty()) {
			return null;
		}
		return tryDate(nodeValue);
	}

	/***
	 * returns a util.Date from a 102 String yyyymmdd
	 * @param toParse the string
	 * @return a util.Date, or null, if not parseable
	 */
	public static Date tryDate(String toParse) {
		final SimpleDateFormat formatter = ZUGFeRDDateFormat.DATE.getFormatter();
		try {
			return formatter.parse(toParse);
		} catch (final Exception e) {
			return null;
		}
	}

	/***
	 * relplaces some entities like &lt; , &gt; and &amp; with their escaped pendant like &amp;lt;
	 * @param s the string
	 * @return the "safe" string
	 */
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


	public static String trimOrNull(Node node) {
		if (node != null) {
			String textContent = node.getTextContent();
			if (textContent != null) {
				return textContent.trim();
			}
		}
		return null;
	}


}
