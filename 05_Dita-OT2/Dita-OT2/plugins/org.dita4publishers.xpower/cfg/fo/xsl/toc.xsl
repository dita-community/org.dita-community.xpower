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
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
    xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
    exclude-result-prefixes="xs opentopic opentopic-func ot-placeholder opentopic-index"
    version="2.0">

    <xsl:variable name="map" select="//opentopic:map"/>

    <xsl:template name="createTocHeader">
        <fo:block xsl:use-attribute-sets="__toc__header" id="{$id.toc}">
            <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="'Table of Contents'"/>
            </xsl:call-template>
        </fo:block>
    </xsl:template>

    <xsl:template match="/" mode="toc">
        <xsl:apply-templates mode="toc">
            <xsl:with-param name="include" select="'true'"/>
        </xsl:apply-templates>
    </xsl:template>

    <!-- THIS PART ONLY RELEVANT FOR THE TOC .... NOT FOR BOOKMARKS -->
    <xsl:template match="*[contains(@class, ' topic/topic ')]" mode="toc">
        <xsl:param name="include"/>
        <xsl:variable name="topicLevel" as="xs:integer">
            <xsl:apply-templates select="." mode="get-topic-level"/>
        </xsl:variable>
        <xsl:if test="$topicLevel &lt;= $tocMaximumLevel">
            <xsl:variable name="mapTopicref" select="key('map-id', @id)[1]"/>
            <!--HSX solving the chapter problem requires to know the topic type -->
            <xsl:variable name="topicType">
                <xsl:call-template name="determineTopicType"/>
            </xsl:variable>

            <xsl:choose>
                <!-- In a future version, suppressing Notices in the TOC should not be hard-coded. -->
                <!--HSX2 If retain-bookmap-order determines the existance of the notices section (commons.xsl) then
                this should also be valid for the table of contents and the bookmarks. Here we handle the
                table of contents -->
                <xsl:when test="not($retain-bookmap-order) and $mapTopicref/self::*[contains(@class, ' bookmap/notices ')]" />


                <!-- DELETE THE FOLLOWING xsl:when if you want the TOC back it blocks the following statment!!!!!!!
                <xsl:when test="$mapTopicref[@toc = 'yes' or not(@toc)] or
                (not($mapTopicref) and $include = 'true')"/>
                -->

                <!--HSX This 'when" does everything but List of Figures and INDEX
                Here we are always in something that has the child 'title' (e.g. concept/task/...)
                -->

                <!--HSX2:emptyTitle do not act on empty titles -->
                <xsl:when test="string-length(normalize-space(title)) = 0"/>

                <xsl:when test="$mapTopicref[@toc = 'yes' or not(@toc)] or
                    (not($mapTopicref) and $include = 'true')">

                    <fo:block xsl:use-attribute-sets="__toc__indent">
                        <xsl:variable name="tocItemContent">
                            <fo:basic-link xsl:use-attribute-sets="__toc__link">
                                <xsl:attribute name="internal-destination">
                                    <xsl:call-template name="generate-toc-id"/>
                                </xsl:attribute>
                                <!--HSX Do not generate a marker within the TOC, only on the title itself -->
                                <xsl:apply-templates select="$mapTopicref" mode="tocPrefix">
                                    <xsl:with-param name="isFromBkx" select="true()"/>
                                </xsl:apply-templates>

                                <!--HSX get the title entry
                                However, this does NOT generate LoF (list of figures) / Preface / Appendix / INDEX
                                they are done in separate templates
                                <xsl:template match="ot-placeholder:figurelist" mode="toc">
                                <xsl:template match="ot-placeholder:indexlist" mode="toc" name="toc.index">
                                -->
                                <!--HSX isFromNav=False allows to respect sup/sub within the title -->
                                <fo:inline xsl:use-attribute-sets="__toc__title">
                                    <xsl:call-template name="getNavTitle">
                                        <xsl:with-param name="isFromToc" select="true()"/>
                                        <xsl:with-param name="useNavTitle" select="$useNavTitle-toc"/>
                                    </xsl:call-template>
                                </fo:inline>

                                <!--HSX generate the page number with preceding leader -->
                                <fo:inline xsl:use-attribute-sets="__toc__page-number">
                                    <!--HSC [DtPrt#16.16.2] shows how to eliminate page numbers
                                    from Head1 entries in the TOC. However, if we use
                                    dot leaders with 'justify' mode, then the Head1's go
                                    over the entire line. So I added the __hdrftr__leader on
                                    top of the proposal in the book which allows to stay the
                                    entries on the left side.
                                    To switch justify on/off ... just change !=1 (left align) to != 999 (justify) -->
                                    <xsl:choose>
                                        <!--HSX This is the insertion for every chapter page number -->
                                        <xsl:when test="$topicLevel !=999">
                                            <xsl:text>&#xA0;&#xA0;</xsl:text>
                                            <fo:leader xsl:use-attribute-sets="__toc__leader"/>
                                            <xsl:text>&#xA0;&#xA0;</xsl:text>
                                            <!--HSC [DtPrt#16.11] allows to add chapter number prior to
                                            the TOC page number -->
                                            <xsl:if test="contains($PageLayout, 'prefix_chapter')">
                                                <xsl:variable name="ChapterPrefix">
                                                    <xsl:call-template name="getChapterPrefix" />
                                                </xsl:variable>

                                                <xsl:choose>
                                                    <xsl:when test="$topicType = 'topicAbstract'"/>
                                                    <xsl:when test="$topicType = 'topicPreface'"/>
                                                    <xsl:when test="$ChapterPrefix = ''"/>
                                                    <xsl:otherwise>
                                                        <xsl:value-of select="$ChapterPrefix"/>
                                                        <xsl:text>-</xsl:text>
                                                    </xsl:otherwise>
                                                </xsl:choose>
                                                <!--HSC end insertion -->
                                            </xsl:if>
                                            <fo:page-number-citation>
                                                <xsl:attribute name="ref-id">
                                                    <xsl:call-template name="generate-toc-id"/>
                                                </xsl:attribute>
                                            </fo:page-number-citation>
                                        </xsl:when>
                                        <!--HSC this is the 999 case where we do not justify -->
                                        <xsl:otherwise>
                                            <xsl:if test="contains($PageLayout, 'prefix_chapter')">
                                                <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                                                <!--HSC added two spaces which makes it pretty -->
                                                <xsl:text>&#xA0;&#xA0;</xsl:text>
                                                <xsl:text>-</xsl:text>
                                            </xsl:if>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </fo:inline>
                            </fo:basic-link>
                        </xsl:variable>
                        <xsl:choose>
                            <!--HSX Process non-chapters Heading n (n > 1) -->
                            <!--HSC If we do not have a topic ref (e.g. on PreFace),
                            we fall into here -->
                            <xsl:when test="not($mapTopicref)">
                                <xsl:apply-templates select="." mode="tocText">
                                    <xsl:with-param name="tocItemContent" select="$tocItemContent"/>
                                    <xsl:with-param name="currentNode" select="."/>
                                </xsl:apply-templates>
                            </xsl:when>
                            <!--HSX Process chapters Heading n (n > 1) -->
                            <!--HSC All chapter entries greater Head 1 are managed here -->
                            <xsl:otherwise>
                                <xsl:apply-templates select="$mapTopicref" mode="tocText">
                                    <xsl:with-param name="tocItemContent" select="$tocItemContent"/>
                                    <xsl:with-param name="currentNode" select="."/>
                                </xsl:apply-templates>
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:block>
                    <!--HSX process all chapters/non-chapters Heading n (n > 1) -->
                    <xsl:apply-templates mode="toc">
                        <xsl:with-param name="include" select="'true'"/>
                    </xsl:apply-templates>
                </xsl:when>
                <!--HSC never reached this one ...) -->
                <xsl:otherwise>
                    <xsl:apply-templates mode="toc">
                        <xsl:with-param name="include" select="'true'"/>
                    </xsl:apply-templates>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <!--HSXC process any Head 1 chapters -->
    <xsl:template match="*[contains(@class, ' bookmap/chapter ')] |
        *[contains(@class, ' bookmap/bookmap ')]/opentopic:map/*[contains(@class, ' map/topicref ')]" mode="tocPrefix" priority="-1">
        <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Table of Contents Chapter'"/>
            <xsl:with-param name="params">
                <number>
                    <xsl:apply-templates select="." mode="topicTitleNumber"/>
                </number>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!--HSX This call creates the number (A,B,C) for the appendix TOC and bookmarks entry
        followed by the appendex Head1 title -->
    <xsl:template match="*[contains(@class, ' bookmap/appendix ')]" mode="tocPrefix">
        <xsl:param name="isFromBkx" select="false()" />
        <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Table of Contents Appendix'"/>
            <xsl:with-param name="params">
                <number>
                    <!-- 'Appendix' from en.xml -->
                    <xsl:apply-templates select="." mode="topicTitleNumber">
                        <xsl:with-param name="fromBkx" select="$isFromBkx" />
                    </xsl:apply-templates>
                    <!-- solved the following with 'Table of Contents Appendix'
                    <xsl:choose>
                        <xsl:when test="$isFromBkx">
                            <xsl:text> - </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text> - </xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                    -->
                    <xsl:value-of select="*[contains(@class, ' topic/title ')]"/>
                </number>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!--HSX BOOKMARKS Titles - Create the "Part (n)" portion, the title TEXT is not made here
        The templates matches on the bookmap/part (proven) so it can see all 'chapter' elements
    -->
    <xsl:template match="*[contains(@class, ' bookmap/part ')]" mode="tocPrefix">
        <xsl:param name="isFromBkx" select="false()" />
        <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Table of Contents Part'"/>
            <xsl:with-param name="params">
                <number>
                    <xsl:apply-templates select="." mode="topicTitleNumber">
                        <xsl:with-param name="isFromBkx" select="$isFromBkx"/>
                    </xsl:apply-templates>
                </number>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' bookmap/preface ')]" mode="tocPrefix">
        <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Table of Contents Preface'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' bookmap/notices ')]" mode="tocPrefix">
        <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Table of Contents Notices'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="node()" mode="tocPrefix" priority="-10"/>

    <!--HSX This inserts all chapters -->
    <xsl:template match="*[contains(@class, ' bookmap/chapter ')] |
        opentopic:map/*[contains(@class, ' map/topicref ')]" mode="tocText" priority="-1">
        <xsl:param name="tocItemContent"/>
        <xsl:param name="currentNode"/>
        <xsl:for-each select="$currentNode">
            <fo:block xsl:use-attribute-sets="__toc__chapter__content">
                <xsl:copy-of select="$tocItemContent"/>
            </fo:block>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' bookmap/appendix ')]" mode="tocText">
        <xsl:param name="tocItemContent"/>
        <xsl:param name="currentNode"/>
        <!--HSX This inserts the APPENDIX -->
        <xsl:for-each select="$currentNode">
            <fo:block xsl:use-attribute-sets="__toc__appendix__content">
                <xsl:copy-of select="$tocItemContent"/>
            </fo:block>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' bookmap/part ')]" mode="tocText">
        <xsl:param name="tocItemContent"/>
        <xsl:param name="currentNode"/>
        <!--HSX This inserts PART information (if we use those -->
        <xsl:for-each select="$currentNode">
            <fo:block xsl:use-attribute-sets="__toc__part__content">
                <xsl:copy-of select="$tocItemContent"/>
            </fo:block>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' bookmap/preface ')]" mode="tocText">
        <xsl:param name="tocItemContent"/>
        <xsl:param name="currentNode"/>
        <!--HSX This inserts PREFACE information (if we use those -->
        <xsl:for-each select="$currentNode">
            <fo:block xsl:use-attribute-sets="__toc__preface__content">
                <xsl:copy-of select="$tocItemContent"/>
            </fo:block>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' bookmap/notices ')]" mode="tocText">
        <xsl:param name="tocItemContent"/>
        <xsl:param name="currentNode"/>
        <!--HSX This inserts NOTICE information (if we use those -->
        <xsl:for-each select="$currentNode">
            <fo:block xsl:use-attribute-sets="__toc__notices__content">
                <xsl:copy-of select="$tocItemContent"/>
            </fo:block>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="node()" mode="tocText" priority="-10">
        <xsl:param name="tocItemContent"/>
        <xsl:param name="currentNode"/>

        <!--HSX This inserts subchapters head2+ -->
        <xsl:for-each select="$currentNode">
            <xsl:variable name="myNode" select="."/>
            <xsl:choose>
                <!--HSX If the first level-2 entry has ancestor backmatter
                        then we have to deal with the first topicref in the backmatter
                        section. This shall have some padding-top in order to separate
                        it from previous entries.
                -->
                <xsl:when test="(($map//*[@id = $myNode/@id])/ancestor::*)/name() = 'backmatter'">
                    <fo:block xsl:use-attribute-sets="__toc__topic__content __toc__topic__content_backmatter">
                        <xsl:copy-of select="$tocItemContent"/>
                    </fo:block>
                </xsl:when>
                <xsl:otherwise>
                    <fo:block xsl:use-attribute-sets="__toc__topic__content __toc__topic__content">
                        <xsl:copy-of select="$tocItemContent"/>
                    </fo:block>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template match="node()" mode="toc">
        <xsl:param name="include"/>
        <!--HSX This inserts the entire TOC -->
        <xsl:apply-templates mode="toc">
            <xsl:with-param name="include" select="$include"/>
        </xsl:apply-templates>
    </xsl:template>

    <xsl:template name="createToc">
        <xsl:if test="$generate-toc">
            <xsl:variable name="toc">
                <xsl:choose>
                    <xsl:when test="$map//*[contains(@class,' bookmap/toc ')][@href]"/>
                    <xsl:when test="$map//*[contains(@class,' bookmap/toc ')]">
                        <xsl:apply-templates select="/" mode="toc"/>
                    </xsl:when>
                    <xsl:when test="/*[contains(@class,' map/map ')][not(contains(@class,' bookmap/bookmap '))]">
                        <xsl:apply-templates select="/" mode="toc"/>
                        <!--HSX THis inserts something I don't know -->
                        <xsl:call-template name="toc.index"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:variable>

            <xsl:if test="count($toc/*) > 0">
                <!--HSC If you really need roman page numbers on the TOC (old style)
                [DtPrt#16.16.5] shows how to proceed
                I did not implement this old style, but here you could -->
            <fo:page-sequence master-reference="toc-sequence" xsl:use-attribute-sets="page-sequence.toc">
                    <!--HSC use either Roman literals only
                    <fo:page-sequence master-reference="toc-sequence" format="i" xsl:use-attribute-sets="__force__page__count">
                    -->
                    <!--HSC or use Roman literals and restart page numbering for TOC
                    <fo:page-sequence master-reference="toc-sequence" format="i" initial-page-number="1" xsl:use-attribute-sets="__force__page__count">
                    -->

                    <xsl:call-template name="insertTocStaticContents"/>
                    <fo:flow flow-name="xsl-region-body">
                        <xsl:call-template name="createTocHeader"/>
                        <fo:block>
                            <fo:marker marker-class-name="current-header">
                          <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'Table of Contents'"/>
                                </xsl:call-template>
                            </fo:marker>
                            <xsl:copy-of select="$toc"/>
                        </fo:block>
                    </fo:flow>
                </fo:page-sequence>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="processTocList">
        <fo:page-sequence master-reference="toc-sequence" xsl:use-attribute-sets="page-sequence.toc">
            <xsl:call-template name="insertTocStaticContents"/>
            <fo:flow flow-name="xsl-region-body">
                <xsl:call-template name="createTocHeader"/>
                <fo:block>
                    <xsl:apply-templates/>
                </fo:block>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>

    <xsl:template match="ot-placeholder:toc[$retain-bookmap-order]">
        <xsl:call-template name="createToc"/>
    </xsl:template>

    <!--HSX This inserts the INDEX in the TOC !!!!!! -->
    <xsl:template match="ot-placeholder:indexlist" mode="toc" name="toc.index">
        <xsl:if test="(//opentopic-index:index.groups//opentopic-index:index.entry) and (exists($index-entries//opentopic-index:index.entry))">
            <fo:block xsl:use-attribute-sets="__toc__indent__index">
                <fo:block xsl:use-attribute-sets="__toc__topic__content__index">
                    <fo:basic-link internal-destination="{$id.index}" xsl:use-attribute-sets="__toc__link">
                        <fo:inline xsl:use-attribute-sets="__toc__title">
              <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="'Index'"/>
                            </xsl:call-template>
                        </fo:inline>
                        <fo:inline xsl:use-attribute-sets="__toc__page-number">
                            <xsl:text>&#xA0;&#xA0;</xsl:text>
                            <fo:leader xsl:use-attribute-sets="__toc__leader"/>
                            <xsl:text>&#xA0;&#xA0;</xsl:text>
                            <fo:page-number-citation ref-id="{$id.index}"/>
                        </fo:inline>
                    </fo:basic-link>
                </fo:block>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!--HSC this template generates the TOC glossary text -->
    <xsl:template match="ot-placeholder:glossarylist" mode="toc">
        <fo:block xsl:use-attribute-sets="__toc__indent__glossary">
            <fo:block xsl:use-attribute-sets="__toc__topic__content__glossary">
                <fo:basic-link internal-destination="{$id.glossary}" xsl:use-attribute-sets="__toc__link">
                    <fo:inline xsl:use-attribute-sets="__toc__title">
                        <xsl:call-template name="getGlossaryTitle"/>
                    </fo:inline>
                    <fo:inline xsl:use-attribute-sets="__toc__page-number">
                        <xsl:text>&#xA0;&#xA0;</xsl:text>
                        <fo:leader xsl:use-attribute-sets="__toc__leader"/>
                        <xsl:text>&#xA0;&#xA0;</xsl:text>
                        <fo:page-number-citation ref-id="{$id.glossary}"/>
                    </fo:inline>
                </fo:basic-link>
            </fo:block>
        </fo:block>
    </xsl:template>

    <xsl:template match="ot-placeholder:tablelist" mode="toc">
        <xsl:if test="//*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ' )]">
            <fo:block xsl:use-attribute-sets="__toc__indent__lot">
                <fo:block xsl:use-attribute-sets="__toc__topic__content__lot">
                    <fo:basic-link internal-destination="{$id.lot}" xsl:use-attribute-sets="__toc__link">
                        <fo:inline xsl:use-attribute-sets="__toc__title">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'List of Tables'"/>
                            </xsl:call-template>
                        </fo:inline>
                        <fo:inline xsl:use-attribute-sets="__toc__page-number">
                            <xsl:text>&#xA0;&#xA0;</xsl:text>
                            <fo:leader xsl:use-attribute-sets="__toc__leader"/>
                            <xsl:text>&#xA0;&#xA0;</xsl:text>
                            <fo:page-number-citation ref-id="{$id.lot}"/>
                        </fo:inline>
                    </fo:basic-link>
                </fo:block>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!--HSX This inserts the List of Figures LoF in the TOC !!!!!!
    Change __toc__topic__content__lof in toc-attr.xsl in order to correct the attribute values
    which are set in this template
    -->
    <xsl:template match="ot-placeholder:figurelist" mode="toc">
        <xsl:if test="//*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ' )]">
            <fo:block xsl:use-attribute-sets="__toc__indent__lof">
                <fo:block xsl:use-attribute-sets="__toc__topic__content__lof">
                    <fo:basic-link internal-destination="{$id.lof}" xsl:use-attribute-sets="__toc__link">
                        <fo:inline xsl:use-attribute-sets="__toc__title">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'List of Figures'"/>
                            </xsl:call-template>
                        </fo:inline>
                        <fo:inline xsl:use-attribute-sets="__toc__page-number">
                            <xsl:text>&#xA0;&#xA0;</xsl:text>
                            <fo:leader xsl:use-attribute-sets="__toc__leader"/>
                            <xsl:text>&#xA0;&#xA0;</xsl:text>
                            <fo:page-number-citation ref-id="{$id.lof}"/>
                        </fo:inline>
                    </fo:basic-link>
                </fo:block>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' glossentry/glossentry ')]" mode="toc" priority="10"/>

</xsl:stylesheet>
