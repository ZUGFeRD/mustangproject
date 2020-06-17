package org.mustangproject.validator;

import java.io.BufferedWriter;
import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class MiscValidatorTest extends ResourceCase  {


	public void testInvalidFileValidation() {

		ZUGFeRDValidator zfv=new ZUGFeRDValidator();

		String res=zfv.validate(null);
		assertTrue(res.matches("<\\?xml version=\"1.0\" encoding=\"UTF-8\"\\?>\n" + 
				"\n" + 
				"<validation filename=\"\" datetime=\".*?\">\n" + 
				"  <messages>\n" + 
				"    <error type=\"10\">Filename not specified</error> \n" + 
				"  </messages>\n" + 
				"  <summary status=\"invalid\"/>\n" + 
				"</validation>\n" + 
				""));

		res=zfv.validate("/dhfkbv/sfjkh");
		assertTrue(res.matches("<\\?xml version=\"1.0\" encoding=\"UTF-8\"\\?>\n" + 
				"\n" + 
				"<validation filename=\"sfjkh\" datetime=\".*?\">\n" + 
				"  <messages>\n" + 
				"    <error type=\"1\">File not found</error> \n" + 
				"  </messages>\n" + 
				"  <summary status=\"invalid\"/>\n" + 
				"</validation>\n"));

		boolean noExceptionOccurred=true;
		File tempFile=null;
		try {
			tempFile = File.createTempFile("hello", ".tmp");
		} catch (IOException e) {
			noExceptionOccurred=true;
		}
		assertTrue(noExceptionOccurred);

		res=zfv.validate(tempFile.getAbsolutePath());
		assertTrue(res.matches("<\\?xml version=\"1.0\" encoding=\"UTF-8\"\\?>\n" + 
				"\n" + 
				"<validation filename=\".*\" datetime=\".*\">\n" + 
				"  <messages>\n" + 
				"    <error type=\"5\">File too small</error> \n" + 
				"  </messages>\n" + 
				"  <summary status=\"invalid\"/>\n" + 
				"</validation>\n" + 
				""));
		
		
		String fileContent = "ladhvkdbfk  wkhfbkhdhkb svbkfsvbksfbvk sdvsdvbksjdvbkfdsv sdvbskdvbsjhkvbfskh dvbskfvbkfsbvke"
				+ "ladhvkdbfk  wkhfbkhdhkb svbkfsvbksfbvk sdvsdvbksjdvbkfdsv sdvbskdvbsjhkvbfskh dvbskfvbkfsbvke";
		noExceptionOccurred=true;
	    BufferedWriter writer;
		try {
			writer = new BufferedWriter(new FileWriter(tempFile));
		    writer.write(fileContent);
		    writer.close();
		} catch (IOException e) {
			noExceptionOccurred=false;
		}
		assertTrue(noExceptionOccurred);
 

		res=zfv.validate(tempFile.getAbsolutePath());
		assertTrue(res.matches("<\\?xml version=\"1.0\" encoding=\"UTF-8\"\\?>\n" + 
				"\n" + 
				"<validation filename=\".*\" datetime=\".*\">\n" + 
				"  <messages>\n" + 
				"    <exception type=\"8\">File does not look like PDF nor XML \\(contains neither %PDF nor &lt;\\?xml\\)</exception> \n" + 
				"  </messages>\n" + 
				"  <summary status=\"invalid\"/>\n" + 
				"</validation>\n" + 
				""));

		
		// clean up
		tempFile.delete();
		
	}
	
}
