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

This file is part of the DITA Open Toolkit project.
See the accompanying license.txt file for applicable licenses.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:opentopic-mapmerge="http://www.idiominc.com/opentopic/mapmerge"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:related-links="http://dita-ot.sourceforge.net/ns/200709/related-links"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="opentopic-mapmerge opentopic-func related-links xs" version="2.0">

    <xsl:template match="*[contains(@class, ' equation-d/equation-block ')]">
        <fo:table xsl:use-attribute-sets="eq-table">
            <fo:table-column column-number="1" column-width="proportional-column-width(1.)" text-align="left"/>
            <fo:table-column column-number="2" column-width="20mm" text-align="right"/> 
            <fo:table-body keep-with-previous="1" start-indent="0pt">
                <fo:table-row background-color="#FFFFFF" keep-together.within-page="1" keep-with-previous="1">
                    <fo:table-cell keep-with-previous="1" text-align="left">
                        <fo:block xsl:use-attribute-sets="eq-formula">
                            <xsl:apply-templates select="*[not(contains(@class, ' equation-d/equation-number '))]"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell keep-with-previous="1" text-align="right" display-align="center">
                        <xsl:apply-templates select="*[contains(@class, ' equation-d/equation-number ')]"/>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' equation-d/equation-inline ')]">
        <fo:inline>
            <xsl:attribute name="baseline-shift" select="'-3pt'"/>
            <xsl:apply-templates/>
        </fo:inline>

    </xsl:template>

    <xsl:template match="mathml">
        <fo:instream-foreign-object>
            <xsl:copy-of select="child::*"/>            
        </fo:instream-foreign-object>
    </xsl:template>    


    <xsl:template match="*[contains(@class, ' equation-d/equation-number ')]">
        <xsl:variable name="eqNumber">
            <xsl:call-template name="getEquationNumber"/>
        </xsl:variable>
        
        <fo:block xsl:use-attribute-sets="eq-number">                    
            <xsl:choose>
                <xsl:when test="string-length(.) &gt; 0">
                    <xsl:choose>
                        <xsl:when test="contains(., '#')">
                            <xsl:value-of select="substring-before(., '#')"/>
                            <xsl:copy-of select="$eqNumber" copy-namespaces="no"/>
                            <xsl:value-of select="substring-after(., '#')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="commonattributes"/>
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'InsertEquation'"/>
                        <xsl:with-param name="params">
                            <number>
                                <xsl:copy-of select="$eqNumber" copy-namespaces="no"/>
                            </number>
                        </xsl:with-param>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
        </fo:block>
    </xsl:template>

    <xsl:template name="getEquationNumber">
        <!--HSC add chapter prefix acc. to [DtPrt#14.4] -->
        <xsl:if test="contains($EnumerationMode, 'eq_prefix')">
            <xsl:call-template name="getChapterPrefix"/>
            <xsl:text>-</xsl:text>
        </xsl:if>
        <!--HSC add restart numbering acc. to [DtPrt#14.4] I added the configurability -->
        <xsl:choose>
            <xsl:when test="contains($EnumerationMode, 'eq_numrestart')">
                <xsl:choose>
                    <!--HSX this case covers the occurrences of 
                            equation-number in LATER than the FIRST chapter
                            The &gt; 0 condition checks whether there is any
                            other chapter prior to this chapter.
                    -->
                    <xsl:when
                        test="count(ancestor-or-self::*
                        [contains(@class, ' topic/topic')][position()=last()]
                        [count(preceding-sibling::*[contains(@class, ' topic/topic')]) &gt; 0])">
                        <!--HSX compute the renumbered count -->
                        <xsl:value-of
                            select="count(./preceding::*
                            [contains(@class, ' equation-d/equation-number ')]
                            [(string-length(.) = 0) or contains(., '#')]
                            [ancestor-or-self::*[contains(@class, ' topic/topic')]
                            [position()=last()]]) 
                            - count(ancestor-or-self::*
                            [contains(@class, ' topic/topic')]
                            [position()=last()]/preceding-sibling::*[contains(@class, ' topic/topic')]//*
                            [contains(@class, ' equation-d/equation-number ')]
                            [(string-length(.) = 0) or contains(., '#')])+1"
                        />
                    </xsl:when>
                    <!--HSX this case covers the occurrences of 
                            equation-number in the FIRST chapter ever
                    -->
                    <xsl:otherwise>
                        <xsl:value-of
                            select="count(./preceding::*[contains(@class, ' equation-d/equation-number ')]
                            [(string-length(.) = 0) or contains(., '#')]
                            [ancestor-or-self::*[contains(@class, ' topic/topic')]
                            [position()=last()]])+1"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:number level="any"
                count="*
                [contains(@class, ' equation-d/equation-number ')]
                [(string-length(.) = 0) or contains(., '#')]" from="/"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>                                

</xsl:stylesheet>
