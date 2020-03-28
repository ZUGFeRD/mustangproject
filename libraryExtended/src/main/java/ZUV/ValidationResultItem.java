package ZUV;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

public class ValidationResultItem {
	private static final Logger LOGGER = LoggerFactory.getLogger(ValidationResultItem.class.getCanonicalName()); // log output is
	// ignored for the
	// time being

	
	protected String message, location=null;
	protected int section =-1;


	private ESeverity severity=ESeverity.error;
	private String criterion=null;


	private String stacktrace=null;
	private boolean hasBeenOutputted=false;


	private EPart part;

	public ValidationResultItem(ESeverity sev, String msg) {
		setSeverity(sev);
		setMessage(msg);
	}
	public ValidationResultItem setMessage(String msg) {
		message=msg;
		return this;
	}

	public ValidationResultItem setSection(int sec) {
		section=sec;
		return this;
	}	
	public ValidationResultItem setLocation(String loc) {
		location=loc;
		return this;
	}
	public ValidationResultItem setPart(EPart loc) {
		part=loc;
		return this;
	}
	public EPart getPart() {
		return part;
	}
	public ValidationResultItem setSeverity(ESeverity sev) {
		severity=sev;
		return this;
	}
	public ValidationResultItem setStacktrace(String stack) {
		stacktrace=stack;
		return this;
	}
	
	
	public String getXML() {
		String tagname="error";
		if (severity==ESeverity.exception) {
			tagname="exception";
		} else if (severity==ESeverity.warning) {
			tagname="warning";
		} else if (severity==ESeverity.notice) {
			tagname="notice";
		} 
		String additionalAttributes="";
		String additionalContents="";
		if (section!=-1) {
			additionalAttributes+=" type=\""+section+"\"";
		}
		if (location!=null) {
			additionalAttributes+=" location=\""+XMLTools.encodeAttribute(location)+"\"";
		}
		if (criterion!=null) {
			additionalAttributes+=" criterion=\""+XMLTools.encodeAttribute(criterion)+"\"";
		}
		if (stacktrace!=null) {
			additionalContents+="<stacktrace>"+XMLTools.encodeAttribute(stacktrace)+"</stacktrace>";
		}
		hasBeenOutputted=true;
		return "<"+tagname+additionalAttributes+">"+XMLTools.encodeXML(message+additionalContents)+"</"+tagname+">";
	}
	
	public String getXMLOnce() {
		if (!hasBeenOutputted) {
			return getXML();
		} else {
			return "";
		}
	}
	
	public ValidationResultItem setCriterion(String test) {
		 criterion = test;
		 return this;
	}
	public ESeverity getSeverity() {
		return severity;
	}

	public int getSection() {
		return section;
	}

	public String getMessage() {
		return message;
	}
	

}
