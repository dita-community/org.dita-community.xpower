<?xml version='1.0'?>
<!--

Oxygen Codeblock Highlights plugin
Copyright (c) 1998-2015 Syncro Soft SRL, Romania.  All rights reserved.
Licensed under the terms stated in the license file README.txt
available in the base directory of this plugin.
For the implementation ...
https://sourceforge.net/p/xslthl/wiki/Usage/

https://www.oxygenxml.com/doc/versions/17.1/ug-editorEclipse/index.html#topics/simple-dita-ot-plugin.html
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:d="http://docbook.org/ns/docbook"
    xmlns:ConnectorSaxonEE="java:net.sf.xslthl.ConnectorSaxonEE"
    xmlns:ConnectorSaxonB="java:net.sf.xslthl.ConnectorSaxonB"
    xmlns:saxonb="http://saxon.sf.net/"
    xmlns:sbhl="java:net.sf.xslthl.ConnectorSaxonB"
    xmlns:exsl="http://exslt.org/common"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:xslthl="http://xslthl.sf.net"
    xmlns:saxonica="com.saxonica.Transform"
    exclude-result-prefixes="exsl xs ConnectorSaxonEE ConnectorSaxonB d"
    version='2.0'>

    <!-- for saxon 8.5 and later -->
    <saxonb:script implements-prefix="sbhl" 
                   language="java"
                   src="java:net.sf.xslthl.ConnectorSaxonB" />

    <xsl:variable name="unittest" select="' none '"/>
    
    <xsl:template match="*" name="outputStyling" mode="outputstyling">
        <xsl:param name="myText"/>
        <xsl:variable name="outpclass">
            <xsl:variable name="oitems" select="tokenize(normalize-space(@outputclass), '\s+')" as="xs:string*"/>
            <xsl:value-of select="$oitems[contains(., 'language-')]"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$outpclass">
                <xsl:variable name="type">
                    <xsl:choose>
                        <xsl:when test="starts-with($outpclass, 'language-')">
                            <!-- Either starts with a certain language -->
                            <xsl:value-of select="substring-after($outpclass, 'language-')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- or not -->
                            <xsl:value-of select="$outpclass"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <!-- CONFIG FILE FOR SH -->
                <xsl:variable name="config" select="document('highlighters/xslthl-config.xml')"/>
                <!-- We'll try to use XSLTHL -->
                <xsl:variable name="content">
                    <xsl:choose>
                        <xsl:when test="string-length($myText) &gt; 0">
                            <xsl:copy-of select="$myText"/>
                        </xsl:when>
                        <!-- HSX Actually I think we never get here anymore -->
                        <xsl:otherwise>
                            <xsl:apply-templates/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:choose>
                    <xsl:when test="$config//*[@id=$type]">
                        <!-- We found a SH for it -->
                        <xsl:choose>
                            <!--HSX the manual version which ignored that saxonica:doTransform was not found -->
                            <xsl:when test="1">
                                <xsl:apply-templates
                                       select="sbhl:highlight($type, $content, base-uri($config))" mode="xslthl"/>
                                <xsl:choose>
                                    <xsl:when test="contains($unittest, 'chkHL')">
                                        <xsl:message>
                                            <xsl:choose>
                                                <xsl:when test="function-available('ConnectorSaxonEE:highlight')">
                                                    <xsl:text>&#xA;function-available('ConnectorSaxonEE:highlight')</xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:text>&#xA;NOT!!! function-available('ConnectorSaxonEE:highlight')</xsl:text>
                                                </xsl:otherwise>
                                            </xsl:choose>

                                            <xsl:choose>
                                                <xsl:when test="function-available('saxonica:doTransform')">
                                                    <xsl:text>&#xA;function-available('saxonica:doTransform')</xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:text>&#xA;NOT!!! function-available('saxonica:doTransform')</xsl:text>
                                                </xsl:otherwise>
                                            </xsl:choose>

                                            <xsl:choose>
                                                <xsl:when test="function-available('ConnectorSaxonB:highlight')">
                                                    <xsl:text>&#xA;function-available('ConnectorSaxonB:highlight')</xsl:text>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:text>&#xA;NOT!!! function-available('ConnectorSaxonB:highlight')</xsl:text>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:message>
                                    </xsl:when>
                                </xsl:choose>
                            </xsl:when>
                            <!--HSX the official variant, which didn't work because it never found saxonica:doTransform -->
                            <xsl:otherwise>
                                <xsl:apply-templates
                                    select="ConnectorSaxonEE:highlight($type, $content, base-uri($config))" mode="xslthl"
                                use-when="function-available('ConnectorSaxonEE:highlight') and function-available('saxonica:doTransform')"/>
                                <xsl:apply-templates
                                    select="ConnectorSaxonB:highlight($type, $content, base-uri($config))" mode="xslthl"
                                    use-when="function-available('ConnectorSaxonB:highlight')
                                and not(function-available('ConnectorSaxonEE:highlight') and function-available('saxonica:doTransform'))"/>
                                <xsl:copy-of select="$content"
                                    use-when="not(function-available('ConnectorSaxonEE:highlight') and function-available('saxonica:doTransform'))
                                and not(function-available('ConnectorSaxonB:highlight'))"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:copy-of select="$content"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <!-- No syntax highlight -->
                <xsl:apply-templates mode="#default"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- A fallback when the specific style isn't recognized -->
    <xsl:template match="xslthl:*" mode="xslthl">
        <xsl:message>
            <xsl:text>unprocessed xslthl style: </xsl:text>
            <xsl:value-of select="local-name(.)" />
        </xsl:message>
        <xsl:apply-templates mode="xslthl"/>
    </xsl:template>

    <!-- Copy over already produced markup (FO/HTML) -->
    <xsl:template match="node()" mode="xslthl" priority="-1">
        <xsl:copy>
            <xsl:apply-templates select="node()" mode="xslthl"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*" mode="xslthl">
        <xsl:copy>
            <xsl:copy-of select="@*"/>
            <xsl:apply-templates select="node()" mode="xslthl"/>
        </xsl:copy>
    </xsl:template>

</xsl:stylesheet>
