package ZUV;


public class XMLTools {
	public static String encodeXML(CharSequence s) {
	    StringBuilder sb = new StringBuilder();
	    int len = s.length();
	    for (int i=0;i<len;i++) {
	        int c = s.charAt(i);
	        if (c >= 0xd800 && c <= 0xdbff && i + 1 < len) {
	            c = ((c-0xd7c0)<<10) | (s.charAt(++i)&0x3ff);    // UTF16 decode
	        }
	        if (c < 0x80) {      // ASCII range: test most common case first
	            if (c < 0x20 && (c != '\t' && c != '\r' && c != '\n')) {
	                // Illegal XML character, even encoded. Skip or substitute
	                sb.append("&#xfffd;");   // Unicode replacement character
	            } else {
	                switch(c) {
	                  case '&':  sb.append("&amp;"); break;
	                  case '>':  sb.append("&gt;"); break;
	                  case '<':  sb.append("&lt;"); break;
	                  // Uncomment next two if encoding for an XML attribute
//	                  case '\''  sb.append("&apos;"); break;
//	                  case '\"'  sb.append("&quot;"); break;
	                  // Uncomment next three if you prefer, but not required
//	                  case '\n'  sb.append("&#10;"); break;
//	                  case '\r'  sb.append("&#13;"); break;
//	                  case '\t'  sb.append("&#9;"); break;

	                  default:   sb.append((char)c);
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
	public static String encodeAttribute(String s) {
		String res=s.replace("\n", "").replace("\r", "").replace("\"", "");
		
		return XMLTools.encodeXML(res);
	
	}

}
