package org.mustangproject.ZUGFeRD;

import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;
import static org.junit.jupiter.api.Assertions.assertEquals;

import java.nio.charset.StandardCharsets;

import org.junit.Test;
import org.mustangproject.util.ByteArraySearcher;

public class ByteArraySearcherTest
{
  @Test
  public void testIndexOf () {
    byte [] haystack = "Hello World".getBytes (StandardCharsets.ISO_8859_1);
    assertEquals (0, ByteArraySearcher.indexOf (haystack, new byte [] { 'H' }));
    assertEquals (1, ByteArraySearcher.indexOf (haystack, new byte [] { 'e' }));
    assertEquals (0, ByteArraySearcher.indexOf (haystack, new byte [] { 'H', 'e' }));
    assertEquals (0, ByteArraySearcher.indexOf (haystack, new byte [] { 'H', 'e' }));
    assertEquals (0, ByteArraySearcher.indexOf (haystack, new byte [] { 'H', 'e', 'l', 'l' }));
    assertEquals (0, ByteArraySearcher.indexOf (haystack, haystack));
    assertEquals (-1, ByteArraySearcher.indexOf (haystack, new byte [0]));
    assertEquals (-1, ByteArraySearcher.indexOf (haystack, new byte [] { 'a' }));
    assertEquals (-1, ByteArraySearcher.indexOf (haystack, new byte [] { 'h' }));
    assertEquals (-1, ByteArraySearcher.indexOf (haystack, new byte [] { 'r', 'o' }));
  }

  @Test
  public void testStartsWith () {
    byte [] haystack = "Hello World".getBytes (StandardCharsets.ISO_8859_1);
    assertTrue (ByteArraySearcher.startsWith (haystack, new byte [] { 'H' }));
    assertFalse (ByteArraySearcher.startsWith (haystack, new byte [] { 'e' }));
    assertTrue (ByteArraySearcher.startsWith (haystack, new byte [] { 'H', 'e' }));
    assertTrue (ByteArraySearcher.startsWith (haystack, new byte [] { 'H', 'e' }));
    assertTrue (ByteArraySearcher.startsWith (haystack, new byte [] { 'H', 'e', 'l', 'l' }));
    assertTrue (ByteArraySearcher.startsWith (haystack, haystack));
    assertFalse (ByteArraySearcher.startsWith (haystack, new byte [0]));
    assertFalse (ByteArraySearcher.startsWith (haystack, new byte [] { 'a' }));
    assertFalse (ByteArraySearcher.startsWith (haystack, new byte [] { 'h' }));
    assertFalse (ByteArraySearcher.startsWith (haystack, new byte [] { 'r', 'o' }));
  }
}
