package org.mustangproject.validator;

import java.io.File;
import java.util.List;

import org.junit.Test;

/**
 * Tests the optional internal warning for line-level SpecifiedTradeAllowanceCharge arithmetic.
 *
 * The check is anchored on the semantic definitions of BT-137 / BT-142 in
 * EN 16931-1:2017+A1:2019: "the base amount used in conjunction with the percentage to
 * calculate the allowance/charge amount."
 *
 * No normative BR-* enforces this identity today (ConnectingEurope/eInvoicing-EN16931 issue #350).
 * This warning is informational only and does not affect the validation summary status.
 */
public class XMLValidatorAllowanceChargeArithmeticTest extends ResourceCase {

    @Test
    public void testNoWarningWhenArithmeticIdentityHolds() throws IrrecoverableValidationError {
        // BasisAmount=64.25, CalculationPercent=10 -> expected=6.425, ActualAmount=6.42
        // Deviation = |6.42 - 6.425| = 0.005 < 0.02 -> warning must NOT fire.
        final ValidationContext ctx = new ValidationContext(null);
        final XMLValidator xv = new XMLValidator(ctx);

        File f = getResourceAsFile("validLineLevelAllowanceArithmetic.xml");
        assertNotNull("Test fixture not found", f);
        xv.setFilename(f.getAbsolutePath());
        xv.validate();

        final List<ValidationResultItem> results = ctx.getResults();
        for (ValidationResultItem item : results) {
            if (item.getSeverity() == ESeverity.warning) {
                final String msg = item.getMessage();
                assertFalse(
                    "Unexpected BT-137/BT-142 warning for a valid fixture: " + msg,
                    msg != null && (msg.contains("BT-137") || msg.contains("BT-142"))
                );
            }
        }
    }

    @Test
    public void testWarningFiredWhenArithmeticIdentityViolated() throws IrrecoverableValidationError {
        // BasisAmount=64.25, CalculationPercent=10 -> expected=6.425, ActualAmount=9.99
        // Deviation = |9.99 - 6.425| = 3.565 > 0.02 -> warning MUST fire.
        final ValidationContext ctx = new ValidationContext(null);
        final XMLValidator xv = new XMLValidator(ctx);

        File f = getResourceAsFile("invalidLineLevelAllowanceArithmetic.xml");
        assertNotNull("Test fixture not found", f);
        xv.setFilename(f.getAbsolutePath());
        xv.validate();

        final List<ValidationResultItem> results = ctx.getResults();
        boolean warningFound = false;
        for (ValidationResultItem item : results) {
            if (item.getSeverity() == ESeverity.warning) {
                final String msg = item.getMessage();
                if (msg != null && (msg.contains("BT-137") || msg.contains("BT-142"))) {
                    warningFound = true;
                    break;
                }
            }
        }
        assertTrue(
            "Expected a BT-137/BT-142 arithmetic warning but none was found in: " + results,
            warningFound
        );
    }
}
