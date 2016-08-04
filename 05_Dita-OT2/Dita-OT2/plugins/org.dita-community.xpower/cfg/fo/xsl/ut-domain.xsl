<?xml version="1.0" encoding="UTF-8"?>
<!--
This file is part of the DITA Open Toolkit project.
See the accompanying license.txt file for applicable licenses.
-->
<xsl:stylesheet  version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:svg="http://www.w3.org/2000/svg" xmlns:fo="http://www.w3.org/1999/XSL/Format" 
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function" 
    xmlns:xalan="http://xml.apache.org/xslt" xmlns:Math="xalan://java.lang.Math" xmlns:myJava="xalan://java.lang">



    <!--HSC imagemap in [DitaSpec#3.1.4.3.3] -->
    <xsl:template match="*[contains(@class, ' ut-d/imagemap ')]">
        <fo:inline>
            <xsl:call-template name="commonattributes"/>
        </fo:inline>
        <fo:block keep-with-previous="always">
            <fo:block-container>
                <!--HSX provide 10mm space for the scale, otherwise our scale
                    out run into the image (or the above text)
                -->  
                <xsl:choose>
                    <xsl:when test="contains(@outputclass, 'scale')">
                        <xsl:attribute name="space-before" select="'10mm'"/>                                
                        <!--HSX Create scale - [xslfo#5.10.4]-->
                        <!-- image -->
                        <!--HSX Define the units in which you like to see the scale -->
                        <xsl:variable name="attr-scale">
                            <xsl:analyze-string select="@outputclass" regex="{'scale:(.*)\s*'}">
                                <xsl:matching-substring>
                                    <xsl:value-of select="regex-group(1)"/>
                                </xsl:matching-substring>
                            </xsl:analyze-string>
                        </xsl:variable>
                        
                        <xsl:variable name="ScaleUnit">
                            <xsl:choose>
                                <xsl:when test="string-length($attr-scale) &gt; 0">
                                    <xsl:choose>
                                        <xsl:when test="$attr-scale = 'mm'">
                                            <xsl:value-of select="'mm'"/>
                                        </xsl:when>
                                        <xsl:when test="$attr-scale = 'px'">
                                            <xsl:value-of select="'px'"/>
                                        </xsl:when>
                                        <xsl:when test="$attr-scale = 'pt'">
                                            <xsl:value-of select="'pt'"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="'mm'"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'mm'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
    
                        <xsl:variable name="rawWidth" as="xs:double">
                            <xsl:call-template name="getImageWidth">
                                <xsl:with-param name="img" select="image"/>
                                <xsl:with-param name="unit" select="'px'"/>
                            </xsl:call-template>
                        </xsl:variable>
                        
                        <xsl:variable name="rawHeight" as="xs:double">
                            <xsl:call-template name="getImageHeight">
                                <xsl:with-param name="img" select="image"/>
                                <xsl:with-param name="unit" select="'px'"/>
                            </xsl:call-template>
                        </xsl:variable>
    
                        <xsl:variable name="imgWidth" as="xs:double">
                            <xsl:choose>
                                <xsl:when test="image/@width">
                                    <xsl:call-template name="convertUnitx">
                                        <xsl:with-param name="numUnit" select="image/@width"/>
                                        <xsl:with-param name="inUnitsOf" select="'px'"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="image/@height">
                                    <xsl:variable name="numHeight">
                                        <xsl:call-template name="convertUnitx">
                                            <xsl:with-param name="numUnit" select="image/@height"/>
                                            <xsl:with-param name="inUnitsOf" select="'px'"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:value-of select="round(10 * $rawWidth * $numHeight div $rawHeight) div 10"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$rawWidth"/>
                                </xsl:otherwise>
                            </xsl:choose>
                         </xsl:variable>
    
                        <xsl:variable name="imgHeight" as="xs:double">
                            <xsl:choose>
                                <xsl:when test="image/@height">
                                    <xsl:call-template name="convertUnitx">
                                        <xsl:with-param name="numUnit" select="image/@height"/>
                                        <xsl:with-param name="inUnitsOf" select="'px'"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="image/@width">
                                    <xsl:variable name="numWidth">
                                        <xsl:call-template name="convertUnitx">
                                            <xsl:with-param name="numUnit" select="image/@width"/>
                                            <xsl:with-param name="inUnitsOf" select="'px'"/>
                                        </xsl:call-template>
                                    </xsl:variable>
                                    <xsl:value-of select="round(10 * $rawHeight * $numWidth div $rawWidth) div 10"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$rawHeight"/>
                                </xsl:otherwise>
                            </xsl:choose>
                         </xsl:variable>
    
                        <xsl:variable name="topleftShift">
                            <xsl:variable name="Lraw">
                                <xsl:call-template name="convertUnitx">
                                    <xsl:with-param name="numUnit" select="'10mm'"/>
                                    <xsl:with-param name="inUnitsOf" select="$ScaleUnit"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:variable name="roh">
                                <xsl:call-template name="roundUnit">
                                    <xsl:with-param name="val" select="$Lraw"/>
                                </xsl:call-template>
                            </xsl:variable>
                            <xsl:value-of select="concat('-', $roh, $ScaleUnit)"/>
                        </xsl:variable>
                        
                        <xsl:if test="contains($unittest, 'imgscale')">
                            <xsl:message>                        
                                <xsl:text>ImageXY[px]=(</xsl:text>
                                <xsl:value-of select="$imgWidth"/>
                                <xsl:text>)(</xsl:text>
                                <xsl:value-of select="$imgHeight"/>
                                <xsl:text>) topleftShift = </xsl:text>
                                <xsl:value-of select="$topleftShift"/>
                            </xsl:message>
                        </xsl:if>
                        
                        <xsl:variable name="PageWidth">
                            <xsl:call-template name="convertUnitx">
                                <xsl:with-param name="numUnit" select="$page-width"/>
                                <xsl:with-param name="inUnitsOf" select="'px'"/>
                            </xsl:call-template>
                        </xsl:variable>
                        
                        <xsl:variable name="PageMrgInside">
                            <xsl:call-template name="convertUnitx">
                                <xsl:with-param name="numUnit" select="$page-margin-inside"/>
                                <xsl:with-param name="inUnitsOf" select="'px'"/>
                            </xsl:call-template>
                        </xsl:variable>
                        
                        <xsl:variable name="PageMrgOutside">
                            <xsl:call-template name="convertUnitx">
                                <xsl:with-param name="numUnit" select="$page-margin-outside"/>
                                <xsl:with-param name="inUnitsOf" select="'px'"/>
                            </xsl:call-template>
                        </xsl:variable>
                        
                        <xsl:variable name="LeftColWidth">
                            <xsl:call-template name="convertUnitx">
                                <xsl:with-param name="numUnit" select="$side-col-width"/>
                                <xsl:with-param name="inUnitsOf" select="'px'"/>
                            </xsl:call-template>
                        </xsl:variable>
                        
                        <!--HSX
                            The scale and area will always be computed left aligned. If the image
                            has the placement=break and align=center, then the scale will stay
                            left aligned. Same is valid for the imagemap AREA.
                            
                            So the area has alwasy be computed from left-alignment, only the
                            image will move by the @align = left|center|right.
                            
                            This method has the advantage that any measurements are always
                            exact. As we do not know our odd/even page status, we would not
                            be able to determine the correct offset from the left margin.
                        -->
                        <xsl:variable name="ExtendedWidth" as="xs:double">
                            <xsl:choose>
                                <!--HSX inline image will alwasy be left aligned -->
                                <xsl:when test="contains(image/@placement, 'inline')">
                                    <xsl:value-of select="$imgWidth"/>
                                </xsl:when>
                                <xsl:when test="contains(image/@align, 'center')">
                                    <xsl:call-template name="convertUnitx">
                                        <xsl:with-param name="numUnit" select="concat(string(($PageWidth - 
                                                                                $PageMrgInside - 
                                                                                $PageMrgOutside -
                                                                                $LeftColWidth +
                                                                                $imgWidth) div 2) , 'px')"/>
                                        <xsl:with-param name="inUnitsOf" select="'px'"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:when test="contains(image/@align, 'right')">
                                    <xsl:call-template name="convertUnitx">
                                        <xsl:with-param name="numUnit" select="concat(string($PageWidth - 
                                                                                $PageMrgInside - 
                                                                                $PageMrgOutside - 
                                                                                $LeftColWidth) , 'px')"/>
                                        <xsl:with-param name="inUnitsOf" select="'px'"/>
                                    </xsl:call-template>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$imgWidth"/>
                                </xsl:otherwise>
                            </xsl:choose>                            
                        </xsl:variable>
                                                
                        <!--HSX Print the actual image, left aligned to text flow -->
                        <fo:block start-indent="0mm">
                            <xsl:apply-templates select="*[contains(@class, ' topic/image ')]"/>
                        </fo:block>
    
                        <fo:block-container absolute-position="absolute"
                            border-color="blue"
                            border-style="solid"
                            border-width="0pt">
                            <xsl:attribute name="left"   select="$topleftShift"/>
                            <xsl:attribute name="top"    select="$topleftShift"/>
                            <xsl:attribute name="width"  select="concat($ExtendedWidth+50, 'px')"/>
                            <xsl:attribute name="height" select="concat($imgHeight+50, 'px')"/>
    
                            <!--HSX place scale directly over the image drawn above -->
                            <fo:block padding-bottom="0mm" padding-left="0mm" padding-top="0mm" start-indent="0mm">
                                <!-- this is new -->
                                <fo:instream-foreign-object>
                                    <xsl:call-template name="createSvg">
                                        <xsl:with-param name="filename"  select="image/@href"/>
                                        <xsl:with-param name="units"     select="$ScaleUnit"/>
                                        <xsl:with-param name="moveout"   select="$topleftShift"/>
                                        <xsl:with-param name="imgWidth"  select="$ExtendedWidth"/>
                                        <xsl:with-param name="imgHeight" select="$imgHeight"/>
                                    </xsl:call-template>
                                </fo:instream-foreign-object>
                            </fo:block>
                        </fo:block-container>
                        <!-- this made it work - end -->        
                        <xsl:apply-templates select="*[contains(@class, ' ut-d/area ')]"/>                        
                    </xsl:when>
                    <!--HSX If we do not have a scale, we print the image as usual -->
                    <xsl:otherwise>
                        <fo:block start-indent="0mm">
                            <xsl:apply-templates select="*[contains(@class, ' topic/image ')]"/>
                        </fo:block>
                        <xsl:apply-templates select="*[contains(@class, ' ut-d/area ')]"/>
                    </xsl:otherwise>
                </xsl:choose>                            
            </fo:block-container>
        </fo:block>
    </xsl:template>
    
    <!--HSX get the stb-important part from an stb reference, we correct the path from our
        knowledge of the relative path in DocuPath
    -->
    <xsl:template name="getStbTarget">
        <xsl:param name="stbPath"/>
        <xsl:analyze-string select="$stbPath" regex="{'.*(/.*/.*$)'}" flags="x">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)"/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' ut-d/area ')]">
        <xsl:variable name="shpType">
            <xsl:apply-templates select="*[contains(@class, ' ut-d/shape ')]"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$shpType = 'rect'">
                <fo:block-container border-style="solid" border-width="0pt" border-color="blue">
                    <xsl:apply-templates select="*[contains(@class, ' ut-d/coords ')]"/>
                    <fo:block padding-bottom="0mm" padding-left="0mm" padding-top="0mm" start-indent="0mm">
                        <!--HSX we need separate dispatch mechanism for area/xref/@href because we do not want any
                            linktext printed
                        -->
                        <fo:basic-link xsl:use-attribute-sets="xref">
                            <!--HSX in case of keyref, we are internal and the destination is in @href-->
                            <xsl:variable name="sref">
                                <xsl:choose>
                                    <xsl:when test="xref/@scope = 'external'">
                                        <xsl:value-of select="xref/@href"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:value-of select="opentopic-func:getDestinationId(xref/@href)"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </xsl:variable>
                            
                            <xsl:choose>
                                <xsl:when test="$sref">
                                    <xsl:choose>
                                        <xsl:when test="xref/@scope = 'external'">
                                            <xsl:attribute name="external-destination">
                                                <!--HSX special path correction for a ezread stub file relative path -->
                                                <xsl:choose>
                                                    <xsl:when test="starts-with($sref,'..') and ends-with($sref,'.stb')">
                                                        <xsl:variable name="stbTarget">
                                                            <xsl:call-template name="getStbTarget">
                                                                <xsl:with-param name="stbPath" select="$sref"/>
                                                            </xsl:call-template>
                                                        </xsl:variable>
                                                        <xsl:value-of
                                                            select="concat(
                                                            $DocuPath,
                                                            '\dev\ref\stb',
                                                            translate($stbTarget, '/', '\'))"
                                                        />
                                                    </xsl:when>
                                                </xsl:choose>
                                                
                                            </xsl:attribute>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:attribute name="internal-destination" select="$sref"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:when>
                            </xsl:choose>
                            
                            <fo:instream-foreign-object display-align="center" text-align="center">
                                <xsl:call-template name="setCoords">
                                    <xsl:with-param name="sqc" select="coords"/>
                                    <xsl:with-param name="width" select="'width'"/>
                                    <xsl:with-param name="height" select="'height'"/>
                                </xsl:call-template>
                                <!-- content-width/height is optional, will default correctly -->
                                <xsl:call-template name="setCoords">
                                    <xsl:with-param name="sqc" select="coords"/>
                                    <xsl:with-param name="width" select="'content-width'"/>
                                    <xsl:with-param name="height" select="'content-height'"/>
                                </xsl:call-template>
                                <!-- Create the SVG box -->
                                <xsl:element name="svg">
                                    <xsl:attribute name="version" select="1.1"/>
                                    <!-- viewbox in [svgspec#7.7] -->
                                    <xsl:attribute name="viewBox">
                                        <!--HSX calling setCoords with ':' delivers values only -->
                                        <xsl:call-template name="setCoords">
                                            <xsl:with-param name="sqc" select="coords"/>
                                            <xsl:with-param name="left" select="':'"/>
                                        </xsl:call-template>
                                        <xsl:text> </xsl:text>
                                        <xsl:call-template name="setCoords">
                                            <xsl:with-param name="sqc" select="coords"/>
                                            <xsl:with-param name="top" select="':'"/>
                                        </xsl:call-template>
                                        <xsl:text> </xsl:text>
                                        <xsl:call-template name="setCoords">
                                            <xsl:with-param name="sqc" select="coords"/>
                                            <xsl:with-param name="width" select="':'"/>
                                        </xsl:call-template>
                                        <xsl:text> </xsl:text>
                                        <xsl:call-template name="setCoords">
                                            <xsl:with-param name="sqc" select="coords"/>
                                            <xsl:with-param name="height" select="':'"/>
                                        </xsl:call-template>
                                    </xsl:attribute>
                                    <xsl:element name="rect">
                                        <xsl:attribute name="stroke" select="'none'"/>
                                        <xsl:attribute name="stroke-width" select="3"/>
                                        <xsl:attribute name="fill" select="'red'"/>
                                        <xsl:choose>
                                            <xsl:when
                                                test="
                                                contains(@outputclass, 'show') or
                                                contains(../@outputclass, 'show')">
                                                <xsl:attribute name="fill-opacity" select="0.3"/>
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:attribute name="fill-opacity" select="0.0"/>
                                            </xsl:otherwise>
                                        </xsl:choose>
                                        <xsl:call-template name="setCoords">
                                            <xsl:with-param name="sqc" select="coords"/>
                                            <xsl:with-param name="left" select="'x'"/>
                                            <xsl:with-param name="top" select="'y'"/>
                                            <xsl:with-param name="width" select="'width'"/>
                                            <xsl:with-param name="height" select="'height'"/>
                                        </xsl:call-template>
                                    </xsl:element>
                                </xsl:element>
                            </fo:instream-foreign-object>
                        </fo:basic-link>
                    </fo:block>
                </fo:block-container>
            </xsl:when>

            <!--HSX currently no other than rect box is supported -->
            <xsl:otherwise/>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' ut-d/shape ')]">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' ut-d/coords ')]">
        <xsl:attribute name="absolute-position">absolute</xsl:attribute>
        <xsl:call-template name="setCoords">
            <xsl:with-param name="sqc" select="."/>
            <xsl:with-param name="left" select="'left'"/>
            <xsl:with-param name="top" select="'top'"/>
            <xsl:with-param name="width" select="'width'"/>
            <xsl:with-param name="height" select="'height'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template name="setCoords">
        <xsl:param name="sqc"/>
        <xsl:param name="left"/>
        <xsl:param name="top"/>
        <xsl:param name="width"/>
        <xsl:param name="height"/>

        <xsl:variable name="coords" select="tokenize($sqc, ',')"/>

        <xsl:if test="$left">
            <xsl:variable name="cleft" as="xs:double">
                <xsl:call-template name="convertUnits">
                    <xsl:with-param name="numUnit" select="subsequence($coords, 1, 1)"/>
                    <xsl:with-param name="inUnitsOf" select="'mm'"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$left = ':'">
                    <xsl:value-of select="concat(round(10 * $cleft) div 10, 'mm')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="{$left}">
                        <xsl:value-of select="concat(round(10 * $cleft) div 10, 'mm')"/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

        <xsl:if test="$top">
            <xsl:variable name="ctop" as="xs:double">
                <xsl:call-template name="convertUnits">
                    <xsl:with-param name="numUnit" select="subsequence($coords, 2, 1)"/>
                    <xsl:with-param name="inUnitsOf" select="'mm'"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$top = ':'">
                    <xsl:value-of select="concat(round(10 * $ctop) div 10, 'mm')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="{$top}">
                        <xsl:value-of select="concat(round(10 * $ctop) div 10, 'mm')"/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

        <xsl:if test="$width">
            <xsl:variable name="cwidth" as="xs:double">
                <xsl:call-template name="convertUnits">
                    <xsl:with-param name="numUnit" select="subsequence($coords, 3, 1)"/>
                    <xsl:with-param name="inUnitsOf" select="'mm'"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$width = ':'">
                    <xsl:value-of select="concat(round(10 * $cwidth) div 10, 'mm')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="{$width}">
                        <xsl:value-of select="concat(round(10 * $cwidth) div 10, 'mm')"/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>

        <xsl:if test="$height">
            <xsl:variable name="cheight" as="xs:double">
                <xsl:call-template name="convertUnits">
                    <xsl:with-param name="numUnit" select="subsequence($coords, 4, 1)"/>
                    <xsl:with-param name="inUnitsOf" select="'mm'"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$height = ':'">
                    <xsl:value-of select="concat(round(10 * $cheight) div 10, 'mm')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="{$height}">
                        <xsl:value-of select="concat(round(10 * $cheight) div 10, 'mm')"/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
