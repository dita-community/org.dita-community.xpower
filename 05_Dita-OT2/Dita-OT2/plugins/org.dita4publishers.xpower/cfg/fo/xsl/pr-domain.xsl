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


https://www.oxygenxml.com/doc/versions/17.1/ug-editorEclipse/index.html#topics/simple-dita-ot-plugin.html


-->

    <!--HSX For highlighting YOU SHALL ADD xslthl-2.1.3.jar TO YOUR CLASSPATH,
    otherwise the functions will not be found.
    20160404: Today there's a signer mismatch for a function by doing this
    -->


<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" version="2.0" exclude-result-prefixes="xs">

    <xsl:template match="*[contains(@class, ' pr-d/codeph ')]">
        <fo:inline xsl:use-attribute-sets="codeph">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:variable name="codeblock.wrap" select="false()"/>

    <xsl:template match="node()" mode="codeblock.generate-line-number" as="xs:boolean">
        <xsl:choose>
            <xsl:when test="0">
                <xsl:sequence select="true()"/>
            </xsl:when>
            <xsl:when test="contains(@outputclass, 'line-number')">
                <xsl:sequence select="true()"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:sequence select="false()"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="processing-instruction()" mode="getType">
        <xsl:value-of select="3"/>
    </xsl:template>
    <xsl:template match="text()" mode="getType">
        <xsl:value-of select="2"/>
    </xsl:template>
    <xsl:template match="*" mode="getType">
        <xsl:value-of select="1"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/codeblock ')]">
        <xsl:call-template name="generateAttrLabel"/>

        <xsl:variable name="lineOffset" as="xs:integer">
            <xsl:message>
                <xsl:text>Outputclass = </xsl:text>
                <xsl:value-of select="@outputclass"/>
                <xsl:text>    : </xsl:text>
                <xsl:value-of select="name()"/>
            </xsl:message>
            <xsl:choose>
                <xsl:when test="contains(@outputclass, 'line-number:')">
                    <xsl:variable name="rawnum">
                        <xsl:analyze-string select="@outputclass" regex="{'line-number:([0-9]+)\s*'}">
                            <xsl:matching-substring>
                                <xsl:value-of select="regex-group(1)"/>
                            </xsl:matching-substring>
                        </xsl:analyze-string>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="string-length($rawnum)">
                            <xsl:value-of select="$rawnum - 1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="0"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <fo:block xsl:use-attribute-sets="codeblock">
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="setFrame"/>
            <xsl:call-template name="setScale"/>
            <xsl:variable name="codeblock.line-number" as="xs:boolean">
                <xsl:apply-templates select="." mode="codeblock.generate-line-number"/>
            </xsl:variable>

            <xsl:variable name="content1" as="node()*">
                <xsl:apply-templates/>
            </xsl:variable>

            <xsl:variable name="subTypes" as="node()">
                <xsl:element name="dummy">
                    <xsl:for-each select="$content1">
                        <xsl:variable name="myPos" select="position()"/>
                        <xsl:element name="section">
                            <xsl:element name="cType">
                                <xsl:apply-templates select="." mode="getType"/>
                            </xsl:element>
                            <xsl:element name="cContent">
                                <xsl:copy-of select="."/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:element>
            </xsl:variable>

            <xsl:variable name="content">
                <xsl:for-each select="$subTypes/section">
                    <xsl:variable name="myPos" select="position()"/>
                    <xsl:choose>
                        <!--HSX text field -->
                        <xsl:when test="cType = 2">
                            <xsl:value-of select="cContent"/>
                        </xsl:when>
                        <!--HSX any element, keep the element and 
                                replace its content by trivial text that
                                no formatter would ever catch, however
                                the field # is coded, to allow later retrieval
                        -->
                        <xsl:when test="cType = 1">
                            <xsl:value-of select="concat('HSCX',$myPos,'XCSH')"/>
                        </xsl:when>
                        <!--HSX anything else - should never occur -->
                        <xsl:otherwise>
                            <xsl:value-of select="0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:for-each>
            </xsl:variable>

            <xsl:variable name="rawText">
                <xsl:choose>
                    <xsl:when test="$codeblock.wrap or $codeblock.line-number">
                        <xsl:choose>
                            <!--HSC here the lines numbers are added as processing instruction -->
                            <xsl:when test="$codeblock.line-number">
                                <xsl:variable name="buf" as="document-node()">
                                    <xsl:document>
                                        <xsl:processing-instruction name="line-number"/>
                                        <xsl:apply-templates select="$content" mode="codeblock.line-number"/>
                                    </xsl:document>
                                </xsl:variable>
                                <xsl:variable name="line-count"
                                select="count($buf/descendant::processing-instruction('line-number')) + $lineOffset"/>

                                <xsl:apply-templates select="$buf" mode="codeblock">
                                    <xsl:with-param name="line-count" select="$line-count" tunnel="yes"/>
                                    <xsl:with-param name="line-offset" select="$lineOffset"/>
                                    <xsl:with-param name="myNode" select="."/>
                                </xsl:apply-templates>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="$content" mode="codeblock">
                                    <xsl:with-param name="myNode" select="."/>
                                </xsl:apply-templates>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:apply-templates select="." mode="outputstyling">
                            <xsl:with-param name="myText" select="$content"/>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <xsl:choose>
                <!--HSX different tests ... the official variant is
                        the first cases (right here)
                -->
                <xsl:when test="1">
                    <xsl:apply-templates select="$rawText" mode="rebuild">
                        <xsl:with-param name="subTypes" select="$subTypes"/>
                    </xsl:apply-templates>
                </xsl:when>
                <!--HSX test the captured raw content -->
                <xsl:when test="0">
                    <xsl:copy-of select="$content1" copy-namespaces="no"/>
                </xsl:when>
                <!--HSX apply directory which is the same as $content1 -->
                <xsl:when test="0">
                    <xsl:apply-templates/>
                </xsl:when>
                <!--HSX show the pre-conditioned text which goes to syntax checker  -->
                <xsl:otherwise>
                    <xsl:copy-of select="$rawText" copy-namespaces="no"/>
                </xsl:otherwise>
            </xsl:choose>
        </fo:block>
    </xsl:template>

    <xsl:template match="text()" mode="rebuild">
        <xsl:param name="subTypes"/>
        <xsl:analyze-string select="." regex="{'HSCX([0-9]+)XCSH'}">
            <xsl:matching-substring>
                <xsl:copy-of select="($subTypes/section[number(regex-group(1))])/cContent/*"/>
            </xsl:matching-substring>
            <xsl:non-matching-substring>
                <xsl:value-of select="."/>
            </xsl:non-matching-substring>
        </xsl:analyze-string>
    </xsl:template>

    <xsl:template match="*" mode="rebuild">
        <xsl:param name="subTypes"/>
        <xsl:element name="{name()}">
            <xsl:call-template name="putAttrs"/>
            <xsl:apply-templates mode="rebuild">
                <xsl:with-param name="subTypes" select="$subTypes"/>
            </xsl:apply-templates>
        </xsl:element>
    </xsl:template>

    <xsl:template match="node() | @*" mode="codeblock.line-number">
        <xsl:copy>
            <xsl:apply-templates select="node() | @*" mode="codeblock.line-number"/>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="text()" mode="codeblock.line-number" name="codeblock.line-number" priority="10">
        <xsl:param name="text" select="." as="xs:string"/>
        <xsl:variable name="head" select="substring($text, 1, 1)"/>
        <xsl:variable name="tail" select="substring($text, 2)"/>
        <xsl:value-of select="$head"/>
        <xsl:if test="$head = '&#xA;'">
            <xsl:processing-instruction name="line-number"/>
        </xsl:if>

        <!--HSC rekursive call to this template until we detect a line-feed -->
        <xsl:if test="$tail">
            <xsl:call-template name="codeblock.line-number">
                <xsl:with-param name="text" select="$tail"/>
            </xsl:call-template>
        </xsl:if>
    </xsl:template>

    <xsl:template match="@* | node()" mode="codeblock">
        <xsl:param name="myNode"/>
        <xsl:copy>
            <xsl:apply-templates select="@* | node()" mode="codeblock">
                <xsl:with-param name="myNode" select="$myNode"/>
            </xsl:apply-templates>
        </xsl:copy>
    </xsl:template>

    <xsl:template match="processing-instruction('line-number')" mode="codeblock" priority="10">
        <xsl:param name="line-count" as="xs:integer" tunnel="yes"/>
        <xsl:param name="line-offset" select="0" as="xs:integer"/>
        <xsl:variable name="line-number" select="count(preceding::processing-instruction('line-number')) + 1 + $line-offset"
        as="xs:integer"/>
        <fo:inline xsl:use-attribute-sets="codeblock.line-number">
            <xsl:for-each select="string-length(string($line-number)) to string-length(string($line-count)) - 1">
                <xsl:text>&#xA0;</xsl:text>
            </xsl:for-each>
            <xsl:value-of select="$line-number"/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="text()" mode="codeblock" name="codeblock.text" priority="10">
        <xsl:param name="myNode"/>
        <xsl:param name="text" select="."/>
        <xsl:choose>
            <xsl:when test="contains($text, '&#xA;')">
                <xsl:variable name="head">
                    <xsl:value-of select="substring-before($text, '&#xA;')"/>
                </xsl:variable>
                <xsl:variable name="tail">
                    <xsl:copy-of select="substring-after($text, '&#xA;')"/>
                </xsl:variable>

                <xsl:if test="string-length($head)">
                    <xsl:apply-templates select="$myNode" mode="outputstyling">
                        <xsl:with-param name="myText" select="$head"/>
                    </xsl:apply-templates>
                </xsl:if>
                <xsl:text>&#xA;&#xD;</xsl:text>
                <xsl:if test="string-length($tail)">
                    <xsl:call-template name="codeblock.text">
                        <xsl:with-param name="text" select="$tail"/>
                        <xsl:with-param name="myNode" select="$myNode"/>
                    </xsl:call-template>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="$myNode" mode="outputstyling">
                    <xsl:with-param name="myText" select="$text"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>

        <!--
        <xsl:variable name="head" select="substring($text, 1, 1)"/>
        <xsl:variable name="tail" select="substring($text, 2)"/>
        <xsl:choose>
            <xsl:when test="
                $codeblock.wrap and $head = (' ',
                '&#xA0;')">
                <xsl:text>&#xA0;&#xAD;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$head"/>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:if test="$tail">
            <xsl:call-template name="codeblock.text">
                <xsl:with-param name="text" select="$tail"/>
            </xsl:call-template>
        </xsl:if>
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/option ')]">
        <fo:inline xsl:use-attribute-sets="option">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/var ')]">
        <fo:inline xsl:use-attribute-sets="var">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/parmname ')]">
        <fo:inline xsl:use-attribute-sets="parmname">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/synph ')]">
        <fo:inline xsl:use-attribute-sets="synph">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/oper ')]">
        <fo:inline xsl:use-attribute-sets="oper">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/delim ')]">
        <fo:inline xsl:use-attribute-sets="delim">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/sep ')]">
        <fo:inline xsl:use-attribute-sets="sep">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/apiname ')]">
        <fo:inline xsl:use-attribute-sets="apiname">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/parml ')]">
        <xsl:call-template name="generateAttrLabel"/>
        <fo:block xsl:use-attribute-sets="parml">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/plentry ')]">
        <fo:block xsl:use-attribute-sets="plentry">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/pt ')]">
        <fo:block xsl:use-attribute-sets="pt">
            <xsl:call-template name="commonattributes"/>
            <xsl:choose>
                <xsl:when test="*">
                    <!-- tagged content - do not default to bold -->
                    <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                    <fo:inline xsl:use-attribute-sets="pt__content">
                        <xsl:apply-templates/>
                    </fo:inline>
                    <!-- text only - bold it -->
                </xsl:otherwise>
            </xsl:choose>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/pd ')]">
        <fo:block xsl:use-attribute-sets="pd">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/synblk ')]">
        <fo:inline xsl:use-attribute-sets="synblk">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/synnoteref ')]">
        <fo:inline xsl:use-attribute-sets="synnoteref">
            <xsl:call-template name="commonattributes"/> [<xsl:value-of select="@refid"/>] <!--TODO: synnoteref-->
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/synnote ')]">
        <fo:inline xsl:use-attribute-sets="synnote">
            <!--TODO: synnote-->
            <xsl:call-template name="commonattributes"/>
            <xsl:choose>
                <xsl:when test="not(@id = '')">
                    <!-- case of an explicit id -->
                    <xsl:value-of select="@id"/>
                </xsl:when>
                <xsl:when test="not(@callout = '')">
                    <!-- case of an explicit callout (presume id for now) -->
                    <xsl:value-of select="@callout"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>*</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/syntaxdiagram ')]">
        <fo:block xsl:use-attribute-sets="syntaxdiagram">
            <!--TODO: syntaxdiagram-->
            <xsl:call-template name="commonattributes"/>
            <!--HSX respect marginalia when setting list margin -->
            <xsl:call-template name="setListMargin"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/fragment ')]">
        <fo:block xsl:use-attribute-sets="fragment">
            <xsl:call-template name="commonattributes"/>
            <xsl:value-of select="*[contains(@class, ' topic/title ')]"/>
            <xsl:text> </xsl:text>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/syntaxdiagram ')]/*[contains(@class, ' topic/title ')]">
        <fo:block xsl:use-attribute-sets="syntaxdiagram.title">
            <xsl:call-template name="commonattributes"/>
            <xsl:value-of select="."/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/kwd ')]">
        <fo:inline xsl:use-attribute-sets="kwd">
            <xsl:call-template name="commonattributes"/>
            <xsl:if test="parent::*[contains(@class, ' pr-d/groupchoice ')]">
                <xsl:if test="count(preceding-sibling::*) != 0"> | </xsl:if>
            </xsl:if>
            <xsl:if test="@importance = 'optional'"> [</xsl:if>
            <xsl:choose>
                <xsl:when test="@importance = 'default'">
                    <fo:inline xsl:use-attribute-sets="kwd__default">
                        <xsl:value-of select="."/>
                    </fo:inline>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="."/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:if test="@importance = 'optional'">] </xsl:if>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/fragref ')]">
        <fo:inline xsl:use-attribute-sets="fragref">
            <!--TODO: fragref-->
        <xsl:call-template name="commonattributes"/> &lt;<xsl:value-of select="."/>&gt; </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/fragment ')]/*[contains(@class, ' topic/title ')]">
        <fo:block xsl:use-attribute-sets="fragment.title">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template
        match="*[contains(@class, ' pr-d/fragment ')]/*[contains(@class, ' pr-d/groupcomp ')] | *[contains(@class, ' pr-d/fragment ')]/*[contains(@class, ' pr-d/groupchoice ')] | *[contains(@class, ' pr-d/fragment ')]/*[contains(@class, ' pr-d/groupseq ')]">
        <fo:block xsl:use-attribute-sets="fragment.group">
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="makeGroup"/>
        </fo:block>
    </xsl:template>

    <xsl:template
        match="*[contains(@class, ' pr-d/syntaxdiagram ')]/*[contains(@class, ' pr-d/groupcomp ')] | *[contains(@class, ' pr-d/syntaxdiagram ')]/*[contains(@class, ' pr-d/groupseq ')] | *[contains(@class, ' pr-d/syntaxdiagram ')]/*[contains(@class, ' pr-d/groupchoice ')]">
        <fo:block xsl:use-attribute-sets="syntaxdiagram.group">
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="makeGroup"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/groupcomp ')]/*[contains(@class, ' pr-d/groupcomp ')]">
        <fo:inline>
            <xsl:call-template name="commonattributes"/>
        </fo:inline>
        <xsl:call-template name="makeGroup"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/groupchoice ')]/*[contains(@class, ' pr-d/groupchoice ')]">
        <fo:inline>
            <xsl:call-template name="commonattributes"/>
        </fo:inline>
        <xsl:call-template name="makeGroup"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/groupseq ')]/*[contains(@class, ' pr-d/groupseq ')]">
        <fo:inline>
            <xsl:call-template name="commonattributes"/>
        </fo:inline>
        <xsl:call-template name="makeGroup"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/groupchoice ')]/*[contains(@class, ' pr-d/groupcomp ')]">
        <fo:inline>
            <xsl:call-template name="commonattributes"/>
        </fo:inline>
        <xsl:call-template name="makeGroup"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/groupchoice ')]/*[contains(@class, ' pr-d/groupseq ')]">
        <fo:inline>
            <xsl:call-template name="commonattributes"/>
        </fo:inline>
        <xsl:call-template name="makeGroup"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/groupcomp ')]/*[contains(@class, ' pr-d/groupchoice ')]">
        <fo:inline>
            <xsl:call-template name="commonattributes"/>
        </fo:inline>
        <xsl:call-template name="makeGroup"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/groupcomp ')]/*[contains(@class, ' pr-d/groupseq ')]">
        <fo:inline>
            <xsl:call-template name="commonattributes"/>
        </fo:inline>
        <xsl:call-template name="makeGroup"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/groupseq ')]/*[contains(@class, ' pr-d/groupchoice ')]">
        <fo:inline>
            <xsl:call-template name="commonattributes"/>
        </fo:inline>
        <xsl:call-template name="makeGroup"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' pr-d/groupseq ')]/*[contains(@class, ' pr-d/groupcomp ')]">
        <fo:inline>
            <xsl:call-template name="commonattributes"/>
        </fo:inline>
        <xsl:call-template name="makeGroup"/>
    </xsl:template>

    <xsl:template name="makeGroup">
        <xsl:if test="parent::*[contains(@class, ' pr-d/groupchoice ')]">
            <xsl:if test="count(preceding-sibling::*) != 0"> | </xsl:if>
        </xsl:if>
        <xsl:if test="@importance = 'optional'">[</xsl:if>
        <xsl:if test="name() = 'groupchoice'">{</xsl:if>
        <xsl:text> </xsl:text>
        <xsl:apply-templates/>
        <xsl:text> </xsl:text>
        <!-- repid processed here before -->
        <xsl:if test="name() = 'groupchoice'">}</xsl:if>
        <xsl:if test="@importance = 'optional'">]</xsl:if>
    </xsl:template>

    <xsl:template name="putAttrs">
        <xsl:for-each select="@*">
            <xsl:attribute name="{name()}">
                <xsl:value-of select="."/>
            </xsl:attribute>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
