<?xml version="1.0"?>

<!--
Copyright © 2004-2006 by Idiom Technologies, Inc. All rights reserved.
IDIOM is a registered trademark of Idiom Technologies, Inc. and WORLDSERVER
and WORLDSTART are trademarks of Idiom Technologies, Inc. All other
trademarks are the property of their respective owners.

IDIOM TECHNOLOGIES, INC. IS DELIVERING THE SOFTWARE &quot;AS IS,&quot; WITH
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
Software or its derivatives. In no event shall Idiom Technologies, Inc.&apos;s
liability for any damages hereunder exceed the amounts received by Idiom
Technologies, Inc. as a result of this transaction.

These terms and conditions supersede the terms and conditions in any
licensing agreement to the extent that such terms and conditions conflict
with those set forth herein.

This file is part of the DITA Open Toolkit project hosted on Sourceforge.net.
See the accompanying license.txt file for applicable licenses.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">

    <!-- contents of table entries or similer structures -->
    <xsl:attribute-set name="common.table.body.entry">
        <xsl:attribute name="space-before">3pt</xsl:attribute>
        <xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
        <xsl:attribute name="space-after">3pt</xsl:attribute>
        <xsl:attribute name="space-after.conditionality">retain</xsl:attribute>
        <xsl:attribute name="start-indent">3pt</xsl:attribute>
        <xsl:attribute name="end-indent">3pt</xsl:attribute>
    </xsl:attribute-set>

    <!--HSX Table header line - typical layout -->
    <xsl:attribute-set name="common.table.head.entry">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <!-- Table Title above -->
    <xsl:attribute-set name="table.title.above" use-attribute-sets="base-font common.title">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="space-before">10pt</xsl:attribute>
        <xsl:attribute name="space-after">3pt</xsl:attribute>
        <!--HSC [DtPrt#13.11] allows placing the table title below the table. In that
        case we want to keep the title with the table and the keep changes from always to auto -->
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>

        <!--HSC Table title can be changed here acc. to [DtPrt#13.10] -->
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="color">black</xsl:attribute>
    </xsl:attribute-set>

    <!-- Table Title below -->
    <xsl:attribute-set name="table.title.below" use-attribute-sets="base-font common.title">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="space-before">3pt</xsl:attribute>
        <xsl:attribute name="space-after">10pt</xsl:attribute>
        <!--HSC [DtPrt#13.11] allows placing the table title below the table. In that
        case we want to keep the title with the table and the keep changes from always to auto
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute> -->
        <xsl:attribute name="keep-with-next.within-column">auto</xsl:attribute>
        <xsl:attribute name="keep-with-previous.within-column">always</xsl:attribute>

        <!--HSC Table title can be changed here acc. to [DtPrt#13.10] -->
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="color">black</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__tableframe__none"/>

    <!--HSC Enhance table rule specification acc. to [DtPrt#13.9]
    <xsl:attribute-set name="__tableframe__top" use-attribute-sets="common.border__top">
    </xsl:attribute-set>

    <xsl:attribute-set name="__tableframe__bottom" use-attribute-sets="common.border__bottom">
    <xsl:attribute name="border-after-width.conditionality">retain</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="thead__tableframe__bottom" use-attribute-sets="common.border__bottom">
    </xsl:attribute-set>

    <xsl:attribute-set name="__tableframe__left" use-attribute-sets="common.border__left">
    </xsl:attribute-set>

    <xsl:attribute-set name="__tableframe__right" use-attribute-sets="common.border__right">
    </xsl:attribute-set>
    -->
    <xsl:attribute-set name="__tableframe__top" use-attribute-sets="table.rule__top"> </xsl:attribute-set>

    <xsl:attribute-set name="__tableframe__bottom" use-attribute-sets="table.rule__bottom">
        <xsl:attribute name="border-after-width.conditionality">retain</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="thead__tableframe__bottom" use-attribute-sets="table.frame__bottom"> </xsl:attribute-set>

    <xsl:attribute-set name="__tableframe__left" use-attribute-sets="table.rule__left"> </xsl:attribute-set>

    <xsl:attribute-set name="__tableframe__right" use-attribute-sets="table.rule__right"> </xsl:attribute-set>
    <!--HSC end of insertion -->

  <xsl:attribute-set name="table__container">
    <xsl:attribute name="reference-orientation" select="if (@orient eq 'land') then 90 else 0"/>
    <!--HSX3 very important to set start-indent = 0 to avoid double indentation by following block-->
    <xsl:attribute name="start-indent">0pt</xsl:attribute>
    <xsl:attribute name="keep-with-previous.within-column">always</xsl:attribute>
  </xsl:attribute-set>

    <xsl:attribute-set name="table" use-attribute-sets="base-font">
        <!--It is a table container -->
        <xsl:attribute name="space-after">10pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="table.tgroup">
        <!--It is a table-->
        <xsl:attribute name="table-layout">fixed</xsl:attribute>
        <xsl:attribute name="width">100%</xsl:attribute>
        <!--xsl:attribute name=&quot;inline-progression-dimension&quot;&gt;auto&lt;/xsl:attribute-->
        <!--        &lt;xsl:attribute name=&quot;background-color&quot;&gt;white&lt;/xsl:attribute&gt;-->

        <!-- When [DtPrt#13.11] suggested the table title below the table, we should adjust
        the space-before, which did the title when it was on top.
        <xsl:attribute name="space-before">5pt</xsl:attribute> -->

        <!-- Actually we let the space come from TitleAbove and TitleBelow ... they know better  -->
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="table__tableframe__all"
        use-attribute-sets="table__tableframe__topbot table__tableframe__sides">
        <!--HSC [DtPrt#13.13.1] create bottom rule (if there are bottom rules) on page-break -->
        <xsl:attribute name="border-before-width.conditionality">retain</xsl:attribute>
        <xsl:attribute name="border-after-width.conditionality">retain</xsl:attribute>
        <!--HSC end of insertion -->
    </xsl:attribute-set>

    <xsl:attribute-set name="table__tableframe__topbot"
        use-attribute-sets="table__tableframe__top table__tableframe__bottom">
        <!--HSC [DtPrt#13.13.1] create bottom rule (if there are bottom rules) on page-break -->
        <xsl:attribute name="border-before-width.conditionality">retain</xsl:attribute>
        <xsl:attribute name="border-after-width.conditionality">retain</xsl:attribute>
        <!--HSC end of insertion -->
    </xsl:attribute-set>

    <!--HSC Enhance table rule specification acc. to [DtPrt#13.9]
    <xsl:attribute-set name="table__tableframe__top" use-attribute-sets="common.border__top">
    </xsl:attribute-set>

    <xsl:attribute-set name="table__tableframe__bottom" use-attribute-sets="common.border__bottom">
    </xsl:attribute-set>

    <xsl:attribute-set name="table__tableframe__sides" use-attribute-sets="table__tableframe__right table__tableframe__left">
    </xsl:attribute-set>

    <xsl:attribute-set name="table__tableframe__right" use-attribute-sets="common.border__right">
    </xsl:attribute-set>

    <xsl:attribute-set name="table__tableframe__left" use-attribute-sets="common.border__left">
    </xsl:attribute-set>
    -->

    <!-- insertions -->
    <xsl:attribute-set name="table__tableframe__top" use-attribute-sets="table.frame__top"> </xsl:attribute-set>

    <xsl:attribute-set name="table__tableframe__bottom" use-attribute-sets="table.frame__bottom"> </xsl:attribute-set>

    <xsl:attribute-set name="table__tableframe__sides"
        use-attribute-sets="table__tableframe__right table__tableframe__left"> </xsl:attribute-set>

    <xsl:attribute-set name="table__tableframe__right" use-attribute-sets="table.frame__right"> </xsl:attribute-set>

    <xsl:attribute-set name="table__tableframe__left" use-attribute-sets="table.frame__left"> </xsl:attribute-set>

    <xsl:attribute-set name="tgroup.tbody">
        <!--Table body-->
    </xsl:attribute-set>

    <xsl:attribute-set name="tgroup.thead">
        <!--Table head-->
    </xsl:attribute-set>

    <xsl:attribute-set name="tgroup.tfoot">
        <!--Table footer-->
    </xsl:attribute-set>

    <xsl:attribute-set name="thead.row">
        <!--Head row-->
        <xsl:attribute name="background-color">
            <xsl:value-of select="$Table-backgroundHeader"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="tfoot.row">
        <!--Table footer-->
    </xsl:attribute-set>

    <!--HSX allow rowcolor assignment, this is ALWAYS and ONLY called from a row element -->
    <xsl:template name="setRowColor">
        <xsl:param name="rowcolor" select="'rowcolor'"/>
        <xsl:param name="defaultcolor" select="$Table-backgroundRow"/>
            <xsl:choose>
                <!--HSX process RGB coding -->
                <xsl:when test="contains(@outputclass, concat($rowcolor, '=#'))">
                    <xsl:variable name="matchRGB" select="concat('^.*', $rowcolor, '=#([0-9, A-F]+).*$')"/>
                    <xsl:analyze-string select="@outputclass" regex="{$matchRGB}">
                        <xsl:matching-substring>
                            <xsl:if test="string-length(regex-group(1)) = 6">
                                <xsl:value-of select="concat('#', regex-group(1))"/>
                            </xsl:if>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:when>
                <!--HSX process text coding (e.g. red, yellow) -->
                <xsl:when test="contains(@outputclass, concat($rowcolor, '='))">
                    <xsl:variable name="matchRGB" select="concat('^.*', $rowcolor, '=([a-z]+).*$')"/>
                    <xsl:analyze-string select="@outputclass" regex="{$matchRGB}">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(1)"/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:when>

                <!--HSX process TABLE based body row color in #1280FF hex RGB notation -->
                <xsl:when test="contains(ancestor::*[contains(name(), 'table')][1]/@outputclass, concat($rowcolor, '=#'))">
                    <xsl:variable name="matchRGB" select="concat('^.*', $rowcolor, '=#([0-9, A-F]+).*$')"/>
                    <xsl:analyze-string select="ancestor::*[contains(name(), 'table')][1]/@outputclass" regex="{$matchRGB}">
                        <xsl:matching-substring>
                            <xsl:if test="string-length(regex-group(1)) = 6">
                                <xsl:value-of select="concat('#', regex-group(1))"/>
                            </xsl:if>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:when>

                <!--HSX process direct color names blue,black etc. -->
                <xsl:when test="contains(ancestor::*[contains(name(), 'table')][1]/@outputclass, concat($rowcolor, '='))">
                    <xsl:variable name="matchRGB" select="concat('^.*', $rowcolor, '=([a-z]+).*$')"/>
                    <xsl:analyze-string select="ancestor::*[contains(name(), 'table')][1]/@outputclass" regex="{$matchRGB}">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(1)"/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:when>

                <!--HSX process plugin default row color
                  WE NEVER MEET THIS !!!!! - handled in 2nd case
                <xsl:when test="contains(@outputclass, 'rowcolor')">
                    <xsl:analyze-string select="@outputclass" regex="{'^.*rowcolor=([a-z]+).*$'}">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(1)"/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:when>
                -->

                <!--HSX process system default row color-->
                <xsl:otherwise>
                    <xsl:value-of select="$defaultcolor"/>
                    <!-- <xsl:value-of select="'antiquewhite'"/> -->
                </xsl:otherwise>
            </xsl:choose>
    </xsl:template>

    <xsl:attribute-set name="tbody.row">
        <!--Table body row-->
        <xsl:attribute name="background-color">
            <xsl:call-template name="setRowColor">
                <xsl:with-param name="defaultcolor" select="$Table-backgroundRow"/>
            </xsl:call-template>
        </xsl:attribute>
        <xsl:attribute name="keep-together.within-page">1</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="thead.row.entry">
        <!--head cell-->
        <!--HSC to change head row color acc. to [DtPrt#13.7]
        <xsl:attribute name="background-color">antiquewhite</xsl:attribute> -->
        <xsl:attribute name="background-color">
            <xsl:value-of select="$Table-backgroundHeader"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="thead.row.entry__content"
        use-attribute-sets="common.table.body.entry common.table.head.entry">
        <!--head cell contents-->
        <!--HSC [DtPrt#13.7] controls the table header row
        Because the common.table.head.entry attribute set specifies bold text, you don't need to specify it here.
        -->
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="color">black</xsl:attribute>
        <xsl:attribute name="start-indent">6pt</xsl:attribute>
        <!--HSC ... end insertions -->
    </xsl:attribute-set>

    <xsl:attribute-set name="tfoot.row.entry">
        <!--footer cell-->
    </xsl:attribute-set>

    <xsl:attribute-set name="tfoot.row.entry__content"
        use-attribute-sets="common.table.body.entry common.table.head.entry">
        <!--footer cell contents-->
    </xsl:attribute-set>

    <xsl:attribute-set name="tbody.row.entry">
        <!--body cell-->
    </xsl:attribute-set>

    <xsl:attribute-set name="tbody.row.entry__firstcol" use-attribute-sets="tbody.row.entry">
        <!--HSX first col can be handled specially body cell-->
    </xsl:attribute-set>

    <xsl:attribute-set name="tbody.row.entry__content" use-attribute-sets="common.table.body.entry">
        <!--body cell contents-->
        <!--HSC [DtPrt#13.8] controls the text in table cells -->
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <!--
        <xsl:attribute name="color">#8A8A8C</xsl:attribute>
        -->
        <xsl:attribute name="color">#000001</xsl:attribute>

        <!--HSX the row:outputclass=compact mechanism will provide a dense
            compact (nearly no space) to all non-existing separators. If
            separator is found, then a distance to it will automatically be
            taken, which is exactly what a user would expect
        -->
        <xsl:attribute name="space-before">
            <xsl:choose>
                <!-- allow dense compact only, if previous row does not have a separator -->
                <xsl:when test="contains(../@outputclass, 'compact') and
                    (../preceding-sibling::row[1]/@rowsep != 1)">
                    <xsl:text>0.61pt</xsl:text>
                </xsl:when>
                <xsl:when test="contains(../@outputclass, 'compact')">
                    <xsl:text>2pt</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>4pt</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="space-after">
            <xsl:choose>
                <!-- allow dense compact only, if our row does not have a separator -->
                <xsl:when test="contains(../@outputclass, 'compact') and (../@rowsep = 0) ">
                    <xsl:text>0.61pt</xsl:text>
                </xsl:when>
                <xsl:when test="contains(../@outputclass, 'compact')">
                    <xsl:text>1pt</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:text>4pt</xsl:text>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="start-indent">
            <xsl:choose>
                <xsl:when test="contains(@outputclass,'left:')">
                    <xsl:analyze-string select="@outputclass" regex="{'^.*left:([0-9]+)([A-Z, a-z]+).*$'}">
                        <xsl:matching-substring>
                            <xsl:choose>
                                <xsl:when test="contains('mm cm pt px em', regex-group(2))">
                                    <xsl:value-of select="regex-group(1)"/>
                                    <xsl:value-of select="regex-group(2)"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'6pt'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:matching-substring>
                        <xsl:non-matching-substring>
                            <xsl:value-of select="'6pt'"/>
                        </xsl:non-matching-substring>
                    </xsl:analyze-string>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'6pt'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="end-indent">6pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="dl">
        <!--DL is a table-->
        <xsl:attribute name="width">100%</xsl:attribute>
        <xsl:attribute name="space-before">5pt</xsl:attribute>
        <xsl:attribute name="space-after">5pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="dl__body"> </xsl:attribute-set>

    <xsl:attribute-set name="dl.dlhead"> </xsl:attribute-set>

    <xsl:attribute-set name="dlentry"> </xsl:attribute-set>

    <xsl:attribute-set name="dlentry.dt">
        <xsl:attribute name="relative-align">baseline</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="dlentry.dt__content"
        use-attribute-sets="common.table.body.entry common.table.head.entry">
        <!--HSC test <xsl:attribute name="background-color">#0080FF</xsl:attribute> -->
        <xsl:attribute name="start-indent">0mm</xsl:attribute>
        <!--HSX <xsl:value-of select="$side-col-width"/></xsl:attribute> -->
        <xsl:attribute name="space-before">
            <xsl:choose>
                <!-- In the first position we have a default correction in dlentry.dd__content -->
                <xsl:when test="position() = 1">
                    <xsl:value-of select="$advance-entry"/>
                </xsl:when>
                <xsl:when test="contains(@outputclass, 'compact')">
                    <xsl:value-of select="$advance-compact"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$advance-default"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="dlentry.dd">
        <!--HSX provide separate start-indent for all lists -->
    </xsl:attribute-set>

    <xsl:attribute-set name="dlentry.dd__content" use-attribute-sets="common.table.body.entry">
        <!--HSX provide separate start-indent for all lists
        <xsl:attribute name="start-indent">
    <xsl:value-of select="$side-col-width"/>+20pt</xsl:attribute> -->
        <xsl:attribute name="start-indent">20pt</xsl:attribute>
        <xsl:attribute name="space-before">
            <!--HSX The first position corrects the vertical shift due to the selected fonts,
        The actual shift is specified in dlentry.dd__content
        The width of the rows is determined by [Xslfo#7.14.6] through relative-align
        -->
            <xsl:choose>
                <!-- In the first position we have a default correction in dlentry.dd__content -->
                <xsl:when test="position() = 1">
                    <xsl:value-of select="$advance-entry"/>
                </xsl:when>
                <xsl:when test="contains(@outputclass, 'compact')">
                    <xsl:value-of select="$advance-compact"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$advance-default"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="dl.dlhead__row"> </xsl:attribute-set>

    <xsl:attribute-set name="dlhead.dthd__cell"> </xsl:attribute-set>

    <xsl:attribute-set name="dlhead.dthd__content"
        use-attribute-sets="common.table.body.entry common.table.head.entry"> </xsl:attribute-set>

    <xsl:attribute-set name="dlhead.ddhd__cell"> </xsl:attribute-set>

    <xsl:attribute-set name="dlhead.ddhd__content"
        use-attribute-sets="common.table.body.entry common.table.head.entry"> </xsl:attribute-set>

    <xsl:attribute-set name="simpletable" use-attribute-sets="base-font">
        <!--It is a table container -->
        <xsl:attribute name="width">100%</xsl:attribute>
        <xsl:attribute name="space-before">8pt</xsl:attribute>
        <xsl:attribute name="space-after">10pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="simpletable__body"> </xsl:attribute-set>

    <xsl:attribute-set name="sthead">
    </xsl:attribute-set>

    <xsl:attribute-set name="sthead__row">
        <xsl:attribute name="background-color">
            <xsl:call-template name="setRowColor">
                <xsl:with-param name="defaultcolor" select="$Table-backgroundHeader"/>
            </xsl:call-template>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="strow">
        <xsl:attribute name="background-color">
            <xsl:call-template name="setRowColor"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="sthead.stentry"> </xsl:attribute-set>

    <xsl:attribute-set name="sthead.stentry__content"
        use-attribute-sets="common.table.body.entry common.table.head.entry"> </xsl:attribute-set>

    <xsl:attribute-set name="sthead.stentry__keycol-content"
        use-attribute-sets="common.table.body.entry common.table.head.entry">
        <!--HSX Bug in DITA-OT, background color shall not be set on text level (as here)
                but on entry level. We do need to set the background nevertheless here
                because the org.dita.pdf2 does it. So we need to overwrite as we cannot
                delete the setting done by the (buggy) org.dita.pdf2

                Here We simnply correct the bug from org.dita.pdf2 ... can go if fixed officially
        -->
        <xsl:attribute name="background-color">
            <xsl:variable name="entryCol" select="count(preceding-sibling::*[contains(@class, ' topic/stentry ')]) + 1"/>
            <xsl:choose>
                <xsl:when test="contains(@outputclass, 'cellcolor')">
                    <xsl:call-template name="setRowColor">
                        <xsl:with-param name="rowcolor" select="'cellcolor'"/>
                        <xsl:with-param name="defaultcolor" select="$Table-backgroundHeader"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="number(ancestor::*[contains(@class, ' topic/simpletable ')][1]/@keycol) = $entryCol">
                    <xsl:value-of select="$Table-highlightRow"/>
                </xsl:when>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="strow.stentry__content" use-attribute-sets="common.table.body.entry"> </xsl:attribute-set>

    <xsl:attribute-set name="strow.stentry__keycol-content"
        use-attribute-sets="common.table.body.entry common.table.head.entry">
        <!--HSX Bug in DITA-OT, background color shall not be set on text level (as here)
                but on entry level. We do need to set the background nevertheless here
                because the org.dita.pdf2 does it. So we need to overwrite as we cannot
                delete the setting done by the (buggy) org.dita.pdf2

                Here We simnply correct the bug from org.dita.pdf2 ... can go if fixed officially
        -->
        <xsl:attribute name="background-color">
            <xsl:variable name="entryCol" select="count(preceding-sibling::*[contains(@class, ' topic/stentry ')]) + 1"/>
            <xsl:choose>
                <xsl:when test="contains(@outputclass, 'cellcolor')">
                    <xsl:call-template name="setRowColor">
                        <xsl:with-param name="rowcolor" select="'cellcolor'"/>
                        <xsl:with-param name="defaultcolor" select="$Table-backgroundRow"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:when test="number(ancestor::*[contains(@class, ' topic/simpletable ')][1]/@keycol) = $entryCol">
                    <xsl:value-of select="$Table-highlightRow"/>
                </xsl:when>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="strow.stentry">
        <!--
        <xsl:attribute name="background-color">
            <xsl:call-template name="setRowColor"/>
        </xsl:attribute>
        -->
    </xsl:attribute-set>

</xsl:stylesheet>
