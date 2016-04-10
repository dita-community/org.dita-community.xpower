<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    
    <xsl:include href="svgRepairVisioExport.xsl"/>
    <xsl:output method="xml" indent="yes"/>

    <!--
        This transformation repairs all SVG files in the directory of the
        input file. The SVG files to be repaired need to start with p_ and
        the output replaces the p_ by x_  p_test.svg ==> x_test.svg.
        
        If MS-VISIO exports a VSD to an SVG, all boxes with two or more lines
        of text will generate a too small link area. This transformation repairs
        the size of the link area so that the entire box is hit again. It
        It works conservatively taking only p_ prefixed files and outputs x_prefixed files.
        
        If you want comfort, you may link to x_prefixed SVG files in your DITA book so
        you only need to apply the repair scenario, but no rename is necessary.
        
        The transformation shall be applied to the DITAMAP because it will search
        relative to the DITAMAP's directory in the gfx directory.
        
        This can be changed in the next statement, but is not recommended        
    <xsl:variable name="folderURI" select="concat(resolve-uri('.', base-uri()),  'gfx/')"/>
    -->
    <xsl:variable name="folderURI" select="resolve-uri('.', base-uri())"/>

    <xsl:template match="/">
        <xsl:variable name="mergedFiles">
            <xsl:text>&#xA;</xsl:text>
            <xsl:element name="books">
                <xsl:apply-templates mode="rootcopy"/>
            </xsl:element>
        </xsl:variable>
        
        <xsl:for-each select="$mergedFiles/books/book">
            <xsl:variable name="myPos" select="position()"/>
            <xsl:text>&#xA;</xsl:text>
            <xsl:variable name="fileName">
                <xsl:value-of select="replace(@uri, 'p_', 'x_')"/>
            </xsl:variable>
            <xsl:message>
                <xsl:text>Output file = </xsl:text>
                <xsl:value-of select="$fileName"/>
            </xsl:message>
            <xsl:result-document href="{$fileName}" format="xml">
                <xsl:apply-templates/>
            </xsl:result-document>
            <!--
            -->
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="*" mode="rootcopy">
        <!-- the folder URI holdes the absolute path of the directory
             to be visited e.g. "file:/F:/Gnd/DocuDesign/Dita/Stylesheets/"
                 
             resolve-uri resolves a relative URI against an absolute URI 
                 e.g. "file:/F:/Gnd/DocuDesign/Dita/Stylesheets/"
                 
             base-uri provides the input filepath-name 
                 e.g. file:/F:/Gnd/DocuDesign/Dita/Stylesheets/test.xml 
            -->
        
        <xsl:message>
            <xsl:text>Processing: </xsl:text>
            <xsl:value-of select="./name()"/>
        </xsl:message>

        <xsl:for-each select="collection(concat($folderURI, '?select=p_*.svg;recurse=yes'))/*">
            <xsl:text>&#xA;</xsl:text>
            <xsl:element name="book">
                <!-- Get the file's filename through document-uri [Xslt#12.1.1] -->
                <xsl:attribute name="uri" select="document-uri(/)"/>
                <xsl:text>&#xA;</xsl:text>
                <xsl:element name="{name()}">
                    <xsl:apply-templates mode="copy" select="@*"/>
                    <xsl:for-each select="*">
                        <xsl:text>&#xA;</xsl:text>
                        <xsl:apply-templates mode="copy" select="."/>
                        <xsl:text>&#xA;</xsl:text>
                    </xsl:for-each>
                </xsl:element>
                <xsl:text>&#xA;</xsl:text>
            </xsl:element>
        </xsl:for-each>
        <xsl:text>&#xA;</xsl:text>
    </xsl:template>

    <!-- Deep copy template -->
    <xsl:template match="node() | @*" mode="copy">
        <xsl:copy>
            <xsl:apply-templates mode="copy" select="@*"/>
            <xsl:apply-templates mode="copy"/>
        </xsl:copy>
    </xsl:template>
    
    <!-- templates to avoid well formatted text - sometimes worked too efficient
         better to use xsl:output method="xml" indent="no"

    <xsl:template match="*/text()[normalize-space()]">
        <xsl:value-of select="normalize-space()"/>
    </xsl:template>

    <xsl:template match="*/text()[not(normalize-space())]"/>
    
    <xsl:template match="text[normalize-space()='']" />
    -->

    <!-- Handle default matching must go because it overrides the import templates -->
    <xsl:template match="xxx">
        <xsl:text>DEFAULT</xsl:text>
        <xsl:value-of select="name()"/>
    </xsl:template>
</xsl:stylesheet>
