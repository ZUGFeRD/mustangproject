package org.mustangproject;

import com.fasterxml.jackson.annotation.JsonIgnoreProperties;
import com.fasterxml.jackson.annotation.JsonInclude;

@JsonIgnoreProperties(ignoreUnknown = true)
@JsonInclude(JsonInclude.Include.NON_EMPTY)
public class FileAttachment {

	protected String filename;
	protected String mimetype;
	protected String relation = "Unspecified";
	protected String description = "Additional file attachment";
	protected byte[] data;


	/***
	 * bean contructor
	 */
	public FileAttachment() {

	}

	public FileAttachment(String filename, String mimetype, String relation, byte[] data, String description) {
		this.filename = filename;
		this.mimetype = mimetype;
		this.relation = relation;
		this.data = data;
		this.description = description;
	}

	public FileAttachment(String filename, String mimetype, String relation, byte[] data) {
		this.filename = filename;
		this.mimetype = mimetype;
		this.relation = relation;
		this.data = data;
	}

	public FileAttachment(String filename, String mimetype, byte[] data) {
		this.filename = filename;
		this.mimetype = mimetype;
		this.data = data;
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

	/***
	 * only needed when embedded in PDF described
	 *
	 * values
	 * 	- Source shall be used if this file specification is the original
	 * source material for the associated content.
	 * 	- Data shall be used if this file specification represents information
	 * used to derive a visual presentation, such as for a table or a
	 * graph.
	 * 	- Alternative shall be used if this file specification is an alternative
	 * representation of content, for example audio.
	 * 	- Supplement shall be used if this file specification represents a
	 * supplemental representation of the original source or data that
	 * may be more easily consumable (e.g. A MathML version of an
	 * equation).
	 * 	- Unspecified shall be used when the relationship is not known
	 * or cannot be described using one of the other values.
	 * @param relation String: either : Source, Data or Alternative. Usually Data, except source if the file attachment
	 *                    is the basis for the pdf (xrechnung2fx) or Alternative if it contains the same content (e.g. the
	 *                 factur-x.xml file in a factur-x PDF)
	 * @return fluent setter
	 */
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
