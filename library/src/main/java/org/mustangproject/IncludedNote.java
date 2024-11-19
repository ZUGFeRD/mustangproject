package org.mustangproject;

/**
 * A grouping of business terms to indicate accounting-relevant free texts including a qualification of these.
 */
public class IncludedNote {
  private String content;
  private SubjectCode subjectCode;

  private static final String INCLUDE_START = "<ram:IncludedNote>";
  private static final String INCLUDE_END = "</ram:IncludedNote>";
  private static final String CONTENT_START = "<ram:Content>";
  private static final String CONTENT_END = "</ram:Content>";
  private static final String SUBJECT_CODE_START = "<ram:SubjectCode>";
  private static final String SUBJECT_CODE_END = "</ram:SubjectCode>";

  private IncludedNote(String content, SubjectCode subjectCode) {
    this.content = content;
    this.subjectCode = subjectCode;
  }

	/**
	 * bean constructor
	 */
	public  IncludedNote() {

	}

  public static IncludedNote generalNote(String content) {
    return new IncludedNote(content, SubjectCode.AAI);
  }
  public static IncludedNote regulatoryNote(String content) {
    return new IncludedNote(content, SubjectCode.REG);
  }
  public static IncludedNote legalNote(String content) {
    return new IncludedNote(content, SubjectCode.ABL);
  }
  public static IncludedNote customsNote(String content) {
    return new IncludedNote(content, SubjectCode.CUS);
  }
  public static IncludedNote sellerNote(String content) {
    return new IncludedNote(content, SubjectCode.SUR);
  }
  public static IncludedNote taxNote(String content) {
    return new IncludedNote(content, SubjectCode.TXD);
  }
  public static IncludedNote introductionNote(String content) {
    return new IncludedNote(content, SubjectCode.ACY);
  }
  public static IncludedNote discountBonusNote(String content) {
    return new IncludedNote(content, SubjectCode.AAK);
  }

  public static IncludedNote unspecifiedNote(String content) {
    return new IncludedNote(content, null);
  }

  public String getContent() {
    return content;
  }

  public SubjectCode getSubjectCode() {
    return subjectCode;
  }
  
  public String toCiiXml(){
    String result = INCLUDE_START + CONTENT_START +
        XMLTools.encodeXML(getContent() )+ CONTENT_END;
    if (getSubjectCode() != null) {
      result += SUBJECT_CODE_START + getSubjectCode() + SUBJECT_CODE_END;
    }
    return result + INCLUDE_END;
  }
  
}
