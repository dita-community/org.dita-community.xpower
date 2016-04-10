<?xml version='1.0'?>

<!--
  This is only an extract of the original
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">
    <!--HSC [DtPrt#16.8] explains how to change the maximum level for the TOC -->
    <xsl:param name="tocMaximumLevel" select="$tocMaxLevel"/>
    <!--
    <xsl:import href="../../org.dita.pdf2/xsl/common/attr-set-reflection.xsl"/>
    -->
</xsl:stylesheet>