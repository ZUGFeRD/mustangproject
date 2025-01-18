package org.mustangproject.ZUGFeRD;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import org.apache.pdfbox.io.IOUtils;
import org.apache.pdfbox.preflight.parser.PreflightParser;

import jakarta.activation.DataSource;

// Copied from PDFBox preflight 2.0.x 
final class ByteArrayDataSource implements DataSource
{
	private ByteArrayOutputStream data;
	private String type = null;
	private String name = null;

	public ByteArrayDataSource (InputStream is) throws IOException
	{
		data = new ByteArrayOutputStream ();
		IOUtils.copy (is, data);
		IOUtils.closeQuietly (is);
	}

	public String getContentType ()
	{
		return this.type;
	}

	/**
	 * @param type
	 *              the type to set
	 */
	public void setType (String type)
	{
		this.type = type;
	}

	/**
	 * @param name
	 *              the name to set
	 */
	public void setName (String name)
	{
		this.name = name;
	}

	public InputStream getInputStream () throws IOException
	{
		return new ByteArrayInputStream (data.toByteArray ());
	}

	public String getName ()
	{
		return this.name;
	}

	public OutputStream getOutputStream () throws IOException
	{
		this.data = new ByteArrayOutputStream ();
		return data;
	}
}

// Try to create an API similar to the 2.x one
final class PreflightParserHelper
{
	private static File createTmpFile (InputStream input) throws IOException
	{
		FileOutputStream fos = null;
		try
		{
			File tmpFile = File.createTempFile ("mustang-pdf", ".pdf");
			fos = new FileOutputStream (tmpFile);
			IOUtils.copy (input, fos);
			return tmpFile;
		}
		finally
		{
			IOUtils.closeQuietly (input);
			IOUtils.closeQuietly (fos);
		}
	}

	public static PreflightParser createPreflightParser (DataSource dataSource) throws IOException
	{
		return new PreflightParser (createTmpFile (dataSource.getInputStream ()));
	}
}

final class PDFBoxUpdateMitigation
{
	// Dummy for the name only
}
