package org.mustangproject.util;

public final class ByteArraySearcher {

	private ByteArraySearcher() {
	}

	public static int indexOf(byte[] haystack, byte[] needle) {
		if (needle.length > haystack.length) {
			return -1;
		}

		// Any needle to search?
		if (needle.length == 0) {
			return -1;
		}

		for (int i = 0; i <= haystack.length - needle.length; i++) {
			boolean found = true;
			for (int j = 0; j < needle.length; j++) {
				if (haystack[i + j] != needle[j]) {
					found = false;
					break;
				}
			}
			if (found) {
				return i;
			}
		}

		return -1;
	}

	public static boolean contains(byte[] haystack, byte[] needle) {
		return indexOf(haystack, needle) >= 0;
	}

	public static boolean startsWith(byte[] haystack, byte[] needle) {
		if (needle.length > haystack.length) {
			return false;
		}

		// Any needle to search?
		if (needle.length == 0) {
			return false;
		}

		for (int j = 0; j < needle.length; j++) {
			if (haystack[j] != needle[j]) {
				return false;
			}
		}

		return true;
	}
}
