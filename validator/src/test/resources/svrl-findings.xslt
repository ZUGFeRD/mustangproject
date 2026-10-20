<?xml version="1.0" encoding="UTF-8"?>
<!-- Emits SVRL findings for XMLValidatorTest: each child element of the
     invoice triggers one kind of failed assertion or successful report. -->
<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:svrl="http://purl.oclc.org/dsdl/svrl">
  <xsl:template match="/">
    <svrl:schematron-output>
      <svrl:active-pattern/>
      <svrl:fired-rule context="/invoice"/>
      <xsl:if test="/invoice/unused">
        <svrl:successful-report test="unused" id="FX-SCH-R-000001" flag="warning" location="/invoice/unused">
          <svrl:text>Element 'unused' is marked as not used in the given context.</svrl:text>
        </svrl:successful-report>
      </xsl:if>
      <xsl:if test="/invoice/forbidden">
        <svrl:successful-report test="forbidden" id="FX-SCH-R-000002" flag="fatal" location="/invoice/forbidden">
          <svrl:text>Element 'forbidden' must not be used.</svrl:text>
        </svrl:successful-report>
      </xsl:if>
      <xsl:if test="/invoice/legacy">
        <svrl:successful-report test="legacy" location="/invoice/legacy">
          <svrl:text>Element 'legacy' is marked as not used in the given context.</svrl:text>
        </svrl:successful-report>
      </xsl:if>
      <xsl:if test="/invoice/mixed">
        <svrl:failed-assert test="first" id="BR-01" location="/invoice/mixed">
          <svrl:text>[BR-01]-First rule.</svrl:text>
        </svrl:failed-assert>
        <svrl:failed-assert test="second" flag="warning" location="/invoice/mixed">
          <svrl:text>Second rule without an ID.</svrl:text>
        </svrl:failed-assert>
      </xsl:if>
    </svrl:schematron-output>
  </xsl:template>
</xsl:stylesheet>
