<?xml version="1.0" encoding="UTF-8" ?>

<!--
Copyright © 2004-2005 by Idiom Technologies, Inc. All rights reserved.
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

<!-- An adaptation of the Toolkit topicmerge.xsl for FO plugin use. -->

<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot" exclude-result-prefixes="xs dita-ot">

    <xsl:import href="plugin:org.dita.base:xsl/common/dita-utilities.xsl"/>
    <xsl:import href="plugin:org.dita.base:xsl/common/output-message.xsl"/>

    <xsl:variable name="msgprefix" select="'PDFX'"/>

    <xsl:output indent="no"/>

    <!--key all id(s) which come from topics with topic/topic -->
    <xsl:key name="topic" match="dita-merge/*[contains(@class,' topic/topic ')]" use="concat('#',@id)"/>
    <xsl:key name="topic" match="dita-merge/dita" use="concat('#',*[contains(@class, ' topic/topic ')][1]/@id)"/>
    <!-- key all topicrefs in the map -->
    <xsl:key name="topicref" match="//*[contains(@class,' map/topicref ')]" use="generate-id()"/>

    <!--
  <xsl:template match="/">
    <xsl:copy-of select="."/>
  </xsl:template>
-->
    <!--HSX unittest for messages " copyel chghref replid           -->
    <xsl:variable name="unittest" select="'none'"/>

    <!--HSC walk through all maps -->
    <xsl:template match="dita-merge">
        <xsl:variable name="map" select="(*[contains(@class,' map/map ')])[1]"/>
        <xsl:element name="{name($map)}">
            <xsl:copy-of select="$map/@*"/>
            <xsl:apply-templates select="$map" mode="build-tree"/>
        </xsl:element>
    </xsl:template>

    <xsl:template match="dita-merge/*[contains(@class,' map/map ')]" mode="build-tree">
        <opentopic:map xmlns:opentopic="http://www.idiominc.com/opentopic">
            <xsl:apply-templates/>
        </opentopic:map>
        <xsl:apply-templates mode="build-tree"/>
    </xsl:template>

    <xsl:template match="*[contains(@class,' map/topicref ')]" mode="build-tree">
        <xsl:choose>
            <!--HSX if @first_topic_id has content ... -->
            <xsl:when test="not(normalize-space(@first_topic_id) = '')">
                <xsl:message>DebugX01</xsl:message>
                <xsl:apply-templates select="key('topic',@first_topic_id)">
                    <xsl:with-param name="parentId" select="generate-id()"/>
                </xsl:apply-templates>
                <xsl:if test="@first_topic_id != @href">
                    <xsl:message>DebugX02</xsl:message>
                    <xsl:apply-templates select="key('topic',@href)">
                        <xsl:with-param name="parentId" select="generate-id()"/>
                    </xsl:apply-templates>
                </xsl:if>
            </xsl:when>
            <!--HSX if a href exists ... -->
            <xsl:when test="not(normalize-space(@href) = '')">
                <xsl:message>DebugX03</xsl:message>
                <xsl:apply-templates select="key('topic',@href)">
                    <xsl:with-param name="parentId" select="generate-id()"/>
                </xsl:apply-templates>
            </xsl:when>
            <!--HSX if we have a bookmap/part or navtitle ... -->
            <xsl:when
                test="contains(@class, ' bookmap/part ') or
                      (normalize-space(@navtitle) != '' or
                      *[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')])">
                <xsl:message>DebugX04</xsl:message>
                <xsl:variable name="isNotTopicRef" as="xs:boolean">
                    <xsl:call-template name="isNotTopicRef"/>
                </xsl:variable>
                <xsl:if test="not($isNotTopicRef)">
                    <xsl:message>DebugX05</xsl:message>
                    <topic id="{generate-id()}" class="+ topic/topic pdf2-d/placeholder ">
                        <title class="- topic/title ">
                            <xsl:choose>
                                <xsl:when
                                    test="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]">
                                    <xsl:copy-of
                                        select="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]/node()"
                                    />
                                </xsl:when>
                                <xsl:when test="@navtitle">
                                    <xsl:value-of select="@navtitle"/>
                                </xsl:when>
                            </xsl:choose>
                        </title>
                        <!--body class=" topic/body "/-->
                        <xsl:apply-templates mode="build-tree"/>
                    </topic>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>DebugX06</xsl:message>
                <xsl:apply-templates mode="build-tree"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[@print = 'no']" priority="5" mode="build-tree"/>

    <xsl:template
        match="*[contains(@class,' bookmap/backmatter ')] |
                         *[contains(@class,' bookmap/booklists ')] |
                         *[contains(@class,' bookmap/frontmatter ')]"
        priority="2" mode="build-tree">
        <xsl:message>DebugX07</xsl:message>
        <xsl:apply-templates mode="build-tree"/>
    </xsl:template>

    <xsl:template match="*[contains(@class,' bookmap/toc ')][not(@href)]" priority="2" mode="build-tree">
        <ot-placeholder:toc id="{generate-id()}">
            <xsl:apply-templates mode="build-tree"/>
        </ot-placeholder:toc>
    </xsl:template>

    <xsl:template match="*[contains(@class,' bookmap/indexlist ')][not(@href)]" priority="2" mode="build-tree">
        <ot-placeholder:indexlist id="{generate-id()}">
            <xsl:apply-templates mode="build-tree"/>
        </ot-placeholder:indexlist>
    </xsl:template>

    <xsl:template match="*[contains(@class,' bookmap/glossarylist ')][not(@href)]" priority="2" mode="build-tree">
        <xsl:message>DebugX08</xsl:message>
        <ot-placeholder:glossarylist id="{generate-id()}">
            <xsl:apply-templates mode="build-tree"/>
        </ot-placeholder:glossarylist>
    </xsl:template>

    <xsl:template match="*[contains(@class,' bookmap/tablelist ')][not(@href)]" priority="2" mode="build-tree">
        <ot-placeholder:tablelist id="{generate-id()}">
            <xsl:apply-templates mode="build-tree"/>
        </ot-placeholder:tablelist>
    </xsl:template>

    <xsl:template match="*[contains(@class,' bookmap/figurelist ')][not(@href)]" priority="2" mode="build-tree">
        <ot-placeholder:figurelist id="{generate-id()}">
            <xsl:apply-templates mode="build-tree"/>
        </ot-placeholder:figurelist>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' map/topicref ') and @print='no']" priority="6"/>

    <!--HSC ======================= Process topics in DITA files found in the href attr ============== -->
    <!--HSX I had to exclude glossentry from the match in order to 
        propagate the correct id prefix. Other templates do this correctly.
        The situation occurred when trying to refer xref a glossterm -->
    <xsl:template
        match="*[contains(@class,' topic/topic ')]
                          [not(contains(@class,' glossentry/glossentry '))] |
                          dita-merge/dita">

        <xsl:param name="parentId"/>
        <xsl:param name="newid"/>
        <xsl:message>
            <xsl:text>DebugX18:MatchingId:</xsl:text>
            <xsl:value-of select="@id"/>
            <xsl:text>-</xsl:text>
            <xsl:value-of select="$newid"/>
            <xsl:text>::</xsl:text>
            <xsl:value-of select="@class"/>
        </xsl:message>

        <!--HSC The same file could have been used twice or more in a ditamap.
            To avoid multiple ids, the system will convert the id's in a file
            to make them unique.
            
            $idcount counts the number of siblings for the id of a topicref,
            if there is no reuse ... there will be no change in the id
        -->
        <xsl:variable name="idcount">
            <!--for-each is used to change context.  There's only one entry with a key of $parentId-->
            <xsl:for-each select="key('topicref',$parentId)">
                <xsl:message>
                    <xsl:text>DebugParentId=</xsl:text>
                    <xsl:value-of select="$parentId"/>
                </xsl:message>
                <xsl:value-of
                    select="count(preceding::*[@href = current()/@href][not(ancestor::*[contains(@class, ' map/reltable ')])]) + count(ancestor::*[@href = current()/@href])"
                />
            </xsl:for-each>
        </xsl:variable>
        <xsl:copy>
            <!--HSC process all attributes except id (do the homework) 
                Doing this check revealed that the initial id is still
                available in @oid
            -->
            <xsl:if test="contains($unittest, 'prcattrs')">
                <xsl:message>
                    <xsl:text>Processing attributes ...&#xA;</xsl:text>
                    <xsl:for-each select="@*">
                        <xsl:value-of select="name()"/>
                        <xsl:text>=[</xsl:text>
                        <xsl:value-of select="."/>
                        <xsl:text>]&#xA;</xsl:text>
                    </xsl:for-each>
                </xsl:message>
            </xsl:if>
            <xsl:apply-templates select="@*[name() != 'id']"/>
            <xsl:if test="contains($unittest, 'prcattrs')">
                <xsl:message>Ended Processing attributes ...</xsl:message>
            </xsl:if>

            <!--HSX Process the id attribute -->
            <xsl:variable name="new_id">
                <xsl:choose>
                    <xsl:when test="number($idcount) &gt; 0">
                        <xsl:value-of select="concat(@id,'_ssol',$idcount)"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="@id"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>

            <xsl:call-template name="DebugShowIdChange">
                <xsl:with-param name="newid" select="$new_id"/>
            </xsl:call-template>
            <xsl:attribute name="id">
                <xsl:value-of select="$new_id"/>
            </xsl:attribute>

            <!--HSC Add the new prefix to all children, we are in a copy, so the
                    templates will simply copy themselves -->
            <xsl:apply-templates>
                <xsl:with-param name="newid" select="$new_id"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="key('topicref',$parentId)/*" mode="build-tree"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template name="DebugShowIdChange">
        <xsl:param name="newid"/>
        <xsl:if test="contains($unittest, 'replid')">
            <xsl:message>
                <xsl:text>ReplaceID[</xsl:text>
                <xsl:value-of select="name()"/>
                <xsl:text>] id=[</xsl:text>
                <xsl:value-of select="@id"/>
                <xsl:text>] by [</xsl:text>
                <xsl:value-of select="$newid"/>
                <xsl:text>]</xsl:text>
            </xsl:message>
        </xsl:if>
    </xsl:template>

    <!-- Linkless topicref or topichead -->
    <xsl:template match="*[contains(@class,' map/topicref ')][not(@href)]" priority="5">
        <xsl:param name="newid"/>
        <xsl:message>CalledDebug01</xsl:message>
        <xsl:copy>
            <xsl:attribute name="id">
                <xsl:value-of select="generate-id()"/>
            </xsl:attribute>
            <xsl:message>NewDebug02</xsl:message>
            <xsl:apply-templates select="@*">
                <xsl:with-param name="newid" select="$newid"/>
            </xsl:apply-templates>
            <xsl:message>NewDebug03</xsl:message>
            <xsl:apply-templates select="*|text()|processing-instruction()">
                <xsl:with-param name="newid" select="$newid"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="*[contains(@class,' map/topicref ')]/@id" priority="5"/>

    <xsl:template match="@href">
        <xsl:param name="newid"/>
        <xsl:message>DebugX09</xsl:message>
        <xsl:message>CalledDebug02</xsl:message>

        <xsl:variable name="topic-id" select="dita-ot:get-topic-id(.)" as="xs:string?"/>
        <xsl:variable name="element-id" select="dita-ot:get-element-id(.)" as="xs:string?"/>
        <xsl:if test="contains($unittest, 'chghref')">
            <xsl:message>
                <xsl:text>Change-href using topic-id=[</xsl:text>
                <xsl:value-of select="$topic-id"/>
                <xsl:text>] element-id=[</xsl:text>
                <xsl:value-of select="$element-id"/>
                <xsl:text>] &#xA;ohref[</xsl:text>
                <xsl:value-of select="../@ohref/name()"/>
                <xsl:text>] = </xsl:text>
                <xsl:value-of select="../@ohref"/>
                <xsl:text>&#xA;</xsl:text>
            </xsl:message>
        </xsl:if>
        <xsl:attribute name="href">
            <xsl:variable name="chref">
                <xsl:if test="../@ohref">
                    <xsl:analyze-string select="../@ohref" regex="{'^.*#(.*)/(.*)'}">
                        <xsl:matching-substring>
                            <xsl:choose>
                                <xsl:when test="regex-group(1) = regex-group(2)">
                                    <xsl:value-of select="concat('#', $topic-id)"/>
                                </xsl:when>
                            </xsl:choose>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:if>
            </xsl:variable>

            <xsl:choose>
                <xsl:when test="empty($element-id) or not(starts-with(., '#unique'))">
                    <xsl:if test="contains($unittest, 'chghref')">
                        <xsl:message>
                            <xsl:text>Applying href:empty-elementid or not-unique ot href=[</xsl:text>
                            <xsl:value-of select="."/>
                            <xsl:text>]</xsl:text>
                        </xsl:message>
                    </xsl:if>
                    <xsl:value-of select="."/>
                </xsl:when>

                <!--HSC SELDOM: if a topicref is copied under itself ... 
                        (sounds like nonsens but maybe there are situations)
                        then apply _Connect_42_ to the original id only in the second(element) place
                -->
                <xsl:when test="ancestor::*[contains(@class, ' topic/topic ')][1]/@id = $topic-id">
                    <xsl:if test="contains($unittest, 'chghref')">
                        <xsl:message>
                            <xsl:text>Applying href:connect_42_newid_newid to href=[</xsl:text>
                            <xsl:value-of select="."/>
                        </xsl:message>
                    </xsl:if>
                    <xsl:text>#</xsl:text>
                    <xsl:value-of select="$newid"/>
                    <xsl:text>/</xsl:text>
                    <xsl:value-of select="$newid"/>
                    <xsl:text>_Connect_42_</xsl:text>
                    <xsl:value-of select="$element-id"/>
                </xsl:when>

                <!--HSX for the majority of cases, if there is a #unique ... 
                     apply _Connect_42_
                     
                     There seems to be a bug because the dost.jar kills the original id
                     of a concept/task/reference etc and replace by a single #unique_n
                     
                     Consequently all href going to such concept/task/reference shall
                     cut off the existing specifier and isolate the #unique_n information
                     
                     e.g. I got a chapter concept:@id = 'c_concept' and it showed up here
                     as 
                        @id = 'unique_10' where the hrefs going to @href = '#unique_10/c_concept'
                        
                     in  the final topic.fo the target (concept) was
                        @id = 'unique_10' with hrefs goint to @href = 'unique_10_Connect_42_c_concept'
                     
                     which shows, that we need another when case
                     
               -->
                <xsl:when test="string-length(normalize-space($chref)) &gt; 0">
                    <xsl:if test="contains($unittest, 'chref')">
                        <xsl:message>
                            <xsl:text>Apply=[</xsl:text>
                            <xsl:value-of select="$chref"/>
                            <xsl:text>]</xsl:text>
                        </xsl:message>
                    </xsl:if>
                    <xsl:value-of select="$chref"/>
                </xsl:when>
                <xsl:otherwise>
                    <!--HSX I should recognize the target's type, depending on that I can say
                        how the change goes
                    -->
                    <xsl:if test="contains($unittest, 'chg42')">
                        <xsl:message>
                            <xsl:text>Unittest-Applying href:connect_42_topicid_elementid to href=[</xsl:text>
                            <xsl:value-of select="."/>
                            <xsl:text>] parent = </xsl:text>
                            <xsl:value-of
                                select="ancestor::*[contains(name(), 'concept') or
                            contains(name(), 'task') or
                            contains(name(), 'reference') or
                            contains(name(), 'glossary') or
                            contains(@class, ' topic/topic ')
                            ][1]/name()"/>
                            <xsl:text> class=</xsl:text>
                            <xsl:value-of
                                select="ancestor::*[contains(name(), 'concept') or
                            contains(name(), 'task') or
                            contains(name(), 'reference') or
                            contains(name(), 'glossary') or
                            contains(@class, ' topic/topic ')
                            ][1]/@class"
                            />
                        </xsl:message>
                    </xsl:if>
                    <xsl:value-of select="concat('#',$topic-id,'/',$topic-id,'_Connect_42_',$element-id)"/>
                </xsl:otherwise>
            </xsl:choose>


        </xsl:attribute>
    </xsl:template>

    <xsl:template match="*[contains(@class,' map/topicref ')]/@href">
        <xsl:message>DebugX13</xsl:message>
        <xsl:copy-of select="."/>
        <xsl:attribute name="id">
            <xsl:variable name="fragmentId" select="substring-after(.,'#')"/>
            <xsl:variable name="idcount"
                select="count(../preceding::*[@href = current()][not(ancestor::*[contains(@class, ' map/reltable ')])]) + count(../ancestor::*[@href = current()])"/>
            <xsl:choose>
                <xsl:when test="$idcount &gt; 0">
                    <xsl:value-of select="concat($fragmentId,'_ssol',$idcount)"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$fragmentId"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:template>


    <xsl:template match="*" mode="build-tree" priority="-1">
        <xsl:apply-templates mode="build-tree"/>
    </xsl:template>

    <xsl:template match="text()" mode="build-tree" priority="-1"/>

    <xsl:template match="*" priority="-1">
        <xsl:param name="newid"/>
        <xsl:if test="contains($unittest, 'copyel')">
            <xsl:message>
                <xsl:text>CopyElement:</xsl:text>
                <xsl:value-of select="name()"/>
                <xsl:text> new-id=</xsl:text>
                <xsl:value-of select="$newid"/>
            </xsl:message>
        </xsl:if>
        <xsl:copy>
            <xsl:message>NewDebug04</xsl:message>
            <xsl:apply-templates select="@*">
                <xsl:with-param name="newid" select="$newid"/>
            </xsl:apply-templates>
            <xsl:message>
                <xsl:text>NewDebug05:</xsl:text>
                <xsl:value-of select="$newid"/>
            </xsl:message>
            <xsl:apply-templates select="*|text()|processing-instruction()">
                <xsl:with-param name="newid" select="$newid"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*" priority="-1">
        <xsl:if test="contains($unittest, 'copyel')">
        <xsl:message>
                <xsl:text>CopyAttribute:</xsl:text>
                <xsl:value-of select="name()"/>
                <xsl:text>=</xsl:text>
                <xsl:value-of select="."/>
        </xsl:message>
        </xsl:if>
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="processing-instruction()" priority="-1">
        <xsl:message>DebugX15</xsl:message>
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:key name="duplicate-id" match="*[not(contains(@class, ' topic/topic '))]/@id"
        use="concat(ancestor::*[contains(@class, ' topic/topic ')][1]/@id, '|', .)"/>

    <!--HSX
     If found out that stage2.fo processes 'glossary.xls' and there a template will receive this value
     Unfortunately we are getting the wrong prefix newid already here. Therefore we need to find the caller

     [xslt] Processing stage1a.xml to stage2.fo
     [xslt] Loading stylesheet F:\Dita-OT2\plugins\org.dita.pdf2\xsl\fo\topic2fo_shell_axf.xsl
     
     The following template is only available in the debug version to check the newid
    -->
    <xsl:template match="@id[parent::*[contains(@class, ' glossentry/glossterm ')]]" priority="5">
        <xsl:param name="newid"/>
        <xsl:message>DebugX16</xsl:message>
        <xsl:message>
            <xsl:text>&#xA;Catchnewid=</xsl:text>
            <xsl:value-of select="$newid"/>
        </xsl:message>
        <xsl:attribute name="id">
            <xsl:value-of select="$newid"/>
            <xsl:text>_Connect_42_</xsl:text>
            <xsl:value-of select="."/>
            <xsl:variable name="current-id"
                select="concat(ancestor::*[contains(@class, ' topic/topic ')][1]/@id, '|', .)"/>
            <xsl:if test="not(generate-id(.) = generate-id(key('duplicate-id', $current-id)[1]))">
                <xsl:text>_</xsl:text>
                <xsl:value-of select="generate-id()"/>
            </xsl:if>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="@id[not(parent::*[contains(@class, ' topic/topic ')])]" priority="1">
        <xsl:param name="newid"/>
        <xsl:message>DebugX17</xsl:message>
        <xsl:attribute name="id">
            <xsl:value-of select="$newid"/>
            <xsl:text>_Connect_42_</xsl:text>
            <xsl:value-of select="."/>
            <xsl:variable name="current-id"
                select="concat(ancestor::*[contains(@class, ' topic/topic ')][1]/@id, '|', .)"/>
            <xsl:if test="not(generate-id(.) = generate-id(key('duplicate-id', $current-id)[1]))">
                <xsl:text>_</xsl:text>
                <xsl:value-of select="generate-id()"/>
            </xsl:if>
        </xsl:attribute>
        <xsl:message>CalledDebug04</xsl:message>
    </xsl:template>

    <xsl:template name="isNotTopicRef" as="xs:boolean">
        <xsl:param name="class" select="@class"/>
        <xsl:message>DebugX21</xsl:message>
        <xsl:sequence
            select="contains($class,' bookmap/abbrevlist ')
                       or contains($class,' bookmap/amendments ')
                       or contains($class,' bookmap/bookabstract ')
                       or contains($class,' bookmap/booklist ')
                       or contains($class,' bookmap/colophon ')
                       or contains($class,' bookmap/dedication ')
                       or contains($class,' bookmap/tablelist ')
                       or contains($class,' bookmap/trademarklist ')
                       or contains($class,' bookmap/figurelist ')"
        />
    </xsl:template>

    <xsl:template match="*[contains(@class, ' map/reltable ')]" mode="build-tree"/>

</xsl:stylesheet>
