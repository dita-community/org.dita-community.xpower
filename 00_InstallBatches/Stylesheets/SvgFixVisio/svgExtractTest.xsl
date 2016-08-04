<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:v="http://schemas.microsoft.com/visio/2003/SVGExtensions/"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:my="my:my" xmlns:ev="http://www.w3.org/2001/xml-events"
    exclude-result-prefixes="xsl v svg xlink my ev xs">
    <xsl:output method="xml" indent="yes" use-character-maps="sample" name="xml"/>
    <xsl:output method="text" indent="no" use-character-maps="sample" name="text"/>
    <xsl:strip-space elements="tspan"/>
    <xsl:strip-space elements="text"/>

    <xsl:variable name="folderURI" select="resolve-uri('.', base-uri())"/>
    <xsl:variable name="FN" select="concat($folderURI, 'svgsize.xml')"/>
    <xsl:variable name="sfile" select="document($FN)"/>
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


    <xsl:template match="/">
        <xsl:apply-templates select="$sfile/*"/>
    </xsl:template>
    
    <xsl:template match="*">
        <xsl:value-of select="key('svgs', '1' )/width-unit"/>
    </xsl:template>

</xsl:stylesheet>
