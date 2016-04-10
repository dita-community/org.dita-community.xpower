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

<!-- Elements for steps have been relocated to task-elements.xsl -->
<!-- Templates for <dl> are in tables.xsl -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">

    <xsl:template match="*[contains(@class,' topic/linklist ')]/*[contains(@class,' topic/title ')]">
        <fo:block xsl:use-attribute-sets="linklist.title">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <!--Lists-->
    <xsl:template match="*[contains(@class, ' topic/ul ')]" priority="1" >
        <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')]" mode="outofline"/>
        <fo:list-block xsl:use-attribute-sets="ul">
            <xsl:call-template name="setNestedListMargin"/>
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:list-block>
        <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-endprop ')]" mode="outofline"/>
    </xsl:template>

    <!--HSX:20150409 I had to surround blocks with fo:block to get side-col-width respected
    in lists that are not within a paragraph

    However, I have to consider that in tables (ancestor name contains entry)
    we do not want start-indent (because it is already given with the table
    
    parml should not be in the below ancestor list since it works independently
    -->
    <xsl:template name="setListMargin">
        <xsl:choose>
            <xsl:when test="contains(@outputclass, 'relstart')">
                <xsl:analyze-string select="@outputclass" regex="{'relstart=(.*)\s*'}">
                    <xsl:matching-substring>
                        <xsl:attribute name="start-indent">
                            <xsl:value-of select="regex-group(1)"/>
                        </xsl:attribute>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:when>
            <xsl:when test="ancestor::*[contains(name(), 'dl')
                                       ]">
                        <xsl:attribute name="id">
                            <xsl:value-of select="@outputclass"/>
                        </xsl:attribute>
                <xsl:attribute name="start-indent">
                    <xsl:value-of select="'0mm'"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="ancestor::*[contains(name(), 'table') or 
                                        contains(name(), 'ul') or
                                        contains(name(), 'ol') or
                                        contains(name(), 'dl') or
                                        contains(name(), 'lq') or
                                        contains(name(), 'example') or
                                        contains(name(), 'note')
                                       ]">
                <xsl:attribute name="start-indent">
                    <xsl:value-of select="'inherited-property-value(start-indent)'"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="start-indent">
                    <xsl:value-of select="$side-col-width"/>
                </xsl:attribute>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="setNestedListMargin">
        <xsl:choose>
            <xsl:when test="parent::*[contains(name(), 'li')]">
                <xsl:attribute name="margin-left" select="'0.01mm'"/>
            </xsl:when>
            <xsl:when test="parent::*[contains(name(), 'dd')]"/>
                
            <xsl:when test="count(preceding-sibling::*[contains(name(), 'li')]) = 0">
                <xsl:attribute name="margin-left" select="'0.01mm'"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    <!--HSX special handling of the first unnested block, I wanted indentation (from ul.First)
    on the first level list items, however, the margin attribute should not be seen in any
    nested level.

    ATTENTION - this template shall be positioned later than the previous since it is specialized. The order
    dependency can be avoided if the condition of the above template respects the
    count != 0 as explicit condition. For now the order is alright ... just you should know !

    The following template matches, if the ul does not have an ancestor of topic/li i.e. it is not nested
    -->
    <!--HSX first ul, not within another list -->
    <xsl:template match="*[contains(@class, ' topic/ul ')]
                          [count(ancestor::*[contains(@class, ' topic/li ')]) = 0]
                          [count(ancestor::*[contains(@class, ' topic/sli ')]) = 0]
                          [count(ancestor::*[contains(@class, ' topic/dlentry ')]) = 0]
                          " priority="5" >
        <fo:block>
            <xsl:call-template name="setListMargin"/>
            <fo:list-block xsl:use-attribute-sets="ul.First">
                <xsl:call-template name="commonattributes"/>
                <xsl:apply-templates/>
            </fo:list-block>
        </fo:block>
    </xsl:template>

    <!--HSX emtpy ul does nothing -->
    <xsl:template match="*[contains(@class, ' topic/ul ')][empty(*[contains(@class, ' topic/li ')])]" priority="10" />

    <xsl:template match="*[contains(@class, ' topic/ol ')]">
        <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')]" mode="outofline"/>
        <fo:list-block xsl:use-attribute-sets="ol">
            <xsl:call-template name="setNestedListMargin"/>
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:list-block>
        <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-endprop ')]" mode="outofline"/>
    </xsl:template>

    <!-- HSXol  apply left margin to first li, but not on subsequent nestings -->
    <xsl:template match="*[contains(@class, ' topic/ol ')]
                          [count(ancestor::*[contains(@class, ' topic/li ')]) = 0]
                          [count(ancestor::*[contains(@class, ' topic/sli ')]) = 0]
                          [count(ancestor::*[contains(@class, ' topic/dlentry ')]) = 0]
                          " priority="5" >
        <fo:block>
            <xsl:call-template name="setListMargin"/>
            <fo:list-block xsl:use-attribute-sets="ol.First">
                <xsl:call-template name="commonattributes"/>
                <xsl:apply-templates/>
            </fo:list-block>
        </fo:block>
    </xsl:template>

    <!--HSC os without entries does nothing -->
    <xsl:template match="*[contains(@class, ' topic/ol ')][empty(*[contains(@class, ' topic/li ')])]" priority="10"/>

    <!--HSC list item of an ul -->
    <xsl:template match="*[contains(@class, ' topic/ul ')]/*[contains(@class, ' topic/li ')]">
        <!--HSC [DtPrt#11.7.2] allows to use an image as a bullet, requires the bulletImagePath -->
        <xsl:variable name="bulletImagePath">
            <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="'Bullet Image Path'"/>
            </xsl:call-template>
        </xsl:variable>
        <fo:list-item xsl:use-attribute-sets="ul.li">
            <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')]" mode="flag-attributes"/>
            <fo:list-item-label xsl:use-attribute-sets="ul.li__label">
                <fo:block xsl:use-attribute-sets="ul.li__label__content">
                    <fo:inline>
                        <xsl:call-template name="commonattributes"/>
                    </fo:inline>
                    <xsl:choose>
                        <!--HSC to add a new layout depending on the 'outputclass=checklist' attribute
                        follow [DtPrt#11.6]. Here we use a checklist, but on my PC
                        the character &#25A1; didn't show anything. Font problem?
                        -->
                        <xsl:when test="../@outputclass='checklist'">
                            <fo:inline font-size="18pt" baseline-shift="20%">
                    <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="'Checklist bullet'"/>
                                </xsl:call-template>
                            </fo:inline>
                        </xsl:when>
                        <!--HSC [DtPrt#11.7.2] suggests an image as bullet - very nice, implemented here
                        I related it to the 'outputclass=folder' which is consequent according to the
                        changes from [DtPrt#11.4]
                        -->
                        <xsl:when test="../@outputclass='folder'">
                            <fo:inline baseline-shift="10%">
                                <!--HSC [DtPrt#11.7.2] suggests an image as bullet - very nice, implemented here -->
                                <xsl:choose>
                                    <!--HSC [DtPrt#11.7.2] allows to use an image as a bullet, requires the bulletImagePath
                                    if there's no image ... fall back to bullet (default case) -->
                                    <xsl:when test="not($bulletImagePath = '')">
                                        <fo:external-graphic src="url({$bulletImagePath})" xsl:use-attribute-sets="list__label__image"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:call-template name="getVariable">
                                            <xsl:with-param name="id" select="'Unordered List bullet'"/>
                                        </xsl:call-template>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:inline>
                        </xsl:when>
                        <!--HSC organize separate bullet characters for nested structures [DtPrt#11.4]
                        The next tests catches all nested list items
                        That would still apply if the nested item was under an ordered list, which is
                        likely what we want. [DtPrt#11.5] allows more specific handling
                        -->
                        <xsl:when test="ancestor::*[contains(@class, ' topic/li ')]">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Unordered List bullet nested'"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <!--HSC This is the original unconditioned statement prior to [DtPrt#11.4] -->
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Unordered List bullet'"/>
                            </xsl:call-template>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:block>
            </fo:list-item-label>

            <fo:list-item-body xsl:use-attribute-sets="ul.li__body">
                <fo:block xsl:use-attribute-sets="ul.li__content">
                    <xsl:apply-templates/>
                </fo:block>
            </fo:list-item-body>

        </fo:list-item>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/ol ')]/*[contains(@class, ' topic/li ')]">
        <fo:list-item xsl:use-attribute-sets="ol.li">
          <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')]" mode="flag-attributes"/>
            <fo:list-item-label xsl:use-attribute-sets="ol.li__label">
                <fo:block xsl:use-attribute-sets="ol.li__label__content">
                    <fo:inline>
                        <xsl:call-template name="commonattributes"/>
                    </fo:inline>
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'Ordered List Number'"/>
                        <xsl:with-param name="params">
                            <number>
                                <xsl:choose>
                                    <!--HSC here I'm catching ol(1)-ol(a)-ol(i) since the scheme to follow
                                    the parent chain is systematic. Indeed nested ols work like
                                    ol:li.ol:li.ol.li/li /ol /li /ol /li /ol ...so the new ol always
                                    starts in an unclosed li tag. -->
                                    <xsl:when test="parent::*[contains(@class, ' topic/ol ')]/
                                        parent::*[contains(@class, ' topic/li ')]/
                                        parent::*[contains(@class, ' topic/ol ')]/
                                        parent::*[contains(@class, ' topic/li ')]/
                                        parent::*[contains(@class, ' topic/ol ')]">
                                        <!--HSC format of nested list can be changed acc. [DtPrt#11.5]
                                        valid formats are 1, 01, A, a, I, i
                                        -->
                                        <xsl:number format="i"/>
                                    </xsl:when>
                                    <xsl:when test="parent::*[contains(@class, ' topic/ol ')]/
                                        parent::*[contains(@class, ' topic/li ')]/
                                        parent::*[contains(@class, ' topic/ol ')]">
                                        <!--HSC format of nested list can be changed acc. [DtPrt#11.5]
                                        valid formats are 1, 01, A, a, I, i
                                        -->
                                        <xsl:number format="a"/>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:number>
                                            <!--HSC here is the right place to change the default (top level) format -->
                                        </xsl:number>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </number>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:block>
            </fo:list-item-label>

            <fo:list-item-body xsl:use-attribute-sets="ol.li__body">
                <fo:block xsl:use-attribute-sets="ol.li__content">
                    <xsl:apply-templates/>
                </fo:block>
            </fo:list-item-body>

        </fo:list-item>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/li ')]/*[contains(@class, ' topic/itemgroup ')]">
        <fo:block xsl:use-attribute-sets="li.itemgroup">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/sl ')]">
        <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')]" mode="outofline"/>
        <fo:list-block xsl:use-attribute-sets="sl">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:list-block>
        <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-endprop ')]" mode="outofline"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/sl ')]
        [(count(ancestor::*[contains(@class, ' topic/li ')]) +
        count(ancestor::*[contains(@class, ' topic/sli ')]) +
        count(ancestor::*[contains(@class, ' topic/simpletable ')]) +
        count(ancestor::*[contains(@class, ' topic/table ')])
        ) = 0]" priority="5" >
        <fo:block>
            <xsl:call-template name="setListMargin"/>
            <fo:list-block xsl:use-attribute-sets="sl.First">
                <xsl:call-template name="commonattributes"/>
                <xsl:apply-templates/>
            </fo:list-block>
        </fo:block>
    </xsl:template>


    <xsl:template match="*[contains(@class, ' topic/sl ')][empty(*[contains(@class, ' topic/sli ')])]" priority="10"/>

    <xsl:template match="*[contains(@class, ' topic/sl ')]/*[contains(@class, ' topic/sli ')]" priority="1" >
        <fo:list-item xsl:use-attribute-sets="sl.sli">
          <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')]" mode="flag-attributes"/>
            <xsl:call-template name="setNestedListMargin"/>
            <fo:list-item-label xsl:use-attribute-sets="sl.sli__label">
                <fo:block xsl:use-attribute-sets="sl.sli__label__content">
                    <fo:inline>
                        <xsl:call-template name="commonattributes"/>
                    </fo:inline>
                </fo:block>
            </fo:list-item-label>

            <fo:list-item-body xsl:use-attribute-sets="sl.sli__body">
                <fo:block xsl:use-attribute-sets="sl.sli__content">
                    <xsl:apply-templates/>
                </fo:block>
            </fo:list-item-body>

        </fo:list-item>
    </xsl:template>

</xsl:stylesheet>
