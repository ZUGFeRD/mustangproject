package org.mustangproject.validator;

public final class ByteArraySearcher {

	private ByteArraySearcher() {
	}

	public static boolean contains(byte[] haystack, byte[] needle) {
		if (needle.length > haystack.length) {
			return false;
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
				return true;
			}
		}

		return false;
	}
}
