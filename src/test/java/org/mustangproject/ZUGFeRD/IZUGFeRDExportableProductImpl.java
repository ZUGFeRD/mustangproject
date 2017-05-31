package org.mustangproject.ZUGFeRD;

import java.math.BigDecimal;

public class IZUGFeRDExportableProductImpl implements IZUGFeRDExportableProduct {
    private String unit;
    private String name;
    private String description;
    private BigDecimal vatPercent;

    @Override
    public String getUnit() {
        return unit;
    }

    @Override
    public String getName() {
        return name;
    }

    @Override
    public String getDescription() {
        return description;
    }

    @Override
    public BigDecimal getVATPercent() {
        return vatPercent;
    }

    public IZUGFeRDExportableProductImpl setUnit(String unit) {
        this.unit = unit;
        return this;
    }

    public IZUGFeRDExportableProductImpl setName(String name) {
        this.name = name;
        return this;
    }

    public IZUGFeRDExportableProductImpl setDescription(String description) {
        this.description = description;
        return this;
    }

    public IZUGFeRDExportableProductImpl setVatPercent(BigDecimal vatPercent) {
        this.vatPercent = vatPercent;
        return this;
    }
}
