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

<xsl:stylesheet version="2.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                exclude-result-prefixes="xs dita-ot">

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
            <xsl:message>HSXT:X01</xsl:message>
            <xsl:apply-templates select="key('topic',@first_topic_id)">
                <xsl:with-param name="parentId" select="generate-id()"/>
            </xsl:apply-templates>
            <xsl:if test="@first_topic_id != @href">
            <xsl:message>HSXT:X02</xsl:message>
                <xsl:apply-templates select="key('topic',@href)">
                    <xsl:with-param name="parentId" select="generate-id()"/>
                </xsl:apply-templates>
            </xsl:if>
        </xsl:when>
      <!--HSX if a href exists ... -->
      <xsl:when test="not(normalize-space(@href) = '')">
            <xsl:message>HSXT:X03</xsl:message>
        <xsl:apply-templates select="key('topic',@href)">
          <xsl:with-param name="parentId" select="generate-id()"/>
        </xsl:apply-templates>
      </xsl:when>
      <!--HSX if we have a bookmap/part or navtitle ... -->
      <xsl:when test="contains(@class, ' bookmap/part ') or
                      (normalize-space(@navtitle) != '' or 
                      *[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')])">
            <xsl:message>HSXT:X04</xsl:message>
          <xsl:variable name="isNotTopicRef" as="xs:boolean">
              <xsl:call-template name="isNotTopicRef"/>
          </xsl:variable>
          <xsl:if test="not($isNotTopicRef)">
            <xsl:message>HSXT:X05</xsl:message>
              <topic id="{generate-id()}" class="+ topic/topic pdf2-d/placeholder ">
                  <title class="- topic/title ">
                      <xsl:choose>
                          <xsl:when test="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]">
                              <xsl:copy-of select="*[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]/node()"/>
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
            <xsl:message>HSXT:X06</xsl:message>
          <xsl:apply-templates mode="build-tree"/>
      </xsl:otherwise>
    </xsl:choose>
    </xsl:template>

    <xsl:template match="*[@print = 'no']" priority="5" mode="build-tree"/>

    <xsl:template match="*[contains(@class,' bookmap/backmatter ')] |
                         *[contains(@class,' bookmap/booklists ')] |
                         *[contains(@class,' bookmap/frontmatter ')]" priority="2" mode="build-tree">
            <xsl:message>HSXT:X07</xsl:message>
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
            <xsl:message>HSXT:X08</xsl:message>
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

    <xsl:template match="*[contains(@class,' topic/topic ')][not(contains(@class,' glossentry/glossentry '))] | dita-merge/dita">
        <xsl:param name="parentId"/>
        <xsl:param name="newid"/>
      <xsl:message>
        <xsl:text>HSXT:X18:MatchingId:</xsl:text>
        <xsl:value-of select="@id"/>
        <xsl:text>-</xsl:text>
        <xsl:value-of select="$newid"/>
        <xsl:text>::</xsl:text>
        <xsl:value-of select="@class"/>
     </xsl:message>
      <xsl:variable name="idcount">
        <!--for-each is used to change context.  There's only one entry with a key of $parentId-->
        <xsl:for-each select="key('topicref',$parentId)">
          <xsl:message>
            <xsl:text>HSXT:ParentId=</xsl:text>
            <xsl:value-of select="$parentId"/>
          </xsl:message>
          <xsl:value-of select="count(preceding::*[@href = current()/@href][not(ancestor::*[contains(@class, ' map/reltable ')])]) + count(ancestor::*[@href = current()/@href])"/>
        </xsl:for-each>
      </xsl:variable>
        <xsl:copy>
            <!--HSX First process all attributes that are not 'id' -->
            <xsl:message>HSXT:X19:Process attrs neq id</xsl:message>
            <xsl:apply-templates select="@*[name() != 'id']"/>
            
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
            <xsl:attribute name="id">
              <xsl:value-of select="$new_id"/>
            </xsl:attribute>
            <xsl:message>
                <xsl:text>NewHSXT:01:new_id=</xsl:text>
                <xsl:value-of select="$new_id"/>                
                <xsl:text>[</xsl:text>
                <xsl:value-of select="@class"/>                
                <xsl:text>](</xsl:text>
                <xsl:value-of select="$idcount"/>                
                <xsl:text>) id=</xsl:text>
                <xsl:value-of select="@id"/>                
                <xsl:text>&#xA;</xsl:text>
            </xsl:message>
            <xsl:apply-templates>
                <xsl:with-param name="newid" select="$new_id"/>
            </xsl:apply-templates>
            <xsl:apply-templates select="key('topicref',$parentId)/*" mode="build-tree"/>
        </xsl:copy>
    </xsl:template>

  <!-- Linkless topicref or topichead -->
  <xsl:template match="*[contains(@class,' map/topicref ')][not(@href)]" priority="5">
    <xsl:param name="newid"/>
    <xsl:message>CalledHSXT:01</xsl:message>
    <xsl:copy>
      <xsl:attribute name="id">
        <xsl:value-of select="generate-id()"/>
      </xsl:attribute>
      <xsl:message>NewHSXT:02</xsl:message>
      <xsl:apply-templates select="@*">
        <xsl:with-param name="newid" select="$newid"/>
      </xsl:apply-templates>
      <xsl:message>NewHSXT:03</xsl:message>
      <xsl:apply-templates select="*|text()|processing-instruction()">
        <xsl:with-param name="newid" select="$newid"/>
      </xsl:apply-templates>
    </xsl:copy>
  </xsl:template>

    <xsl:template match="*[contains(@class,' map/topicref ')]/@id" priority="5"/>

    <xsl:template match="@href">
        <xsl:param name="newid"/>
        <xsl:message>HSXT:X09</xsl:message>
        <xsl:message>CalledHSXT:02</xsl:message>

        <xsl:variable name="topic-id" select="dita-ot:get-topic-id(.)" as="xs:string?"/>
        <xsl:variable name="element-id" select="dita-ot:get-element-id(.)" as="xs:string?"/>

        <xsl:attribute name="href">
        <xsl:choose>
            <xsl:when test="empty($element-id) or not(starts-with(., '#unique'))">
            <xsl:message>HSXT:X10</xsl:message>
                <xsl:value-of select="."/>
            </xsl:when>
            <xsl:when test="ancestor::*[contains(@class, ' topic/topic ')][1]/@id = $topic-id">
            <xsl:message>HSXT:X11</xsl:message>
                <xsl:text>#</xsl:text>
                <xsl:value-of select="$newid"/>
                <xsl:text>/</xsl:text>
                <xsl:value-of select="$newid"/>
                <xsl:text>_Connect_42_</xsl:text>
                <xsl:value-of select="$element-id"/>
            </xsl:when>
            <xsl:otherwise>
            <xsl:message>HSXT:X12</xsl:message>
                <xsl:value-of select="concat('#',$topic-id,'/',$topic-id,'_Connect_42_',$element-id)"/>
            </xsl:otherwise>
        </xsl:choose>


        </xsl:attribute>
    </xsl:template>

  <xsl:template match="*[contains(@class,' map/topicref ')]/@href">
            <xsl:message>HSXT:X13</xsl:message>
        <xsl:copy-of select="."/>
        <xsl:attribute name="id">
            <xsl:variable name="fragmentId" select="substring-after(.,'#')"/>
            <xsl:variable name="idcount" select="count(../preceding::*[@href = current()][not(ancestor::*[contains(@class, ' map/reltable ')])]) + count(../ancestor::*[@href = current()])"/>
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
    <xsl:message>
        <xsl:message>HSXT:X13</xsl:message>
        <xsl:text>&#xA;CalledHSXT:03:</xsl:text>
        <xsl:value-of select="name()"/>
        <xsl:text>(</xsl:text>
        <xsl:value-of select="$newid"/>
        <xsl:text>)</xsl:text>
    </xsl:message>
        <xsl:copy>
            <xsl:message>NewHSXT:04</xsl:message>
            <xsl:apply-templates select="@*">
                <xsl:with-param name="newid" select="$newid"/>
            </xsl:apply-templates>
            <xsl:message>
                <xsl:text>NewHSXT:05:</xsl:text>
                <xsl:value-of select="$newid"/>
            </xsl:message>
            <xsl:apply-templates select="*|text()|processing-instruction()">
                <xsl:with-param name="newid" select="$newid"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="@*" priority="-1">
            <xsl:message>
                <xsl:text>HSXT:X14:name(</xsl:text>
                <xsl:value-of select="name()"/>
                <xsl:text>)[</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>]</xsl:text>
            </xsl:message>
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:template match="processing-instruction()" priority="-1">
            <xsl:message>HSXT:X15</xsl:message>
        <xsl:copy-of select="."/>
    </xsl:template>

    <xsl:key name="duplicate-id"
             match="*[not(contains(@class, ' topic/topic '))]/@id"
             use="concat(ancestor::*[contains(@class, ' topic/topic ')][1]/@id, '|', .)"/>

<!--
     If found out that stage2.fo processes 'gossary.xls' and there a template will receive this value
     Unfortunately we are getting the wrong prefix newid already here. Therefore we need to find the caller
 
     [xslt] Processing stage1a.xml to stage2.fo
     [xslt] Loading stylesheet F:\Dita-OT2\plugins\org.dita.pdf2\xsl\fo\topic2fo_shell_axf.xsl
-->
    <xsl:template match="@id[parent::*[contains(@class, ' glossentry/glossterm ')]]" priority = "5">
        <xsl:param name="newid"/>
            <xsl:message>HSXT:X16</xsl:message>
        <xsl:message>
            <xsl:text>&#xA;Catchnewid=</xsl:text>
            <xsl:value-of select="$newid"/>
        </xsl:message>
        <xsl:attribute name="id">
            <xsl:value-of select="$newid"/>
            <xsl:text>_Connect_42_</xsl:text>
            <xsl:value-of select="."/>
            <xsl:variable name="current-id" select="concat(ancestor::*[contains(@class, ' topic/topic ')][1]/@id, '|', .)"/>
            <xsl:if test="not(generate-id(.) = generate-id(key('duplicate-id', $current-id)[1]))">
                <xsl:text>_</xsl:text>
                <xsl:value-of select="generate-id()"/>
            </xsl:if>
        </xsl:attribute>
    </xsl:template>

    <xsl:template match="@id[not(parent::*[contains(@class, ' topic/topic ')])]" priority = "1">
        <xsl:param name="newid"/>
            <xsl:message>HSXT:X17</xsl:message>
        <xsl:attribute name="id">
            <xsl:value-of select="$newid"/>
            <xsl:text>_Connect_42_</xsl:text>
            <xsl:value-of select="."/>
            <xsl:variable name="current-id" select="concat(ancestor::*[contains(@class, ' topic/topic ')][1]/@id, '|', .)"/>
            <xsl:if test="not(generate-id(.) = generate-id(key('duplicate-id', $current-id)[1]))">
                <xsl:text>_</xsl:text>
                <xsl:value-of select="generate-id()"/>
            </xsl:if>
        </xsl:attribute>
    <xsl:message>CalledHSXT:04</xsl:message>
    </xsl:template>

  <xsl:template name="isNotTopicRef" as="xs:boolean">
    <xsl:param name="class" select="@class"/>
            <xsl:message>HSXT:X21</xsl:message>
    <xsl:sequence select="contains($class,' bookmap/abbrevlist ')
                       or contains($class,' bookmap/amendments ')
                       or contains($class,' bookmap/bookabstract ')
                       or contains($class,' bookmap/booklist ')
                       or contains($class,' bookmap/colophon ')
                       or contains($class,' bookmap/dedication ')
                       or contains($class,' bookmap/tablelist ')
                       or contains($class,' bookmap/trademarklist ')
                       or contains($class,' bookmap/figurelist ')"/>
  </xsl:template>

    <xsl:template match="*[contains(@class, ' map/reltable ')]" mode="build-tree"/>

</xsl:stylesheet>
