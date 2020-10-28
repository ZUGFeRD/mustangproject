package org.mustangproject;

public class FileAttachment {

	protected String filename;
	protected String mimetype;
	protected String relation;
	protected String description;
	protected byte[] data;

	public FileAttachment(String filename, String mimetype, String relation, byte[] data) {
		this.filename = filename;
		this.mimetype = mimetype;
		this.relation = relation;
		this.data = data;
		description = "Additional file attachment";
	}

	public String getDescription() {
		return description;
	}

	public FileAttachment setDescription(String description) {
		this.description = description;
		return this;
	}

	public String getFilename() {
		return filename;
	}

	public FileAttachment setFilename(String filename) {
		this.filename = filename;
		return this;
	}

	public String getMimetype() {
		return mimetype;
	}

	public FileAttachment setMimetype(String mimetype) {
		this.mimetype = mimetype;
		return this;
	}

	public String getRelation() {
		return relation;
	}

	public FileAttachment setRelation(String relation) {
		this.relation = relation;
		return this;
	}

	public byte[] getData() {
		return data;
	}

	public FileAttachment setData(byte[] data) {
		this.data = data;
		return this;
	}




}
