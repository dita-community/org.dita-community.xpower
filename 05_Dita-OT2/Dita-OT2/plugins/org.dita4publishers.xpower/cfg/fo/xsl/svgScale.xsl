<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:svg="http://www.w3.org/2000/svg"
    xmlns:my="my:my" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:math="http://exslt.org/math"
    xmlns:test="something"
    xmlns:java-file="java:java.io.File"
    xmlns:java-uri="java:java.net.URI"
    xmlns:java-imageicon="java:javax.swing.ImageIcon"
    exclude-result-prefixes="xs my">

    <xsl:output method="xml" indent="yes"/>

    <xsl:param name="input.dir.url" required="yes" as="xs:string"/>

    <!--
    ================================================================

    Create Scale as svg inline drawing

    ================================================================
    -->

    <xsl:variable name="fonts" select="'sans-serif'"/>

    <xsl:template name="createSvg">
        <xsl:param name="filename"   as="xs:string"/>
        <xsl:param name="units"      as="xs:string"/>
        <xsl:param name="moveout"    as="xs:string"/>
        <xsl:param name="imgWidth"   as="xs:double"/>
        <xsl:param name="imgHeight"  as="xs:double"/>
        <!-- alternative approach using the URL, not used here
        <xsl:variable name="pathname" select="replace(concat($input.dir.url, $filename), 'file:[/]+', '')" as="xs:string"/>
        
        <xsl:message>
            <xsl:text>CreateSVG:&#x0A;imgWidth = </xsl:text>
            <xsl:value-of select="$imgWidth"/>
            <xsl:text>&#xA;imgHeight = </xsl:text>
            <xsl:value-of select="$imgHeight"/>
        </xsl:message>
        -->
        
        <xsl:variable name="pathname" select="concat($input.dir.url, $filename)" as="xs:string"/>
        <xsl:variable name="filepath" select="replace($pathname, 'file:[/]+', '')" as="xs:string"/>

        <xsl:if test="test:file-exists(string($filepath))">
            <!--
            <xsl:variable name="pxwidth"  as="xs:integer" select="test:image-width($filepath)"/>
            <xsl:variable name="pxheight" as="xs:integer" select="test:image-height($filepath)"/>
            <xsl:variable name="uwidth" as="xs:string">
                <xsl:variable name="raw">
                    <xsl:call-template name="convertUnitx">
                        <xsl:with-param name="numUnit" select="concat(string($pxwidth), 'px')"/>
                        <xsl:with-param name="inUnitsOf" select="$units"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat(string($raw), $units)"/>
            </xsl:variable>

            <xsl:variable name="uheight" as="xs:string">
                <xsl:variable name="raw">
                    <xsl:call-template name="convertUnitx">
                        <xsl:with-param name="numUnit" select="concat(string($pxheight), 'px')"/>
                        <xsl:with-param name="inUnitsOf" select="$units"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat(string($raw), $units)"/>
            </xsl:variable>
            -->
            
            <xsl:variable name="uwidth" as="xs:string">
                <xsl:variable name="raw">
                    <xsl:call-template name="convertUnitx">
                        <xsl:with-param name="numUnit" select="concat($imgWidth, 'px')"/>
                        <xsl:with-param name="inUnitsOf" select="$units"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat(string($raw), $units)"/>
            </xsl:variable>

            <xsl:variable name="uheight" as="xs:string">
                <xsl:variable name="raw">
                    <xsl:call-template name="convertUnitx">
                        <xsl:with-param name="numUnit" select="concat($imgHeight, 'px')"/>
                        <xsl:with-param name="inUnitsOf" select="$units"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:value-of select="concat(string($raw), $units)"/>
            </xsl:variable>

            <!--
            <xsl:message>
                <xsl:text>uwidth = </xsl:text>
                <xsl:value-of select="$uwidth"/>
                <xsl:text>&#xA;uheight = </xsl:text>
                <xsl:value-of select="$uheight"/>
            </xsl:message>
            -->
            
            <xsl:variable name="unit" select="$units"/>

             <!-- Define colors -->
            <xsl:variable name="color-axis" select="'black'"/>
            <xsl:variable name="color-hops" select="'blue'"/>
            <xsl:variable name="color-step" select="'red'"/>
            <xsl:variable name="text-color" select="'blue'"/>

            <!-- Define base coordinates in units of the base unit
                 xoffs and yoffs move the coordinate system right-down
                 from the 0,0 point of the image
            -->
            <xsl:variable name="xoffs" as="xs:double">
                <xsl:variable name="xRaw">
                    <xsl:call-template name="convertUnitx">
                        <xsl:with-param name="numUnit" select="$moveout"/>
                        <xsl:with-param name="inUnitsOf" select="$unit"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="roundUnit">
                    <xsl:with-param name="val" select="$xRaw"/>
                </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="yoffs" as="xs:double">
                <xsl:variable name="yRaw">
                    <xsl:call-template name="convertUnitx">
                        <xsl:with-param name="numUnit" select="$moveout"/>
                        <xsl:with-param name="inUnitsOf" select="$unit"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="roundUnit">
                    <xsl:with-param name="val" select="$yRaw"/>
                </xsl:call-template>
            </xsl:variable>

            <!--
            <xsl:message>
                <xsl:text>xyoffs = [</xsl:text>
                <xsl:value-of select="$xoffs"/>
                <xsl:text>][</xsl:text>
                <xsl:value-of select="$yoffs"/>
                <xsl:text>]</xsl:text>
            </xsl:message>
            -->

            <xsl:variable name="hop-offs">
                <xsl:variable name="rRaw">
                    <xsl:call-template name="convertUnitx">
                        <xsl:with-param name="numUnit" select="'5mm'"/>
                        <xsl:with-param name="inUnitsOf" select="$unit"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="roundUnit">
                    <xsl:with-param name="val" select="$rRaw"/>
                </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="step-offs">
                <xsl:variable name="rRaw">
                    <xsl:call-template name="convertUnitx">
                        <xsl:with-param name="numUnit" select="'1mm'"/>
                        <xsl:with-param name="inUnitsOf" select="$unit"/>
                    </xsl:call-template>
                </xsl:variable>
                <xsl:call-template name="roundUnit">
                    <xsl:with-param name="val" select="$rRaw"/>
                </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="fontsize-in-pt">
                <xsl:call-template name="convertUnitx">
                    <xsl:with-param name="numUnit" select="'12pt'"/>
                    <xsl:with-param name="inUnitsOf" select="'pt'"/>
                </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="xtext-offs">
                <xsl:call-template name="convertUnitx">
                    <xsl:with-param name="numUnit" select="concat($fontsize-in-pt * 4, 'pt')"/>
                    <xsl:with-param name="inUnitsOf" select="$unit"/>
                </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="ytext-offs">
                <xsl:call-template name="convertUnitx">
                    <xsl:with-param name="numUnit" select="concat($fontsize-in-pt * 0.3, 'pt')"/>
                    <xsl:with-param name="inUnitsOf" select="$unit"/>
                </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="xtext-align">
                <xsl:call-template name="convertUnitx">
                    <xsl:with-param name="numUnit" select="concat($fontsize-in-pt * 0.72, 'pt')"/>
                    <xsl:with-param name="inUnitsOf" select="$unit"/>
                </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="ytext-align">
                <xsl:call-template name="convertUnitx">
                    <xsl:with-param name="numUnit" select="concat($fontsize-in-pt * 0.2, 'pt')"/>
                    <xsl:with-param name="inUnitsOf" select="$unit"/>
                </xsl:call-template>
            </xsl:variable>



            <xsl:element name="svg">
                <!-- set default namespace, not really necessary as done automatically
                    <xsl:namespace name="" select="'http://www.w3.org/2000/svg'"/>
                -->
                <xsl:attribute name="version" select="1.1"/>

                <!-- viewbox in [svgspec#7.7] -->
    <!--
                <xsl:attribute name="width" select="$uwidth"/>
                <xsl:attribute name="height" select="$uheight"/>
    -->
                <xsl:variable name="width" select="number(normalize-space(substring-before($uwidth, $unit)))" as="xs:double"/>
                <xsl:variable name="height" select="number(normalize-space(substring-before($uheight, $unit)))" as="xs:double"/>

    <!--
                <xsl:attribute name="viewBox">
                    <xsl:value-of select="concat('0mm 0mm ', $width, ' ', $height)"/>
                </xsl:attribute>
    -->
                <!-- draw horizontal units every 5mm -->
                <xsl:variable name="mm10" as="xs:double">
                    <xsl:call-template name="convertUnitx">
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
                            <xsl:value-of select="5"/>
                        </xsl:when>
                        <xsl:when test="$unit = 'px'">
                            <xsl:value-of select="10"/>
                        </xsl:when>
                        <xsl:when test="$unit = 'pc'">
                            <xsl:value-of select="0.5"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="1"/>
                        </xsl:otherwise>
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
                            <xsl:value-of select="5 * $increment"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="5 * $increment"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <xsl:variable name="from" select="1"/>

                <xsl:variable name="tox" as="xs:integer">
                    <xsl:value-of select="round(($width + $xoffs) div $increment)"/>
                </xsl:variable>

                <!-- DRAW HORIZONTAL TICKS -->
                <xsl:for-each select="for $i in $from to $tox return $i">
                    <xsl:variable name="distance" as="xs:double">
                        <xsl:value-of select=". * $increment"/>
                    </xsl:variable>

                    <!--
                    <xsl:message>
                        <xsl:text>x-distance[</xsl:text>
                        <xsl:value-of select="$xoffs"/>
                        <xsl:text>] = </xsl:text>
                        <xsl:value-of select="$distance"/>
                        <xsl:text>  tox = </xsl:text>
                        <xsl:value-of select="$tox"/>
                        <xsl:text>  i = </xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:message>
                    -->

                    <xsl:if test="$distance &gt;= $xoffs">
                        <xsl:element name="line">
                            <xsl:attribute name="x1">
                                <xsl:value-of select="concat($distance ,$unit)"/>
                            </xsl:attribute>

                            <xsl:attribute name="y1" select="concat($yoffs, $unit)"/>
                            <xsl:attribute name="x2">
                                <xsl:value-of select="concat($distance,$unit)"/>
                            </xsl:attribute>
                            <xsl:choose>
                                <xsl:when test="(($distance - $xoffs) mod $hops) = 0">
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

                        <!--HSX print axis text -->
                        <xsl:if test="(($distance - $xoffs) mod $hops) = 0">
                            <!--
                            <xsl:message>
                                <xsl:text>mod-distance[</xsl:text>
                                <xsl:value-of select="$xoffs"/>
                                <xsl:text>] = </xsl:text>
                                <xsl:value-of select="$distance"/>
                                <xsl:text>  hops = </xsl:text>
                                <xsl:value-of select="$hops"/>
                                <xsl:text>  diff = </xsl:text>
                                <xsl:value-of select="$distance - $xoffs"/>
                                <xsl:text>  mod = </xsl:text>
                                <xsl:value-of select="($distance - $xoffs) mod $hops"/>
                            </xsl:message>
                            -->

                            <xsl:element name="text">
                                <xsl:attribute name="y" select="concat($yoffs - $ytext-offs, $unit)"/>
                                <xsl:call-template name="setFontFamily"/>
                                <xsl:attribute name="font-size" select="$fontsize-in-pt"/>
                                <xsl:attribute name="fill" select="$text-color"/>
                                <xsl:choose>
                                    <xsl:when test="($distance - $xoffs) &gt; 0">
                                <xsl:attribute name="x" select="concat(($distance - (string-length(string($distance - $xoffs)) * 5 * $xtext-align) div 10) + (0.5 * $xtext-align),$unit)"/>
                                        <xsl:value-of select="$distance - $xoffs"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:attribute name="x" select="'6mm'"/>
                                        <xsl:value-of select="concat('[', $unit, ']')"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:element>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>

                <xsl:variable name="toy" as="xs:integer">
                    <xsl:value-of select="round(($height + $yoffs) div $increment)"/>
                </xsl:variable>


                <!-- DRAW VERTICAL TICKS -->
                <xsl:for-each select="for $i in $from to $toy return $i">
                    <xsl:variable name="distance" as="xs:double">
                        <xsl:value-of select=". * $increment"/>
                    </xsl:variable>

                    <xsl:if test="$distance &gt;= $yoffs">
                        <xsl:element name="line">
                            <xsl:attribute name="y1">
                                <xsl:value-of select="concat($distance,$unit)"/>
                            </xsl:attribute>

                            <xsl:attribute name="x1" select="concat($xoffs, $unit)"/>

                            <xsl:attribute name="y2">
                                <xsl:value-of select="concat($distance,$unit)"/>
                            </xsl:attribute>

                            <xsl:choose>
                                <xsl:when test="(($distance - $yoffs) mod $hops) = 0">
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

                        <xsl:if test="(($distance - $yoffs) mod $hops) = 0">
                            <xsl:element name="text">
                                <xsl:attribute name="x" select="concat(($xoffs - ((string-length(string($distance - $yoffs)) * 5 * $xtext-align)) div 10) - (0.6 * $xtext-align),$unit)"/>
                                <xsl:attribute name="y" select="concat(($distance + $ytext-align),$unit)"/>
                                <xsl:attribute name="font-size" select="$fontsize-in-pt"/>
                                <xsl:call-template name="setFontFamily"/>
                                <xsl:attribute name="fill" select="$text-color"/>
                                <xsl:if test="($distance - $yoffs) &gt; 0">
                                    <xsl:value-of select="$distance - $yoffs"/> <!--  - $yoffs -->
                                </xsl:if>
                            </xsl:element>
                        </xsl:if>
                    </xsl:if>
                </xsl:for-each>

                <!-- draw horizontal scale line -->
                <xsl:element name="line">
                    <xsl:attribute name="x1" select="concat($xoffs, $unit)"/>
                    <xsl:attribute name="y1" select="concat($yoffs, $unit)"/>
                    <xsl:attribute name="x2" select="concat($width+$xoffs, $unit)"/>
                    <xsl:attribute name="y2" select="concat($yoffs, $unit)"/>
                    <xsl:attribute name="style" select="'stroke:', $color-axis,'; stroke-width:2px;'"/>
                </xsl:element>

                <!-- draw vertical scale line -->
                <xsl:element name="line">
                    <xsl:attribute name="x1" select="concat($xoffs, $unit)"/>
                    <xsl:attribute name="y1" select="concat($yoffs, $unit)"/>
                    <xsl:attribute name="x2" select="concat($xoffs, $unit)"/>
                    <xsl:attribute name="y2" select="concat($height+$yoffs, $unit)"/>
                    <xsl:attribute name="style" select="'stroke:', $color-axis,'; stroke-width:2px;'"/>
                </xsl:element>
            </xsl:element>
        </xsl:if>
    </xsl:template>

<!-- defined elsewhere
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
-->


    <!--HSX roundUnit determines the best increment value that is a multiple of 10**n -->
    <xsl:template name="roundUnit">
        <xsl:param name="val" select="rawVal" as="xs:double"/>

        <xsl:variable name="lg10" as="xs:integer">
            <xsl:value-of select="string-length(string(round(1000*$val)))"/>
        </xsl:variable>

        <xsl:variable name="fc" as="xs:integer">
            <xsl:variable name="sq0">
                <xsl:for-each
                    select="
                        for $i in 2 to $lg10
                        return
                            $i">
                    <xsl:value-of select="'0'"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="number(concat('1', string($sq0)))"/>
        </xsl:variable>

        <xsl:variable name="dtm" as="xs:double">
            <xsl:value-of select="1000*$val div $fc"/>
        </xsl:variable>

        <xsl:variable name="incr">
            <xsl:choose>
                <xsl:when test="$dtm &gt; 7.5">
                    <xsl:value-of select="10"/>
                </xsl:when>
                <xsl:when test="$dtm &gt; 3.5">
                    <xsl:value-of select="5"/>
                </xsl:when>
                <xsl:when test="$dtm &gt; 1.5">
                    <xsl:value-of select="2"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="1"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$incr * $fc div 1000"/>
    </xsl:template>

    <!--
        convertUnitx receives a value 'numUnit' which contains unit information e.g. 54px
        and it returns the converted value as a number.

        The associated unit is delivered as input, so the caller knows it.
        This allows to convert any unit into a number which can take math.
    -->
    <xsl:template name="convertUnitx" as="xs:double">
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
        <!--
        <xsl:message>
          <xsl:text>numUnit = </xsl:text>
          <xsl:value-of select="$numUnit"/>
          <xsl:text>&#xA;vQ = </xsl:text>
          <xsl:value-of select="$vQ"/>
          <xsl:text>&#xA;vU = </xsl:text>
          <xsl:value-of select="$vU"/>
        </xsl:message>
        -->

        <xsl:variable name="normUnit">
            <num>
                <xsl:value-of select="round(10*$vQ * $vUnits[@name = $vU] div $vUnits[@name = $inUnitsOf]) div 10"/>
            </num>
        </xsl:variable>
        <xsl:value-of select="$normUnit"/>
    </xsl:template>

    <!--
    ================================================================

    HSX JAVA function calls to support image size and file existance

    ================================================================
    -->
    <xsl:function name="test:file-exists" as="xs:boolean">
        <xsl:param name="chkname" as="xs:string"/>
        <!-- alternative approach using the URL, not used here
        <xsl:value-of select="java-file:exists(java-file:new(java-uri:new($chkname)))"/>
        -->
        <xsl:value-of select="java-file:exists(java-file:new(string($chkname)))"/>
    </xsl:function>

    <!--HSX The invokation with string(..) is necessary to call the string constructor.
            If we don't use string(...) then the $-sign of the variable makes the
            function think to expect a byte instead of a string
    -->
    <xsl:function name="test:image-height" as="xs:integer">
        <xsl:param name="gfxname" as="xs:string"/>
        <xsl:value-of select="java-imageicon:getIconHeight(java-imageicon:new(string($gfxname)))"/>
    </xsl:function>

    <xsl:function name="test:image-width" as="xs:integer">
        <xsl:param name="gfxname" as="xs:string"/>
        <xsl:value-of select="java-imageicon:getIconWidth(java-imageicon:new(string($gfxname)))"/>
    </xsl:function>


    <xsl:template name="getImageWidth" as="xs:double">
        <xsl:param name="img"     as="node()"/>
        <xsl:param name="unit"    as="xs:string"/>

        <xsl:variable name="filename" select="$img/@href" as="xs:string" />
        <xsl:variable name="pathname" select="concat($input.dir.url, $filename)" as="xs:string"/>
        <xsl:variable name="filepath" select="replace($pathname, 'file:[/]+', '')" as="xs:string"/>

        <xsl:variable name="pxwidth"  as="xs:integer" select="test:image-width($filepath)"/>
        <xsl:variable name="raw">
            <xsl:call-template name="convertUnitx">
                <xsl:with-param name="numUnit" select="concat(string($pxwidth), 'px')"/>
                <xsl:with-param name="inUnitsOf" select="$unit"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$raw"/>
    </xsl:template>

    <xsl:template name="getImageHeight" as="xs:double">
        <xsl:param name="img"     as="node()"/>
        <xsl:param name="unit"    as="xs:string"/>

        <xsl:variable name="filename" select="$img/@href" as="xs:string" />
        <xsl:variable name="pathname" select="concat($input.dir.url, $filename)" as="xs:string"/>
        <xsl:variable name="filepath" select="replace($pathname, 'file:[/]+', '')" as="xs:string"/>

        <xsl:variable name="pxheight" as="xs:integer" select="test:image-height($filepath)"/>
        <xsl:variable name="raw">
            <xsl:call-template name="convertUnitx">
                <xsl:with-param name="numUnit" select="concat(string($pxheight), 'px')"/>
                <xsl:with-param name="inUnitsOf" select="$unit"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="$raw"/>
    </xsl:template>
    
    <xsl:template name="setFontFamily">
        <!--HSX did complain in i8n that font family is not available
        -->
        <xsl:attribute name="font-family" select="$fonts"/>
    </xsl:template>
        

</xsl:stylesheet>
