package org.mustangproject.ZUGFeRD.model;

public enum PDFAConformanceLevel {
    ACCESSIBLE("A"), BASIC("B"), U("U");

    private final String letter;

    PDFAConformanceLevel(final String letter) {
        this.letter = letter;
    }

    public String getLetter() {
        return letter;
    }
}
