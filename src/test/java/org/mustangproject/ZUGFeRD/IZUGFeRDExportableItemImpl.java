package org.mustangproject.ZUGFeRD;

import java.math.BigDecimal;

public class IZUGFeRDExportableItemImpl implements IZUGFeRDExportableItem {
    private IZUGFeRDExportableProduct product;
    private IZUGFeRDAllowanceCharge[] itemAllowances;
    private IZUGFeRDAllowanceCharge[] itemCharges;
    private BigDecimal price;
    private BigDecimal quantity;

    @Override
    public IZUGFeRDExportableProduct getProduct() {
        return product;
    }

    @Override
    public IZUGFeRDAllowanceCharge[] getItemAllowances() {
        return itemAllowances;
    }

    @Override
    public IZUGFeRDAllowanceCharge[] getItemCharges() {
        return itemCharges;
    }

    @Override
    public BigDecimal getPrice() {
        return price;
    }

    @Override
    public BigDecimal getQuantity() {
        return quantity;
    }

    public IZUGFeRDExportableItemImpl setProduct(IZUGFeRDExportableProduct product) {
        this.product = product;
        return this;
    }

    public IZUGFeRDExportableItemImpl setItemAllowances(IZUGFeRDAllowanceCharge[] itemAllowances) {
        this.itemAllowances = itemAllowances;
        return this;
    }

    public IZUGFeRDExportableItemImpl setItemCharges(IZUGFeRDAllowanceCharge[] itemCharges) {
        this.itemCharges = itemCharges;
        return this;
    }

    public IZUGFeRDExportableItemImpl setPrice(BigDecimal price) {
        this.price = price;
        return this;
    }

    public IZUGFeRDExportableItemImpl setQuantity(BigDecimal quantity) {
        this.quantity = quantity;
        return this;
    }
}
