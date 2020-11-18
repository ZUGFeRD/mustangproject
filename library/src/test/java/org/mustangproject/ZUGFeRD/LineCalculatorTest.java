package org.mustangproject.ZUGFeRD;

import static java.math.BigDecimal.TEN;
import static java.math.BigDecimal.valueOf;
import static org.junit.Assert.assertEquals;

import org.junit.Test;

public class LineCalculatorTest {

  @Test
  public void testLineCalculator_simpleAmounts_resultInValidVATAmount() {
    final IZUGFeRDExportableProduct product = new IZUGFeRDExportableProductImpl().setVatPercent(valueOf(16));
    final IZUGFeRDExportableItem currentItem = new IZUGFeRDExportableItemImpl().setPrice(valueOf(100))
        .setQuantity(TEN)
        .setProduct(product);

    final LineCalculator calculator = new LineCalculator(currentItem);

    assertEquals(valueOf(100).stripTrailingZeros(), calculator.getPrice().stripTrailingZeros());
    assertEquals(valueOf(1000).stripTrailingZeros(), calculator.getItemTotalNetAmount().stripTrailingZeros());
    assertEquals(valueOf(160).stripTrailingZeros(), calculator.getItemTotalVATAmount().stripTrailingZeros());
  }

  @Test
  public void testLineCalculatorInclusiveAllowance() {
    //This test failed with previous implementation. By rounding the totalVATAmount to 2 decimal places the result became wrong
    final IZUGFeRDExportableProduct product = new IZUGFeRDExportableProductImpl().setVatPercent(valueOf(16));
    // 10 % discount on each item
    final IZUGFeRDAllowanceCharge allowance = new IZUGFeRDAllowanceChargeImpl().setTotalAmount(valueOf(14.8730));

    final IZUGFeRDExportableItem currentItem = new IZUGFeRDExportableItemImpl().setPrice(valueOf(148.73))
        .setQuantity(valueOf(12))
        .setItemAllowances(new IZUGFeRDAllowanceCharge[] { allowance })
        .setProduct(product);

    final LineCalculator calculator = new LineCalculator(currentItem);

    assertEquals(valueOf(133.857).stripTrailingZeros(), calculator.getPrice().stripTrailingZeros());
    assertEquals(valueOf(1606.28).stripTrailingZeros(), calculator.getItemTotalNetAmount().stripTrailingZeros());
    assertEquals(valueOf(257.0048).stripTrailingZeros(), calculator.getItemTotalVATAmount().stripTrailingZeros());
  }

  @Test
  public void testLineCalculatorInclusiveAllowanceAndCharge() {
    final IZUGFeRDExportableProduct product = new IZUGFeRDExportableProductImpl().setVatPercent(valueOf(16));
    // 10 % discount on each item
    final IZUGFeRDAllowanceCharge allowance = new IZUGFeRDAllowanceChargeImpl().setTotalAmount(valueOf(14.873));
    // 20 % charge
    final IZUGFeRDAllowanceCharge charge = new IZUGFeRDAllowanceChargeImpl().setTotalAmount(valueOf(29.746));
    final IZUGFeRDExportableItem currentItem = new IZUGFeRDExportableItemImpl().setPrice(valueOf(148.73))
        .setQuantity(valueOf(12))
        .setItemAllowances(new IZUGFeRDAllowanceCharge[] { allowance })
        .setItemCharges(new IZUGFeRDAllowanceCharge[] { charge })
        .setProduct(product);

    final LineCalculator calculator = new LineCalculator(currentItem);

    assertEquals(valueOf(163.603).stripTrailingZeros(), calculator.getPrice().stripTrailingZeros());
    assertEquals(valueOf(1963.24).stripTrailingZeros(), calculator.getItemTotalNetAmount().stripTrailingZeros());
    assertEquals(valueOf(314.1184).stripTrailingZeros(), calculator.getItemTotalVATAmount().stripTrailingZeros());
  }
}
