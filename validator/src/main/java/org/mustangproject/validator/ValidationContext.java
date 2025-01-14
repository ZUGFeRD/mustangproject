package org.mustangproject.validator;

import java.util.ArrayList;
import java.util.List;
import java.util.Vector;

import org.slf4j.Logger;

public class ValidationContext {
	protected Vector<ValidationResultItem> results;
	protected String customXML = "";
	private String format = "CII";// CII or UBL
	private String generation = null; // generation 1 is ZF1, gen 2 is ZF2, XRechnung, Factur-X or UBL
	private String profile = null;
	private String signature = null;
	private boolean isValid = true;
	protected Logger logger;
	private String filename;

	public ValidationContext(Logger log) {
		logger = log;
		results = new Vector<>();
	}

	public void addResultItem(ValidationResultItem vr) throws IrrecoverableValidationError {
		results.add(vr);

		if ((vr.getSeverity() == ESeverity.fatal) || (vr.getSeverity() == ESeverity.exception)
				|| (vr.getSeverity() == ESeverity.error)) {
			isValid = false;

		}
		if (logger != null) {
			if ((vr.getSeverity() == ESeverity.fatal) || (vr.getSeverity() == ESeverity.exception)) {
				logger.error("Fatal Error " + vr.getSection() + ": " + vr.getMessage());
			} else if ((vr.getSeverity() == ESeverity.error)) {
				logger.error("Error " + vr.getSection() + ": " + vr.getMessage());
			} else if (vr.getSeverity() == ESeverity.warning) {
				logger.warn("Warning " + vr.getSection() + ": " + vr.getMessage());
			} else if (vr.getSeverity() == ESeverity.notice) {
				logger.info("Notice " + vr.getSection() + ": " + vr.getMessage());
			}
		}

		if ((vr.getSeverity() == ESeverity.fatal) || (vr.getSeverity() == ESeverity.exception)) {
			throw new IrrecoverableValidationError(vr.getMessage());
		}

	}

	public void clearCustomXML() {
		customXML = "";
	}
	
	public void addCustomXML(String XML) {
		customXML += XML;
	}

	public String getCustomXML() {
		return customXML;
	}

	public void setFormat(String format) {
		this.format=format;
	}

	public ValidationContext setGeneration(String version) {
		this.generation = version;
		return this;
	}

	public ValidationContext setProfile(String profile) {
		this.profile = profile.trim();
		return this;
	}

	public ValidationContext setSignature(String signature) {
		this.signature = signature;
		return this;
	}

	public String getGeneration() {
		return generation;
	}

	public String getProfile() {
		return profile;
	}

	public String getSignature() {
		return signature;
	}

	public boolean isValid() {
		return isValid;
	}

	public void clear() {
		results.clear();
		isValid = true;
		clearCustomXML();
		generation = null;
		profile = null;
		signature = null;

	}

	public String getXMLResult() {
		String res = getCustomXML();
		if (results.size() > 0) {
			res += "<messages>";
		}

		for (final ValidationResultItem validationResultItem : results) {
			// xml and pdf are handled in their respective sections
			res += validationResultItem.getXMLOnce() + "\n";	
		}
		if (results.size() > 0) {
			res += "</messages>";
		}
		res += "<summary status=\"" + (isValid ? "valid" : "invalid") + "\"/>";
		return res;
	}

	/***
	 *
	 * @return the unique error types as comma separated string
	 */
	public String getCSVResult() {
		final ArrayList<String> errorcodes = new ArrayList<>();
		for (final ValidationResultItem validationResultItem : results) {
			final String errorCodeStr=Integer.toString(validationResultItem.getSection());
			errorcodes.add(errorCodeStr);
		}
		return String.join(",", errorcodes);
	}

	/***
	 *
	 * @return the unique error IDs as comma separated string
	 */
	public String getCSVIDResult() {
		final ArrayList<String> errorIDs = new ArrayList<>();
		for (final ValidationResultItem validationResultItem : results) {
			if (!validationResultItem.getID().isEmpty()) {
				final String errorID=validationResultItem.getID();
				errorIDs.add(errorID);

			}
		}
		return String.join(",", errorIDs);
	}

	public void setInvalid() {
		isValid = false;
	}

	public void setFilename(String filename) {
		this.filename=filename;
	}
	public String getFilename() {
		if (filename==null) {
			return "";
		} else {
			return filename;
		}
	}

	public String getFormat() {
		return format;
	}

	public List<ValidationResultItem> getResults() {
		return results;
	}

}
