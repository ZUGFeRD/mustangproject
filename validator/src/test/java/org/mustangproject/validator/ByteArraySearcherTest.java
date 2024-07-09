package org.mustangproject.validator;

import static org.junit.jupiter.api.Assertions.assertEquals;

import java.nio.charset.StandardCharsets;

import org.junit.Test;

public class ByteArraySearcherTest {
  @Test
  public void testIndexOf () {
    byte[] haystack = "Hello World".getBytes (StandardCharsets.ISO_8859_1);
    assertEquals (0, ByteArraySearcher.indexOf (haystack, new byte[] {'H'}));
    assertEquals (1, ByteArraySearcher.indexOf (haystack, new byte[] {'e'}));
    assertEquals (0, ByteArraySearcher.indexOf (haystack, new byte[] {'H', 'e'}));
    assertEquals (0, ByteArraySearcher.indexOf (haystack, new byte[] {'H', 'e'}));
    assertEquals (0, ByteArraySearcher.indexOf (haystack, new byte[] {'H', 'e', 'l', 'l'}));
    assertEquals (0, ByteArraySearcher.indexOf (haystack, haystack));
    assertEquals (-1, ByteArraySearcher.indexOf (haystack, new byte[0]));
    assertEquals (-1, ByteArraySearcher.indexOf (haystack, new byte[] {'a'}));
    assertEquals (-1, ByteArraySearcher.indexOf (haystack, new byte[] {'h'}));
    assertEquals (-1, ByteArraySearcher.indexOf (haystack, new byte[] {'r', 'o'}));
  }
}
