package mustang;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.File;
import java.nio.file.*;

import javax.annotation.security.RolesAllowed;
import javax.ws.rs.Consumes;
import javax.ws.rs.POST;
import javax.ws.rs.Path;
import javax.ws.rs.Produces;
import javax.ws.rs.core.HttpHeaders;
import javax.ws.rs.core.MediaType;
import javax.ws.rs.core.Response;

import org.glassfish.jersey.media.multipart.FormDataContentDisposition;
import org.glassfish.jersey.media.multipart.FormDataParam;
import org.mustangproject.ZUGFeRD.ZUGFeRDConformanceLevel;
import org.mustangproject.ZUGFeRD.ZUGFeRDExporter;
import org.mustangproject.ZUGFeRD.ZUGFeRDExporterFromA1Factory;
import org.mustangproject.ZUGFeRD.ZUGFeRDImporter;

import org.mustangproject.library.extended.ZUGFeRDValidator;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.pdf.PdfWriter;
import com.itextpdf.tool.xml.XMLWorkerHelper;

import io.swagger.annotations.Api;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import io.swagger.annotations.License;
import io.swagger.annotations.Info;
import io.swagger.annotations.SwaggerDefinition;

@Path("/mustang")
@Produces(MediaType.APPLICATION_JSON)
@Api(value = "Mustang")
@SwaggerDefinition(info = @Info(description = "Rest API to read/write hybrid (ZUGFeRD/Factur-X) e-invoices with a Mustang Server", version = "V0.0.2", title = "Mustangproject API", license = @License(name = "Apache 2.0", url = "http://www.apache.org")

), schemes = { SwaggerDefinition.Scheme.HTTP, SwaggerDefinition.Scheme.HTTPS })
public class MustangResource {

	Logger logger = LoggerFactory.getLogger(MustangResource.class.getName());

	public MustangResource() {
	}

	@POST
	@Path("/extract")
	// @RolesAllowed("ADMIN")
	@Consumes(MediaType.MULTIPART_FORM_DATA)
	@Produces(MediaType.APPLICATION_XML)
	@ApiOperation(value = "Extracts XML from a zf/fx PDF", notes = "Input PDF must be ZUGFeRD or Factur-X")
	public String extractFile(
			@ApiParam(required = true, value = "Input ZUGFeRD/Factur-X file") @FormDataParam("file") final InputStream fileInputStream,
			@FormDataParam("file") final FormDataContentDisposition contentDispositionHeader) {

		ZUGFeRDImporter zi;
		logger.debug("Reading...");
		zi = new ZUGFeRDImporter(fileInputStream);
		return "<response>" + zi.getUTF8() + "</response>";
	}

	@POST
	@Path("/validateFX")
	// @RolesAllowed("ADMIN")
	@Consumes(MediaType.MULTIPART_FORM_DATA)
	@Produces(MediaType.APPLICATION_XML)
	@ApiOperation(value = "Validates a ZUGFeRD PDF file", notes = "Input PDF must be ZUGFeRD or Factur-X")
	public String validateFX(
			@ApiParam(required = true, value = "Input ZUGFeRD/Factur-X file") @FormDataParam("file") final InputStream fileInputStream,
			@FormDataParam("file") final FormDataContentDisposition contentDispositionHeader) {
		ZUGFeRDValidator zfv = new ZUGFeRDValidator();
		String validationResult = "";
		try {

			final File tempFile = File.createTempFile("tovalidate", ".pdf");
			tempFile.deleteOnExit();

			Files.copy(fileInputStream, tempFile.toPath(), StandardCopyOption.REPLACE_EXISTING);

			validationResult = zfv.validate(tempFile.getAbsolutePath());
		} catch (Exception ex) {
			logger.error(ex.getMessage(),ex);
		}

		logger.debug("Validating...");
		return validationResult;
	}

	@POST
	@Path("/combine")
	@RolesAllowed("ADMIN")
	@Consumes(MediaType.MULTIPART_FORM_DATA)
	@Produces(MediaType.APPLICATION_OCTET_STREAM)
	@ApiOperation(value = "Combine PDF file and custom XML to zf/fx PDF", notes = "Input PDF must be PDF/A-1, output PDF will be a ZUGFeRD/Factur-X PDF/A-3 file called invoice.pdf. Demo authentication good-guy:secret")
	public Response combineFile(
			@ApiParam(required = true, value = "Input PDF/A-1 file") @FormDataParam("file") final InputStream fileInputStream,
			@FormDataParam("file") final FormDataContentDisposition contentDispositionHeader,
			@ApiParam(required = true, value = "The zf/fx XML to add to the file") @FormDataParam("xml") String XML,
			@ApiParam(required = true, defaultValue = "zf", value = "zf|fx:zf for ZUGFeRD, fx for Factur-X") @FormDataParam("format") String format,
			@ApiParam(required = true, defaultValue = "2", value = "version, i.e. fx 1 or zf 1 or 2") @FormDataParam("version") int version,
			@ApiParam(required = true, defaultValue = "EN16931", value = "Profile: BASIC|COMFORT|EXTENDED for zf1, MINIMUM|BASICWL|BASIC|CIUS|EN16931|EXTENDED for zf2/fx1") @FormDataParam("profile") String profile) {

		ZUGFeRDExporter ze;
		ByteArrayOutputStream output = new ByteArrayOutputStream();

		try {
			logger.debug("Converting to PDF/A-3u");

			if ((version < 1) || (version > 2)) {
				// this should be checked with annotations but I did not get it to work
				throw new IllegalArgumentException("invalid version");
			}

			// this should be restricted to the enum with annotations but I did not get it
			// to work
			ZUGFeRDConformanceLevel prof = ZUGFeRDConformanceLevel.valueOf(profile);
			/*
			 * Add .setZUGFeRDVersion and .setZUGFeRDConformanceLevel in the next lines to
			 * set the ZUGFeRD version respective profile of the XML you are inserting.
			 */
			ze = new ZUGFeRDExporterFromA1Factory().setProducer("Mustang API")
					.setCreator(System.getProperty("user.name")).setZUGFeRDVersion(version)
					.setZUGFeRDConformanceLevel(prof).load(fileInputStream);
			logger.debug("Attaching ZUGFeRD-Data");
			if (format.equalsIgnoreCase("fx")) {
				ze.setFacturX();
			}
			ze.setZUGFeRDXMLData(XML.getBytes("UTF-8"));
			logger.debug("Writing ZUGFeRD-PDF");

			ze.export(output);
		} catch (IOException e) {
			e.printStackTrace();
		}
		byte[] bytes = output.toByteArray();
		InputStream inputStream = new ByteArrayInputStream(bytes);

		return Response.ok(inputStream).header(HttpHeaders.CONTENT_DISPOSITION, "attachment; filename=\"invoice.pdf\"")
				.build();

	}

	@POST
	@Path("/test")
	@Consumes(MediaType.APPLICATION_JSON)
	@Produces(MediaType.APPLICATION_JSON)
	@ApiOperation(value = "Returns a hello world", notes = "Just a test")
	public Response test() {

		return Response.status(Response.Status.OK).entity("{\"payload\":\"test\"}").build();

	}

}