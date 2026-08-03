package org.mustangproject.util;

import java.math.BigDecimal;
import java.math.RoundingMode;

public class BigDecimalUtils {


	/**
	 * Calculates the logarithm of 10 for a BigDecimals absolute value and rounds it down.
	 * i.e. <strong>log10(|x|)</strong>
	 * Examples:
	 * log10Floor(0.0) -> 0; 0.0001 -> 0; 9 -> 0; 10.23 -> 1; 999.99 -> 2; -4242 -> 3;
	 * <p>
	 * It is efficiently calculated by using BigDecimals internal representation in scientific notation.
	 *
	 * @param bd a positive BigDecimal
	 * @return the logarithm of 10 rounded down to the nearest integer,
	 * which is equal to the index of its most significant digit.
	 * @throws IllegalArgumentException if bd is either null or a negative value
	 */
	public static int log10Floor(BigDecimal bd) {
		if (bd == null) {
			throw new IllegalArgumentException("Parameter bd should not be null");
		}
		// Special handling for ZERO: "0", "0.0", "0.00" would otherwise return only the scale, as it does not have a significant digit.
		if (bd.signum() == 0) {
			return 0;
		}
		// BigDecimal are kept in scientific notation internally, extract the information directly.
		// This returns the index of the most significant digit and exponent used in scientific notation (i.e. 10^x)
		return bd.precision() - bd.scale() - 1;
	}


	/**
	 * Calculates the minimum scale for a division that is needed for the inverse multiplication to return the
	 * original denominator rounded to targetScale decimal places.
	 * When using HALF_UP rounding mode.
	 * <p>
	 * This method can overestimate the necessary scale for specific denominators, but never underestimates.
	 * <p>
	 * Example:
	 * Given: Amount = 1024 and Total = 12.44, how many decimal places are needed for the Unit Price, so that
	 * (Unit Price * Amount).setScale(targetScale, RoundingMode.HALF_UP) = Total.setScale(targetScale, RoundingMode.HALF_UP).
	 *
	 * @param targetScale positive number of decimal places required to match (rounded) when multiplying with the factor.
	 * @param divisor     nonnull divisor
	 * @return an upper bound for the minimum scale needed in a division with the given divisor to match the original denominator,
	 * if rounded to targetScale.
	 * Will return a number larger or equals to targetScale, even if divisor is zero.
	 * @throws IllegalArgumentException if targetScale is negative
	 * @throws IllegalArgumentException if divisor is null
	 */
	public static int calculateScale(int targetScale, BigDecimal divisor) {
		if (targetScale < 0) {
			throw new IllegalArgumentException("Parameter targetScale should not be negative, got " + targetScale);
		}
		if (divisor == null) {
			throw new IllegalArgumentException("Parameter 'divisor' should not be null");
		}
		if (divisor.signum() == 0) {
			return targetScale;
		}
		// + 1 to round up (i.e. log10Ceiling) + targetScale, so even a divisor of 1 will result in at least targetScale precision.
		return Math.max(0, log10Floor(divisor)) + 1 + targetScale;
	}


	/**
	 * Divides the denominator by the divisor and returns the result.
	 * The scale of the result is determined dynamically, so that the inverse multiplication returns the denominator again,
	 * if rounded to the original denominators scale.
	 * This method uses {@link RoundingMode#HALF_UP} internally.
	 * <code>minScale</code> is used as an explicit lower bound.
	 * <p>
	 * Unlike standard {@link BigDecimal#divide(BigDecimal)}, this method automatically
	 * calculates a dynamic target scale. It guarantees that the resulting factor,
	 * when multiplied back by the {@code amount} and rounded to the {@code total}'s
	 * original scale, will exactly equal the {@code total}.
	 *
	 * @param denominator the denominator of the division, nonnull.
	 * @param divisor the divisor of the division, nonnull.
	 * @param minScale the minimum scale of the result, needs to be a positive number.
	 *       For example the number of supported decimal places for currencies, e.g. 2 for Euro.
	 * @return the result of the division, rounded (via HALF_UP mode) to the scale needed to invert the calculation again.
	 * @throws ArithmeticException – if divisor is zero
	 * @throws IllegalArgumentException if either denominator or divisor is null
	 */
	public static BigDecimal divideReversible(BigDecimal denominator, BigDecimal divisor, int minScale) {
		if (denominator == null || divisor == null) {
			throw new IllegalArgumentException("Neither parameter 'denominator' (" + denominator + ") nor 'divisor' (" + divisor + ") should be null");
		}
		int denominatorScale = Math.max(minScale, denominator.scale());
		int requiredScale = calculateScale(denominatorScale, divisor);
		return denominator.divide(divisor, requiredScale, RoundingMode.HALF_UP);
	}

}
