<?xml version='1.0'?>

<!-- 
Copyright © 2004-2006 by Idiom Technologies, Inc. All rights reserved. 
IDIOM is a registered trademark of Idiom Technologies, Inc. and WORLDSERVER
and WORLDSTART are trademarks of Idiom Technologies, Inc. All other 
trademarks are the property of their respective owners. 

IDIOM TECHNOLOGIES, INC. IS DELIVERING THE SOFTWARE "AS IS," WITH 
ABSOLUTELY NO WARRANTIES WHATSOEVER, WHETHER EXPRESS OR IMPLIED,  AND IDIOM
TECHNOLOGIES, INC. DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING
BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR 
PURPOSE AND WARRANTY OF NON-INFRINGEMENT. IDIOM TECHNOLOGIES, INC. SHALL NOT
BE LIABLE FOR INDIRECT, INCIDENTAL, SPECIAL, COVER, PUNITIVE, EXEMPLARY,
RELIANCE, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF 
ANTICIPATED PROFIT), ARISING FROM ANY CAUSE UNDER OR RELATED TO  OR ARISING 
OUT OF THE USE OF OR INABILITY TO USE THE SOFTWARE, EVEN IF IDIOM
TECHNOLOGIES, INC. HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. 

Idiom Technologies, Inc. and its licensors shall not be liable for any
damages suffered by any person as a result of using and/or modifying the
Software or its derivatives. In no event shall Idiom Technologies, Inc.'s
liability for any damages hereunder exceed the amounts received by Idiom
Technologies, Inc. as a result of this transaction.

These terms and conditions supersede the terms and conditions in any
licensing agreement to the extent that such terms and conditions conflict
with those set forth herein.

This file is part of the DITA Open Toolkit project hosted on Sourceforge.net. 
See the accompanying license.txt file for applicable licenses.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">

    <xsl:attribute-set name="linklist.title">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <!--Common-->
    <xsl:attribute-set name="li.itemgroup">
        <xsl:attribute name="space-after">3pt</xsl:attribute>
        <xsl:attribute name="space-before">3pt</xsl:attribute>
    </xsl:attribute-set>

    <!--Unordered list-->
    <xsl:attribute-set name="ul" use-attribute-sets="common.block">
        <!--HSC [DtPrt#11.7.1] explains the meaning of provisional-distance-between-starts
            specified also in [XslFo#7.30.12]
        -->
        <xsl:attribute name="provisional-distance-between-starts">5mm</xsl:attribute>
        <xsl:attribute name="provisional-label-separation">1mm</xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="margin-left">5.01mm</xsl:attribute>        
        <xsl:attribute name="start-indent">inherited-property-value(start-indent)</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="compact">
        <xsl:attribute name="space-before">
            <!--HSX allow the compact format for list items -->
            <xsl:variable name="myName" select="name()"/>
            <xsl:choose>
                <xsl:when test="contains(../@outputclass, 'compact') or (../@compact = 'yes')">
                    <xsl:choose>
                        <xsl:when test="count(preceding-sibling::*[contains(name(), $myName)]) &gt; 0">
                            <xsl:value-of select="$advance-compact"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <!-- check whether list item or compact:all enforces small space-before
                                 on first entry
                            -->
                            <xsl:choose>
                                <xsl:when test="contains(@outputclass, 'compact') or
                                                contains(../@outputclass, 'compact:all')">
                                    <xsl:value-of select="$advance-compact"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="$advance-default"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:when test="contains(@outputclass, 'compact')">
                    <xsl:value-of select="$advance-compact"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$advance-default"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <!--HSX ul.First is used to control indentation of the first ul -->
    <xsl:attribute-set name="ul.First" use-attribute-sets="ul">
        <xsl:attribute name="margin-left">5.03mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ul.li" use-attribute-sets="compact">
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <xsl:attribute name="relative-align">baseline</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ul.li__label">
        <xsl:attribute name="keep-together.within-line">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-line">always</xsl:attribute>
        <xsl:attribute name="end-indent">label-end()</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ul.li__label__content">
        <xsl:attribute name="text-align">start</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ul.li__body">
        <xsl:attribute name="start-indent">body-start()</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ul.li__content">
    </xsl:attribute-set>

    <!--Ordered list-->
    <xsl:attribute-set name="ol" use-attribute-sets="common.block">
        <xsl:attribute name="provisional-distance-between-starts">5mm</xsl:attribute>
        <xsl:attribute name="provisional-label-separation">1mm</xsl:attribute>
        <xsl:attribute name="margin-left">5.02mm</xsl:attribute>
    </xsl:attribute-set>

    <!--HSX ol.First is used to control indentation of the first ol -->
    <xsl:attribute-set name="ol.First" use-attribute-sets="ol">
        <xsl:attribute name="margin-left">5.6mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ol.li" use-attribute-sets="compact">
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <xsl:attribute name="relative-align">baseline</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ol.li__label">
        <xsl:attribute name="keep-together.within-line">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-line">always</xsl:attribute>
        <xsl:attribute name="end-indent">label-end()</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ol.li__label__content">
        <xsl:attribute name="text-align">start</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ol.li__body">
        <xsl:attribute name="start-indent">body-start()</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ol.li__content">
    </xsl:attribute-set>

    <!--Simple list-->
    <xsl:attribute-set name="sl" use-attribute-sets="common.block">
        <!-- Sounds like a copy-paste problem ... a simple table doesn't have a label - right?
        <xsl:attribute name="provisional-distance-between-starts">5mm</xsl:attribute>
        -->
        <xsl:attribute name="provisional-distance-between-starts">0mm</xsl:attribute>
        <xsl:attribute name="provisional-label-separation">1mm</xsl:attribute>
        <xsl:attribute name="space-before">3pt</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
    </xsl:attribute-set>
    
    <!--HSX ul.First is used to control indentation of the first ul -->
    <xsl:attribute-set name="sl.First" use-attribute-sets="sl">
        <xsl:attribute name="margin-left">5mm</xsl:attribute>
        <xsl:attribute name="space-before">10pt</xsl:attribute>
    </xsl:attribute-set>
    

    <xsl:attribute-set name="sl.sli" use-attribute-sets="compact">
        <!--HSX changed default value to 0pt to allow 'compact' attribute
        <xsl:attribute name="space-after">12pt</xsl:attribute>
        <xsl:attribute name="space-before">1.5pt</xsl:attribute>
        -->
        <xsl:attribute name="space-after">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="sl.sli__label">
        <xsl:attribute name="keep-together.within-line">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-line">always</xsl:attribute>
        <xsl:attribute name="end-indent">label-end()</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="sl.sli__label__content">
        <xsl:attribute name="text-align">start</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="sl.sli__body">
        <xsl:attribute name="start-indent">body-start()</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="sl.sli__content">
    </xsl:attribute-set>

</xsl:stylesheet>