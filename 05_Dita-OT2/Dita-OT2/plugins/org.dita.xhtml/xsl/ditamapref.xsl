<?xml version="1.0" encoding="UTF-8" ?>
<!-- This file is part of the DITA Open Toolkit project.
See the accompanying license.txt file for applicable licenses. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    xmlns:dita2html="http://dita-ot.sourceforge.net/ns/200801/dita2html"
    xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
    exclude-result-prefixes="xs dita-ot dita2html ditamsg"
    version="2.0">

    <!-- XHTML output with XML syntax -->
    <xsl:output method="xml" encoding="utf-8" indent="no"/>

    <xsl:template match="/">
        <xsl:element name="hrefs">
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="*[contains(name(), 'topicref') or contains(name(), 'chapter')]">
        <xsl:element name="href">
            <xsl:value-of select="@href"/>
            <xsl:text>&#xA;</xsl:text>
        </xsl:element>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="*" priority="-1">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="text()"/>


</xsl:stylesheet>
