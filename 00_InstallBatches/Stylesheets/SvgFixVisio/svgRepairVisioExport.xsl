<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:v="http://schemas.microsoft.com/visio/2003/SVGExtensions/"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:my="my:my" xmlns:ev="http://www.w3.org/2001/xml-events"
    exclude-result-prefixes="xsl v svg xlink my ev xs" version="2.0">
    <xsl:output method="xml" indent="no" use-character-maps="sample" name="xml"/>
    <xsl:output method="text" indent="no" use-character-maps="sample" name="text"/>
    <xsl:strip-space elements="tspan"/>
    <xsl:strip-space elements="text"/>
    
    <xsl:character-map name="sample">
        <xsl:output-character character="&#x3C;" string="&amp;lt;"/>
        <xsl:output-character character="&#x3E;" string="&amp;gt;"/>
        <xsl:output-character character="&#60;" string="&amp;lt;"/>
        <xsl:output-character character="&#62;" string="&amp;gt;"/>
        <xsl:output-character character="⊕" string="&amp;#x2295;"/>
        <xsl:output-character character="“" string='"'/>
        <xsl:output-character character="”" string='"'/>
        <!--<xsl:output-character character="&#x26;" string='&amp;'/>-->
    </xsl:character-map>

    <!-- THIS IS THE MAIN TEMPLATE, can be match="/" in single purpose use
         but it works also this way in single purpose use
    -->
    <xsl:template match="book">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="svg:a">
        <xsl:apply-templates select="svg:g" mode="linked"/>
        <!-- most likely we do not need the other templates since under a will only be g's 
        <xsl:apply-templates select="*[not(name() = 'g')]"/>
        -->
    </xsl:template>

    <xsl:template match="svg:g" mode="linked" priority="10">
        <xsl:call-template name="putXML"/>
        <xsl:element name="a">
            <xsl:attribute name="xlink:href" select="../@xlink:href"/>
            <xsl:element name="{name()}">
                <xsl:for-each select="@*[not(starts-with(name(), 'v:'))]">
                    <xsl:attribute name="{name()}">
                        <xsl:choose>
                            <xsl:when test="name() = 'id'">
                                <xsl:value-of select="concat(., '.link')"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="."/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:attribute>
                </xsl:for-each>
                <xsl:apply-templates mode="linked"/>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <xsl:template match="svg:g" priority="5">
        <xsl:call-template name="putXML"/>
    </xsl:template>

    <xsl:template name="putLINKED">
        <xsl:choose>
            <xsl:when test="name() = 'title'">
                <xsl:element name="{name()}">
                    <xsl:value-of select="concat(., '.link')"/>
                </xsl:element>
            </xsl:when>
            <xsl:when test="starts-with(name(), 'v:')"/>
            <xsl:when test="name() = 'text'"/>
            <xsl:otherwise>
                <xsl:element name="{name()}">
                    <xsl:for-each select="@*[not(starts-with(name(), 'v:'))]">
                        <xsl:choose>
                            <xsl:when test="name() = 'class'">
                                <xsl:attribute name="fill" select="'none'"/>
                                <xsl:attribute name="stroke" select="'none'"/>
                                <!--
                                <xsl:attribute name="stroke-linecap" select="'round'"/>
                                <xsl:attribute name="stroke-linejoin" select="'round'"/>
                                <xsl:attribute name="stroke-width" select="'0.25'"/>
                                -->
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="{name()}">
                                    <xsl:value-of select="."/>
                                </xsl:attribute>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:for-each>
                    <xsl:apply-templates select="* | text() | comment() | processing-instruction()" mode="linked"/>
                </xsl:element>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- ##################### BASIC routines ################### -->
    <!-- eliminate all VISIO tags -->
    <xsl:template match="v:*">
        <xsl:value-of select="''"/>
    </xsl:template>
    
<!--    <xsl:strip-space elements="*"/>-->

    <xsl:template match="svg:svg | svg">
        <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
        <xsl:text>&#x21;DOCTYPE svg PUBLIC "-//W3C//DTD SVG 1.0//EN" "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd"</xsl:text>
        <xsl:text disable-output-escaping="yes">&gt;&#xA;</xsl:text>
        <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
        <xsl:text>svg xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:ev="http://www.w3.org/2001/xml-events"
		xmlns:v="http://schemas.microsoft.com/visio/2003/SVGExtensions/"</xsl:text>
        <xsl:for-each select="@*">
            <xsl:text> </xsl:text>
            <xsl:value-of select="name()"/>
            <xsl:text>="</xsl:text>
            <xsl:value-of select="."/>
            <xsl:text>"</xsl:text>
        </xsl:for-each>
        <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
        <xsl:apply-templates/>
        <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
        <xsl:text>/svg</xsl:text>
        <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
    </xsl:template>

    <xsl:template match="svg:style">
        <xsl:element name="style">
            <xsl:attribute name="type" select="'text/css'"/>
            <xsl:text>&#xA;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
            <xsl:text>![CDATA[</xsl:text>
            <xsl:apply-templates/>
            <xsl:text>]]</xsl:text>
            <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
            <xsl:text>&#xA;</xsl:text>
        </xsl:element>
    </xsl:template>
    
    <!-- transparent throughput of any XML input -->
    <xsl:template name="putXML">
        <xsl:element name="{name()}">
            <xsl:for-each select="@*[not(starts-with(name(), 'v:'))]">
                <xsl:attribute name="{name()}">
                    <xsl:value-of select="."/>
                </xsl:attribute>
            </xsl:for-each>
            <xsl:apply-templates select="* | text() | comment() | processing-instruction()" mode="#default"/>
        </xsl:element>
    </xsl:template>

    <my:units>
        <unit name="pt">19.95</unit>
        <unit name="in">1440</unit>
        <unit name="cm">567</unit>
        <unit name="mm">56.7</unit>
        <unit name="em">240</unit>
        <unit name="px">15</unit>
        <unit name="pc">240</unit>
    </my:units>

    <xsl:variable name="vUnits" select="document('')/*/my:units/*"/>

    <xsl:template name="xonvertUnits" as="xs:double">
        <xsl:param name="numUnit"/>
        <xsl:param name="inUnitsOf"/>
        <xsl:value-of select="1"/>
    </xsl:template>

    <xsl:template name="convertUnits" as="xs:double">
        <xsl:param name="numUnit"/>
        <xsl:param name="inUnitsOf"/>
        <xsl:variable name="vQ">
            <xsl:analyze-string select="$numUnit" regex="{'[0-9,\.]+'}">
                <xsl:matching-substring>
                    <number>
                        <xsl:value-of select="."/>
                    </number>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>

        <xsl:variable name="vU">
            <xsl:variable name="sUnit">
                <xsl:analyze-string select="$numUnit" regex="{'[a-z]+'}">
                    <xsl:matching-substring>
                        <number>
                            <xsl:value-of select="."/>
                        </number>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="string-length(normalize-space($sUnit)) = 0">
                    <!--HSX apply millimeter as default -->
                    <xsl:value-of select="'mm'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$sUnit"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="normUnit">
            <num>
                <xsl:value-of select="$vQ * $vUnits[@name = $vU] div $vUnits[@name = $inUnitsOf]"/>
            </num>
        </xsl:variable>
        <xsl:value-of select="$normUnit"/>
    </xsl:template>

    <xsl:template match="*">
        <xsl:call-template name="putXML"/>
    </xsl:template>

    <xsl:template match="*" mode="linked">
        <xsl:call-template name="putLINKED"/>
    </xsl:template>
    
</xsl:stylesheet>
