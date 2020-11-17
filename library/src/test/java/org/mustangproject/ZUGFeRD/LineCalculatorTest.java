package org.mustangproject.ZUGFeRD;

import static org.junit.Assert.assertEquals;

import java.math.BigDecimal;

import org.junit.Test;

public class LineCalculatorTest {

  @Test
  public void testLineCalculator() {
    final IZUGFeRDExportableProduct product = new IZUGFeRDExportableProductImpl().setVatPercent(BigDecimal.valueOf(16));
    final IZUGFeRDExportableItem currentItem = new IZUGFeRDExportableItemImpl().setPrice(BigDecimal.valueOf(78.35))
        .setQuantity(BigDecimal.valueOf(11))
        .setProduct(product);
    final LineCalculator calculator = new LineCalculator(currentItem);

    assertEquals(BigDecimal.valueOf(78.35), calculator.getPrice().stripTrailingZeros());
    assertEquals(BigDecimal.valueOf(861.85), calculator.getItemTotalNetAmount().stripTrailingZeros());
    assertEquals(BigDecimal.valueOf(861.85), calculator.getItemTotalGrossAmount().stripTrailingZeros());
    assertEquals(BigDecimal.valueOf(137.896), calculator.getItemTotalVATAmount().stripTrailingZeros());
  }

  @Test
  public void testLineCalculatorInclusiveAllowance() {
    final IZUGFeRDExportableProduct product = new IZUGFeRDExportableProductImpl().setVatPercent(BigDecimal.valueOf(16));
    final IZUGFeRDAllowanceCharge allowance = new IZUGFeRDAllowanceChargeImpl()
        .setTotalAmount(BigDecimal.valueOf(14.8730));
    final IZUGFeRDExportableItem currentItem = new IZUGFeRDExportableItemImpl().setPrice(BigDecimal.valueOf(148.73))
        .setQuantity(BigDecimal.valueOf(12))
        .setItemAllowances(new IZUGFeRDAllowanceCharge[] { allowance })
        .setProduct(product);
    final LineCalculator calculator = new LineCalculator(currentItem);

    assertEquals(BigDecimal.valueOf(133.857), calculator.getPrice().stripTrailingZeros());
    assertEquals(BigDecimal.valueOf(1606.28), calculator.getItemTotalNetAmount().stripTrailingZeros());
    assertEquals(BigDecimal.valueOf(1606.28), calculator.getItemTotalGrossAmount().stripTrailingZeros());
    assertEquals(BigDecimal.valueOf(257.0048), calculator.getItemTotalVATAmount().stripTrailingZeros());
  }

  @Test
  public void testLineCalculatorInclusiveAllowanceAndCharge() {
    final IZUGFeRDExportableProduct product = new IZUGFeRDExportableProductImpl().setVatPercent(BigDecimal.valueOf(16));
    final IZUGFeRDAllowanceCharge allowance = new IZUGFeRDAllowanceChargeImpl()
        .setTotalAmount(BigDecimal.valueOf(14.8730));
    final IZUGFeRDAllowanceCharge charge = new IZUGFeRDAllowanceChargeImpl()
        .setTotalAmount(BigDecimal.valueOf(14.8730));
    final IZUGFeRDExportableItem currentItem = new IZUGFeRDExportableItemImpl().setPrice(BigDecimal.valueOf(148.73))
        .setQuantity(BigDecimal.valueOf(12))
        .setItemAllowances(new IZUGFeRDAllowanceCharge[] { allowance })
        .setItemCharges(new IZUGFeRDAllowanceCharge[] { charge })
        .setProduct(product);
    final LineCalculator calculator = new LineCalculator(currentItem);

    assertEquals(BigDecimal.valueOf(148.73), calculator.getPrice().stripTrailingZeros());
    assertEquals(BigDecimal.valueOf(1784.76), calculator.getItemTotalNetAmount().stripTrailingZeros());
    assertEquals(BigDecimal.valueOf(1784.76), calculator.getItemTotalGrossAmount().stripTrailingZeros());
    assertEquals(BigDecimal.valueOf(285.5616), calculator.getItemTotalVATAmount().stripTrailingZeros());
  }
}
