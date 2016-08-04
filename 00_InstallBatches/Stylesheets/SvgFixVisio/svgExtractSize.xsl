<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:v="http://schemas.microsoft.com/visio/2003/SVGExtensions/"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:my="my:my" xmlns:ev="http://www.w3.org/2001/xml-events"
    exclude-result-prefixes="xsl v svg xlink my ev xs">
    <xsl:output method="xml" indent="yes" use-character-maps="sample" name="xml"/>
    <xsl:output method="text" indent="no" use-character-maps="sample" name="text"/>
    <xsl:strip-space elements="tspan"/>
    <xsl:strip-space elements="text"/>

    <xsl:variable name="sfile" select="document('svgsize.xml')"/>
    <xsl:key name="svgs" match="svgimg" use="@uri"/>
    
    <!--
        This transformation extracts the sizes all SVG files in the directory of the
        input file. The SVG files to be repaired need to start with p_ and
        the output replaces the p_ by x_  p_test.svg ==> svgsize.xml
        
        This can be changed in the next statement, but is not recommended        
    <xsl:variable name="folderURI" select="concat(resolve-uri('.', base-uri()),  'gfx/')"/>
    -->

    <xsl:character-map name="sample">
        <xsl:output-character character="&#x3C;" string="&lt;"/>
        <xsl:output-character character="&#x3E;" string="&gt;"/>
        <xsl:output-character character="⊕" string="&amp;#x2295;"/>
        <xsl:output-character character="“" string='"'/>
        <xsl:output-character character="”" string='"'/>
        <!--<xsl:output-character character="&#x26;" string='&amp;'/>-->
    </xsl:character-map>

    <xsl:variable name="folderURI" select="resolve-uri('.', base-uri())"/>

    <xsl:template match="/">
        <xsl:variable name="mergedFiles">
            <xsl:text>&#xA;</xsl:text>
            <xsl:element name="svgimgs">
                <xsl:apply-templates mode="rootcopy"/>
            </xsl:element>
        </xsl:variable>

        <xsl:variable name="fileName">
            <xsl:value-of select="concat($folderURI, 'svgsize.xml')"/>
        </xsl:variable>
        <xsl:message>
            <xsl:text>Output file = </xsl:text>
            <xsl:value-of select="$fileName"/>
        </xsl:message>

        <xsl:choose>
            <xsl:when test="0">
                <xsl:copy-of select="$mergedFiles" copy-namespaces="no"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:result-document href="{$fileName}" format="xml">
                    <xsl:copy-of select="$mergedFiles" copy-namespaces="no"/>
                </xsl:result-document>
            </xsl:otherwise>
        </xsl:choose>


    </xsl:template>

    <xsl:template match="*" mode="rootcopy">
        <xsl:message>
            <xsl:text>Processing: </xsl:text>
            <xsl:value-of select="base-uri()"/>
        </xsl:message>

        <xsl:for-each select="collection(concat($folderURI, '?select=*.svg;recurse=yes'))/*">
            <xsl:text>&#xA;    </xsl:text>
            <xsl:element name="svgimg">
                <!-- Get the file's filename through document-uri [Xslt#12.1.1] -->
                <xsl:attribute name="uri" select="substring-after(substring-before(document-uri(/), lower-case('.svg')), $folderURI)"/>
                <xsl:analyze-string select="/svg:svg/@width" regex="{'([0-9\.]+)([a-z]+)'}">
                    <xsl:matching-substring>
                        <xsl:text>&#xA;        </xsl:text>
                        <xsl:element name="width">
                            <xsl:value-of select="regex-group(1)"/>
                        </xsl:element>
                        <xsl:text>&#xA;        </xsl:text>
                        <xsl:element name="width-unit">
                            <xsl:value-of select="regex-group(2)"/>
                        </xsl:element>
                    </xsl:matching-substring>
                </xsl:analyze-string>
                <xsl:analyze-string select="/svg:svg/@height" regex="{'([0-9,\.]+)([a-z]+)'}">
                    <xsl:matching-substring>
                        <xsl:text>&#xA;        </xsl:text>
                        <xsl:element name="height">
                            <xsl:value-of select="regex-group(1)"/>
                        </xsl:element>
                        <xsl:text>&#xA;        </xsl:text>
                        <xsl:element name="height-unit">
                            <xsl:value-of select="regex-group(2)"/>
                        </xsl:element>
                    </xsl:matching-substring>
                </xsl:analyze-string>
                <xsl:text>&#xA;    </xsl:text>
            </xsl:element>
        </xsl:for-each>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>

</xsl:stylesheet>
