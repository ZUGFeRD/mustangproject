package org.mustangproject;

import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;

import java.text.SimpleDateFormat;
import java.util.Base64;
import java.util.Date;

import org.mustangproject.ZUGFeRD.IReferencedDocument;
import org.mustangproject.util.NodeMap;
import org.mustangproject.util.StringUtils;
import org.w3c.dom.Node;

@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class ReferencedDocument implements IReferencedDocument {

	private String issuerAssignedID;
	private String uriID;
	private String lineID;
	private String typeCode;
	private String name;
	private FileAttachment attachmentBinaryObject;
	private String referenceTypeCode;
	private Date formattedIssueDateTime;

	public ReferencedDocument() {
		//bean
	}

	public ReferencedDocument(String issuerAssignedID, String typeCode, String referenceTypeCode) {
		this(issuerAssignedID);
		this.typeCode = typeCode;
		this.referenceTypeCode = referenceTypeCode;
	}

	public ReferencedDocument(String issuerAssignedID, String typeCode, String referenceTypeCode, Date formattedIssueDateTime) {
		this(issuerAssignedID, typeCode, referenceTypeCode);
		this.formattedIssueDateTime = formattedIssueDateTime;
	}

	public ReferencedDocument(String issuerAssignedID, String referenceTypeCode) {
		this(issuerAssignedID, "916", referenceTypeCode); // additional invoice related document
	}

	public ReferencedDocument(String issuerAssingedID, Date formattedIssueDateTime) {
		this(issuerAssingedID);
		this.formattedIssueDateTime = formattedIssueDateTime;
	}

	public ReferencedDocument(String issuerAssignedID) {
		if (StringUtils.isNotBlank(issuerAssignedID)) {
			this.issuerAssignedID = issuerAssignedID;
		}
	}

	/***
	 * sets an ID assigned by the sender
	 * @param issuerAssignedID the ID as a string :-)
	 */
	public ReferencedDocument setIssuerAssignedID(String issuerAssignedID) {
		this.issuerAssignedID = issuerAssignedID;
		return this;
	}

	/**
	 * @param uriID the uriID to set
	 */
	public ReferencedDocument setUriID(String uriID) {
		this.uriID = uriID;
		return this;
	}

	/***
	 * sets an ID assigned by the sender
	 * @param lineID the ID as a string :-)
	 */
	public ReferencedDocument setLineID(String lineID) {
		this.lineID = lineID;
		return this;
	}

	/**
	 * which type is the document? e.g. "916" for additional invoice related
	 *
	 * @param typeCode as String, e.g. 916
	 */
	public ReferencedDocument setTypeCode(String typeCode) {
		this.typeCode = typeCode;
		return this;
	}

	/**
	 * Name of the document.
	 * @param name as String
	 */
	public ReferencedDocument setName(String name) {
		this.name = name;
		return this;
	}

	/**
	 * @param attachmentBinaryObject the attachmentBinaryObject to set
	 */
	public ReferencedDocument setAttachmentBinaryObject(FileAttachment attachmentBinaryObject) {
		this.attachmentBinaryObject = attachmentBinaryObject;
		return this;
	}

	/**
	 * type of the reference of this line, a UNTDID 1153 code
	 *
	 * @param referenceTypeCode three uppercase character reference type code as string
	 */
	public ReferencedDocument setReferenceTypeCode(String referenceTypeCode) {
		this.referenceTypeCode = referenceTypeCode;
		return this;
	}

	/**
	 * issue date of this line
	 *
	 * @param formattedIssueDateTime as Date
	 */
	public ReferencedDocument setFormattedIssueDateTime(Date formattedIssueDateTime) {
		this.formattedIssueDateTime = formattedIssueDateTime;
		return this;
	}

	@Override
	public String getIssuerAssignedID() {
		return issuerAssignedID;
	}

	/**
	 * @return the uriID
	 */
	public String getUriID() {
		return uriID;
	}

	@Override
	public String getLineID() {
		return lineID;
	}

	@Override
	public String getTypeCode() {
		return typeCode;
	}

	@Override
	public String getName() {
		return name;
	}

	/**
	 * @return the attachmentBinaryObject
	 */
	public FileAttachment getAttachmentBinaryObject() {
		return attachmentBinaryObject;
	}

	@Override
	public String getReferenceTypeCode() {
		return referenceTypeCode;
	}

	@Override
	public Date getFormattedIssueDateTime() {
		return formattedIssueDateTime;
	}

	public static ReferencedDocument fromNode(Node node) {
		if (!node.hasChildNodes()) {
			return null;
		}
		NodeMap nodes = new NodeMap(node);
		ReferencedDocument rd = new ReferencedDocument(nodes.getAsStringOrNull("IssuerAssignedID", "ID"),
			nodes.getAsStringOrNull("TypeCode", "DocumentTypeCode"),
			nodes.getAsStringOrNull("ReferenceTypeCode"));

		nodes.getNode("URIID").ifPresent(childNode -> rd.setUriID(childNode.getTextContent()));
		nodes.getNode("LineID").ifPresent(childNode -> rd.setLineID(childNode.getTextContent()));
		nodes.getNode("Name", "SalesOrderID").ifPresent(childNode -> rd.setName(childNode.getTextContent()));
		nodes.getNode("AttachmentBinaryObject").ifPresent(childNode -> rd.setAttachmentBinaryObject(new FileAttachment(childNode.getAttributes().getNamedItem("filename").getNodeValue(), childNode.getAttributes().getNamedItem("mimeCode").getNodeValue(), "Data", Base64.getMimeDecoder().decode(XMLTools.trimOrNull(childNode)))));
		nodes.getAsNodeMap("FormattedIssueDateTime")
			.flatMap(fdt -> fdt.getNode("DateTimeString"))
			.map(XMLTools::getNodeValue)
			.map(XMLTools::tryDate)
			.ifPresent(d -> rd.setFormattedIssueDateTime(d));

		// Try UBL format: IssueDate (direct text content)
		String issueDateString = nodes.getAsStringOrNull("IssueDate");
		if (issueDateString != null) {
			rd.setFormattedIssueDateTime(XMLTools.tryDate(issueDateString));
		}

		if (nodes.getAsStringOrNull("ID") != null) {
			// sure sign for UBL: here ReferenceTypeCode is no element but a "schemeID" attribute to ID
			Node childNode = nodes.getNode("ID").get();
			if (childNode != null) {
				Node schemeIDAttr = childNode.getAttributes().getNamedItem("schemeID");
				if (schemeIDAttr != null && schemeIDAttr.getNodeValue() != null && !schemeIDAttr.getNodeValue().trim().isEmpty()) {
					rd.setReferenceTypeCode(schemeIDAttr.getNodeValue());
				}
			}
		}
		return rd;
	}
	/***
	 * @return this particular ReferencedDocument industry invoice XML
	 */
	@JsonIgnore
	public String getAsCII() {
		StringBuilder xml = new StringBuilder();
		if (StringUtils.isNotBlank(this.getIssuerAssignedID())) {
			xml.append("<ram:IssuerAssignedID>" + XMLTools.encodeXML(this.getIssuerAssignedID()) + "</ram:IssuerAssignedID>" );
		}
		if (StringUtils.isNotBlank(this.getUriID())) {
			xml.append("<ram:URIID>" + XMLTools.encodeXML(this.getLineID()) + "</ram:URIID>" );
		}
		if (StringUtils.isNotBlank(this.getLineID())) {
			xml.append("<ram:LineID>" + XMLTools.encodeXML(this.getLineID()) + "</ram:LineID>" );
		}
		if (StringUtils.isNotBlank(this.getTypeCode())) {
			xml.append("<ram:TypeCode>" + XMLTools.encodeXML(this.getTypeCode()) + "</ram:TypeCode>");
		}
		if (StringUtils.isNotBlank(this.getName())) {
			xml.append("<ram:name>" + XMLTools.encodeXML(this.getName()) + "</ram:Name>");
		}
		if (this.getAttachmentBinaryObject() != null) {
			FileAttachment f = this.getAttachmentBinaryObject();
			String documentContent = Base64.getEncoder().encodeToString(f.getData());
			xml.append("<ram:AttachmentBinaryObject mimeCode=\"" + f.getMimetype() + "\" " + " filename=\"" + f.getFilename() + "\">" + documentContent + "</ram:AttachmentBinaryObject>");
		}
		if (StringUtils.isNotBlank(this.getReferenceTypeCode())) {
			xml.append("<ram:ReferenceTypeCode>" + XMLTools.encodeXML(this.getReferenceTypeCode()) + "</ram:ReferenceTypeCode>");
		}
		if (this.getFormattedIssueDateTime() != null) {
			final SimpleDateFormat dateFormat102 = new SimpleDateFormat("yyyyMMdd");
			xml.append("<ram:FormattedIssueDateTime><qdt:DateTimeString format=\"102\">" + XMLTools.encodeXML(dateFormat102.format(this.getFormattedIssueDateTime())) + "</qdt:DateTimeString></ram:FormattedIssueDateTime>");
		}
		return xml.toString();
	}
}
