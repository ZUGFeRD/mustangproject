package org.mustangproject.ZUGFeRD;

public enum PDFAConformanceLevel {
    ACCESSIBLE("A"), BASIC("B"), UNICODE("U");

    private final String letter;

    PDFAConformanceLevel(String letter) {
        this.letter = letter;
    }

    public String getLetter() {
        return letter;
    }

    public static PDFAConformanceLevel findByLetter(String letter) {
        for (PDFAConformanceLevel candidate : values()) {
            if (candidate.letter.equals(letter)) {
                return candidate;
            }
        }
        throw new IllegalArgumentException("PDF conformance level <" + letter + "> is unknown.");
    }
}
