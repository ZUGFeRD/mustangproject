package org.mustangproject.util;

public class StringUtils {
	private StringUtils() {}

	public static boolean isBlank(String str) {
		return str == null || str.isBlank();
	}
	public static boolean isNotBlank(String str) {
		return !isBlank(str);
	}
}
