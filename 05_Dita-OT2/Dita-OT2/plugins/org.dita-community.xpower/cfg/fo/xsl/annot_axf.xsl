<?xml version='1.0'?>

<!--
Copyright ? 2004-2006 by Idiom Technologies, Inc. All rights reserved.
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

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:ddwrt="http://schemas.microsoft.com/WebParts/v2/DataView/runtime" xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index" xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:dita2xslfo="http://dita-ot.sourceforge.net/ns/200910/dita2xslfo"
    xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder" xmlns:my="my:my" xmlns:ext="http://exslt.org/common"
    exclude-result-prefixes="ot-placeholder opentopic opentopic-index opentopic-func dita2xslfo xs my ext axf" version="2.0">


    <!--HSX //////////////////////// VERY IMPORTANT ////////////////////
         Do not delete or change the statement <xsl:output indent="no"/>

         It is vital to avoid odd insertions in association with
         comments in 'codeblock'. Without this statement
         colored blocks will be indented by the amount of spaces before
         the next fo:inline statement. As the indentation of the stylesheet
         shall not be critical for the output, there shall be no output indentation
         
         I tried to involve a conversion map, but that's very dangerous ... so 
         you shouldn't change ... otherwise some < > will break the output since
         if it is the text (template=text()) it will not be translated to &lt;
         
    -->
    <xsl:output indent="no"/>
    
    <!-- //////////////////////// END VERY IMPORTANT //////////////////// -->

    <!--HSX input dir required to evaluate Ingore.xml without copying it to the temp folder -->
    <xsl:param name="input.dir.url" required="yes" as="xs:string"/>

    <xsl:template match="processing-instruction('oxy_comment_start')">
        <!--
        <xsl:message>
            <xsl:text> oxy_comment_start </xsl:text>
        </xsl:message>
        -->
    </xsl:template>

    <xsl:template match="processing-instruction('oxy_comment_end')">
        <!--
        <xsl:message>
            <xsl:text> oxy_comment_end </xsl:text>
        </xsl:message>
        -->
    </xsl:template>


    <xsl:template match="processing-instruction('oxy_insert_end')" mode="#all"/>

    <!-- <?oxy_delete author="scherzeh" timestamp="20150127T180912+0100" content="the stylesheet"?> -->
    <!-- <xsl:analyze-string select='$rawSuffix' regex="{'([0-9]+){1}([\.,0-9]*)'}"> -->

    <!-- <?oxy_delete author="scherzeh" timestamp="20150127T180912+0100" content="the stylesheet"?> -->
    <xsl:template match="processing-instruction('oxy_delete')">
        <xsl:variable name="author">
            <xsl:analyze-string select="normalize-space(.)"
                regex='author="(.*?)".?timestamp="([0-9]+)T([0-9]+)\+([0-9]+)".*content="(.*?)".?'>
                <xsl:matching-substring>
                    <xsl:element name="author">
                        <xsl:value-of select="regex-group(1)"/>
                    </xsl:element>
                    <xsl:element name="date">
                        <xsl:value-of select="regex-group(2)"/>
                    </xsl:element>
                    <xsl:element name="time">
                        <xsl:value-of select="regex-group(3)"/>
                    </xsl:element>
                    <xsl:element name="gmt">
                        <xsl:value-of select="regex-group(4)"/>
                    </xsl:element>
                    <xsl:element name="text">
                        <xsl:value-of select="regex-group(5)"/>
                    </xsl:element>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>
        <!-- [AHF#21.9] -->
        <!-- annotation types are shown in [pdf#12.5.6] -->

        <xsl:variable name="timestamp">
            <xsl:call-template name="getAuthor">
                <xsl:with-param name="prefix" select="'deleted by'"/>
                <xsl:with-param name="topic" select="$author"/>
            </xsl:call-template>
            <xsl:text>&#xA0;</xsl:text>
            <xsl:call-template name="getTimestamp">
                <xsl:with-param name="prefix" select="''"/>
                <xsl:with-param name="topic" select="$author"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="tid">
            <xsl:call-template name="get-id"/>
        </xsl:variable>

        <!--HSC Change bars are described in [XslFo#6.13.2] -->
        <xsl:if test="contains($revmode, 'change-bars')">
            <fo:change-bar-begin xsl:use-attribute-sets="changeBarDelete">
                <xsl:attribute name="change-bar-class" select="$tid"/>
            </fo:change-bar-begin>
        </xsl:if>

        <!--HSX annotation (PDF comment) can be shown to explain the change -->
        <xsl:choose>
            <xsl:when test="contains($revmode, 'show-annot')">
                <fo:inline xsl:use-attribute-sets="markDelete markDeleteAxf">
                    <xsl:attribute name="axf:annotation-author">
                        <xsl:value-of select="$author/author"/>
                    </xsl:attribute>

                    <xsl:attribute name="axf:annotation-contents">
                        <xsl:value-of select="$author/text"/>
                    </xsl:attribute>

                    <xsl:value-of select="$author/text"/>
                </fo:inline>
            </xsl:when>
            <xsl:otherwise>
                <fo:inline xsl:use-attribute-sets="markDelete">
                    <xsl:value-of select="$author/text"/>
                </fo:inline>
            </xsl:otherwise>
        </xsl:choose>

        <xsl:if test="contains($revmode, 'change-bars')">
            <fo:change-bar-end>
                <xsl:attribute name="change-bar-class" select="$tid"/>
            </fo:change-bar-end>
        </xsl:if>
    </xsl:template>

    <!-- .<?oxy_custom_start type="oxy_content_highlight" color="255,255,0"?> It
    should<?oxy_custom_end?>
    -->


    <!-- =================================== CUT ==================================== -->
    <xsl:template name="oxy_insert_start">
        <xsl:param name="tStart"/>
        <xsl:analyze-string select="normalize-space($tStart)" regex='author="(.*?)".?timestamp="([0-9]+)T([0-9]+)\+([0-9]+)".*'>
            <xsl:matching-substring>
                <xsl:element name="author">
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:element>
                <xsl:element name="date">
                    <xsl:value-of select="regex-group(2)"/>
                </xsl:element>
                <xsl:element name="time">
                    <xsl:value-of select="regex-group(3)"/>
                </xsl:element>
                <xsl:element name="gmt">
                    <xsl:value-of select="regex-group(4)"/>
                </xsl:element>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>


    <xsl:template name="oxy_comment_start">
        <xsl:param name="tStart"/>
        <xsl:if test="contains($unittest, 'oxycmt')">
            <xsl:text>Input to text dispatcher:</xsl:text>
            <xsl:value-of select="$tStart"/>
        </xsl:if>
        <xsl:analyze-string select="normalize-space($tStart)"
            regex='author="(.*?)".?timestamp="([0-9]+)T([0-9]+)\+([0-9]+)".*comment="(.*?)".?'>
            <xsl:matching-substring>
                <xsl:element name="author">
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:element>
                <xsl:element name="date">
                    <xsl:value-of select="regex-group(2)"/>
                </xsl:element>
                <xsl:element name="time">
                    <xsl:value-of select="regex-group(3)"/>
                </xsl:element>
                <xsl:element name="gmt">
                    <xsl:value-of select="regex-group(4)"/>
                </xsl:element>
                <xsl:element name="text">
                    <xsl:value-of select="regex-group(5)"/>
                </xsl:element>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:text>DID NOT MATCH COMMENT</xsl:text>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>

    <!-- <?oxy_custom_start type="oxy_content_highlight" color="255,255,0"?> -->
    <!-- <?oxy_custom_start'type=".*" color="([0-9]+),([0-9]+),([0-9]+)".*'> -->
    <xsl:template name="oxy_custom_start">
        <xsl:param name="tStart"/>
        <xsl:analyze-string select="normalize-space($tStart)" regex='type=".*" color="([0-9]+),([0-9]+),([0-9]+)".*'>
            <xsl:matching-substring>
                <xsl:element name="red">
                    <xsl:value-of select="regex-group(1)"/>
                </xsl:element>
                <xsl:element name="green">
                    <xsl:value-of select="regex-group(2)"/>
                </xsl:element>
                <xsl:element name="blue">
                    <xsl:value-of select="regex-group(3)"/>
                </xsl:element>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>

    <xsl:template name="putFields">
        <xsl:param name="myPos"/>
        <xsl:element name="pName">
            <xsl:value-of select="./name()"/>
        </xsl:element>
        <xsl:element name="pPos">
            <xsl:value-of select="$myPos"/>
        </xsl:element>
        <xsl:element name="pContent">
            <xsl:value-of select="."/>
        </xsl:element>
        <xsl:variable name="seTest">
            <xsl:choose>
                <xsl:when test="contains(./name(), 'start')">
                    <xsl:value-of select="1"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="0"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:element name="pStartEnd">
            <xsl:call-template name="getInteger">
                <xsl:with-param name="topic" select="$seTest"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:template>

    <xsl:template name="getInteger" as="xs:integer">
        <xsl:param name="topic"/>
        <xsl:choose>
            <xsl:when test="string-length($topic[last()]) = 0">
                <xsl:value-of select="0"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$topic[last()]"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="getAuthor">
        <xsl:param name="prefix"/>
        <xsl:param name="topic"/>
        <xsl:if test="string-length($prefix)">
            <xsl:value-of select="concat($prefix, '&#xA0;')"/>
        </xsl:if>
        <xsl:value-of select="$topic/author"/>
    </xsl:template>

    <xsl:template name="getTimestamp">
        <xsl:param name="prefix"/>
        <xsl:param name="topic"/>

        <xsl:value-of
            select="
                concat(
                $prefix,
                '&#xA0;',
                substring($topic/date, 7, 2),
                '.',
                substring($topic/date, 5, 2),
                '.',
                substring($topic/date, 1, 4),
                '&#xA0;&#xA0;&#xA0;',
                substring($topic/time, 1, 2),
                ':',
                substring($topic/time, 3, 2))"
        />
    </xsl:template>

    <!-- we have to check the last of the processing instructions, for its flavor,
    The last gets precedence, whatever it is (highlight, comment, insert -->
    <xsl:template match="text()" mode="insert-text">
        <xsl:call-template name="putLink">
            <xsl:with-param name="noLink" select="true()" tunnel="yes"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="text()">
        <xsl:variable name="checkRev">
            <xsl:for-each
                select="
                    preceding-sibling::processing-instruction('oxy_insert_start') |
                    preceding-sibling::processing-instruction('oxy_insert_end') |
                    preceding-sibling::processing-instruction('oxy_custom_start') |
                    preceding-sibling::processing-instruction('oxy_custom_end') |
                    preceding-sibling::processing-instruction('oxy_comment_start') |
                    preceding-sibling::processing-instruction('oxy_comment_end')
                    ">
                <xsl:variable name="myPos" select="position()"/>
                <xsl:element name="prcState">
                    <xsl:choose>
                        <xsl:when test="contains(./name(), 'oxy_insert')">
                            <xsl:element name="eInsert">
                                <xsl:call-template name="putFields">
                                    <xsl:with-param name="myPos" select="$myPos"/>
                                </xsl:call-template>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="contains(./name(), 'oxy_comment')">
                            <xsl:element name="eComment">
                                <xsl:call-template name="putFields">
                                    <xsl:with-param name="myPos" select="$myPos"/>
                                </xsl:call-template>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="contains(./name(), 'oxy_custom')">
                            <xsl:element name="eCustom">
                                <xsl:call-template name="putFields">
                                    <xsl:with-param name="myPos" select="$myPos"/>
                                </xsl:call-template>
                            </xsl:element>
                        </xsl:when>
                    </xsl:choose>
                </xsl:element>
            </xsl:for-each>
        </xsl:variable>

        <xsl:variable name="pIns">
            <xsl:call-template name="getInteger">
                <xsl:with-param name="topic" select="($checkRev/prcState/eInsert)[last()]/pStartEnd"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="pCst">
            <xsl:call-template name="getInteger">
                <xsl:with-param name="topic" select="($checkRev/prcState/eCustom)[last()]/pStartEnd"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="pCmt">
            <xsl:call-template name="getInteger">
                <xsl:with-param name="topic" select="($checkRev/prcState/eComment)[last()]/pStartEnd"/>
            </xsl:call-template>
        </xsl:variable>

        <!-- get the relevant content whenver we find an active (last) entry -->
        <xsl:variable name="attrs">
            <xsl:choose>
                <xsl:when test="contains($revmode, 'show-annot')">
                    <xsl:element name="mInsert" use-attribute-sets="markInsert markInsertAxf"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:element name="mInsert" use-attribute-sets="markInsert"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:element name="mComment" use-attribute-sets="markComment markCommentAxf"/>
            <xsl:element name="mCustom" use-attribute-sets="markCustom"/>
        </xsl:variable>

        <xsl:variable name="lastInsert">
            <xsl:copy-of select="($checkRev/prcState/eInsert)[last()]"/>
        </xsl:variable>

        <xsl:variable name="lastComment">
            <xsl:copy-of select="($checkRev/prcState/eComment)[last()]"/>
        </xsl:variable>

        <xsl:variable name="lastCustom">
            <xsl:copy-of select="($checkRev/prcState/eCustom)[last()]"/>
        </xsl:variable>

        <xsl:variable name="chkActive">
            <xsl:value-of select="$pIns + $pCmt + $pCst"/>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="$chkActive &gt; 0">
                <xsl:variable name="tid">
                    <xsl:call-template name="get-id"/>
                </xsl:variable>

                <xsl:if test="($pIns = 1) and (contains($revmode, 'change-bars'))">
                    <fo:change-bar-begin xsl:use-attribute-sets="changeBarInsert">
                        <xsl:attribute name="change-bar-class" select="$tid"/>
                    </fo:change-bar-begin>
                </xsl:if>
                <fo:inline>
                    <!-- //////////////////////// INSERTION //////////////////// -->
                    <xsl:if test="($pIns = 1)">
                        <!-- copy the attributes from the attrs/mInsert set -->
                        <xsl:for-each select="$attrs/mInsert/@*">
                            <xsl:attribute name="{name()}">
                                <xsl:value-of select="."/>
                            </xsl:attribute>
                        </xsl:for-each>

                        <!-- dispatch the content -->
                        <xsl:variable name="oxyStart">
                            <xsl:call-template name="oxy_insert_start">
                                <xsl:with-param name="tStart" select="$lastInsert"/>
                            </xsl:call-template>
                        </xsl:variable>

                        <xsl:if test="contains($revmode, 'show-annot')">
                            <!-- set dynamic attributes from content
                            <xsl:variable name="content">
                                <xsl:call-template name="getAuthor">
                                    <xsl:with-param name="prefix" select="'inserted by'"/>
                                    <xsl:with-param name="topic" select="$oxyStart"/>
                                </xsl:call-template>
                            </xsl:variable>
                            -->

                            <!-- get the variable fields from the content of the tag -->
                            <xsl:attribute name="axf:annotation-author">
                                <xsl:value-of select="$oxyStart/author"/>
                            </xsl:attribute>

                            <xsl:attribute name="axf:annotation-contents">
                                <xsl:value-of select="concat('inserted: ', normalize-space(.))"/>
                            </xsl:attribute>
                        </xsl:if>
                    </xsl:if>

                    <!-- //////////////////////// COMMENTS //////////////////// -->
                    <xsl:if test="$pCmt = 1">
                        <!-- copy the attributes from the attrs/mComment set -->
                        <xsl:for-each select="$attrs/mComment/@*">
                            <xsl:attribute name="{name()}">
                                <xsl:value-of select="."/>
                            </xsl:attribute>
                        </xsl:for-each>

                        <!-- dispatch the content -->
                        <xsl:variable name="oxyStart">
                            <xsl:call-template name="oxy_comment_start">
                                <xsl:with-param name="tStart" select="$lastComment"/>
                            </xsl:call-template>
                        </xsl:variable>

                        <!-- set dynamic attributes from content -->
                        <xsl:variable name="author">
                            <xsl:call-template name="getAuthor">
                                <xsl:with-param name="prefix" select="''"/>
                                <xsl:with-param name="topic" select="$oxyStart"/>
                            </xsl:call-template>
                        </xsl:variable>

                        <!-- get the variable fields from the content of the tag -->
                        <xsl:attribute name="axf:annotation-author">
                            <xsl:value-of select="$author"/>
                        </xsl:attribute>

                        <xsl:attribute name="axf:annotation-contents">
                            <xsl:value-of select="$oxyStart/text"/>
                        </xsl:attribute>

                        <xsl:if test="contains($unittest, 'oxycmt')">
                            <xsl:text>CHECK processing Input</xsl:text>
                            <xsl:text>[</xsl:text>
                            <xsl:value-of select="count($checkRev/prcState)"/>
                            <xsl:text>][</xsl:text>
                            <xsl:for-each select="$checkRev/child::*">
                                <xsl:text>  </xsl:text>
                                <xsl:value-of select="name()"/>
                            </xsl:for-each>
                            <xsl:text>]:</xsl:text>
                            <xsl:value-of select="string($checkRev)"/>
                            <xsl:text>::LastComment=</xsl:text>
                            <xsl:value-of select="$lastComment"/>
                            <xsl:text>::oxyStart=</xsl:text>
                            <xsl:value-of select="$oxyStart"/>
                        </xsl:if>
                    </xsl:if>
                    <!-- //////////////////////// CUSTOM INPUT  //////////////////// -->
                    <xsl:if test="$pCst = 1">
                        <!-- copy the attributes from the attrs/mInsert set -->
                        <xsl:for-each select="$attrs/mCustom/@*">
                            <xsl:attribute name="{name()}">
                                <xsl:value-of select="."/>
                            </xsl:attribute>
                        </xsl:for-each>

                        <!-- dispatch the content -->
                        <xsl:variable name="oxyStart">
                            <xsl:call-template name="oxy_custom_start">
                                <xsl:with-param name="tStart" select="$lastCustom"/>
                            </xsl:call-template>
                        </xsl:variable>

                        <!-- set dynamic attributes from content -->
                        <!-- [XslFo#5.9.9] is a discussion how to express colors -->
                        <!-- [XslFo#5.10.2] explains the rgb() function -->
                        <xsl:variable name="color" select="concat('rgb(', $oxyStart/red, ',', $oxyStart/green, ',', $oxyStart/blue, ')')"/>

                        <xsl:attribute name="background-color" select="$color"/>
                    </xsl:if>
                    <!-- give out the final text with all the attributes -->
                    <!--
                    <xsl:value-of select="."/>
                    -->
                    <!-- output link, if available, otherwise simply the text of this topic -->
                    <xsl:call-template name="putLink"/>
                </fo:inline>
                <xsl:if test="($pIns = 1) and (contains($revmode, 'change-bars'))">
                    <fo:change-bar-end>
                        <xsl:attribute name="change-bar-class" select="$tid"/>
                    </fo:change-bar-end>
                </xsl:if>
            </xsl:when>
            <!-- we simply didn't have any processor -->
            <xsl:otherwise>
                <!--
                <xsl:value-of select="."/>
                -->
                <xsl:call-template name="putLink"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- @func putLink | output link, if available, otherwise simply the text of this topic -->
    <!-- external-destination explained in [XlsFo#7.23.6]   -->
    <!-- external-destination="../docudesign/ezRead.pdf#dest=M8.newlink.Ch3p1" -->
    <!-- AHF allows to use GotoR [AHF#21.8.2] this is made in the option setting file [AHF#17.3]. -->

    <!--
    <xsl:variable name="folderURI" select="resolve-uri('.', base-uri(/))"/>
    -->
    <xsl:variable name="ignoresName" select="'Ignore.xml'"/>
    <xsl:variable name="ignAvail" as="xs:integer">
        <xsl:choose>
            <xsl:when test="document(concat($input.dir.url, $ignoresName))">
                <xsl:value-of select="1"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

    <xsl:variable name="ignoreTags">
        <xsl:if test="$ignAvail = 1">
            <xsl:copy-of select="document(concat($input.dir.url, $ignoresName))/*" copy-namespaces="no"/>
        </xsl:if>
    </xsl:variable>

    <xsl:template name="checkEzText">
        <xsl:param name="mytxt"/>
        <xsl:param name="level" select="0"/>
        <xsl:param name="plain" select="''"/>
        <xsl:param name="pretext" tunnel="yes" select="''"/>
        <!-- try to find the [ or ] -->

        <xsl:analyze-string select="$mytxt" regex="{'([^\[^\]]*)([\[\]]+?)(.*)'}">
            <xsl:matching-substring>
                <!--<xsl:text>&#xA;1:[</xsl:text>
                <xsl:value-of select="$level"/>
                <xsl:text>]    PRE=</xsl:text>
                <xsl:value-of select="regex-group(1)"/>
                <xsl:text>    BRK=</xsl:text>
                <xsl:value-of select="regex-group(2)"/>
                <xsl:text>    PST=</xsl:text>
                <xsl:value-of select="regex-group(3)"/>-->

                <xsl:choose>
                    <xsl:when test="$level = 0">
                        <xsl:variable name="LastChar" select="substring(regex-group(1), string-length(regex-group(1)), 1)"/>

                        <xsl:choose>
                            <xsl:when test="($LastChar = '!') or ($LastChar = '~')">
                                <xsl:value-of select="substring(regex-group(1), 1, string-length(regex-group(1)) - 1)"/>

                                <xsl:call-template name="checkEzText">
                                    <xsl:with-param name="mytxt" select="regex-group(3)"/>
                                    <xsl:with-param name="level" select="$level + 1"/>
                                    <xsl:with-param name="plain" select="'['"/>
                                    <xsl:with-param name="pretext" tunnel="yes" select="$LastChar"/>
                                </xsl:call-template>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="regex-group(1)"/>
                                <xsl:call-template name="checkEzText">
                                    <xsl:with-param name="mytxt" select="regex-group(3)"/>
                                    <xsl:with-param name="level" select="$level + 1"/>
                                    <xsl:with-param name="plain" select="'['"/>
                                    <xsl:with-param name="pretext" tunnel="yes" select="''"/>
                                </xsl:call-template>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>

                    <xsl:when test="($level = 1) and (regex-group(2) = ']')">

                        <!-- evaluate the eliminated [ezRead] construction for
                             the case [linktext::booktoken#chapnum]
                             igntext  = linktext, to be ignored (1)
                             chapnum  = chapter pointer (3)
                             linktext = booktoken (2)
                        -->
                        <xsl:analyze-string select="concat('[', regex-group(1), ']')" regex="{'.*?\[(.*?):{2}(.*?)#(.*?)\]'}">
                            <xsl:matching-substring>
                                <xsl:variable name="igntext" select="regex-group(2)"/>
                                <xsl:variable name="chapnum" select="regex-group(3)"/>
                                <xsl:variable name="linktext" select="regex-group(1)"/>
                                <xsl:call-template name="createEzLink">
                                    <xsl:with-param name="pretext" select="$pretext"/>
                                    <xsl:with-param name="igntext" select="$igntext"/>
                                    <xsl:with-param name="chapnum" select="$chapnum"/>
                                    <xsl:with-param name="linktext" select="$linktext"/>
                                    <xsl:with-param name="hasLinktext" select="1"/>
                                </xsl:call-template>
                            </xsl:matching-substring>
                            <!-- evaluate the eliminated [ezRead] construction for
                                 the case [booktoken#chapnum]
                                 igntext  = booktoken (1)
                                 chapnum  = chapter pointer (2)
                                 linktext = igntext=booktoken#chapnum (2)
                            -->
                            <xsl:non-matching-substring>
                                <xsl:analyze-string select="." regex="{'.*?\[(.*?)#(.*?)\]'}">
                                    <xsl:matching-substring>
                                        <xsl:variable name="igntext" select="regex-group(1)"/>
                                        <xsl:variable name="chapnum" select="regex-group(2)"/>
                                        <xsl:variable name="linktext" select="concat(regex-group(1), '#', regex-group(2))"/>
                                        <xsl:call-template name="createEzLink">
                                            <xsl:with-param name="pretext" select="$pretext"/>
                                            <xsl:with-param name="igntext" select="$igntext"/>
                                            <xsl:with-param name="chapnum" select="$chapnum"/>
                                            <xsl:with-param name="linktext" select="$linktext"/>
                                            <xsl:with-param name="hasLinktext" select="0"/>
                                        </xsl:call-template>
                                    </xsl:matching-substring>

                                    <!-- evaluate the eliminated [ezRead] construction for
                                         the case [linktext::booktoken]
                                         igntext  = booktoken (2)
                                         chapnum  = ''
                                         linktext = linktext(1)
                                    -->
                                    <xsl:non-matching-substring>
                                        <xsl:analyze-string select="." regex="{'.*?\[(.*?):{2}(.*?)\]'}">
                                            <xsl:matching-substring>
                                                <xsl:variable name="igntext" select="regex-group(2)"/>
                                                <xsl:variable name="chapnum" select="''"/>
                                                <xsl:variable name="linktext" select="regex-group(1)"/>
                                                <xsl:call-template name="createEzLink">
                                                    <xsl:with-param name="pretext" select="$pretext"/>
                                                    <xsl:with-param name="igntext" select="$igntext"/>
                                                    <xsl:with-param name="chapnum" select="$chapnum"/>
                                                    <xsl:with-param name="linktext" select="$linktext"/>
                                                    <xsl:with-param name="hasLinktext" select="1"/>
                                                </xsl:call-template>
                                            </xsl:matching-substring>
                                            <!-- evaluate the eliminated [ezRead] construction for
                                                 the case [booktoken]
                                                 igntext  = booktoken (1)
                                                 chapnum  = ''
                                                 linktext = [booktoken]
                                            -->
                                            <xsl:non-matching-substring>
                                                <xsl:analyze-string select="." regex="{'.*?\[(.*?)\]'}">
                                                    <xsl:matching-substring>
                                                        <xsl:variable name="igntext" select="regex-group(1)"/>
                                                        <xsl:variable name="chapnum" select="''"/>
                                                        <xsl:variable name="linktext" select="regex-group(1)"/>
                                                        <xsl:call-template name="createEzLink">
                                                            <xsl:with-param name="pretext" select="$pretext"/>
                                                            <xsl:with-param name="igntext" select="$igntext"/>
                                                            <xsl:with-param name="chapnum" select="$chapnum"/>
                                                            <xsl:with-param name="linktext" select="$linktext"/>
                                                            <xsl:with-param name="hasLinktext" select="0"/>
                                                        </xsl:call-template>
                                                    </xsl:matching-substring>
                                                </xsl:analyze-string>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:non-matching-substring>
                                </xsl:analyze-string>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>


                        <!--HSX continue in the text parser -->
                        <xsl:call-template name="checkEzText">
                            <xsl:with-param name="mytxt" select="regex-group(3)"/>
                            <xsl:with-param name="level" select="$level - 1"/>
                            <xsl:with-param name="plain" select="''"/>
                        </xsl:call-template>
                    </xsl:when>

                    <xsl:when test="($level = 1) and (regex-group(2) = '[')">
                        <xsl:call-template name="checkEzText">
                            <xsl:with-param name="mytxt" select="regex-group(3)"/>
                            <xsl:with-param name="level" select="$level + 2"/>
                            <xsl:with-param name="plain" select="concat($plain, regex-group(1), '[')"/>
                        </xsl:call-template>
                    </xsl:when>

                    <!--HSX FLUSH the nested content -->
                    <xsl:when test="($level = 2) and (regex-group(2) = ']')">
                        <xsl:value-of select="concat($plain, ']')"/>

                        <xsl:call-template name="checkEzText">
                            <xsl:with-param name="mytxt" select="regex-group(3)"/>
                            <xsl:with-param name="level" select="0"/>
                            <xsl:with-param name="plain" select="''"/>
                        </xsl:call-template>
                    </xsl:when>
                    
                    <!--HSX found [ ... go one level up -->
                    <xsl:when test="regex-group(2) = '['">
                        <xsl:call-template name="checkEzText">
                            <xsl:with-param name="mytxt" select="regex-group(3)"/>
                            <xsl:with-param name="level" select="$level + 1"/>
                            <xsl:with-param name="plain" select="concat($plain, regex-group(1), '[')"/>
                        </xsl:call-template>
                    </xsl:when>

                    <!--HSX found ] ... go one level down -->
                    <xsl:when test="regex-group(2) = ']'">
                        <xsl:call-template name="checkEzText">
                            <xsl:with-param name="mytxt" select="regex-group(3)"/>
                            <xsl:with-param name="level" select="$level - 1"/>
                            <xsl:with-param name="plain" select="concat($plain, regex-group(1), ']')"/>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>
                            <xsl:text>annot_axf.xsl - Should never occur</xsl:text>
                            <xsl:value-of select="$level"/>
                            <xsl:text>] = </xsl:text>
                            <xsl:value-of select="regex-group(1)"/>
                            <xsl:text>  ::  </xsl:text>
                            <xsl:value-of select="regex-group(2)"/>
                            <xsl:text>  ::  </xsl:text>
                            <xsl:value-of select="regex-group(3)"/>
                            <xsl:text>  ::  </xsl:text>
                            <xsl:value-of select="$plain"/>
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:matching-substring>

            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>

    <xsl:template name="putLink">
        <xsl:choose>
            <!--HSX Helmut's special ... a text with '@' only will not print, this avoids printing
                    the content of a 'should-be-empty' text (with the @ only).

                    Background ... to evaluate comments I need to hit the text() template.
                    Typically you achieve this by having text in the oxygen comments, however, as
                    it runs trough the text() template THAT text would be printed.

                    Well - we put that comment into Acrobat comments, so there's no need to print
                    the comment on the page and it has the advantage that a reader may delete all
                    comments from the PDF to clean it up. If it was on the text ... less convenient.

                    If you don't want to print the text, you cannot just leave out any text
                    from your comment because then it would not hit the text() template.

                    Therefore you may just print a single '@' character which will trigger
                    the text() template but it will not print text. I could have choosen the
                    invisible whitespace (e.ge. &#xA0) but I was afraid that this would be
                    too much of a 'hidden' for a hidden feature.
            -->
            <xsl:when test="normalize-space(.) = '@'"/>

            <xsl:otherwise>

                <!--HSX
                    We need to distinguish between text in a codeblock and any other text.
                    codeblock maintains line breaks and a formatter should not break lines
                    in a codeblock section.

                    Here we solve the problem that an ezRead link eg. [linktext with spaces::ezRead#3]
                    could be broken by formatting into [linktext with
                    space::ezRead#3]

                    Such break is no more recognized by the regex as one text. Using normalize-space()
                    would kill the first and last blank of the current text. Therefore for
                    any text which is not under codeblock, we use the translate(..) function to
                    replace line breaks by spaces.
                -->
                <xsl:variable name="theText">
                    <xsl:choose>
                        <xsl:when test="ancestor::*[contains(@class, 'codeblock')]">
                            <xsl:value-of select="."/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="normalize-space(translate(., '&#x0A;&#x0D;', '  '))"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <!--HSX isolate <pretext>[entry]... we cannot pick posttext because then
                    we would not get the next [] statement
                -->
                <xsl:choose>
                    <!--HSX improve performance, no brackets ... go ahead plain -->
                    <xsl:when test="not(contains($theText, '['))">
                        <xsl:value-of select="$theText"/>
                    </xsl:when>

                    <!-- check whether we have the same number of [ as we have ], otherwise we would
                     create bad structure input in the further process
                -->
                    <xsl:when test="string-length(translate($theText, ']', '')) - string-length(translate($theText, '[', '')) != 0">
                        <xsl:value-of select="$theText"/>
                    </xsl:when>

                    <xsl:otherwise>
                        <xsl:call-template name="checkEzText">
                            <xsl:with-param name="mytxt" select="$theText"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
            <!-- checking for @ -->
        </xsl:choose>
    </xsl:template>

    <!--HSX create the actual link and the associated display text
        $pretext contains the text before the abc![ezRead] link >> "abc!"
        $igntext contains the text to find in the Ignore.xsl (and to suggest in Ignore_Local.xsl)
        $chapnum is the text after # e.g. "4.1"
        $linktext is the text to display (without brackets [])
    -->
    <xsl:template name="createEzLink">
        <xsl:param name="pretext"/>
        <xsl:param name="igntext"/>
        <xsl:param name="chapnum"/>
        <xsl:param name="linktext"/>
        <xsl:param name="hasLinktext"/>
        <xsl:param name="noLink" select="false()" tunnel="yes"/>
        <!--HSX we use tunnel [XSLT#5.4.4.5] for $noLink to allow any caller using it -->
        <xsl:variable name="cntIgn">
            <xsl:choose>
                <!--HSX ~[ ... ] enforces no interpretation of the content -->
                <xsl:when test="ends-with($pretext, '~')">
                    <xsl:value-of select="1"/>
                </xsl:when>
                <xsl:when test="string-length($chapnum) &gt; 0">
                    <xsl:value-of select="0"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="count($ignoreTags/ignores/ignore[. = concat('[', $igntext, ']')])"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$cntIgn = 0">
                <xsl:variable name="file">
                    <xsl:value-of select="replace(translate($chapnum, '._-:', 'pum'), '(^[0-9])', 'Ch$1')"/>
                </xsl:variable>
                <!-- Print the text before the [ezRead] link
                     An exclamation mark before the [ ] construct will set the
                    content in brackets [ ]
                -->
                <xsl:choose>
                    <xsl:when test="ends-with($pretext, '!')">
                        <xsl:value-of select="substring($pretext, 1, string-length($pretext) - 1)"/>
                        <xsl:text>[</xsl:text>
                    </xsl:when>
                    <xsl:when test="$hasLinktext = 0">
                        <xsl:value-of select="$pretext"/>
                        <xsl:text>[</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$pretext"/>
                    </xsl:otherwise>
                </xsl:choose>

                <!-- print the [ezRead] link-->
                <xsl:choose>
                    <!--HSX We might get situations where we cannot allow a link
                            to be generated. This can happen if we create a list of
                            figures (which already does links) and meet a figure caption
                            with an ezRead link. As we do nto want to create link-in-link
                            we can catch these situations with $noLink = true()
                    -->
                    <xsl:when test="$noLink or not(contains($ezRead, 'link'))">
                        <xsl:value-of select="$linktext"/>
                    </xsl:when>
                    <xsl:when test="string-length($chapnum) &gt; 0">
                        <fo:basic-link xsl:use-attribute-sets="xref">
                            <xsl:attribute name="external-destination">
                                <xsl:value-of
                                    select="
                                        concat(
                                        $DocuPath,
                                        '\dev\ref\stb\',
                                        $igntext,
                                        '\',
                                        $igntext,
                                        '_',
                                        $file,
                                        '.stb')"
                                />
                            </xsl:attribute>
                            <xsl:value-of select="$linktext"/>
                        </fo:basic-link>
                    </xsl:when>
                    <!-- no chapter available -->
                    <xsl:otherwise>
                        <fo:basic-link xsl:use-attribute-sets="xref">
                            <xsl:attribute name="external-destination">
                                <xsl:value-of
                                    select="
                                        concat(
                                        $DocuPath,
                                        '\dev\ref\stb\',
                                        $igntext,
                                        '\',
                                        $igntext,
                                        '.stb')"
                                />
                            </xsl:attribute>
                            <xsl:value-of select="$linktext"/>
                        </fo:basic-link>
                    </xsl:otherwise>
                </xsl:choose>

                <!--HSX an exclamation mark before the [ ] construct will set the
                    content in brackets [ ]
                -->
                <xsl:if test="ends-with($pretext, '!') or ($hasLinktext = 0)">
                    <xsl:text>]</xsl:text>
                </xsl:if>
            </xsl:when>

            <!-- found the [] to be ignored (cntIgn > 0)
             -->
            <xsl:otherwise>
                <xsl:choose>
                    <!-- skip the tilde and print the pretext -->
                    <xsl:when test="ends-with($pretext, '~')">
                        <xsl:value-of select="substring-before($pretext, '~')"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$pretext"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:choose>
                    <xsl:when test="string-length($linktext) &gt; 0">
                        <xsl:text>[</xsl:text>
                        <xsl:value-of select="$linktext"/>
                        <xsl:text>]</xsl:text>
                    </xsl:when>
                    <!-- simply print the content, found in igntext, to reference made -->
                    <xsl:otherwise>
                        <xsl:text>[</xsl:text>
                        <xsl:value-of select="$igntext"/>
                        <xsl:if test="string-length($chapnum) &gt; 0">
                            <xsl:text>#</xsl:text>
                            <xsl:value-of select="$chapnum"/>
                        </xsl:if>
                        <xsl:text>]</xsl:text>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
