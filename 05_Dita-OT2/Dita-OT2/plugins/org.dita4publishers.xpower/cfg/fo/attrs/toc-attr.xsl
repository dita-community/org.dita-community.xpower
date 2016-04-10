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
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">

    <!--HSC [DtPrt#16.14] allows to change indent for TOC entries by formula
    <xsl:variable name="toc.text-indent" select="'14pt'"/>
    <xsl:variable name="toc.toc-indent" select="'30pt'"/> -->
    <xsl:variable name="toc.text-indent" select="'0in'"/>
    <xsl:variable name="toc.toc-indent" select="'0.25in'"/>

    <xsl:attribute-set name="__toc__header" use-attribute-sets="common.title">
        <!--HSC [DtPrt#16.7] describes changing the formatting
            if you like it ... follow it ... I had no reason to change ... -
        <xsl:attribute name="font-size">28pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="color"><xsl:value-of select="$FmColor-RoyalBlue100"/></xsl:attribute>  -->
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after">16.8pt</xsl:attribute>
        <!--HSC option to skip -->
        <xsl:attribute name="font-size">20pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="padding-top">16.8pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__link">
        <xsl:attribute name="line-height">150%</xsl:attribute>
        <!--xsl:attribute name="font-size">
            <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
            <xsl:value-of select="concat(string(20 - number($level) - 4), 'pt')"/>
        </xsl:attribute-->
    </xsl:attribute-set>


    <xsl:attribute-set name="__toc__topic__content_backmatter">
        <xsl:attribute name="padding-top">19pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__topic__content">
        <xsl:attribute name="padding-top">0pt</xsl:attribute>
        <xsl:attribute name="last-line-end-indent">-22pt</xsl:attribute>
        <xsl:attribute name="end-indent">22pt</xsl:attribute>
        <!--HSC [DtPrt#16.14] allows to change indent for TOC entries by formula
            this would want to set text-indent to 0in.
        <xsl:attribute name="text-indent">0pt</xsl:attribute>
        -->
        <xsl:attribute name="text-indent">-<xsl:value-of select="$toc.text-indent"/></xsl:attribute>
        <xsl:attribute name="text-align">start</xsl:attribute>
        <xsl:attribute name="text-align-last">justify</xsl:attribute>
        <xsl:attribute name="font-size">
            <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
            <xsl:choose>
                <xsl:when test="$level = 1">12pt</xsl:when>
                <!--HSC [DtPrt#16.9] change the font size if you like
                <xsl:otherwise><xsl:value-of select="$default-font-size"/></xsl:otherwise> -->
                <xsl:otherwise>10pt</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="font-weight">
            <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
            <xsl:choose>
                <xsl:when test="$level = 1">bold</xsl:when>  <!--HSC can also be 'normal' [DtPrt#16.9] -->
                <xsl:otherwise>normal</xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <!--HSC [DtPrt#16.9] specifies different layout for different levels. This can
                actually done above in the font-size section but if we want to change
                the color experimentally we need to put this section. -->
        <xsl:attribute name="color">
            <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
            <xsl:choose>
                <xsl:when test="$level = 1">
                    <xsl:value-of select="$Toc-level-1"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$Toc-level-n"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__chapter__content" use-attribute-sets="__toc__topic__content">
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="padding-top">20pt</xsl:attribute>
        <xsl:attribute name="padding-bottom">
            <xsl:value-of select="$toc2padding"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__appendix__content" use-attribute-sets="__toc__topic__content">
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="padding-top">20pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__part__content" use-attribute-sets="__toc__topic__content">
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="padding-top">20pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__preface__content" use-attribute-sets="__toc__topic__content">
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="padding-top">20pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__notices__content" use-attribute-sets="__toc__topic__content">
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="padding-top">20pt</xsl:attribute>
    </xsl:attribute-set>

    <!-- Added for back compatibility since __toc__content was renamed into __toc__topic__content-->
    <xsl:attribute-set name="__toc__content" use-attribute-sets="__toc__topic__content">
      <!--HSC delete the entire line if you remove -->
                    <xsl:attribute name="font-weight">bold</xsl:attribute>

    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__title">
      <xsl:attribute name="end-indent"><xsl:value-of select="$toc.text-indent"/></xsl:attribute>
      <!--HSC [DtPrt#16.16.4] allows line braks in TOC entries -->
      <xsl:attribute name="keep-together.within-line">auto</xsl:attribute>
      <!--HSC [DtPrt#16.16.4] allows hyphenating on long TOC lines -->
      <xsl:attribute name="hyphenate">true</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__page-number">
      <xsl:attribute name="start-indent">-<xsl:value-of select="$toc.text-indent"/></xsl:attribute>
      <xsl:attribute name="keep-together.within-line">always</xsl:attribute>
      <!--HSC [DtPrt16.10] formats the page number in a TOC -->
      <xsl:attribute name="font-size">10pt</xsl:attribute>
      <xsl:attribute name="color">
        <xsl:value-of select="$Toc-pagenumber"/>
      </xsl:attribute>
      <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__leader">
    <!--HSC [DtPrt#16.12] modifies leader for TOC
        Possible alternatives for 'dots' are 'space' or 'rule' (underscores)
        I did not want any of them. Yet ... if you really don't want anything
        you will empty the line and follow [DtPrt#16.2] to left-align the TOC entries
    -->
        <xsl:attribute name="leader-pattern">dots</xsl:attribute>
    </xsl:attribute-set>

    <!--HSC [DtPrt#16.14] allows to change indent for TOC entries by formula -->
    <xsl:attribute-set name="__toc__indent">
        <xsl:attribute name="start-indent">
            <xsl:variable name="level" select="count(ancestor-or-self::*[contains(@class, ' topic/topic ')])"/>
            <!--HSC [DtPrt#16.14]
            <xsl:value-of select="concat($side-col-width, ' + (', string($level - 1), ' * ', $toc.toc-indent, ') + ', $toc.text-indent)"/>
            -->
            <xsl:value-of select="concat($toc.text-indent, ' + (', string($level - 1), ' * ', $toc.toc-indent, ') + ', $toc.text-indent)"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <!--HSX __toc__mini determines the layout of the actual mini-TOC text, but
            not for the title (which is __toc__mini_float)
            <xsl:attribute name="font-size">10.5pt</xsl:attribute>
            is not reasonable here because it is overridden by
            xref__mini__toc
    -->
    <xsl:attribute-set name="__toc__mini">
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="end-indent">5pt</xsl:attribute>
        <xsl:attribute name="start-indent">
            <xsl:value-of select="$side-col-width"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__mini_float"  use-attribute-sets="__toc__mini common.title">
        <!-- text geometry -->
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
        <xsl:attribute name="text-indent">0em</xsl:attribute>
        <xsl:attribute name="space-before">25pt</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>

        <xsl:attribute name="start-indent">0pt</xsl:attribute>
        <xsl:attribute name="padding-left">0mm</xsl:attribute>
        <xsl:attribute name="padding-top">2pt</xsl:attribute>
        <xsl:attribute name="padding-bottom">0pt</xsl:attribute>
        <xsl:attribute name="background-color">#FFFFFF</xsl:attribute>

        <!--HSX font attributes
            Ddon't need to add sans-serif [DtPrt#10.3.3] as section title calls
        common.title above
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        -->
        <xsl:attribute name="color">#000040</xsl:attribute>
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="line-height">100%</xsl:attribute>

        <!--HSX borders -->
        <xsl:attribute name="border-top-style">solid</xsl:attribute>
        <xsl:attribute name="border-top-width">0.5mm</xsl:attribute>
        <xsl:attribute name="border-top-color">#C0C0C1</xsl:attribute>

        <xsl:attribute name="border-bottom-style">none</xsl:attribute>
        <xsl:attribute name="border-bottom-width">1.5pt</xsl:attribute>
        <xsl:attribute name="border-bottom-color">#0080FF</xsl:attribute>
    </xsl:attribute-set>

    <!--HSX __toc__mini__header is the header style of the 'Content' text-indent
        if the mini-TOC comes first (@outputclass=tocfirst in element=topic/concept/task/reference)
    -->
    <xsl:attribute-set name="__toc__mini__header" use-attribute-sets="__toc__mini common.title">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="color">#000141</xsl:attribute>
        <xsl:attribute name="padding-bottom">1mm</xsl:attribute>
        <xsl:attribute name="font-size">12pt</xsl:attribute>
    </xsl:attribute-set>

    <!--HSX __toc__mini__list determine the geometry of the entire
        mini-TOC, but they do not determine the layout of the padding etc
        which is done when
        <xsl:template match="*[contains(@class, ' topic/topic ')]" mode="in-this-chapter-list">
        is processed
    -->
    <xsl:attribute-set name="__toc__mini__list">
        <xsl:attribute name="provisional-distance-between-starts">18pt</xsl:attribute>
        <xsl:attribute name="provisional-label-separation">12pt</xsl:attribute>
        <xsl:attribute name="space-before">1pt</xsl:attribute>
        <xsl:attribute name="space-after">9pt</xsl:attribute>
    </xsl:attribute-set>

    <!--HSX __toc__mini__entry determines space-before/after for EVERY single
            mini-TOC entry. Use __toc__mini__list for the entire block
    -->
    <xsl:attribute-set name="__toc__mini__entry">
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
    </xsl:attribute-set>


    <!--HSX __toc__mini__body determines space-before/after for the
            mini-TOC block.  Use __toc__mini__entry for every line of the mini-TOC
    -->
    <xsl:attribute-set name="__toc__mini__body">
        <!--HSX
        <xsl:attribute name="start-indent">body-start()</xsl:attribute>
        -->
        <xsl:attribute name="start-indent">
            <xsl:value-of select="$side-col-width"/>
        </xsl:attribute>

    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__mini__label">
        <xsl:attribute name="keep-together.within-line">always</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-line">always</xsl:attribute>
        <xsl:attribute name="end-indent">label-end()</xsl:attribute>
    </xsl:attribute-set>

    <!-- SF Bug 1815571: page-break-after must be on fo:table rather than fo:table-body
                         in order to produce valid XSL-FO 1.1 output. -->
    <xsl:attribute-set name="__toc__mini__table">
        <xsl:attribute name="table-layout">fixed</xsl:attribute>
        <xsl:attribute name="width">100%</xsl:attribute>
        <xsl:attribute name="page-break-after">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__mini__table__body">
        <!-- SF Bug 1815571: moved page-break-after to __toc__mini__table -->
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__mini__table__column_1">
        <xsl:attribute name="column-number">1</xsl:attribute>
        <xsl:attribute name="column-width">35%</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__mini__table__column_2">
        <xsl:attribute name="column-number">2</xsl:attribute>
        <xsl:attribute name="column-width">65%</xsl:attribute>
    </xsl:attribute-set>

     <xsl:attribute-set name="__toc__mini__summary" use-attribute-sets="common.border__left">
         <xsl:attribute name="padding-left">10pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__topic__content__booklist" use-attribute-sets="__toc__topic__content">
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__topic__content__index" use-attribute-sets="__toc__topic__content">
<!--HSX these entries determinen the INDEX entry formatting in the TOC -->
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__indent__booklist" use-attribute-sets="__toc__indent">
        <xsl:attribute name="start-indent"><xsl:value-of select="$side-col-width"/> + <xsl:value-of select="$toc.text-indent"/></xsl:attribute>
        <xsl:attribute name="space-before">10pt</xsl:attribute>
        <xsl:attribute name="space-after">10pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__topic__content__glossary" use-attribute-sets="__toc__topic__content__booklist">
      <xsl:attribute name="font-size">14pt</xsl:attribute>
      <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__topic__content__lot" use-attribute-sets="__toc__topic__content__booklist">
      <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
      <xsl:attribute name="color">#000002</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__topic__content__lof" use-attribute-sets="__toc__topic__content__booklist">
<!--HSX This font-size attribute determines the size of the TOC LoF entry in the TOC -->
      <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
      <xsl:attribute name="color">#000100</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__indent__glossary" use-attribute-sets="__toc__indent__booklist">
      <xsl:attribute name="font-size">12pt</xsl:attribute>
      <xsl:attribute name="start-indent">0mm</xsl:attribute>
    </xsl:attribute-set>

<!--HSX This attribute sets the block formatting (start-indent) of the LoF entry in the TOC (only)
    Important to correct the default indent value created from and its associated attributes
    xsl:template match="ot-placeholder:figurelist" mode="toc"> in toc.xsl
-->
    <xsl:attribute-set name="__toc__indent__lot" use-attribute-sets="__toc__indent__booklist">
      <xsl:attribute name="start-indent">0mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__indent__lof" use-attribute-sets="__toc__indent__booklist">
      <xsl:attribute name="start-indent">0mm</xsl:attribute>
    </xsl:attribute-set>

<!--HSX This attribute determines the INDEX entry in the TOC.
    Important to override the default settings __toc__indent__booklist
    in toc.xsl:<xsl:template match="ot-placeholder:indexlist" mode="toc" name="toc.index">
    see also __toc__topic__content__index
-->
    <xsl:attribute-set name="__toc__indent__index" use-attribute-sets="__toc__indent__booklist">
      <xsl:attribute name="start-indent">0mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__item__right">
        <xsl:attribute name="keep-together.within-line">always</xsl:attribute>
        <xsl:attribute name="start-indent">1pt</xsl:attribute>
    </xsl:attribute-set>

</xsl:stylesheet>