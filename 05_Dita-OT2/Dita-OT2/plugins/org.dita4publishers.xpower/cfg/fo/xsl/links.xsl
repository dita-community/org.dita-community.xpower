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

    <!--HSC since we pick the links from another directory, the internal reference
    to output-message.xsl has to be fixed ... see [DtPrt#12.8.2] the matter
    if actually described in [DtPrt#15.2] but a bit late so that the reader
    will have trouble in the first place when he hasn't read [DtPrt#15.2] before [DtPrt#12.8.2]
<xsl:import href="../../../../xsl/common/output-message.xsl"/> -->
    <xsl:import href="../../../../../xsl/common/output-message.xsl"/>


    <!--HSC
        How this module works ....
        1. enter at
        <xsl:template match="*[contains(@class,' topic/xref ')]" name="topic.xref">

        2. check whether the topic has a title child
        <xsl:variable name="referenceTitle" as="node()*">
        calls
        <xsl:template match="*" mode="insertReferenceTitle">
        calls
        <xsl:template match="*" mode="retrieveReferenceTitle">
        which returns
        #none#       if there was not title child
        <title text> if there was a title child
        returns

        3. check whether user text is given in the XREF
        <xsl:template match="*[processing-instruction()[name()='ditaot'][.='usertext']]"


        which returns

        ...
        <xsl:template match="*" mode="retrieveReferenceTitle">
        if "title" exists : process the title text
        otherwise return #none#

        HSX2: NEW EXTENSIONS ADDED
        Supported outputclass terms are

        outputclass = [see] [noheading|num|chapter|label] [onpage]

        see         : (see ....)

        num         : 1.3.7
        chapter     : Chapter num
        label       : Table 3.2  Figure 7.1
        noheading   : suppresses heading

        page        : on page 42
        pageonly    : page 42
        pagenumonly : 42

    -->

    <xsl:param name="figurelink.style" select="'NUMTITLE'"/>
    <xsl:param name="tablelink.style" select="'NUMTITLE'"/>

    <xsl:variable name="msgprefix">DOTX</xsl:variable>

    <xsl:key name="key_anchor" match="*[@id][not(contains(@class, ' map/topicref '))]" use="@id"/>
    <!--[not(contains(@class,' map/topicref '))]-->
    <xsl:template name="insertLinkShortDesc">
        <xsl:param name="destination"/>
        <xsl:param name="element"/>
        <xsl:param name="linkScope"/>
        <xsl:choose>
            <!-- User specified description (from map or topic): use that. -->
            <xsl:when test="
                    *[contains(@class, ' topic/desc ')] and
                    processing-instruction()[name() = 'ditaot'][. = 'usershortdesc']">
                <fo:block xsl:use-attribute-sets="link__shortdesc">
                    <xsl:apply-templates select="*[contains(@class, ' topic/desc ')]"/>
                </fo:block>
            </xsl:when>
            <!-- External: do not attempt to retrieve. -->
            <xsl:when test="$linkScope = 'external'"> </xsl:when>
            <!-- When the target has a short description and no local override, use the target -->
            <xsl:when test="$element/*[contains(@class, ' topic/shortdesc ')]">
                <fo:block xsl:use-attribute-sets="link__shortdesc">
                    <xsl:apply-templates select="$element/*[contains(@class, ' topic/shortdesc ')]"/>
                </fo:block>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="insertLinkDesc">
        <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Link description'"/>
            <xsl:with-param name="params">
                <desc>
                    <fo:inline>
                        <xsl:apply-templates select="*[contains(@class, ' topic/desc ')]" mode="insert-description"/>
                    </fo:inline>
                </desc>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="
            *[contains(@class, ' topic/xref ') or
            contains(@class, ' topic/link ')]/*[contains(@class, ' topic/desc ')]" priority="1"/>

    <xsl:template match="*[contains(@class, ' topic/desc ')]" mode="insert-description">
        <xsl:apply-templates/>
    </xsl:template>


    <!-- The insertReferenceTitle template is called from <xref> and <link> and is
         used to build link contents (using full FO syntax, not just the text).
    -->
    <!-- Process any cross reference or link with author-specified text.
         The specified text is used as the link text.
    -->
    <xsl:template match="*[processing-instruction()[name() = 'ditaot'][. = 'usertext']]" mode="insertReferenceTitle">
        <xsl:if test="contains($unittest, 'chklinks')">
            <xsl:message>LogTest01:</xsl:message>
        </xsl:if>
        <xsl:apply-templates select="*[not(contains(@class, ' topic/desc '))] | text()"/>
    </xsl:template>
    <xsl:template match="*[processing-instruction()[name() = 'ditaot'][. = 'usertext']]" mode="insertReferenceTitleNumber">
        <xsl:if test="contains($unittest, 'chklinks')">
            <xsl:message>LogTest02:</xsl:message>
        </xsl:if>
        <xsl:apply-templates select="*[not(contains(@class, ' topic/desc '))] | text()"/>
    </xsl:template>

    <!-- Process any cross reference or link with no content, or with content
         generated by the DITA-OT preprocess. The title will be retrieved from
         the target element, and combined with generated text such as Figure N.
    -->
    <xsl:template match="*" mode="insertReferenceTitle">
        <xsl:param name="href"/>
        <xsl:param name="titlePrefix"/>
        <xsl:param name="destination"/>
        <xsl:param name="element"/>

        <!--HSC insert #none# as indicator for no destination content
            'destination' is the content of the href/keyref attribute
        -->
        <xsl:variable name="referenceContent" as="node()*">
            <xsl:choose>
                <xsl:when test="not($element) or ($destination = '')">
                    <xsl:text>#none#</xsl:text>
                </xsl:when>
                <xsl:when test="
                        contains($element/@class, ' topic/li ') and
                        contains($element/parent::*/@class, ' topic/ol ')">
                    <!-- SF Bug 1839827: This causes preprocessor text to be used for links to OL/LI -->
                    <xsl:text>#none#</xsl:text>
                </xsl:when>

                <!--HSC process the entrie's topic to retrieve its title text -->
                <xsl:otherwise>
                    <xsl:apply-templates select="$element" mode="retrieveReferenceTitle"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:if test="not($titlePrefix = '')">
            <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="$titlePrefix"/>
            </xsl:call-template>
        </xsl:if>

        <xsl:if test="contains($unittest, 'chklinks')">
            <xsl:message>LogTest04:</xsl:message>
        </xsl:if>

        <xsl:choose>
            <xsl:when test="not($element) or ($destination = '') or $referenceContent = '#none#'">
                <!--HSC if another than desc is child or if no user text   -->
                <xsl:choose>
                    <xsl:when test="*[not(contains(@class, ' topic/desc '))] | text()">
                        <xsl:if test="contains($unittest, 'chklinks')">
                            <xsl:message>LogTest05:</xsl:message>
                        </xsl:if>
                        <xsl:apply-templates select="*[not(contains(@class, ' topic/desc '))] | text()"/>
                    </xsl:when>
                    <!--HSC no text is given ... then show the link text -->
                    <xsl:otherwise>
                        <xsl:if test="contains($unittest, 'chklinks')">
                            <xsl:message>
                                <xsl:text>LogTest06:</xsl:text>
                                <xsl:value-of select="$href"/>
                            </xsl:message>
                        </xsl:if>
                        <xsl:value-of select="$href"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>

            <xsl:otherwise>
                <xsl:if test="contains($unittest, 'chklinks')">
                    <xsl:message>
                        <xsl:text>LogTest07(</xsl:text>
                        <xsl:copy-of select="$referenceContent"/>
                        <xsl:text>)</xsl:text>
                    </xsl:message>
                </xsl:if>
                <xsl:copy-of select="$referenceContent"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--HSX receive chapter title number -->
    <xsl:template match="*" mode="insertReferenceTitleNumber">
        <xsl:param name="href"/>
        <xsl:param name="titlePrefix"/>
        <xsl:param name="destination"/>
        <xsl:param name="element"/>

        <!--HSC insert #none# as indicator for no destination content
            'destination' is the content of the href/keyref attribute
        -->
        <xsl:variable name="referenceContentNumber">
            <xsl:choose>
                <xsl:when test="not($element) or ($destination = '')">
                    <xsl:value-of select="'#none#'"/>
                </xsl:when>

                <xsl:when test="
                        contains($element/@class, ' topic/li ') and
                        contains($element/parent::*/@class, ' topic/ol ')">
                    <xsl:value-of select="'#none#'"/>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:apply-templates select="$element" mode="retrieveReferenceTitleNumber"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$referenceContentNumber"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/fig ')][*[contains(@class, ' topic/title ')]]" mode="retrieveReferenceTitle">
        <xsl:message>
            <xsl:text>FigureCheck::</xsl:text>
            <xsl:value-of select="title"/>
        </xsl:message>
        <xsl:choose>
            <xsl:when test="$figurelink.style = 'NUMBER'">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Figure Number'"/>
                    <xsl:with-param name="params">
                        <number>
                            <xsl:value-of select="count(key('enumerableByClass', 'topic/fig')[. &lt;&lt; current()]) + 1"/>
                        </number>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$figurelink.style = 'TITLE'">
                <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="insert-text"/>
            </xsl:when>
            <!-- if not parameter specifies the output style, then the default
                 has changed in DITA-OT 2.1.1 to become label and number.

                 The idea is good, but we need to care with outputclass=[title] on figure to get
                 the entire caption.
            -->
            <xsl:otherwise>
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Figure.title'"/>
                    <xsl:with-param name="params">
                        <number>
                            <xsl:value-of select="count(key('enumerableByClass', 'topic/fig')[. &lt;&lt; current()]) + 1"/>
                        </number>
                        <title>
                            <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="insert-text"/>
                        </title>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/section ')][*[contains(@class, ' topic/title ')]]" mode="retrieveReferenceTitle">
        <xsl:variable name="title">
            <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="insert-text"/>
        </xsl:variable>
        <xsl:value-of select="normalize-space($title)"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/table ')][*[contains(@class, ' topic/title ')]]" mode="retrieveReferenceTitle">
        <xsl:choose>
            <xsl:when test="$tablelink.style = 'NUMBER'">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Table Number'"/>
                    <xsl:with-param name="params">
                        <number>
                            <xsl:value-of select="count(key('enumerableByClass', 'topic/table')[. &lt;&lt; current()]) + 1"/>
                        </number>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="$tablelink.style = 'TITLE'">
                <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="insert-text"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Table.title'"/>
                    <xsl:with-param name="params">
                        <number>
                            <xsl:value-of select="count(key('enumerableByClass', 'topic/table')[. &lt;&lt; current()]) + 1"/>
                        </number>
                        <title>
                            <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="insert-text"/>
                        </title>
                    </xsl:with-param>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/li ')]" mode="retrieveReferenceTitle">
        <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'List item'"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/fn ')]" mode="retrieveReferenceTitle">
        <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Foot note'"/>
        </xsl:call-template>
    </xsl:template>

    <!--HSX template to match 'title' element and retrieve the title number -->
    <xsl:template match="*[contains(@class, ' topic/title ')]" mode="get-title-number">
        <xsl:call-template name="getTitleNumber"/>
    </xsl:template>


    <!-- HSX get the title number of a target, applies to 'title'
         or an immediate parent of title.
    -->
    <xsl:template match="*" mode="retrieveReferenceTitleNumber">
        <xsl:choose>
            <xsl:when test="contains(@class, ' topic/title ')">
                <xsl:variable name="TitleNum">
                    <xsl:if test="parent::*[contains(@class, ' topic/topic ')]">
                        <xsl:call-template name="getTitleNumber"/>
                    </xsl:if>
                </xsl:variable>
                <xsl:value-of select="$TitleNum"/>
            </xsl:when>

            <!--HSX Check the child::title element which is
                child of current template (e.g. current = concept / section etc)
            -->
            <xsl:when test="*[contains(@class, ' topic/title ')]">
                <xsl:variable name="TitleNum">
                    <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="get-title-number"> </xsl:apply-templates>
                </xsl:variable>

                <xsl:value-of select="$TitleNum"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>#none#</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!--HSC RETRIEVE TITLE TEXT of an empty XREF target
            on any element which is not fig, section, li, fn
            because for those more special templates will match
            Default rule: if element has a title,
            use that, otherwise return '#none#'

            Extension HSC: Add any topic (eg. glossterm)
            whose content shall be taken on empty xref
    -->
    <xsl:template match="*" mode="retrieveReferenceTitle">
        <xsl:choose>
            <!--HSX bug fixed, links to titles didn't work because the
                test="*[contains ... ] statement did apply to children,
                but not to the topic itself. The first test therefore
                matches a title itself
            -->
            <!--HSX Check the current element which is 'title'
            -->
            <xsl:when test="contains(@class, ' topic/title ')">
                <xsl:copy-of select="."/>
                <xsl:if test="contains($unittest, 'chklinks')">
                    <xsl:message>
                        <xsl:text>LogTest16:</xsl:text>
                        <xsl:copy-of select="."/>
                    </xsl:message>
                </xsl:if>
            </xsl:when>

            <!--HSX Check the child::title element which is
                child of current template (e.g. current = concept / section etc)

                We use 'copy-of' to maintain possible character elements (e.g sub/sup)
            -->
            <xsl:when test="*[contains(@class, ' topic/title ')]">
                <xsl:copy-of select="*[contains(@class, ' topic/title ')]"/>
            </xsl:when>

            <!--HSX glossterm is considered a title quality because it needs
                    to provide the text for empty xrefs to glossary
            -->
            <xsl:when test="contains(name(), 'glossterm')">
                <xsl:value-of select="string(.)"/>
            </xsl:when>

            <xsl:when test="contains(name(), 'entry')">
                <xsl:apply-templates/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:text>#none#</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/xref ')]" name="topic.xref">
        <fo:inline>
            <xsl:call-template name="commonattributes"/>
        </fo:inline>

        <xsl:if test="contains($unittest, 'xref')">
            <xsl:message>
                <xsl:text>XREF:</xsl:text>
                <xsl:value-of select=".."/>
            </xsl:message>
        </xsl:if>

        <xsl:if test="contains($unittest, 'gls')">
            <xsl:variable name="chkGls">
                <xsl:analyze-string select="@href" regex="{'.*(gls_.*)$'}">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(1)"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:variable>

            <xsl:variable name="chkSpc">
                <xsl:analyze-string select="@href" regex="{'.*(spb_.*)$'}">
                    <xsl:matching-substring>
                        <xsl:value-of select="regex-group(1)"/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:variable>

            <xsl:if test="string-length($chkGls) > 0">
                <xsl:message>
                    <xsl:text>XREFgls:</xsl:text>
                    <xsl:value-of select="$chkGls"/>
                </xsl:message>
            </xsl:if>

            <xsl:if test="string-length($chkSpc) > 0">
                <xsl:message>
                    <xsl:text>XREFspc:</xsl:text>
                    <xsl:value-of select="$chkSpc"/>
                </xsl:message>
            </xsl:if>
        </xsl:if>

        <!--HSC 'destination' is the actual destination (with unique prefix) given in the href/keyref -->
        <xsl:variable name="destination" select="opentopic-func:getDestinationId(@href)"/>

        <!--HSC 'element' is the element (e.g. concept, glossterm etc.) that carries the referenced 'id' -->
        <xsl:variable name="element" select="key('key_anchor', $destination, $root)[1]"/>

        <!--HSC The referenceTitle is the text of the target's title. This can be a Figure
                caption or chapter title, in general what is written in the "title" element
                of the target. The enumeration is no contained in referenceTitle
        -->
        <xsl:variable name="referenceTitle" as="node()*">
            <xsl:apply-templates select="." mode="insertReferenceTitle">
                <xsl:with-param name="href" select="@href"/>
                <xsl:with-param name="titlePrefix" select="''"/>
                <xsl:with-param name="destination" select="$destination"/>
                <xsl:with-param name="element" select="$element"/>
            </xsl:apply-templates>
        </xsl:variable>

        <xsl:variable name="referenceTitleText">
            <xsl:value-of select="$referenceTitle"/>
        </xsl:variable>

        <xsl:if test="contains($unittest, 'chklinks')">
            <xsl:message>
                <xsl:text>LogTest08:[</xsl:text>
                <xsl:value-of select="$referenceTitle/name()"/>
                <xsl:text>]=</xsl:text>
                <xsl:value-of select="$referenceTitle"/>
            </xsl:message>
        </xsl:if>

        <xsl:variable name="referenceTitleNumber" as="node()*">
            <xsl:apply-templates select="." mode="insertReferenceTitleNumber">
                <xsl:with-param name="href" select="@href"/>
                <xsl:with-param name="titlePrefix" select="''"/>
                <xsl:with-param name="destination" select="$destination"/>
                <xsl:with-param name="element" select="$element"/>
            </xsl:apply-templates>
        </xsl:variable>

        <xsl:variable name="PageCitation" as="node()*">
            <xsl:call-template name="insertPageNumberCitation">
                <xsl:with-param name="destination" select="$destination"/>
                <xsl:with-param name="element" select="$element"/>
            </xsl:call-template>
        </xsl:variable>

        <fo:basic-link>
            <!--HSX We need the value here to insert it in the @outputclass syntax -->
            <xsl:call-template name="buildBasicLinkDestination">
                <xsl:with-param name="scope" select="@scope"/>
                <xsl:with-param name="format" select="@format"/>
                <xsl:with-param name="href" select="@href"/>
            </xsl:call-template>

            <!--HSC [DtPrt#12.8.2] shows how to link to task-steps through the stylesheet -->
            <xsl:choose>
                <xsl:when test="@type = 'step'">
                    <fo:inline xsl:use-attribute-sets="xref_step">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'Go to step'"/>
                        </xsl:call-template>
                        <xsl:apply-templates select="$referenceTitle"/>
                    </fo:inline>
                </xsl:when>
                <!--HSC end of insertion -->

                <!--HSC this occurs if a referenceTitle was found, even if the referenced topic
            does not have a title child, then referenceTitle would still have #none#

            So this is visited most times.
            -->
                <xsl:when test="
                        not(@scope = 'external' or not(empty(@format) or @format = 'dita'))
                        and exists($referenceTitle)">
                    <xsl:if test="contains($unittest, 'chklinks')">
                        <xsl:message>LogTest09:</xsl:message>
                    </xsl:if>

                    <!--    outputclass = [see] [chp]|[num]|[label] [title] [onpage|page]
                            Between any of the [] .. [] expression the '..' may be any text
                    -->

                    <xsl:choose>
                        <xsl:when test="contains(@outputclass, '[')">
                            <xsl:analyze-string select="@outputclass" regex="{'(.*)(\[see\])'}">
                                <xsl:matching-substring>
                                    <xsl:if test="string-length(regex-group(1)) > 0">
                                        <fo:inline>
                                            <xsl:value-of select="regex-group(1)"/>
                                        </fo:inline>
                                    </xsl:if>
                                    <fo:inline xsl:use-attribute-sets="xref_see">
                                        <xsl:text>(</xsl:text>
                                        <xsl:call-template name="getVariable">
                                            <xsl:with-param name="id" select="'See'"/>
                                        </xsl:call-template>
                                    </fo:inline>
                                </xsl:matching-substring>
                                <xsl:non-matching-substring>
                                    <xsl:analyze-string select="." regex="{'(.*)(\[num\])'}">
                                        <xsl:matching-substring>
                                            <xsl:if test="string-length(regex-group(1)) > 0">
                                                <fo:inline>
                                                    <xsl:value-of select="regex-group(1)"/>
                                                </fo:inline>
                                            </xsl:if>
                                            <fo:inline xsl:use-attribute-sets="xref">
                                                <xsl:value-of select="$referenceTitleNumber"/>
                                            </fo:inline>
                                        </xsl:matching-substring>
                                        <xsl:non-matching-substring>
                                            <xsl:analyze-string select="." regex="{'(.*)(\[chp\])'}">
                                                <xsl:matching-substring>
                                                    <fo:inline>
                                                        <xsl:if test="string-length(regex-group(1)) > 0">
                                                            <xsl:value-of select="regex-group(1)"/>
                                                        </xsl:if>
                                                    </fo:inline>
                                                    <fo:inline xsl:use-attribute-sets="xref">
                                                        <xsl:call-template name="getVariable">
                                                            <xsl:with-param name="id" select="'Chp'"/>
                                                        </xsl:call-template>
                                                        <xsl:value-of select="$referenceTitleNumber"/>
                                                    </fo:inline>
                                                </xsl:matching-substring>
                                                <xsl:non-matching-substring>
                                                    <fo:inline xsl:use-attribute-sets="xref">
                                                        <xsl:analyze-string select="." regex="{'(.*)(\[label\])'}">
                                                            <xsl:matching-substring>
                                                                <xsl:if test="string-length(regex-group(1)) &gt; 0">
                                                                    <xsl:value-of select="regex-group(1)"/>
                                                                </xsl:if>
                                                                <xsl:analyze-string select="$referenceTitleText" regex="{'^([\w\W-[:]]*):.*$'}">
                                                                    <xsl:matching-substring>
                                                                        <xsl:value-of select="regex-group(1)"/>
                                                                    </xsl:matching-substring>
                                                                </xsl:analyze-string>
                                                            </xsl:matching-substring>
                                                            <xsl:non-matching-substring>
                                                                <xsl:analyze-string select="." regex="{'(.*)(\[title\])'}">
                                                                    <xsl:matching-substring>
                                                                        <xsl:if test="string-length(regex-group(1)) &gt; 0">
                                                                            <xsl:value-of select="regex-group(1)"/>
                                                                        </xsl:if>
                                                                        <xsl:choose>
                                                                            <xsl:when test="
                                                                                    $element[contains(@class, ' topic/fig ')] or
                                                                                    $element[contains(@class, ' topic/table ')]">
                                                                                <xsl:value-of select="$element/title"/>
                                                                            </xsl:when>
                                                                            <xsl:otherwise>
                                                                                <xsl:apply-templates select="$referenceTitle"/>
                                                                            </xsl:otherwise>
                                                                        </xsl:choose>
                                                                    </xsl:matching-substring>
                                                                    <xsl:non-matching-substring>
                                                                        <xsl:analyze-string select="." regex="{'(.*)(\[onpage\])'}">
                                                                            <xsl:matching-substring>
                                                                                <xsl:value-of select="regex-group(1)"/>
                                                                                <xsl:copy-of select="$PageCitation"/>
                                                                            </xsl:matching-substring>
                                                                            <xsl:non-matching-substring>
                                                                                <xsl:analyze-string select="." regex="{'(.*)(\[pageonly\])'}">
                                                                                    <xsl:matching-substring>
                                                                                        <xsl:value-of select="regex-group(1)"/>
                                                                                        <xsl:copy-of select="$PageCitation"/>
                                                                                    </xsl:matching-substring>
                                                                                    <xsl:non-matching-substring>
                                                                                        <xsl:analyze-string select="." regex="{'(.*)(\[pagenumonly\])'}">
                                                                                            <xsl:matching-substring>
                                                                                                <xsl:value-of select="regex-group(1)"/>
                                                                                                <xsl:copy-of select="$PageCitation"/>
                                                                                            </xsl:matching-substring>
                                                                                            <!-- finally print whatever's left -->
                                                                                            <xsl:non-matching-substring>
                                                                                                <xsl:value-of select="."/>
                                                                                            </xsl:non-matching-substring>
                                                                                        </xsl:analyze-string>
                                                                                    </xsl:non-matching-substring>
                                                                                </xsl:analyze-string>
                                                                            </xsl:non-matching-substring>
                                                                        </xsl:analyze-string>
                                                                    </xsl:non-matching-substring>
                                                                </xsl:analyze-string>
                                                            </xsl:non-matching-substring>
                                                        </xsl:analyze-string>
                                                    </fo:inline>
                                                </xsl:non-matching-substring>
                                            </xsl:analyze-string>
                                        </xsl:non-matching-substring>
                                    </xsl:analyze-string>
                                </xsl:non-matching-substring>
                            </xsl:analyze-string>
                        </xsl:when>
                        <xsl:when test="contains(@outputclass, 'noheading')"/>
                        <!--HSX We do not have a (valid) outputclass setting -->
                        <xsl:otherwise>
                            <fo:inline xsl:use-attribute-sets="xref">
                                <xsl:variable name="xtext" select="normalize-space(string-join(text(),''))"/>
                                <xsl:variable name="refId" select="substring-after(@href, '/')"/>
                                <xsl:variable name="refTargetNode" select="key('enumerableById', $refId)"/>

                                <!--HSX BUT in DITA-OT
                                        If we refer to table/fig/fn we cannot trust the text() content
                                        It used to contain some label part, but not the right one (e.g. Table 4 while
                                        we refer to Table 384

                                        Therefore we evaluate the referenced ID ($refId), if we find a match in the
                                        'enumerableById'-key, then we have table/fig/fn and we can retrieve
                                        the table/figure/fn from that key to find the right default value
                                        for the xref:notextcontent situation
                                -->
                                <xsl:variable name="curNode" as="node()" select="."/>
                                <xsl:choose>

                                    <!--HSX check whether we refer to any table/fig/fn -->
                                    <xsl:when test="$refTargetNode">
                                        <xsl:analyze-string select="$referenceTitleText" regex="{'^([\w\W-[:]]*):.*$'}">
                                            <xsl:matching-substring>
                                                <xsl:value-of select="regex-group(1)"/>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:if test="$curNode/*[not(contains(@class, ' topic/desc '))] or (string-length($xtext) &gt; 0)">
                                                    <xsl:apply-templates select="$curNode/*[not(contains(@class, ' topic/desc '))] | $curNode/text()"/>
                                                </xsl:if>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:when>

                                    <!--HSX check whether our XREF contains text content, we can check this now
                                            because the bug is covered in the previous when- now we can trust text()
                                    -->
                                    <xsl:when test="*[not(contains(@class, ' topic/desc '))] or
                                                     (string-length($xtext) &gt; 0)">
                                        <xsl:apply-templates select="*[not(contains(@class, ' topic/desc '))] | text()"/>
                                    </xsl:when>

                                    <!--HSX XREF does not contain text content ... take the title of the target
                                                 Any title can use sup/sub etc -->
                                    <xsl:when test="$referenceTitle/name() = 'title'">
                                        <xsl:value-of select="$referenceTitleNumber"/>
                                        <xsl:text>&#xA0;</xsl:text>
                                        <xsl:apply-templates select="$referenceTitle"/>
                                    </xsl:when>
                                    <!-- any other topic (e.g. glossterm) shall be primitive -->
                                    <xsl:otherwise>
                                        <xsl:value-of select="$referenceTitle"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </fo:inline>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                
                
                <!--HSX here we meet the condition
                        (@scope = 'external' or not(empty(@format) or @format = 'dita')
                        or not(exists($referenceTitle))">
                -->
                <!--HSC this occurs if no referenceTitle was ever created for other reasons (special types) -->
                <xsl:when test="not(@scope = 'external' or not(empty(@format) or @format = 'dita'))">
                    <xsl:if test="contains($unittest, 'chklinks')">
                        <xsl:message>LogTest10:</xsl:message>
                    </xsl:if>
                    <xsl:call-template name="insertPageNumberCitation">
                        <xsl:with-param name="isTitleEmpty" select="true()"/>
                        <xsl:with-param name="destination" select="$destination"/>
                        <xsl:with-param name="element" select="$element"/>
                    </xsl:call-template>
                </xsl:when>

                <!--HSC no referenceTitle exists and (scope=external or format=emtpy or format=dita) -->
                <xsl:otherwise>
                    <xsl:choose>
                        <!-- HSC if text is contained - print user's xref text -->
                        <xsl:when test="*[not(contains(@class, ' topic/desc '))] | text()">
                            <xsl:if test="contains($unittest, 'chklinks')">
                                <xsl:message>LogTest11:</xsl:message>
                            </xsl:if>
                            <!--HSC PRINTING xref user text - print the link, matches PDF2:284 -->
                            <fo:inline xsl:use-attribute-sets="xref">
                                <xsl:apply-templates select="*[not(contains(@class, ' topic/desc '))] | text()"/>
                            </fo:inline>
                        </xsl:when>
                        <!-- HSC if no text is contained -->
                        <xsl:otherwise>
                            <xsl:if test="contains($unittest, 'chklinks')">
                                <xsl:message>LogTest12:</xsl:message>
                            </xsl:if>
                            <fo:inline xsl:use-attribute-sets="xref">
                                <xsl:value-of select="@href"/>
                            </fo:inline>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
            <!--HSX2 I wanted the "on page ... " text within the clickable area
            </fo:basic-link>
            -->

            <!--
            Disable because of the CQ#8102 bug
            <xsl:if test="*[contains(@class,' topic/desc ')]">
            <xsl:call-template name="insertLinkDesc"/>
            </xsl:if>
            -->

            <xsl:if test="not(@scope = 'external' or not(empty(@format) or @format = 'dita')) and exists($referenceTitle) and not($element[contains(@class, ' topic/fn ')])">
                <!-- SourceForge bug 1880097: should not include page number when xref includes author specified text -->
                <xsl:if test="contains($unittest, 'chklinks')">
                    <xsl:message>
                        <xsl:text>LogTest13:element.name="</xsl:text>
                        <xsl:value-of select="$element/name()"/>
                    </xsl:message>
                </xsl:if>

                <xsl:choose>
                    <!--HSX Process @outputclass:contains 'pagenumonly onpage pageonly'
                            all is done, but we have to catch it to avoid others' match -->
                    <xsl:when test="contains(@outputclass, '[page') or contains(@outputclass, '[onpage]')"/>
                    <!--HSX no user text was given ... but title text was available in target-->
                    <xsl:when test="
                            not(processing-instruction()[name() = 'ditaot'][. = 'usertext']) and
                            contains(@outputclass, 'page')">
                        <xsl:call-template name="insertPageNumberCitation">
                            <xsl:with-param name="destination" select="$destination"/>
                            <xsl:with-param name="element" select="$element"/>
                        </xsl:call-template>
                    </xsl:when>
                </xsl:choose>
                <!--HSX [see] needs a ')' parenthesis to conclude the text -->
                <xsl:if test="contains(@outputclass, '[see]')">
                    <fo:inline xsl:use-attribute-sets="xref_see">
                        <xsl:text>)</xsl:text>
                    </fo:inline>
                </xsl:if>
            </xsl:if>
        </fo:basic-link>
    </xsl:template>

    <!-- xref to footnote makes a callout. -->
    <xsl:template match="*[contains(@class, ' topic/xref ')][@type = 'fn']" priority="2">
        <xsl:variable name="href-fragment" select="substring-after(@href, '#')"/>
        <xsl:variable name="elemId" select="substring-after($href-fragment, '/')"/>
        <xsl:variable name="topicId" select="substring-before($href-fragment, '/')"/>
        <xsl:variable name="footnote-target" select="key('fnById', $elemId)[ancestor::*[contains(@class, ' topic/topic ')][1]/@id = $topicId]"/>
        <xsl:apply-templates select="$footnote-target" mode="footnote-callout"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/xref ')][empty(@href)]" priority="2">
        <fo:inline>
            <xsl:call-template name="commonattributes"/>
            <xsl:if test="contains($unittest, 'chklinks')">
                <xsl:message>LogTest14:</xsl:message>
            </xsl:if>
            <xsl:apply-templates select="*[not(contains(@class, ' topic/desc '))] | text()"/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/fn ')]" mode="footnote-callout">
        <fo:inline xsl:use-attribute-sets="fn__callout">

            <xsl:choose>
                <xsl:when test="@callout">
                    <xsl:value-of select="@callout"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count(key('enumerableByClass', 'topic/fn')[. &lt;&lt; current()]) + 1"/>
                </xsl:otherwise>
            </xsl:choose>

        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/related-links ')]">
        <xsl:if test="exists($includeRelatedLinkRoles)">
            <!--
            <xsl:variable name="topicType">
            <xsl:for-each select="parent::*">
            <xsl:call-template name="determineTopicType"/>
            </xsl:for-each>
            </xsl:variable>

            <xsl:variable name="collectedLinks">
            <xsl:apply-templates>
            <xsl:with-param name="topicType" select="$topicType"/>
            </xsl:apply-templates>
            </xsl:variable>

            <xsl:variable name="linkTextContent" select="string($collectedLinks)"/>

            <xsl:if test="normalize-space($linkTextContent)!=''">
            <fo:block xsl:use-attribute-sets="related-links">

            <fo:block xsl:use-attribute-sets="related-links.title">
            <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Related Links'"/>
            </xsl:call-template>
            </fo:block>

            <fo:block xsl:use-attribute-sets="related-links__content">
            <xsl:copy-of select="$collectedLinks"/>
            </fo:block>
            </fo:block>
            </xsl:if>

            -->
            <fo:block xsl:use-attribute-sets="related-links">
                <fo:block xsl:use-attribute-sets="related-links__content">
                    <xsl:if test="
                            $includeRelatedLinkRoles = ('child',
                            'descendant')">
                        <xsl:call-template name="ul-child-links"/>
                        <xsl:call-template name="ol-child-links"/>
                    </xsl:if>
                    <!--xsl:if test="$includeRelatedLinkRoles = ('next', 'previous', 'parent')">
                    <xsl:call-template name="next-prev-parent-links"/>
                </xsl:if-->
                    <xsl:variable name="unordered-links" as="element(linklist)*">
                        <xsl:apply-templates select="." mode="related-links:group-unordered-links">
                            <xsl:with-param name="nodes" select="
                                    descendant::*[contains(@class, ' topic/link ')]
                                    [not(related-links:omit-from-unordered-links(.))]
                                    [generate-id(.) = generate-id(key('hideduplicates', related-links:hideduplicates(.))[1])]"/>
                        </xsl:apply-templates>
                    </xsl:variable>
                    <xsl:apply-templates select="$unordered-links"/>
                    <!--linklists - last but not least, create all the linklists and their links, with no sorting or re-ordering-->
                    <xsl:apply-templates select="*[contains(@class, ' topic/linklist ')]"/>
                </fo:block>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <xsl:template name="ul-child-links">
        <xsl:variable name="children" select="
                descendant::*[contains(@class, ' topic/link ')]
                [@role = ('child',
                'descendant')]
                [not(parent::*/@collection-type = 'sequence')]
                [not(ancestor::*[contains(@class, ' topic/linklist ')])]"/>
        <xsl:if test="$children">
            <fo:list-block xsl:use-attribute-sets="related-links.ul">
                <xsl:for-each select="$children[generate-id(.) = generate-id(key('link', related-links:link(.))[1])]">
                    <fo:list-item xsl:use-attribute-sets="related-links.ul.li">
                        <fo:list-item-label xsl:use-attribute-sets="related-links.ul.li__label">
                            <fo:block xsl:use-attribute-sets="related-links.ul.li__label__content">
                                <fo:inline>
                                    <xsl:call-template name="commonattributes"/>
                                </fo:inline>
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="'Unordered List bullet'"/>
                                </xsl:call-template>
                            </fo:block>
                        </fo:list-item-label>
                        <fo:list-item-body xsl:use-attribute-sets="related-links.ul.li__body">
                            <fo:block xsl:use-attribute-sets="related-links.ul.li__content">
                                <xsl:apply-templates select="."/>
                            </fo:block>
                        </fo:list-item-body>
                    </fo:list-item>
                </xsl:for-each>
            </fo:list-block>
        </xsl:if>
    </xsl:template>

    <xsl:template name="ol-child-links">
        <xsl:variable name="children" select="
                descendant::*[contains(@class, ' topic/link ')]
                [@role = ('child',
                'descendant')]
                [parent::*/@collection-type = 'sequence']
                [not(ancestor::*[contains(@class, ' topic/linklist ')])]"/>
        <xsl:if test="$children">
            <fo:list-block xsl:use-attribute-sets="related-links.ol">
                <xsl:for-each select="($children[generate-id(.) = generate-id(key('link', related-links:link(.))[1])])">
                    <fo:list-item xsl:use-attribute-sets="related-links.ol.li">
                        <fo:list-item-label xsl:use-attribute-sets="related-links.ol.li__label">
                            <fo:block xsl:use-attribute-sets="related-links.ol.li__label__content">
                                <fo:inline>
                                    <xsl:call-template name="commonattributes"/>
                                </fo:inline>
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="'Ordered List Number'"/>
                                    <xsl:with-param name="params">
                                        <number>
                                            <xsl:value-of select="position()"/>
                                        </number>
                                    </xsl:with-param>
                                </xsl:call-template>
                            </fo:block>
                        </fo:list-item-label>
                        <fo:list-item-body xsl:use-attribute-sets="related-links.ol.li__body">
                            <fo:block xsl:use-attribute-sets="related-links.ol.li__content">
                                <xsl:apply-templates select="."/>
                            </fo:block>
                        </fo:list-item-body>
                    </fo:list-item>
                </xsl:for-each>
            </fo:list-block>
        </xsl:if>
    </xsl:template>

    <xsl:template name="getLinkScope" as="xs:string">
        <xsl:choose>
            <xsl:when test="ancestor-or-self::*[@scope][1]/@scope">
                <xsl:value-of select="ancestor-or-self::*[@scope][1]/@scope"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'local'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/link ')]">
        <xsl:param name="topicType" as="xs:string?">
            <xsl:for-each select="ancestor::*[contains(@class, ' topic/topic ')][1]">
                <xsl:call-template name="determineTopicType"/>
            </xsl:for-each>
        </xsl:param>
        <xsl:choose>
            <xsl:when test="
                    (@role and not($includeRelatedLinkRoles = @role)) or
                    (not(@role) and not($includeRelatedLinkRoles = '#default'))"/>
            <xsl:when test="
                    @role = 'child' and $chapterLayout = 'MINITOC' and
                    $topicType = ('topicChapter',
                    'topicAppendix',
                    'topicPart')">
                <!-- When a minitoc already links to children, do not add them here -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="processLink"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/link ')]" mode="processLink">
        <xsl:variable name="destination" select="opentopic-func:getDestinationId(@href)"/>
        <xsl:variable name="element" select="key('key_anchor', $destination, $root)[1]"/>

        <xsl:variable name="referenceTitle" as="node()*">
            <xsl:apply-templates select="." mode="insertReferenceTitle">
                <xsl:with-param name="href" select="@href"/>
                <xsl:with-param name="titlePrefix" select="''"/>
                <xsl:with-param name="destination" select="$destination"/>
                <xsl:with-param name="element" select="$element"/>
            </xsl:apply-templates>
        </xsl:variable>
        <xsl:variable name="linkScope" as="xs:string">
            <xsl:call-template name="getLinkScope"/>
        </xsl:variable>

        <fo:block xsl:use-attribute-sets="link">
            <fo:inline xsl:use-attribute-sets="link__content">
                <fo:basic-link>
                    <xsl:call-template name="buildBasicLinkDestination">
                        <xsl:with-param name="scope" select="$linkScope"/>
                        <xsl:with-param name="href" select="@href"/>
                    </xsl:call-template>
                    <xsl:choose>
                        <xsl:when test="not($linkScope = 'external') and exists($referenceTitle)">
                            <xsl:copy-of select="$referenceTitle"/>
                        </xsl:when>
                        <xsl:when test="not($linkScope = 'external')">
                            <xsl:call-template name="insertPageNumberCitation">
                                <xsl:with-param name="isTitleEmpty" select="true()"/>
                                <xsl:with-param name="destination" select="$destination"/>
                                <xsl:with-param name="element" select="$element"/>
                            </xsl:call-template>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="*[contains(@class, ' topic/linktext ')]"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:basic-link>
            </fo:inline>
            <xsl:if test="not($linkScope = 'external') and exists($referenceTitle)">
                <xsl:call-template name="insertPageNumberCitation">
                    <xsl:with-param name="destination" select="$destination"/>
                    <xsl:with-param name="element" select="$element"/>
                </xsl:call-template>
            </xsl:if>
            <xsl:call-template name="insertLinkShortDesc">
                <xsl:with-param name="destination" select="$destination"/>
                <xsl:with-param name="element" select="$element"/>
                <xsl:with-param name="linkScope" select="$linkScope"/>
            </xsl:call-template>
        </fo:block>
    </xsl:template>

    <xsl:template name="buildBasicLinkDestination">
        <xsl:param name="scope" select="@scope"/>
        <xsl:param name="format" select="@format"/>
        <xsl:param name="href" select="@href"/>
        <xsl:choose>
            <xsl:when test="
                    (contains($href, '://') and not(starts-with($href, 'file://')))
                    or starts-with($href, '/') or $scope = 'external' or not(empty($format) or $format = 'dita')">
                <xsl:attribute name="external-destination">
                    <xsl:text>url('</xsl:text>
                    <xsl:value-of select="$href"/>
                    <xsl:text>')</xsl:text>
                </xsl:attribute>
            </xsl:when>
            <xsl:when test="$scope = 'peer'">
                <xsl:attribute name="internal-destination">
                    <xsl:value-of select="$href"/>
                </xsl:attribute>
            </xsl:when>

            <xsl:when test="contains($href, '#')">
                <xsl:attribute name="internal-destination">
                    <xsl:value-of select="opentopic-func:getDestinationId($href)"/>
                </xsl:attribute>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="internal-destination">
                    <xsl:value-of select="$href"/>
                </xsl:attribute>
                <xsl:call-template name="brokenLinks">
                    <xsl:with-param name="href" select="$href"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--HSX indicate the page in the cross reference according topic
            the xref:outputclass
    -->
    <xsl:template name="insertPageNumberCitation">
        <xsl:param name="isTitleEmpty" as="xs:boolean" select="false()"/>
        <xsl:param name="destination" as="xs:string"/>
        <xsl:param name="element" as="element()?"/>

        <!--HSX check xref -->
        <xsl:choose>
            <xsl:when test="@type = 'step'">
                <!--HSC do not output page number on 'step' acc. to [DtPrt#12.8.2] -->
            </xsl:when>

            <!--HSC on empty destination we do not insert anything -->
            <xsl:when test="not($element) or ($destination = '')"/>

            <!--HSX2 outputclass=pagenumonly: support simple page number without any prefix -->
            <xsl:when test="contains(@outputclass, '[pagenumonly]')">
                <fo:inline>
                    <fo:page-number-citation ref-id="{$destination}"/>
                </fo:inline>
            </xsl:when>

            <!--HSX2 outputclass=pageonly is handled in otherwise clause -->
            <!--HSX2 outputclass=onpage: enforces 'on page 42' -->
            <xsl:when test="$isTitleEmpty or contains(@outputclass, '[onpage]')">
                <!--HSC [DtPrt15.4.4] allows changing the format of related links
                <fo:inline>
                -->
                <fo:inline xsl:use-attribute-sets="link__page">
                    <!--HSC this was inserted -->
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'On the page'"/>
                        <xsl:with-param name="params">
                            <pagenum>
                                <fo:inline>
                                    <fo:page-number-citation ref-id="{$destination}"/>
                                </fo:inline>
                            </pagenum>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:inline>
            </xsl:when>
            <!--HSX2 outputclass=pageonly: enforces 'page 42' -->
            <xsl:otherwise>
                <fo:inline>
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'Page'"/>
                        <xsl:with-param name="params">
                            <pagenum>
                                <fo:inline>
                                    <fo:page-number-citation ref-id="{$destination}"/>
                                </fo:inline>
                            </pagenum>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:inline>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/linktext ')]">
        <fo:inline xsl:use-attribute-sets="linktext">
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/linklist ')]">
        <fo:block xsl:use-attribute-sets="linklist">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/linkinfo ')]">
        <fo:block xsl:use-attribute-sets="linkinfo">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/linkpool ')]">
        <xsl:param name="topicType"/>
        <fo:block xsl:use-attribute-sets="linkpool">
            <xsl:apply-templates>
                <xsl:with-param name="topicType" select="$topicType"/>
            </xsl:apply-templates>
        </fo:block>
    </xsl:template>

    <xsl:function name="opentopic-func:getDestinationId">
        <xsl:param name="href"/>
        <xsl:call-template name="getDestinationIdImpl">
            <xsl:with-param name="href" select="$href"/>
        </xsl:call-template>
    </xsl:function>

    <xsl:template name="getDestinationIdImpl">
        <xsl:param name="href"/>

        <xsl:variable name="topic-id" select="substring-after($href, '#')"/>

        <xsl:variable name="element-id" select="substring-after($topic-id, '/')"/>

        <xsl:choose>
            <xsl:when test="$element-id = ''">
                <xsl:value-of select="$topic-id"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$element-id"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="brokenLinks">
        <xsl:param name="href"/>
        <!-- FIXME: There is no message PDFX063W -->
        <xsl:call-template name="output-message">
            <xsl:with-param name="msgnum">063</xsl:with-param>
            <xsl:with-param name="msgsev">W</xsl:with-param>
            <xsl:with-param name="msgparams">%1=<xsl:value-of select="$href"/>
            </xsl:with-param>
        </xsl:call-template>
    </xsl:template>

    <!-- Links with @type="topic" belong in no-name group. -->
    <xsl:template match="*[contains(@class, ' topic/link ')]" mode="related-links:get-group-priority" name="related-links:group-priority.topic" priority="-10" as="xs:integer">
        <xsl:call-template name="related-links:group-priority."/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/link ')]" mode="related-links:get-group" name="related-links:group.topic" priority="-10" as="xs:string">
        <xsl:call-template name="related-links:group."/>
    </xsl:template>

    <!-- Override no-name group wrapper template for HTML: output "Related Information" in a <linklist>. -->
    <xsl:template match="*[contains(@class, ' topic/link ')]" mode="related-links:result-group" name="related-links:group-result." as="element(linklist)" priority="-10">
        <xsl:param name="links" as="node()*"/>
        <xsl:if test="exists($links)">
            <linklist class="- topic/linklist " outputclass="relinfo">
                <title class="- topic/title ">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'Related information'"/>
                    </xsl:call-template>
                </title>
                <xsl:copy-of select="$links"/>
            </linklist>
        </xsl:if>
    </xsl:template>

    <!-- Concepts have their own group. -->
    <xsl:template match="*[contains(@class, ' topic/link ')][@type = 'concept']" mode="related-links:get-group" name="related-links:group.concept" as="xs:string">
        <xsl:text>concept</xsl:text>
    </xsl:template>

    <!-- Priority of concept group. -->
    <xsl:template match="*[contains(@class, ' topic/link ')][@type = 'concept']" mode="related-links:get-group-priority" name="related-links:group-priority.concept" as="xs:integer">
        <xsl:sequence select="3"/>
    </xsl:template>

    <!-- Wrapper for concept group: "Related concepts" in a <div>. -->
    <xsl:template match="*[contains(@class, ' topic/link ')][@type = 'concept']" mode="related-links:result-group" name="related-links:result.concept" as="element(linklist)">
        <xsl:param name="links" as="node()*"/>
        <xsl:if test="normalize-space(string-join($links, ''))">
            <linklist class="- topic/linklist " outputclass="relinfo relconcepts">
                <title class="- topic/title ">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'Related concepts'"/>
                    </xsl:call-template>
                </title>
                <xsl:copy-of select="$links"/>
            </linklist>
        </xsl:if>
    </xsl:template>

    <!-- References have their own group. -->
    <xsl:template match="*[contains(@class, ' topic/link ')][@type = 'reference']" mode="related-links:get-group" name="related-links:group.reference" as="xs:string">
        <xsl:text>reference</xsl:text>
    </xsl:template>

    <!-- Priority of reference group. -->
    <xsl:template match="*[contains(@class, ' topic/link ')][@type = 'reference']" mode="related-links:get-group-priority" name="related-links:group-priority.reference" as="xs:integer">
        <xsl:sequence select="1"/>
    </xsl:template>

    <!-- Reference wrapper for HTML: "Related reference" in <div>. -->
    <xsl:template match="*[contains(@class, ' topic/link ')][@type = 'reference']" mode="related-links:result-group" name="related-links:result.reference" as="element(linklist)">
        <xsl:param name="links"/>
        <xsl:if test="normalize-space(string-join($links, ''))">
            <linklist class="- topic/linklist " outputclass="relinfo relref">
                <title class="- topic/title ">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'Related reference'"/>
                    </xsl:call-template>
                </title>
                <xsl:copy-of select="$links"/>
            </linklist>
        </xsl:if>
    </xsl:template>

    <!-- Tasks have their own group. -->
    <xsl:template match="*[contains(@class, ' topic/link ')][@type = 'task']" mode="related-links:get-group" name="related-links:group.task" as="xs:string">
        <xsl:text>task</xsl:text>
    </xsl:template>

    <!-- Priority of task group. -->
    <xsl:template match="*[contains(@class, ' topic/link ')][@type = 'task']" mode="related-links:get-group-priority" name="related-links:group-priority.task" as="xs:integer">
        <xsl:sequence select="2"/>
    </xsl:template>

    <!-- Task wrapper for HTML: "Related tasks" in <div>. -->
    <xsl:template match="*[contains(@class, ' topic/link ')][@type = 'task']" mode="related-links:result-group" name="related-links:result.task" as="element(linklist)">
        <xsl:param name="links" as="node()*"/>
        <xsl:if test="normalize-space(string-join($links, ''))">
            <linklist class="- topic/linklist " outputclass="relinfo reltasks">
                <title class="- topic/title ">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'Related tasks'"/>
                    </xsl:call-template>
                </title>
                <xsl:copy-of select="$links"/>
            </linklist>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
