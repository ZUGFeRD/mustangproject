package org.mustangproject.ZUGFeRD;

import java.math.BigDecimal;

public class IZUGFeRDAllowanceChargeImpl implements IZUGFeRDAllowanceCharge {
    private BigDecimal totalAmount;
    private String reason;
    private BigDecimal taxPercent;

    @Override
    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    @Override
    public String getReason() {
        return reason;
    }

    @Override
    public BigDecimal getTaxPercent() {
        return taxPercent;
    }

    public IZUGFeRDAllowanceChargeImpl setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
        return this;
    }

    public IZUGFeRDAllowanceChargeImpl setReason(String reason) {
        this.reason = reason;
        return this;
    }

    public IZUGFeRDAllowanceChargeImpl setTaxPercent(BigDecimal taxPercent) {
        this.taxPercent = taxPercent;
        return this;
    }
}
