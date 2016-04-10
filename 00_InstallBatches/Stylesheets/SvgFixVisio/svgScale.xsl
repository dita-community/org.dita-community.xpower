<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns="http://www.w3.org/2000/svg"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:my="my:my" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:math="http://exslt.org/math"
    exclude-result-prefixes="xs my">

    <xsl:output method="xml" indent="yes"/>

    <!--
        This transformation repairs all SVG files in the directory of the
        input file. The SVG files to be repaired need to start with p_ and
        the output replaces the p_ by x_  p_test.svg ==> x_test.svg.  
    -->
    <xsl:template match="/">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="*">
        <xsl:call-template name="createSvgFile">
            <xsl:with-param name="uwidth" select="'163.2mm'"/>
            <xsl:with-param name="uheight" select="'181.9mm'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="createSvgFile">
        <xsl:param name="uwidth" as="xs:string"/>
        <xsl:param name="uheight" as="xs:string"/>
        <xsl:text>&#xA;</xsl:text>
        <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
        <xsl:text>&#x21;DOCTYPE svg PUBLIC "-//W3C//DTD SVG 20010904//EN" "http://www.w3.org/TR/2001/REC-SVG-20010904/DTD/svg10.dtd"</xsl:text>
        <xsl:text disable-output-escaping="yes">&gt;&#x0A;</xsl:text>
        <xsl:call-template name="createSvg">
            <xsl:with-param name="uwidth" select="$uwidth"/>
            <xsl:with-param name="uheight" select="$uheight"/>
        </xsl:call-template>
    </xsl:template>
    
    <xsl:template name="createSvg">
        <xsl:param name="uwidth" as="xs:string"/>
        <xsl:param name="uheight" as="xs:string"/>
        <xsl:variable name="unit" select="normalize-space(replace($uwidth, '[0-9,\.]+', ''))"/>
        
         <!-- Define colors -->
        <xsl:variable name="color-axis" select="'black'"/>
        <xsl:variable name="color-hops" select="'blue'"/>
        <xsl:variable name="color-step" select="'red'"/>

        <!-- Define base coordinates in units of the base unit-->
        <xsl:variable name="xoffs">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="'8mm'"/>
                <xsl:with-param name="inUnitsOf" select="$unit"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="yoffs">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="'5mm'"/>
                <xsl:with-param name="inUnitsOf" select="$unit"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="hop-offs">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="'3mm'"/>
                <xsl:with-param name="inUnitsOf" select="$unit"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="step-offs">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="'1mm'"/>
                <xsl:with-param name="inUnitsOf" select="$unit"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="fontsize-in-pt">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="'12pt'"/>
                <xsl:with-param name="inUnitsOf" select="'pt'"/>
            </xsl:call-template>
        </xsl:variable>
        
        <xsl:variable name="xtext-offs">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="concat($fontsize-in-pt * 4, 'pt')"/>
                <xsl:with-param name="inUnitsOf" select="$unit"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="ytext-offs">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="concat($fontsize-in-pt * 0.3, 'pt')"/>
                <xsl:with-param name="inUnitsOf" select="$unit"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:message>
            <xsl:text>ytext-offset = </xsl:text>
            <xsl:value-of select="$ytext-offs"/>
        </xsl:message>
        
        <xsl:variable name="xtext-align">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="concat($fontsize-in-pt * 0.4, 'pt')"/>
                <xsl:with-param name="inUnitsOf" select="$unit"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:message>
            <xsl:text>xtext-align = </xsl:text>
            <xsl:value-of select="$xtext-align"/>
        </xsl:message>

        <xsl:variable name="ytext-align">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="concat($fontsize-in-pt * 0.3, 'pt')"/>
                <xsl:with-param name="inUnitsOf" select="$unit"/>
            </xsl:call-template>
        </xsl:variable>
        
        
                
        <xsl:element name="svg">
            <!-- set default namespace, not really necessary as done automatically
                <xsl:namespace name="" select="'http://www.w3.org/2000/svg'"/>
            -->
            <xsl:attribute name="version" select="1.1"/>

            <!-- viewbox in [svgspec#7.7] -->
            <xsl:attribute name="width" select="$uwidth"/>
            <xsl:attribute name="height" select="$uheight"/>

            <xsl:message>
                <xsl:text>unit = </xsl:text>
                <xsl:value-of select="$unit"/>
            </xsl:message>

            <xsl:variable name="width" select="number(normalize-space(substring-before($uwidth, $unit)))" as="xs:double"/>
            <xsl:variable name="height" select="number(normalize-space(substring-before($uheight, $unit)))" as="xs:double"/>

            <xsl:message>
                <xsl:text>Width  =</xsl:text>
                <xsl:value-of select="$width"/>
                <xsl:text>&#xA;Height =</xsl:text>
                <xsl:value-of select="$height"/>
            </xsl:message>
            
            <xsl:attribute name="viewBox">
                <xsl:value-of select="concat('0mm 0mm ', $width, ' ', $height)"/>
            </xsl:attribute>

            <!-- draw horizontal scale -->
            <xsl:element name="line">
                <xsl:attribute name="x1" select="concat($xoffs, $unit)"/>
                <xsl:attribute name="y1" select="concat($yoffs, $unit)"/>
                <xsl:attribute name="x2" select="concat($width, $unit)"/>
                <xsl:attribute name="y2" select="concat($yoffs, $unit)"/>
                <xsl:attribute name="style" select="'stroke:', $color-axis,'; stroke-width:2px;'"/>
            </xsl:element>

            <!-- draw vertical scale -->
            <xsl:element name="line">
                <xsl:attribute name="x1" select="concat($xoffs, $unit)"/>
                <xsl:attribute name="y1" select="concat($yoffs, $unit)"/>
                <xsl:attribute name="x2" select="concat($xoffs, $unit)"/>
                <xsl:attribute name="y2" select="concat($height, $unit)"/>
                <xsl:attribute name="style" select="'stroke:', $color-axis,'; stroke-width:2px;'"/>
            </xsl:element>

            <!-- draw horizontal units every 5mm -->
            <xsl:variable name="mm10" as="xs:double">
                <xsl:call-template name="convertUnits">
                    <xsl:with-param name="numUnit" select="'10mm'"/>
                    <xsl:with-param name="inUnitsOf" select="$unit"/>
                </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="increment" as="xs:double">
                <xsl:choose>
                    <xsl:when test="$unit = 'in'">
                        <xsl:value-of select="0.1"/>
                    </xsl:when>
                    <xsl:when test="$unit = 'cm'">
                        <xsl:value-of select="0.2"/>
                    </xsl:when>
                    <xsl:when test="$unit = 'mm'">
                        <xsl:value-of select="2"/>
                    </xsl:when>
                    <xsl:when test="$unit = 'em'">
                        <xsl:value-of select="0.5"/>
                    </xsl:when>
                    <xsl:when test="$unit = 'pt'">
                        <xsl:value-of select="10"/>
                    </xsl:when>
                    <xsl:when test="$unit = 'px'">
                        <xsl:value-of select="10"/>
                    </xsl:when>
                    <xsl:when test="$unit = 'pc'">
                        <xsl:value-of select="0.5"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>
            
            <xsl:variable name="diplayval" as="xs:double">
                <xsl:choose>
                    <xsl:when test="$unit = 'in'">
                        <xsl:value-of select="0.5"/>
                    </xsl:when>
                    <xsl:when test="$unit = 'cm'">
                        <xsl:value-of select="1"/>
                    </xsl:when>
                    <xsl:when test="$unit = 'mm'">
                        <xsl:value-of select="10"/>
                    </xsl:when>
                    <xsl:when test="$unit = 'em'">
                        <xsl:value-of select="2"/>
                    </xsl:when>
                    <xsl:when test="$unit = 'pt'">
                        <xsl:value-of select="25"/>
                    </xsl:when>
                    <xsl:when test="$unit = 'px'">
                        <xsl:value-of select="50"/>
                    </xsl:when>
                    <xsl:when test="$unit = 'pc'">
                        <xsl:value-of select="0.05"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="hops" as="xs:double">
                <xsl:choose>
                    <xsl:when test="$unit = 'pt'">
                        <xsl:value-of select="5"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="5"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:variable name="from" select="1"/>
            
            <xsl:message>
                <xsl:text>increment = </xsl:text>                
                <xsl:value-of select="$increment"/>
            </xsl:message>
            
            <xsl:variable name="tox" as="xs:integer">
                <xsl:value-of select="round($width div $increment)"/>
            </xsl:variable>

            <!-- DRAW HORIZONTAL TICKS -->
            <xsl:for-each select="for $i in $from to $tox return $i">
                <xsl:if test="(. * $increment) &gt;= $xoffs">
                    <xsl:element name="line">
                        <xsl:attribute name="x1">
                            <xsl:value-of select="concat((. * $increment),$unit)"/>
                        </xsl:attribute>
                        
                        <xsl:attribute name="y1" select="concat($yoffs, $unit)"/>
                        <xsl:attribute name="x2">
                            <xsl:value-of select="concat((. * $increment),$unit)"/>
                        </xsl:attribute>
                        <xsl:choose>
                            <xsl:when test="(. mod $hops) = 0">
                                <xsl:attribute name="y2">
                                    <xsl:value-of select="concat($yoffs + $hop-offs, $unit)"/>
                                </xsl:attribute>
                                <xsl:attribute name="style" select="'stroke:', $color-hops,'; stroke-width:1pt'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="y2">
                                    <xsl:value-of select="concat($yoffs + $step-offs, $unit)"/>
                                </xsl:attribute>
                                <xsl:attribute name="style" select="'stroke:', $color-step,'; stroke-width:1pt'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                    
                    <xsl:if test="(. mod $hops) = 0">
                        <xsl:element name="text">
                            <xsl:attribute name="x" select="concat(((. * $increment) + $xtext-align - (string-length(string(. * $increment)) * $xtext-align)),$unit)"/>
                            <xsl:attribute name="y" select="concat($yoffs - $ytext-offs, $unit)"/>
                            <xsl:attribute name="font-family" select="'Arial'"/>
                            <xsl:attribute name="font-size" select="$fontsize-in-pt"/>
                            <xsl:attribute name="fill" select="'red'"/>
                            <xsl:value-of select=". * $increment"/>                        
                        </xsl:element>
                    </xsl:if>
                </xsl:if>
            </xsl:for-each>

            <xsl:variable name="toy" as="xs:integer">
                <xsl:value-of select="round($height div $increment)"/>
            </xsl:variable>
            
            
            <!-- DRAW VERTICAL TICKS -->
            <xsl:for-each select="for $i in $from to $toy return $i">
                <xsl:if test="(. * $increment) &gt;= $yoffs">
                    <xsl:element name="line">
                        <xsl:attribute name="y1">
                            <xsl:value-of select="concat((. * $increment),$unit)"/>
                        </xsl:attribute>
                        
                        <xsl:attribute name="x1" select="concat($xoffs, $unit)"/>
                        
                        <xsl:attribute name="y2">
                            <xsl:value-of select="concat((. * $increment),$unit)"/>
                        </xsl:attribute>

                        <xsl:choose>
                            <xsl:when test="(. mod $hops) = 0">
                                <xsl:attribute name="x2">
                                    <xsl:value-of select="concat($xoffs + $hop-offs, $unit)"/>
                                </xsl:attribute>
                                <xsl:attribute name="style" select="'stroke:', $color-hops,'; stroke-width:1pt'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:attribute name="x2">
                                    <xsl:value-of select="concat($xoffs + $step-offs, $unit)"/>
                                </xsl:attribute>
                                <xsl:attribute name="style" select="'stroke:', $color-step,'; stroke-width:1pt'"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                    
                    <xsl:if test="(. mod $hops) = 0">
                        <xsl:element name="text">
                            <xsl:attribute name="x" select="concat(($xoffs - $xtext-align - (string-length(string(. * $increment)) * $xtext-align)),$unit)"/>
                            <xsl:attribute name="y" select="concat((. * $increment + $ytext-align),$unit)"/>
                            <xsl:attribute name="font-family" select="'Arial'"/>
                            <xsl:attribute name="font-size" select="$fontsize-in-pt"/>
                            <xsl:attribute name="fill" select="'red'"/>
                            <xsl:value-of select=". * $increment"/>                        
                        </xsl:element>
                    </xsl:if>
                </xsl:if>
            </xsl:for-each>
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

    <!--
        convertUnits receives a value 'numUnit' which contains unit information e.g. 54px
        and it returns the converted value as a number.
        
        The associated unit is delivered as input, so the caller knows it.
        This allows to convert any unit into a number which can take math.
    -->
    <xsl:template name="convertUnits" as="xs:double">
        <xsl:param name="numUnit"/>
        <xsl:param name="inUnitsOf"/>

        <xsl:variable name="vQ">
            <xsl:analyze-string select="string($numUnit)" regex="{'[0-9,\.]+'}">
                <xsl:matching-substring>
                    <number>
                        <xsl:value-of select="."/>
                    </number>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>

        <xsl:variable name="vU">
            <xsl:variable name="sUnit">
                <xsl:analyze-string select="string($numUnit)" regex="{'[a-z]+'}">
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
                <xsl:value-of select="round(10*$vQ * $vUnits[@name = $vU] div $vUnits[@name = $inUnitsOf]) div 10"/>
            </num>
        </xsl:variable>
        <xsl:value-of select="$normUnit"/>

        <!--HSX
        <xsl:message>
        <xsl:text>vU=</xsl:text>
        <xsl:value-of select="$vU" />
        </xsl:message>
        
        <xsl:message>
        <xsl:text>vQ=</xsl:text>
        <xsl:value-of select="$vQ" />
        </xsl:message>
        
        <xsl:message>
        <xsl:text>normUnit=</xsl:text>
        <xsl:value-of select="$normUnit" />
        </xsl:message>
        
        <xsl:text>&#xA;</xsl:text>
        -->
    </xsl:template>
</xsl:stylesheet>
