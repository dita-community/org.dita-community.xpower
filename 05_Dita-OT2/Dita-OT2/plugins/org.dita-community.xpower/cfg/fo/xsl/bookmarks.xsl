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

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:opentopic="http://www.idiominc.com/opentopic"
                xmlns:opentopic-index="http://www.idiominc.com/opentopic/index"
                xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
                xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
                exclude-result-prefixes="xs opentopic-index opentopic opentopic-func ot-placeholder"
                version="2.0">

    <!-- Determines whether letter headings in an index generate bookmarks.
         0 = no bookmarks.
         Any other number = if total # of terms exceeds $bookmarks.index-group-size, generate headers.
         To always generate headers, set to 1. -->
    <xsl:param name="bookmarks.index-group-size" as="xs:integer">100</xsl:param>

    <xsl:variable name="map" select="//opentopic:map"/>

    <!--HSC This creates the bookmarks for all subchapters -->
    <!--HSX2:emptyTitle do not act on empty titles -->
    <xsl:template name="BkTxtContent" as="xs:integer">
        <xsl:variable name="BkTextContent">
            <xsl:apply-templates select="title/text()"/>
        </xsl:variable>
        <xsl:value-of select="string-length(normalize-space($BkTextContent))"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/topic ')]" mode="bookmark">
        <xsl:variable name="mapTopicref" select="key('map-id', @id)[1]"/>
        
        
        <!--HSX Here we construct the bookmark title from the matches -->
        <xsl:variable name="topicTitle">
            <!--HSC this call actually generates the title PREFIX e.g. 'Part I' -->
            <xsl:apply-templates select="$mapTopicref" mode="tocPrefix">
                <xsl:with-param name="isFromBkx" select="true()" />
            </xsl:apply-templates>

            <!--HSC this call actually generates the title TEXT -->
            <xsl:variable name="navString" as="node()*">
                <xsl:call-template name="getNavTitle">
                    <xsl:with-param name="useNavTitle" select="$useNavTitle-bookmarks"/>
                </xsl:call-template>                    
            </xsl:variable>
            <!-- Bookmarks shall be converted to string but ONLY for the title
                 otherwise we loose the marker from the call above (tocPrefix)
            --> 
            <xsl:value-of select="$navString"/>

            <!-- generates Sample Appendix -->
        </xsl:variable>

        <!--HSX2 do not create bookmark if there is no text in the title -->
        <xsl:variable name="txtLen" as="xs:integer">
            <xsl:call-template name="BkTxtContent"/>
        </xsl:variable>

        <!-- check whether we are printing a glossary subchapter -->
        <xsl:variable name="chkGlossary" select="ancestor-or-self::*[contains(name(), 'glossarylist')]"/>

        <xsl:choose>
            <!--HSX2 do not list glossentry in bookmarks, the "when case" avoids it.
                However, the when case must be in first position because the next
                one will match too.
            -->
            <xsl:when test="$chkGlossary and not($bkxChGlossary)"/>

            <!--HSX2 do not create bookmark if there is no text in the title -->
            <xsl:when test="$txtLen = 0"/>

            <xsl:when test="$mapTopicref[@toc = 'yes' or not(@toc)] or
                not($mapTopicref)">
                <!-- For the appendix we do a special check whether we are in appendix.
                     If we are in apppendix, wrap the appendices in an APPENDIX bookmark
                -->
                <!--HSX In order to avoid a Level 0 "APPENDIX" entry in the bookmarks
                        which spoiled numbering and is an obsolete feature (in my view)
                        the evaluation of this case was disabled. The original kept
                        ' bookmap/appendix ' instead of ' bookmap/appendix_DISABLEDbyHAC '
                -->
                <xsl:choose>
                    <xsl:when test="contains($mapTopicref/@class, ' bookmap/appendix_DISABLEDbyHSC ') and 
                        ($mapTopicref/position() = 1)">
                        <fo:bookmark>
                            <xsl:attribute name="internal-destination">
                                <xsl:call-template name="generate-toc-id"/>
                            </xsl:attribute>
                            <xsl:if test="$bookmarkStyle!='EXPANDED'">
                                <xsl:attribute name="starting-state">hide</xsl:attribute>
                            </xsl:if>
                            <fo:bookmark-title>
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="'BookmarkAppendices'"/>
                                </xsl:call-template>
                                <xsl:text>:</xsl:text>
                                <xsl:value-of select="$mapTopicref/position()"/>
                            </fo:bookmark-title>
                            <xsl:call-template name="createBookmarkEntryAndChildren">
                                <xsl:with-param name="topicTitle" select="$topicTitle"/>
                            </xsl:call-template>
                            <xsl:for-each select="$mapTopicref/following-sibling::*[contains(@class, ' bookmap/appendix ')]">
                                <xsl:call-template name="createBookmarkEntryAndChildren">
                                    <xsl:with-param name="topicTitle" select="$topicTitle"/>
                                </xsl:call-template>                            
                            </xsl:for-each>                                                       
                        </fo:bookmark>
                    </xsl:when>
                    
                    <!--HSX having disabled the above appendix case we always end up here
                        The following prints the ENTIRE bookmark title, which is already
                        available in $topicTitle
                    -->
                    <xsl:otherwise>
                        <xsl:call-template name="createBookmarkEntryAndChildren">
                            <xsl:with-param name="topicTitle" select="$topicTitle"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates mode="bookmark"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!--HSX =========== CREATE BOOKMARKS NUMBER+TITLE ================= -->
    <xsl:template name="createBookmarkEntryAndChildren">
        <xsl:param name="topicTitle"/>
        <fo:bookmark>
            <xsl:attribute name="internal-destination">
                <xsl:call-template name="generate-toc-id"/>
            </xsl:attribute>
            <xsl:if test="$bookmarkStyle!='EXPANDED'">
                <xsl:attribute name="starting-state">hide</xsl:attribute>
            </xsl:if>
            <!--HSC [DtPrt#19.2] controls bookmark numbering
            I did, however, already do the numbering in the actual
            chapters, also preventing Prefix/notices/abstract to
            get numbered. So for me everything is alright and I did
            not follow the changes suggested in [DtPrt#19.2]
            -->

            <!--HSX $topicTitle already contains the ENTIRE bookmark text -->
            <fo:bookmark-title>
                <xsl:copy-of select="$topicTitle"/>
            </fo:bookmark-title>
            <xsl:apply-templates mode="bookmark"/>
        </fo:bookmark>
    </xsl:template>

    <xsl:template match="*" mode="bookmark">
        <xsl:apply-templates mode="bookmark"/>
    </xsl:template>

    <xsl:template match="text()" mode="bookmark"/>

    <!--HSC [DtPrt#19.3] suggests to comment out this block to avoid the Index
    in the bookmarks. Of course I didn't apply that, but it is free to be used
    -->
    <xsl:template name="createBookmarks">
        <xsl:variable name="bookmarks" as="element()*">
            <xsl:choose>
                <xsl:when test="$retain-bookmap-order">
                    <xsl:apply-templates select="/" mode="bookmark"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:for-each select="/*/*[contains(@class, ' topic/topic ')]">
                        <xsl:variable name="topicType">
                            <xsl:call-template name="determineTopicType"/>
                        </xsl:variable>
                        <!--HSX2 If retain-bookmap-order determines the existance of the notices section (commons.xsl) then
                        this should also be valid for the table of contents and the bookmarks. Here we handle the
                        table of contents
                        <xsl:if test="$topicType = 'topicNotices'">
                        -->
                        <xsl:if test="$retain-bookmap-order and ($topicType = 'topicNotices')" >
                            <xsl:apply-templates select="." mode="bookmark"/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:choose>
                        <xsl:when test="$map//*[contains(@class,' bookmap/toc ')][@href]"/>
                        <!--HSC In case, the TOC shouldn't be part of the bookmarks in the PDF
                        [DtPrt#16.16.7] eliminates the last or statement.
                        I don't use that, I like TOC in the bookmarks -->
                        <xsl:when test="$map//*[contains(@class,' bookmap/toc ')]
                            | /*[contains(@class,' map/map ')][not(contains(@class,' bookmap/bookmap '))]">
                            <fo:bookmark internal-destination="{$id.toc}">
                                <fo:bookmark-title>
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Table of Contents'"/>
                                    </xsl:call-template>
                                </fo:bookmark-title>
                            </fo:bookmark>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:for-each select="/*/*[contains(@class, ' topic/topic ')] |
                        /*/ot-placeholder:glossarylist |
                        /*/ot-placeholder:tablelist |
                        /*/ot-placeholder:figurelist">
                        <xsl:variable name="topicType">
                            <xsl:call-template name="determineTopicType"/>
                        </xsl:variable>
                        <xsl:if test="not($topicType = 'topicNotices')">
                            <xsl:apply-templates select="." mode="bookmark"/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:apply-templates select="/*" mode="bookmark-index"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:if test="exists($bookmarks)">
            <fo:bookmark-tree>
                <xsl:copy-of select="$bookmarks"/>
            </fo:bookmark-tree>
        </xsl:if>
    </xsl:template>

    <!--HSC [DtPrt#19.3] suggests to comment out this block to avoid the Table of contents
    in the bookmarks. Of course I didn't apply that, but it is free to be used
    -->
    <xsl:template match="ot-placeholder:toc[$retain-bookmap-order]" mode="bookmark">
        <fo:bookmark internal-destination="{$id.toc}">
            <xsl:if test="$bookmarkStyle!='EXPANDED'">
                <xsl:attribute name="starting-state">hide</xsl:attribute>
            </xsl:if>
            <fo:bookmark-title>
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Table of Contents'"/>
                </xsl:call-template>
            </fo:bookmark-title>
        </fo:bookmark>
    </xsl:template>

    <!--HSX This puts the INDEX into the bookmarks -->
    <xsl:template match="ot-placeholder:indexlist[$retain-bookmap-order]" mode="bookmark">
        <fo:bookmark internal-destination="{$id.index}">
            <xsl:if test="$bookmarkStyle!='EXPANDED'">
                <xsl:attribute name="starting-state">hide</xsl:attribute>
            </xsl:if>
            <fo:bookmark-title>
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Index'"/>
                </xsl:call-template>
            </fo:bookmark-title>
        </fo:bookmark>
    </xsl:template>

    <xsl:template match="ot-placeholder:glossarylist" mode="bookmark">
        <fo:bookmark internal-destination="{$id.glossary}">
            <xsl:if test="$bookmarkStyle!='EXPANDED'">
                <xsl:attribute name="starting-state">hide</xsl:attribute>
            </xsl:if>
            <fo:bookmark-title>
                <xsl:call-template name="getGlossaryTitle"/>
            </fo:bookmark-title>
            <!--HSX The following call puts all bookmarks under the 'Glossary' topic
                 If you comment it, the target PDF bookmarks will only have one Glossary entry
                 That would be enough because you do not want to have every glossary entry show
                 up in the bookmarks
            -->
            <xsl:apply-templates mode="bookmark"/>
        </fo:bookmark>
    </xsl:template>

    <xsl:template match="ot-placeholder:tablelist" mode="bookmark">
        <xsl:if test="//*[contains(@class, ' topic/table ')]/*[contains(@class, ' topic/title ' )]">
            <fo:bookmark internal-destination="{$id.lot}">
                <xsl:if test="$bookmarkStyle!='EXPANDED'">
                    <xsl:attribute name="starting-state">hide</xsl:attribute>
                </xsl:if>
                <fo:bookmark-title>
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'List of Tables'"/>
                    </xsl:call-template>
                </fo:bookmark-title>

                <xsl:apply-templates mode="bookmark"/>
            </fo:bookmark>
        </xsl:if>
    </xsl:template>

    <xsl:template match="ot-placeholder:figurelist" mode="bookmark">
        <xsl:if test="//*[contains(@class, ' topic/fig ')]/*[contains(@class, ' topic/title ' )]">
            <fo:bookmark internal-destination="{$id.lof}">
                <xsl:if test="$bookmarkStyle!='EXPANDED'">
                    <xsl:attribute name="starting-state">hide</xsl:attribute>
                </xsl:if>
                <fo:bookmark-title>
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'List of Figures'"/>
                    </xsl:call-template>
                </fo:bookmark-title>

                <xsl:apply-templates mode="bookmark"/>
            </fo:bookmark>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*" mode="bookmark-index">
      <xsl:if test="//opentopic-index:index.groups//opentopic-index:index.entry">
          <xsl:choose>
              <xsl:when test="$map//*[contains(@class,' bookmap/indexlist ')][@href]"/>
              <!--HSC The or part should be subject to deletion in case
              you do not want an INDEX bookmark in the final PDF.
              I like it, however, and therefore didn't apply the chage -->
              <xsl:when test="$map//*[contains(@class,' bookmap/indexlist ')]
                            | /*[contains(@class,' map/map ')][not(contains(@class,' bookmap/bookmap '))]">
                  <fo:bookmark internal-destination="{$id.index}" starting-state="hide">
                      <fo:bookmark-title>
                          <xsl:call-template name="getVariable">
                              <xsl:with-param name="id" select="'Index'"/>
                          </xsl:call-template>
                      </fo:bookmark-title>
                      <xsl:if test="$bookmarks.index-group-size !=0 and 
                                    count(//opentopic-index:index.groups//opentopic-index:index.entry) &gt; $bookmarks.index-group-size">
                        <xsl:apply-templates select="//opentopic-index:index.groups" mode="bookmark-index"/>
                      </xsl:if>
                  </fo:bookmark>
              </xsl:when>
          </xsl:choose>
      </xsl:if>
    </xsl:template>

    <xsl:template match="opentopic-index:index.groups" mode="bookmark-index">
      <xsl:apply-templates select="opentopic-index:index.group" mode="bookmark-index"/>
    </xsl:template>
    <xsl:template match="opentopic-index:index.group" mode="bookmark-index">
      <xsl:apply-templates select="opentopic-index:label" mode="bookmark-index"/>
    </xsl:template>
    <xsl:template match="opentopic-index:label" mode="bookmark-index">
      <!-- Letter headings in index are always collapsed, regardless of bookmarkStyle. -->
      <fo:bookmark internal-destination="{generate-id(.)}" starting-state="hide">
          <fo:bookmark-title>
            <xsl:value-of select="."/>
          </fo:bookmark-title>
      </fo:bookmark>
    </xsl:template>

</xsl:stylesheet>
