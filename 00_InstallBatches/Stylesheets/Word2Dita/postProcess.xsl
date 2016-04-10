<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
      xmlns:xs="http://www.w3.org/2001/XMLSchema"
      xmlns:local="urn:local-functions"
      xmlns:rsiwp="http://reallysi.com/namespaces/generic-wordprocessing-xml"
      xmlns:stylemap="urn:public:dita4publishers.org:namespaces:word2dita:style2tagmap"
      xmlns:relpath="http://dita2indesign/functions/relpath"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xmlns:m="http://www.w3.org/1998/Math/MathML"
      
      exclude-result-prefixes="xs rsiwp stylemap local relpath xsi"
      version="2.0">

    <xsl:template match="title" mode="docs-post">
        <xsl:choose>
            <xsl:when test="parent::entry">
                <xsl:element name="b">
                    <xsl:apply-templates mode="docs-post"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="putXML"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- eliminate Table/Figure # label through the colon -->
    <xsl:template match="text()" mode="tab-title" priority="15">
        <xsl:analyze-string select="." regex="{'.*:\s(.*)'}">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>

    <xsl:template match="*" mode="tab-title" priority="2">
        <xsl:call-template name="putXML"/>
    </xsl:template>

    <!-- print table/figure title from the preceding/following paragraph -->
    <xsl:template match="p" mode="tab-title" priority="10">
        <xsl:apply-templates select="* | text()" mode="tab-title"/>
    </xsl:template>

    <!-- special handling for paragraph -->
    <xsl:template match="p" mode="docs-post">
        <xsl:choose>
            <!-- do not print if we have table title -->
            <xsl:when test="following-sibling::*[1]/name() = 'table'"/>

            <!-- do not print if we have fig title -->
            <xsl:when test="preceding-sibling::*[1]/name() = 'fig'"/>

            <!-- avoid paragraph on first item in a table entry -->
            <xsl:when test="parent::entry and (count(preceding-sibling::p) = 0)">
                <xsl:apply-templates mode="docs-post"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="putXML"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="table" mode="docs-post">
        <xsl:element name="table">
            <xsl:call-template name="putAttrs"/>
            <xsl:if test="preceding-sibling::*[1]/name() = 'p'">
                <xsl:element name="title">
                    <xsl:apply-templates select="preceding-sibling::p[1]" mode="tab-title"/>
                </xsl:element>
            </xsl:if>
            <xsl:apply-templates mode="docs-post"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="fig" mode="docs-post">
        <xsl:element name="fig">
            <xsl:call-template name="putAttrs"/>
            <xsl:if test="following-sibling::*[1]/name() = 'p'">
                <xsl:element name="title">
                    <xsl:apply-templates select="following-sibling::*[1]" mode="tab-title"/>
                </xsl:element>
            </xsl:if>
            <xsl:apply-templates mode="docs-post"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="tab" mode="docs-post">
        <xsl:value-of select="'&#xA0;'"/>
    </xsl:template>

    <xsl:template match="brx" mode="docs-post">
        <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
        <xsl:value-of select="'/p>'"/>
        <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
        <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
        <xsl:value-of select="'p>'"/>
        <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
    </xsl:template>

    <xsl:template match="br" mode="docs-post">
        <xsl:apply-templates mode="docs-post"/>
    </xsl:template>

    <xsl:template name="putAttrs">
        <xsl:for-each select="@*">
            <xsl:attribute name="{name()}">
                <xsl:value-of select="."/>
            </xsl:attribute>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="putXML">
        <xsl:element name="{name()}">
            <xsl:for-each
                select="
                    @*
                    [not(contains(name(), 'class'))]
                    [not(contains(name(), 'ditaarch'))]
                    [not(contains(name(), 'domains'))]">
                <xsl:copy inherit-namespaces="no"/>
            </xsl:for-each>
            <xsl:apply-templates select="* | text() | comment() | processing-instruction()" mode="docs-post"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="node() | @*" mode="docs-post">
        <xsl:param name="doDebug" as="xs:boolean" tunnel="yes" select="false()"/>
        <xsl:param name="simpleWpDoc" as="document-node()" tunnel="yes"/>
        <xsl:copy inherit-namespaces="no">
            <xsl:apply-templates mode="docs-post"
                select="
                    @*
                    [not(contains(name(), 'class'))]
                    [not(contains(name(), 'DITAArchVersion'))]
                    [not(contains(local-name(), 'DITAArchVersion'))]
                    [not(contains(name(), 'domains'))]"/>
            <xsl:apply-templates mode="docs-post"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
