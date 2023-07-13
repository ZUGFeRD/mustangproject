package org.mustangproject;

/**
 * A grouping of business terms to indicate accounting-relevant free texts including a qualification of these.
 */
public class IncludedNote {
  private final String content;
  private final SubjectCode subjectCode;

  private IncludedNote(String content, SubjectCode subjectCode) {
    this.content = content;
    this.subjectCode = subjectCode;
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

  public String getContent() {
    return content;
  }

  public SubjectCode getSubjectCode() {
    return subjectCode;
  }
  
}
