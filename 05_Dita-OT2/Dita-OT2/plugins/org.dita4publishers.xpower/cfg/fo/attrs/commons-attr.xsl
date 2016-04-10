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
    xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    xmlns:rx="http://www.renderx.com/XSL/Extensions"
    version="2.0">

    <xsl:variable name="annot-vertical-offset">-7mm</xsl:variable>


    <!-- common attribute sets -->

    <xsl:attribute-set name="common.border__top">
        <xsl:attribute name="border-before-style">solid</xsl:attribute>
        <xsl:attribute name="border-before-width">1pt</xsl:attribute>
        <xsl:attribute name="border-before-color">black</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="common.border__bottom">
        <xsl:attribute name="border-after-style">solid</xsl:attribute>
        <xsl:attribute name="border-after-width">1pt</xsl:attribute>
        <xsl:attribute name="border-after-color">black</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="common.border__right">
        <xsl:attribute name="border-end-style">solid</xsl:attribute>
        <xsl:attribute name="border-end-width">1pt</xsl:attribute>
        <xsl:attribute name="border-end-color">black</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="common.border__left">
        <xsl:attribute name="border-start-style">solid</xsl:attribute>
        <xsl:attribute name="border-start-width">1pt</xsl:attribute>
        <xsl:attribute name="border-start-color">black</xsl:attribute>
    </xsl:attribute-set>

    <!--HSC Changing table borders acc. to [DtPrt#13.9] -->
    <xsl:attribute-set name="table.frame__top">
        <xsl:attribute name="border-top-style">solid</xsl:attribute>
        <xsl:attribute name="border-top-width">
            <xsl:value-of select="$Table-frameWidth"/>
        </xsl:attribute>
        <xsl:attribute name="border-top-color">
            <xsl:value-of select="$Table-frameTop"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="table.frame__bottom">
        <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
        <xsl:attribute name="border-bottom-width">
            <xsl:value-of select="$Table-frameWidth"/>
        </xsl:attribute>
        <xsl:attribute name="border-bottom-color">
            <xsl:value-of select="$Table-frameBottom"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="table.frame__right">
        <xsl:attribute name="border-right-style">solid</xsl:attribute>
        <xsl:attribute name="border-right-width">
            <xsl:value-of select="$Table-frameWidth"/>
        </xsl:attribute>
        <xsl:attribute name="border-right-color">
            <xsl:value-of select="$Table-frameRight"/>
        </xsl:attribute>
        <!--
        -->
    </xsl:attribute-set>
    <xsl:attribute-set name="table.frame__left">
        <xsl:attribute name="border-left-style">solid</xsl:attribute>
        <xsl:attribute name="border-left-width">
            <xsl:value-of select="$Table-frameWidth"/>
        </xsl:attribute>

        <xsl:attribute name="border-left-color">
            <xsl:value-of select="$Table-frameLeft"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="table.rule__top">
        <xsl:attribute name="border-top-style">solid</xsl:attribute>
        <xsl:attribute name="border-top-width">0.5pt</xsl:attribute>
        <xsl:attribute name="border-top-color">
            <xsl:value-of select="$Table-ruleTop"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="table.rule__bottom">
        <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
        <xsl:attribute name="border-bottom-width">0.5pt</xsl:attribute>
        <xsl:attribute name="border-bottom-color">
            <xsl:value-of select="$Table-ruleBottom"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="table.rule__right">
        <xsl:attribute name="border-right-style">solid</xsl:attribute>
        <xsl:attribute name="border-right-width">0.5pt</xsl:attribute>
        <xsl:attribute name="border-right-color">
            <xsl:value-of select="$Table-ruleRight"/>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="table.rule__left">
        <xsl:attribute name="border-left-style">solid</xsl:attribute>
        <xsl:attribute name="border-left-width">0.5pt</xsl:attribute>
        <xsl:attribute name="border-left-color">
            <xsl:value-of select="$Table-ruleLeft"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="common.border" use-attribute-sets="common.border__top common.border__right common.border__bottom common.border__left"/>

    <xsl:attribute-set name="base-font">
        <xsl:attribute name="font-size">
            <!--HSX any formatting entry in 'title' shall not modify font-size -->
            <xsl:choose>
                <xsl:when test="../name() = 'title'"/>
                <xsl:otherwise>
                    <xsl:value-of select="$default-font-size"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <!--HSC [DtPrt#10.4.4] corrects the line-height from constant to "relative to font"
        but that made some work on title lines, so for now I'm not following. Neither do I think
        that such a general line-height definition should be given here in a very global place,
        instead, it should be more specific in the callers of "base-font"
        
        Currently I brought it down to body__toplevel and body__secondLevel where it doesn't
        spoil the title creation.
        -->
    </xsl:attribute-set>

    <!-- titles -->
    <!--HSC ... changes basic attributes of titles, but not of chapter descriptions (e.g. Chapter 1 ...) -->
    <xsl:attribute-set name="common.title">
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    </xsl:attribute-set>

    <!-- paragraph-like blocks -->
    <xsl:attribute-set name="common.block">
        <!--HSC 0.6 em is the default, however, I need some more
        <xsl:attribute name="space-before">0.6em</xsl:attribute>
        <xsl:attribute name="space-after">0.6em</xsl:attribute>

        -->
        <xsl:attribute name="space-before">10pt</xsl:attribute>
        <xsl:attribute name="space-after">0.01pt</xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$default-line-height"/>
        </xsl:attribute>
        <!--
        -->
    </xsl:attribute-set>

    <xsl:attribute-set name="common.link">
        <xsl:attribute name="color">#4041FF</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <!--HSX line-height resists that the link box in PDF collapses on italic -->
        <xsl:attribute name="line-height">300%</xsl:attribute>
    </xsl:attribute-set>

    <!-- common element specific attribute sets -->
    <!--HSC changes explained in [DtPrt#10.4.5] -->
    <xsl:attribute-set name="tm">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="tm__content">
        <xsl:attribute name="font-size">75%</xsl:attribute>
        <xsl:attribute name="baseline-shift">20%</xsl:attribute>
    </xsl:attribute-set>

    <!--HSC [DtPrt#10.4.5] suggests to add tm__content__tm
    to get special layout for the trademark - this request exists because a trademark
    can have different "tmtype" values "service", "tm" and "reg"
    Template match to be done in commons.xsl -->
    <xsl:attribute-set name="tm__content__tm">
        <xsl:attribute name="font-size">75%</xsl:attribute>
        <xsl:attribute name="baseline-shift">20%</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="tm__content__service">
        <xsl:attribute name="font-size">40%</xsl:attribute>
        <xsl:attribute name="baseline-shift">50%</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="author">
    </xsl:attribute-set>

    <xsl:attribute-set name="source">
    </xsl:attribute-set>

    <!--HSC Attention ! Visit "__chapter__frontmatter__name__container" in static-content-attr.xsl which determines
    the layout of the chapter over-line for Head 1 CHAPTERS. If you would add a text-align="justify" here,
    you will hit "notices, abstract, preface", but NOT the chapter.title.

    That Head 1 chapter title layout (topic.title) is not determined here but in
    "__chapter__frontmatter__name__container"
    However, this set still comes in. If "__chapter__frontmatter__name__container" specifies
    an overline "red" than there will be a full page red overline. But our setting
    here specifies again border-top "blue" and it will be printed over the red line.

    On the other hand ... the power of this attribute-set cannot override the "justify"
    setting of the __chapter__frontmatter__name__container. Seems here it is the first
    who wins (and that is __chapter__frontmatter__name__container).
    -->
    <xsl:attribute-set name="topic.title" use-attribute-sets="common.title common.border__bottom">
        <xsl:attribute name="border-top">5pt solid <xsl:value-of select="$FmColor-RoyalBlue100"/>
        </xsl:attribute>
        <!--HSC-->
        <xsl:attribute name="border-after-width">0pt</xsl:attribute>
        <!--HSX2 new in Dita-OT 2.0 -->
        <xsl:attribute name="border-after-color">red</xsl:attribute>

        <xsl:attribute name="border-bottom">0pt solid red</xsl:attribute>
        <!--HSC
        <xsl:attribute name="background-color">#f0f0ff</xsl:attribute> -->
        <xsl:attribute name="space-before">9pt</xsl:attribute>
        <xsl:attribute name="space-after">9.7pt</xsl:attribute>
        <xsl:attribute name="font-size">18pt</xsl:attribute>
        <!--HSC font size H1 of the actual title text (as in FrameMaker) -->
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="padding-top">1pt</xsl:attribute>
        <!--HSC-->
        <!--    <xsl:attribute name="padding-bottom">26.8pt</xsl:attribute>   HSC-->
        <!--HSC We need to add start-indent if we come from the deletion of the chapter prefix
        acc. to [DtPrt#10.6.2]
        There's an explanation about padding vs space-before in [XslFo#4.1]

        Finally ... checking it out - we don't want the topic.title of any level to be effected from side-col-width
        therefore I took it out again.
        <xsl:attribute name="start-indent">
        <xsl:value-of select="$side-col-width"/>
        </xsl:attribute>
        -->
        <!--HSC The 'justify' below had effect on the titles (!) of notices, abstract, preface,
        but not on the chapter.title, that is controlled by the "__chapter__frontmatter__name__container"
        (see above)
        <xsl:attribute name="text-align">justify</xsl:attribute>
        <xsl:attribute name="text-align-last">justify</xsl:attribute>
        -->
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <!--HSC this is a copy  of the above topic.title acc. to [DtPrt#10.3.7] to maintain further qualities -->
    <xsl:attribute-set name="topic.title.hide" use-attribute-sets="common.title">
        <xsl:attribute name="border-bottom">0pt solid red</xsl:attribute>
        <!--HSC-->
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after">1.3pt</xsl:attribute>
        <xsl:attribute name="font-size">2pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="padding-top">0pt</xsl:attribute>
        <!--HSC-->
        <!--HSC to hide the chapter text, just print it in white and very small -->
        <xsl:attribute name="color">#FFFFFF</xsl:attribute>
        <xsl:attribute name="line-height">4pt</xsl:attribute>
    </xsl:attribute-set>

    <!--HSC the __content is concatenated when building attrSet2 in commons.xsl
    It is only used in 'processAttrSetReflection' -->
    <xsl:attribute-set name="topic.title__content">
        <xsl:attribute name="line-height">100%</xsl:attribute>
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="topic.topic.title" use-attribute-sets="common.title common.border__bottom">
        <xsl:attribute name="border-top">3pt solid <xsl:value-of select="$FmColor-RoyalBlue100"/>
        </xsl:attribute>
        <!--HSC-->
        <xsl:attribute name="border-bottom">0pt solid red</xsl:attribute>
        <!--HSC-->
        <!--HSC I don't want bottom border hence we can set 0pt/none to override fo.pdf2  -->
        <!-- background color is practical for debugging
        <xsl:attribute name="background-color">#80f0ff</xsl:attribute> -->

        <xsl:attribute name="border-bottom-width">0pt</xsl:attribute>
        <xsl:attribute name="border-bottom-style">none</xsl:attribute>
        <!--HSC    <xsl:attribute name="space-before">15pt</xsl:attribute>  useless... override in next statement -->
        <xsl:attribute name="space-before">42.2pt</xsl:attribute>
        <!--HSC space acc. to FrameMaker ref = 18pt-->
        <xsl:attribute name="space-after">10pt</xsl:attribute>
        <xsl:attribute name="font-size">16pt</xsl:attribute>
        <!--HSC font size Head2 -->
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="padding-top">1pt</xsl:attribute>
        <!--HSC-->
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="topic.topic.title__content">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="topic.topic.topic.title" use-attribute-sets="common.title">
        <xsl:attribute name="border-top">0.5pt solid <xsl:value-of select="$FmColor-RoyalBlue100"/>
        </xsl:attribute>
        <!--HSC Head3 color-->
        <xsl:attribute name="space-before">34.3pt</xsl:attribute>
        <xsl:attribute name="space-after">2pt</xsl:attribute>
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <!--HSC font size Head3 -->
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="padding-top">2pt</xsl:attribute>
        <!--HSC-->
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="topic.topic.topic.title__content">
    </xsl:attribute-set>

    <!--HSC side-col-width variable can be found in basic-settings.xls [DtPrt#10.3.2] -->
    <xsl:attribute-set name="topic.topic.topic.topic.title" use-attribute-sets="base-font common.title">
        <xsl:attribute name="border-top">0.5pt solid <xsl:value-of select="$FmColor-RoyalBlue30"/>
        </xsl:attribute>
        <!--HSC Head 4 color-->
        <xsl:attribute name="space-before">28.4pt</xsl:attribute>
        <!--HSX start indent shall be explicitly declared from level 4 otherwise we get side-col-width from parent -->
        <xsl:attribute name="start-indent">0mm</xsl:attribute>
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <!--HSC font size Head4 -->
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="padding-top">2pt</xsl:attribute>
        <!--HSC-->
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="topic.topic.topic.topic.title__content">
    </xsl:attribute-set>

    <xsl:attribute-set name="topic.topic.topic.topic.topic.title" use-attribute-sets="base-font common.title">
        <!--HSX start indent shall be explicitly declared from level 4 otherwise we get side-col-width from parent -->
        <xsl:attribute name="space-before">24.5pt</xsl:attribute>
        <xsl:attribute name="start-indent">0mm</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <!--HSC font size Head5 defaults to 10 -->
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="topic.topic.topic.topic.topic.title__content">
    </xsl:attribute-set>

    <xsl:attribute-set name="topic.topic.topic.topic.topic.topic.title" use-attribute-sets="base-font common.title">
        <!--HSX start indent shall be explicitly declared from level 4 otherwise we get side-col-width from parent -->
        <xsl:attribute name="space-before">22.6pt</xsl:attribute>
        <xsl:attribute name="start-indent">0mm</xsl:attribute>
        <xsl:attribute name="font-style">italic</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <!--HSC can be highlighted acc. to [DtPrt#10.6.1]
        <xsl:attribute name="color">#ff00ff</xsl:attribute> -->
    </xsl:attribute-set>

    <xsl:attribute-set name="topic.topic.topic.topic.topic.topic.title__content">
    </xsl:attribute-set>

    <xsl:attribute-set name="section.title" use-attribute-sets="common.title">
        <!--HSC don't need to add sans-serif [DtPrt#10.3.3] as section title calls
        common.title above
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        -->
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>

        <xsl:attribute name="color">
            <xsl:value-of select="$Section-title"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="space-before">25.2pt</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>

        <xsl:attribute name="start-indent">0mm</xsl:attribute>
        <xsl:attribute name="padding-left">0mm</xsl:attribute>
        <xsl:attribute name="padding-top">2pt</xsl:attribute>
        <xsl:attribute name="padding-bottom">0pt</xsl:attribute>
        <xsl:attribute name="background-color">#FFFFFF</xsl:attribute>

        <!--HSX borders -->
        <xsl:attribute name="border-top-style">solid</xsl:attribute>
        <xsl:attribute name="border-top-width">0.5mm</xsl:attribute>
        <xsl:attribute name="border-top-color">#C0C0C1</xsl:attribute>

        <xsl:attribute name="border-bottom-style">none</xsl:attribute>
        <xsl:attribute name="border-bottom-width">1.5pt</xsl:attribute>
        <xsl:attribute name="border-bottom-color">#0080FF</xsl:attribute>



            <!--HSX Attention -
                Below we define padding-left (that's OK) but this defines an offset
                that we have to recompensate in the start-indent.

                So with padding-left=2mm, we would have to add 2mm
                to side-col-width (here) in order to get the section aligned to
                side-col-width.

                That's all no problem, but you have to respect that because
                obviously padding-left does not care about start-indent and
                spills into the left margin. That's also OK but you need to know.

                I also tried [xslfo#5.10.4] from-nearest-specified-value but this
                only picks the nearest ancestor, not our own definition.
            <xsl:value-of select="concat($side-col-width, ' + from-nearest-specified-value(padding-left)')"/>
        <xsl:attribute name="start-indent">
            <xsl:variable name="mmSideColWidth">
                <xsl:call-template name="convertUnits">
                    <xsl:with-param name="numUnit"   select="$side-col-width"/>
                    <xsl:with-param name="inUnitsOf" select="'mm'"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:value-of select="concat($mmSideColWidth + 2,'mm')" />
        </xsl:attribute>
            -->
    </xsl:attribute-set>

    <!-- ============================== SECTION.TITLE.BLOCK =================== -->

    <xsl:attribute-set name="section.title.Block" use-attribute-sets="common.title">
        <!--HSC don't need to add sans-serif [DtPrt#10.3.3] as section title calls
        common.title above
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        -->
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>

        <!-- these statement do nothing since the float text uses p_marginalia_heading
        <xsl:attribute name="color">#000103</xsl:attribute>
        <xsl:attribute name="font-size">14pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        -->

        <xsl:attribute name="space-before">25.2pt</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>

        <xsl:attribute name="start-indent">0mm</xsl:attribute>
        <xsl:attribute name="padding-left">0mm</xsl:attribute>
        <xsl:attribute name="padding-top">2pt</xsl:attribute>
        <xsl:attribute name="padding-bottom">0pt</xsl:attribute>
        <xsl:attribute name="background-color">#FFFFFF</xsl:attribute>

        <!--HSX borders -->
        <xsl:attribute name="border-top-style">solid</xsl:attribute>
        <xsl:attribute name="border-top-width">0.5mm</xsl:attribute>
        <xsl:attribute name="border-top-color">#C0C0C1</xsl:attribute>

        <xsl:attribute name="border-bottom-style">none</xsl:attribute>
        <xsl:attribute name="border-bottom-width">1.5pt</xsl:attribute>
        <xsl:attribute name="border-bottom-color">#0080FF</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="section.title.flow" use-attribute-sets="section.title.Block">
        <xsl:attribute name="start-indent">
            <xsl:value-of select="$side-col-width"/>
        </xsl:attribute>
        <xsl:attribute name="color">#000103</xsl:attribute>
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="padding-bottom">13pt</xsl:attribute>
    </xsl:attribute-set>

    <!--HSX the next padding determines the distance between text and top-ruler  -->
    <xsl:attribute-set name="section.title.flow.text">
        <xsl:attribute name="padding-top">1.5pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="section.title.page" use-attribute-sets="section.title.Block">
        <xsl:attribute name="start-indent">0mm</xsl:attribute>
        <xsl:attribute name="color">#000102</xsl:attribute>
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="padding-bottom">13pt</xsl:attribute>
    </xsl:attribute-set>

    <!--HSX the next padding determines the distance between text and top-ruler  -->
    <xsl:attribute-set name="section.title.page.text">
        <xsl:attribute name="padding-top">1.5pt</xsl:attribute>
    </xsl:attribute-set>


    <xsl:attribute-set name="example.title" use-attribute-sets="common.title">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="space-after">5pt</xsl:attribute>
    </xsl:attribute-set>

    <!--HSX the following attributes only apply to figures with
        frame=none
    -->
    <xsl:attribute-set name="fig">
        <xsl:attribute name="padding-top">0pt</xsl:attribute>
        <xsl:attribute name="padding-bottom">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="fig.titleAbove">
        <xsl:attribute name="padding-top">0pt</xsl:attribute>
        <xsl:attribute name="padding-bottom">2pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="fig.titleBelow">
        <xsl:attribute name="padding-top">2pt</xsl:attribute>
        <xsl:attribute name="padding-bottom">0pt</xsl:attribute>
    </xsl:attribute-set>

    <!--HSC [DtPrt#14.5] requires separation between figure title on top or bottom -->
    <xsl:attribute-set name="fig.title.bottom" use-attribute-sets="base-font common.title">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="space-after">10pt</xsl:attribute>
        <!--HSC More settings acc. to [DtPrt#14.3] -->
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$Figure-titleBottomCaption"/>
        </xsl:attribute>
        <!-- end of more settings -->
        <xsl:attribute name="keep-with-previous.within-page">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="fig.title.bottom.text">
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$Figure-titleBottomText"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <!--HSC [DtPrt#14.5] requires separation between figure title on top or bottom -->
    <xsl:attribute-set name="fig.title.top" use-attribute-sets="base-font common.title">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="space-before">5pt</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
        <!--HSC More settings acc. to [DtPrt#14.3] -->
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$Figure-titleTopCaption"/>
        </xsl:attribute>
        <!-- end of more settings -->
        <xsl:attribute name="keep-with-next.within-page">always</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="fig.title.top.text">
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$Figure-titleTopText"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="topic" use-attribute-sets="base-font">
    </xsl:attribute-set>

    <xsl:attribute-set name="titlealts" use-attribute-sets="common.border">
        <xsl:attribute name="background-color">#f0f0d0</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="navtitle" use-attribute-sets="common.title">
    </xsl:attribute-set>

    <xsl:attribute-set name="navtitle__label">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="searchtitle">
    </xsl:attribute-set>

    <xsl:attribute-set name="searchtitle__label">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <!--HSC line-height suggestion possible acc. to [DtPrt#10.4.4] -->
    <xsl:attribute-set name="body__toplevel" use-attribute-sets="base-font">
        <xsl:attribute name="start-indent">
            <xsl:value-of select="$side-col-width"/>
        </xsl:attribute>
        <!--
        <xsl:attribute name="line-height">
            <xsl:value-of select="$default-line-height"/>
        </xsl:attribute>
        -->
    </xsl:attribute-set>

    <!--HSC line-height suggestion possible acc. to [DtPrt#10.4.4] -->
    <xsl:attribute-set name="body__secondLevel" use-attribute-sets="base-font">
        <xsl:attribute name="start-indent">
            <xsl:value-of select="$side-col-width"/>
        </xsl:attribute>
        <!--
        <xsl:attribute name="line-height">
            <xsl:value-of select="$default-line-height"/>
        </xsl:attribute>
        -->
    </xsl:attribute-set>

    <xsl:attribute-set name="body" use-attribute-sets="base-font">
        <xsl:attribute name="start-indent">
            <xsl:value-of select="$side-col-width"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$default-line-height"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="abstract" use-attribute-sets="body">
    </xsl:attribute-set>

    <!--HSX used in format-shortdesc-as-inline -->
    <xsl:attribute-set name="shortdesc">
        <xsl:attribute name="keep-with-previous">1</xsl:attribute>
        <xsl:attribute name="font-size">9pt</xsl:attribute>
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$Shortdesc-inline"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <!--HSX used in format-shortdesc-as-block -->
    <xsl:attribute-set name="topic__shortdesc" use-attribute-sets="body">
        <xsl:attribute name="keep-with-previous">1</xsl:attribute>
        <xsl:attribute name="font-size">9pt</xsl:attribute>
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$Shortdesc-asBlock"/>
        </xsl:attribute>
        <xsl:attribute name="space-after">9pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="minitoc__shortdesc" use-attribute-sets="body">
        <xsl:attribute name="keep-with-previous">1</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$Shortdesc-asBlock"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">9pt</xsl:attribute>
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="section" use-attribute-sets="base-font">
        <!--HSC Lineheight set in [DtPrt#10.4.4] basses on variable in basic-settings.xsl -->
        <xsl:attribute name="line-height">
            <xsl:value-of select="$default-line-height"/>
        </xsl:attribute>
        <xsl:attribute name="space-before">0.6em</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="section__content">
        <!--HSC insertions to appearance acc. to [DtPrt#12.6] -->
        <xsl:attribute name="font-size">
            <xsl:value-of select="$default-font-size"/>
        </xsl:attribute>
        <xsl:attribute name="line-height">
            <xsl:value-of select="$default-line-height"/>
        </xsl:attribute>
        <xsl:attribute name="color">#020103</xsl:attribute>
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <!-- end changes -->
    </xsl:attribute-set>

    <xsl:attribute-set name="parent__indent">
        <xsl:attribute name="start-indent">from-parent(start-indent)</xsl:attribute>
        <xsl:attribute name="end-indent">from-parent(end-indent)</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="example" use-attribute-sets="base-font common.border">
        <xsl:attribute name="line-height">
            <xsl:value-of select="$default-line-height"/>
        </xsl:attribute>
        <xsl:attribute name="space-before">0.6em</xsl:attribute>
        <!--HSX with the introduction of marginalia we need an option
                to span over the entire page
        -->
        <xsl:attribute name="start-indent">
            <xsl:choose>
                <xsl:when test="contains(@outputclass, 'page')">
                    <xsl:value-of select="'0mm'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'36pt + from-parent(start-indent)'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="end-indent">
            <xsl:choose>
                <xsl:when test="contains(@outputclass, 'page')">
                    <xsl:value-of select="'0mm'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'36pt'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="padding">5pt</xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="example__content">
    </xsl:attribute-set>

    <xsl:attribute-set name="desc">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="prolog" use-attribute-sets="base-font">
        <xsl:attribute name="start-indent">72pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="div">
    </xsl:attribute-set>

    <xsl:attribute-set name="p" use-attribute-sets="common.block">
        <xsl:attribute name="text-indent">0em</xsl:attribute>
        <!--HSX I had to add this statement to indent Head1 body text which did not follow
        the side-col-width in basic-settings.xsl -->
        <xsl:attribute name="start-indent">
            <xsl:call-template name="setListMargin"/>
            <!--
            <xsl:value-of select="$side-col-width"/>
            -->
        </xsl:attribute>
    </xsl:attribute-set>

    <!--HSX p_noSpaces does not use common.block -->
    <xsl:attribute-set name="p_noSpaces">
        <xsl:attribute name="text-indent">0em</xsl:attribute>
        <xsl:attribute name="start-indent">
            <xsl:value-of select="$side-col-width"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <!--HSX p_titleBefore aligns first text with title of section:outputclass=mrg -->
    <xsl:attribute-set name="p_titleBefore">
        <xsl:attribute name="text-indent">0em</xsl:attribute>
        <xsl:attribute name="space-before">2pt</xsl:attribute>
        <xsl:attribute name="start-indent">
            <xsl:value-of select="$side-col-width"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="p_marginalia">
        <xsl:attribute name="text-indent">0em</xsl:attribute>
        <xsl:attribute name="start-indent">0pt</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="marginaliaFont"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">9pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">italic</xsl:attribute>
        <xsl:attribute name="line-height">100%</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="p_marginalia_heading">
        <xsl:attribute name="text-indent">0em</xsl:attribute>
        <xsl:attribute name="start-indent">0pt</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="marginaliaFont"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="line-height">100%</xsl:attribute>
    </xsl:attribute-set>

    <!--HSX about the attributes ...
        margin-top moves the entire box
        padding-top move only the content (text or graphics), negative values move up
        text-align places image/text within the block
        end-indent moves to the left (works nice with text-align=right

        space-before does nothing
        top="20pt" does nothing
    -->
    <xsl:attribute-set name="p_marginalia_dialog_content">
        <!--
        <xsl:attribute name="background-color">#e6e6e6</xsl:attribute>
        -->

        <xsl:attribute name="height">10mm</xsl:attribute>
        <xsl:attribute name="padding-top">-2pt</xsl:attribute>
        <xsl:attribute name="text-align">right</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="p_marginalia_dialog">
        <xsl:attribute name="text-indent">0em</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$FmColor-RoyalBlue30"/>
        </xsl:attribute>

        <xsl:attribute name="font-size">9pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="font-style">italic</xsl:attribute>
        <xsl:attribute name="line-height">100%</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="p_marginalia_dialog_text">
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="text-indent">0em</xsl:attribute>
        <xsl:attribute name="start-indent">
            <xsl:value-of select="$side-col-width"/>
        </xsl:attribute>
        <xsl:attribute name="padding-bottom">12pt</xsl:attribute>
    </xsl:attribute-set>


    <xsl:attribute-set name="lq" use-attribute-sets="base-font common.border">
        <xsl:attribute name="space-before">10pt</xsl:attribute>
        <xsl:attribute name="padding-left">6pt</xsl:attribute>
        <xsl:attribute name="start-indent">92pt</xsl:attribute>
        <xsl:attribute name="end-indent">92pt</xsl:attribute>
        <xsl:attribute name="text-align">start</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="lq_simple" use-attribute-sets="base-font common.border">
        <xsl:attribute name="space-before">10pt</xsl:attribute>
        <xsl:attribute name="space-after">10pt</xsl:attribute>
        <xsl:attribute name="padding-left">6pt</xsl:attribute>
        <xsl:attribute name="start-indent">92pt</xsl:attribute>
        <xsl:attribute name="end-indent">92pt</xsl:attribute>
        <xsl:attribute name="text-align">start</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="lq_link" use-attribute-sets="base-font common.link">
        <xsl:attribute name="space-after">10pt</xsl:attribute>
        <xsl:attribute name="end-indent">92pt</xsl:attribute>
        <xsl:attribute name="text-align">end</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="lq_title" use-attribute-sets="base-font">
        <xsl:attribute name="space-after">10pt</xsl:attribute>
        <xsl:attribute name="end-indent">92pt</xsl:attribute>
        <xsl:attribute name="text-align">end</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="font-style">italic</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="q">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="figgroup">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note" use-attribute-sets="common.block">
        <!--HSC Example for changes in [DtPrt#10.4.2] and [DtPrt#10.5] and [DtPrt#10.5.5]
        <xsl:attribute name="font-size">9pt</xsl:attribute>
        <xsl:attribute name="margin-right">.5in</xsl:attribute>
        <xsl:attribute name="margin-left">.5in</xsl:attribute>
        <xsl:attribute name="text-align">justify</xsl:attribute>
        and for borders (padding improves the layout)acc. to [DtPart#10.5.6]
        <xsl:attribute name="border-left">2pt double #990032</xsl:attribute>
        <xsl:attribute name="border-right">2pt double #990032</xsl:attribute>     or
        <xsl:attribute name="padding-left">5pt</xsl:attribute>
        <xsl:attribute name="font-size">8pt</xsl:attribute>
        <xsl:attribute name="padding-right">5pt</xsl:attribute> -->
    </xsl:attribute-set>

    <!-- used by <xsl:template match="*" mode="placeNoteContent">
    -->
    <xsl:attribute-set name="note__borders" use-attribute-sets="common.block">
        <!--HSC Example for changes in [DtPrt#10.4.2] and [DtPrt#10.5] and [DtPrt#10.5.5] -->
        <xsl:attribute name="border-top-style">solid</xsl:attribute>
        <xsl:attribute name="border-top-width">1pt</xsl:attribute>
        <xsl:attribute name="border-top-color">#C0C0C3</xsl:attribute>
        <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
        <xsl:attribute name="border-bottom-width">1pt</xsl:attribute>
        <xsl:attribute name="border-bottom-color">#C0C0C3</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__table" use-attribute-sets="common.block">
    </xsl:attribute-set>

    <xsl:attribute-set name="note__image__column">
        <xsl:attribute name="column-number">1</xsl:attribute>
        <xsl:attribute name="column-width">
            <xsl:variable name="noteImagePath">
                <xsl:apply-templates select="." mode="setNoteImagePath"/>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="$noteImagePath = ''">
                    <xsl:value-of select="'0.1pt'"/>
                </xsl:when>
                <xsl:when test="contains(@outputclass, 'noImage')">
                    <xsl:value-of select="'0.2pt'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'32pt'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>
    <xsl:attribute-set name="note__image__entry">
        <xsl:attribute name="start-indent">0pt</xsl:attribute>
        <xsl:attribute name="end-indent">0pt</xsl:attribute>
        <xsl:attribute name="padding-right">5pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__label__column">
        <xsl:attribute name="column-number">2</xsl:attribute>
        <xsl:attribute name="column-width">
            <xsl:choose>
                <xsl:when test="contains(@outputclass, 'noLabel')">
                    <xsl:value-of select="'0pt'"/>
                </xsl:when>
                <!--HSX compute an approximated with for the choosen font
                    basepitch = statistical width of a letter in deci-points

                    You can optimize every note type through a special when clause
                    before the test="@type" e.g.

                    <xsl:when test="@type = 'Warning'">
                        <xsl:value-of select="'46pt'"/>
                    </xsl:when>
                -->
                <xsl:otherwise>
                    <xsl:variable name="basepitch" select="55"/>
                    <xsl:choose>
                        <xsl:when test="@type = 'remember'">
                            <xsl:value-of select="'60pt'"/>
                        </xsl:when>
                        <xsl:when test="@type = 'other'">
                            <xsl:value-of select="concat(string(round($basepitch * (string-length(@othertype) + 1)) div 10), 'pt')"/>
                        </xsl:when>
                        <xsl:when test="@type">
                            <xsl:value-of select="concat(string(round($basepitch * (string-length(@type) + 1)) div 10), 'pt')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat(string(round($basepitch * string-length('Note :')) div 10), 'pt')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__label__entry">
        <xsl:attribute name="start-indent">0pt</xsl:attribute>
        <xsl:attribute name="end-indent">0pt</xsl:attribute>
        <xsl:attribute name="width">10mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__text__column">
        <xsl:attribute name="column-number">3</xsl:attribute>
        <xsl:attribute name="column-width">proportional-column-width(1.0)</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__text__entry">
        <xsl:attribute name="start-indent">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__label">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <!--HSC Color can be added to the note label
        so Note: comes out highlighted [DtPrt#10.5.1] -->
        <xsl:attribute name="color">
            <xsl:value-of select="$Note-label"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="note__label__note">
    </xsl:attribute-set>

    <xsl:attribute-set name="note__label__notice">
    </xsl:attribute-set>

    <xsl:attribute-set name="note__label__attention">
    </xsl:attribute-set>

    <xsl:attribute-set name="note__label__caution">
    </xsl:attribute-set>

    <xsl:attribute-set name="note__label__tip">
    </xsl:attribute-set>

    <xsl:attribute-set name="note__label__danger">
    </xsl:attribute-set>

    <xsl:attribute-set name="note__label__warning">
    </xsl:attribute-set>

    <xsl:attribute-set name="note__label__fastpath">
    </xsl:attribute-set>

    <xsl:attribute-set name="note__label__important">
    </xsl:attribute-set>

    <xsl:attribute-set name="note__label__remember">
    </xsl:attribute-set>

    <xsl:attribute-set name="note__label__restriction">
    </xsl:attribute-set>

    <xsl:attribute-set name="note__label__trouble">
    </xsl:attribute-set>

    <xsl:attribute-set name="note__label__other">
    </xsl:attribute-set>

    <!--HSX [Xslfo#1.2.1] explains linefeed-treatment and wrap-option which
    might be relevant to set the correct behaviour [Xslfo#4.5] explains Line areas (good!) -->
    <xsl:attribute-set name="pre" use-attribute-sets="base-font common.block">
        <!--HSC [Xslfo#7.16.8]  -->
        <xsl:attribute name="white-space-treatment">preserve</xsl:attribute>
        <!--HSC [Xslfo#7.16.12]  -->
        <xsl:attribute name="white-space-collapse">false</xsl:attribute>
        <!--HSC [Xslfo#7.16.12] -->
        <xsl:attribute name="linefeed-treatment">preserve</xsl:attribute>
        <!--HSC [Xslfo#7.16.7]  -->
        <xsl:attribute name="wrap-option">wrap</xsl:attribute>
        <!--HSC [Xslfo#7.16.13] -->
        <!--HSC Example for changes in [DtPrt#10.4.3]
        <xsl:attribute name="background-color">#e6e6e6</xsl:attribute>
        -->
        <xsl:attribute name="background-color">#f0f0f0</xsl:attribute>
        <xsl:attribute name="font-family">monospace</xsl:attribute>
        <xsl:attribute name="line-height">106%</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__spectitle">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__border__right" use-attribute-sets="common.border__right">
        <xsl:attribute name="border-right-color">
            <xsl:value-of select="$Frame-color"/>
        </xsl:attribute>
        <xsl:attribute name="padding-right">3pt</xsl:attribute>
        <xsl:attribute name="end-indent">3pt + from-parent(end-indent)</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__border__left" use-attribute-sets="common.border__left">
        <xsl:attribute name="border-left-color">
            <xsl:value-of select="$Frame-color"/>
        </xsl:attribute>
        <xsl:attribute name="padding-left">3pt</xsl:attribute>
        <xsl:attribute name="start-indent">3pt + from-parent(start-indent)</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__border__top" use-attribute-sets="common.border__top">
        <xsl:attribute name="border-top-color">
            <xsl:value-of select="$Frame-color"/>
        </xsl:attribute>
        <xsl:attribute name="padding-top">3pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__border__bot" use-attribute-sets="common.border__bottom">
        <xsl:attribute name="border-bottom-color">
            <xsl:value-of select="$Frame-color"/>
        </xsl:attribute>
        <xsl:attribute name="padding-bottom">3pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__border__topbot" use-attribute-sets="__border__top __border__bot">
    </xsl:attribute-set>

    <xsl:attribute-set name="__border__sides" use-attribute-sets="__border__right __border__left">
    </xsl:attribute-set>

    <xsl:attribute-set name="__border__all" use-attribute-sets="__border__right __border__left __border__top __border__bot">
    </xsl:attribute-set>

    <xsl:attribute-set name="lines" use-attribute-sets="base-font">
        <xsl:attribute name="space-before">0.8em</xsl:attribute>
        <xsl:attribute name="space-after">0.8em</xsl:attribute>
        <!--        <xsl:attribute name="white-space-treatment">ignore-if-after-linefeed</xsl:attribute>-->
        <xsl:attribute name="white-space-collapse">true</xsl:attribute>
        <xsl:attribute name="linefeed-treatment">preserve</xsl:attribute>
        <xsl:attribute name="wrap-option">wrap</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="keyword">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="term">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
        <xsl:attribute name="font-style">italic</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="ph">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="boolean">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
        <xsl:attribute name="color">green</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="state">
        <xsl:attribute name="border-left-width">0pt</xsl:attribute>
        <xsl:attribute name="border-right-width">0pt</xsl:attribute>
        <xsl:attribute name="color">red</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="alt">
    </xsl:attribute-set>

    <xsl:attribute-set name="object">
    </xsl:attribute-set>

    <xsl:attribute-set name="param">
    </xsl:attribute-set>

    <xsl:attribute-set name="draft-comment" use-attribute-sets="common.border">
        <xsl:attribute name="background-color">#FF99FF</xsl:attribute>
        <xsl:attribute name="color">#CC3333</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="draft-comment__label">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="required-cleanup">
        <xsl:attribute name="background">yellow</xsl:attribute>
        <xsl:attribute name="color">#CC3333</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="required-cleanup__label">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="fn">
        <xsl:attribute name="font-size">8pt</xsl:attribute>
        <xsl:attribute name="color">purple</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="fn__id">
        <xsl:attribute name="font-style">italic</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="fn__callout">
        <xsl:attribute name="keep-with-previous.within-line">always</xsl:attribute>
        <xsl:attribute name="baseline-shift">super</xsl:attribute>
        <xsl:attribute name="font-size">75%</xsl:attribute>
        <!--HSC [DtPrt#15.5.1] changes the format of footnotes, here only those
        on top of fn__body are necessary -->
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$Footnote-callout"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="fn__body" use-attribute-sets="base-font">
        <xsl:attribute name="provisional-distance-between-starts">8mm</xsl:attribute>
        <xsl:attribute name="provisional-label-separation">2mm</xsl:attribute>
        <xsl:attribute name="line-height">1.2</xsl:attribute>
        <xsl:attribute name="start-indent">0pt</xsl:attribute>
        <!--HSC [DtPrt#15.5.1] changes the format of footnotes -->
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="font-size">9pt</xsl:attribute>
        <xsl:attribute name="font-style">italic</xsl:attribute>
        <xsl:attribute name="color">#8A8A86</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__align__left">
        <xsl:attribute name="text-align">start</xsl:attribute>
        <xsl:attribute name="display-align">before</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__align__right">
        <xsl:attribute name="text-align">end</xsl:attribute>
        <xsl:attribute name="display-align">before</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__align__center">
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="display-align">before</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__align__justify">
        <xsl:attribute name="text-align">justify</xsl:attribute>
        <xsl:attribute name="display-align">before</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="indextermref">
        <xsl:attribute name="font-style">italic</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="cite">
        <xsl:attribute name="font-style">italic</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="concept">
    </xsl:attribute-set>

    <!--HSX "body" is VERY GENERAL, so we do not respect $side-col-width
    at this point because this attribute is called by very major
    topics (e.g. conbody) which have children (e.g. section.title) that
    do explicitly not want to obey $side-col-width.

    As a consequence, we override start-ident and go back to 0mm.

    Therefore the actual consideration of $side-col-width will be done
    in the separate sections

    So change this value 0mm only for the most general indentation
    that you want to apply basically in your document. otherwise
    visit the separate sections
    <xsl:value-of select="'0mm'"/>
    -->

    <xsl:attribute-set name="conbody" use-attribute-sets="body">
        <xsl:attribute name="start-indent">0mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="topichead">
    </xsl:attribute-set>

    <xsl:attribute-set name="topicgroup">
    </xsl:attribute-set>

    <xsl:attribute-set name="topicmeta">
    </xsl:attribute-set>

    <xsl:attribute-set name="searchtitle">
    </xsl:attribute-set>

    <xsl:attribute-set name="searchtitle__label">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="publisher">
    </xsl:attribute-set>

    <xsl:attribute-set name="copyright">
    </xsl:attribute-set>

    <xsl:attribute-set name="copyryear">
    </xsl:attribute-set>

    <xsl:attribute-set name="copyrholder">
    </xsl:attribute-set>

    <xsl:attribute-set name="critdates">
    </xsl:attribute-set>

    <xsl:attribute-set name="created">
    </xsl:attribute-set>

    <xsl:attribute-set name="revised">
    </xsl:attribute-set>

    <xsl:attribute-set name="permissions">
    </xsl:attribute-set>

    <xsl:attribute-set name="category">
    </xsl:attribute-set>

    <xsl:attribute-set name="audience">
    </xsl:attribute-set>

    <xsl:attribute-set name="keywords">
    </xsl:attribute-set>

    <xsl:attribute-set name="prodinfo">
    </xsl:attribute-set>

    <xsl:attribute-set name="prodname">
    </xsl:attribute-set>

    <xsl:attribute-set name="vrmlist">
    </xsl:attribute-set>

    <xsl:attribute-set name="vrm">
    </xsl:attribute-set>

    <xsl:attribute-set name="brand">
    </xsl:attribute-set>

    <xsl:attribute-set name="series">
    </xsl:attribute-set>

    <xsl:attribute-set name="platform">
    </xsl:attribute-set>

    <xsl:attribute-set name="prognum">
    </xsl:attribute-set>

    <xsl:attribute-set name="featnum">
    </xsl:attribute-set>

    <xsl:attribute-set name="component">
    </xsl:attribute-set>

    <xsl:attribute-set name="othermeta">
    </xsl:attribute-set>

    <xsl:attribute-set name="resourceid">
    </xsl:attribute-set>

    <xsl:attribute-set name="reference">
    </xsl:attribute-set>

    <!--HSX "body" is VERY GENERAL, so we do not respect $side-col-width
    at this point because this attribute is called by very major
    topics (e.g. conbody) which have children (e.g. section.title) that
    do explicitly not want to obey $side-col-width.

    As a consequence, we override start-ident and go back to 0mm.

    Therefore the actual consideration of $side-col-width will be done
    in the separate sections

    So change this value 0mm only for the most general indentation
    that you want to apply basically in your document. otherwise
    visit the separate sections
    <xsl:value-of select="'0mm'"/>
    -->
    <xsl:attribute-set name="refbody" use-attribute-sets="body">
        <xsl:attribute name="start-indent">0mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="refsyn">
    </xsl:attribute-set>

    <xsl:attribute-set name="metadata">
    </xsl:attribute-set>

    <xsl:attribute-set name="image__float">
    </xsl:attribute-set>

    <xsl:attribute-set name="image__block">
        <!--HSC [DtPrt#14.6] allows dynamically scal images to page width
        I don't know whether I want that ... but here are the settings
        Yet only Images with placement="break" will use this attribute set.
        -->
        <xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
        <xsl:attribute name="content-height">100%</xsl:attribute>
        <xsl:attribute name="width">100%</xsl:attribute>
        <xsl:attribute name="scaling">uniform</xsl:attribute>
        <!--HSX added keep condition to avoid breaking the figure -->
        <!-- got some problem on 10 adjacent figures, so the value should be 1
             instead of "always". [XslFo#4.8]  and [XslFo#7.20.5]

        -->
        <xsl:attribute name="keep-with-previous">1</xsl:attribute>

    </xsl:attribute-set>

    <xsl:attribute-set name="image__inline">
        <!--HSC [DtPrt#14.6] allows dynamically scale images to page width
        I don't know whether I want that ... but here are the settings
        Yet only Images with placement="inline" will use this attribute set.
        content-width is described in [Xslfo#7.15.5].
        -->
        <xsl:attribute name="content-width">auto</xsl:attribute>
        <xsl:attribute name="content-height">auto</xsl:attribute>
        <xsl:attribute name="width">auto</xsl:attribute>
        <xsl:attribute name="scaling">uniform</xsl:attribute>
        <xsl:attribute name="keep-with-previous">1</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="list__label__image">
        <xsl:attribute name="width">16px</xsl:attribute>
        <xsl:attribute name="height">16px</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="image">
        <xsl:attribute name="content-width">auto</xsl:attribute>
        <xsl:attribute name="content-width">auto</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="flag.image" use-attribute-sets="image">
    </xsl:attribute-set>

    <xsl:attribute-set name="__unresolved__conref">
        <xsl:attribute name="color">#CC3333</xsl:attribute>
    </xsl:attribute-set>

    <!--HSC     ... changes most of the default fonts (e.g. <p>)  -->
    <xsl:attribute-set name="__fo__root" use-attribute-sets="base-font">
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <!--HSC was serif -->
        <xsl:attribute name="xml:lang" select="translate($locale, '_', '-')"/>
        <xsl:attribute name="writing-mode" select="$writing-mode"/>
    </xsl:attribute-set>

    <xsl:attribute-set name="__force__page__count">
        <xsl:attribute name="force-page-count">
            <xsl:choose>
                <xsl:when test="/*[contains(@class, ' bookmap/bookmap ')]">
                    <!-- ... suppress blank pages at the end of chapters (from 'even' to 'auto') [DtPrt#7.12.1] -->
                    <xsl:value-of select="'auto'"/>
                </xsl:when>
                <xsl:otherwise>
                    <!-- ... set value to 'even'  (here auto) if you want to make maps equal to bookmaps [tPrt#7.12.3] -->
                    <xsl:value-of select="'auto'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <!-- [DtPrt#16.15.2] allows separate formatting of the mini-TOC -->
    <xsl:attribute-set name="xref__mini__toc">
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="color">black</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>

        <xsl:attribute name="text-align-last">justify</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="upshift.1">
        <!--HSX margin-left needs to be set by variable in commons.xsl
        <xsl:attribute name="margin-left">
        <xsl:value-of select="$HeadtextIndent"/>
        </xsl:attribute>
        -->
        <xsl:attribute name="margin-top">-<xsl:value-of select="$upShiftHead-1" />
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="upshift.2">
        <xsl:attribute name="margin-top">-<xsl:value-of select="$upShiftHead-2" />
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="upshift.3">
        <xsl:attribute name="margin-top">-<xsl:value-of select="$upShiftHead-3" />
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="upshift.4">
        <xsl:attribute name="margin-top">-<xsl:value-of select="$upShiftHead-4" />
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="upshift.5">
        <xsl:attribute name="margin-top">-<xsl:value-of select="$upShiftHead-5" />
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="upshift.6">
        <xsl:attribute name="margin-top">-<xsl:value-of select="$upShiftHead-6" />
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="glossgroup.block">
        <xsl:attribute name="space-after">13mm</xsl:attribute>
    </xsl:attribute-set>


    <!-- you can best learn the possible icons by checking Acrobat Annotation Properties
    The names given there respect capitals but you need to remove the whitespaces to get the correct name

    Text
    Comment Help Insert Key NewParagraph Note Paragraph UpArrow RightPointer
    File attachment
    Graph Paperclip PushPin Tag

    Annotation Flags are described in [pdf#12.5.3]
    -->

    <xsl:attribute-set name="changeBarInsert">
        <xsl:attribute name="change-bar-style">solid</xsl:attribute>
        <xsl:attribute name="change-bar-color">blue</xsl:attribute>
        <xsl:attribute name="change-bar-offset">4mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="changeBarDelete">
        <xsl:attribute name="change-bar-style">solid</xsl:attribute>
        <xsl:attribute name="change-bar-color">red</xsl:attribute>
        <xsl:attribute name="change-bar-offset">1mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="markInsert">
        <xsl:attribute name="color">green</xsl:attribute>
        <xsl:attribute name="background-color">#F0F0F0</xsl:attribute>
    </xsl:attribute-set>
    <!-- [AHF#20] shows the axf:annotation properties -->
    <xsl:attribute-set name="markInsertAxf">
        <xsl:attribute name="axf:annotation-position-horizontal">2pt</xsl:attribute>
        <xsl:attribute name="axf:annotation-position-vertical">
            <xsl:value-of select="$annot-vertical-offset"/>
        </xsl:attribute>
        <xsl:attribute name="axf:annotation-type">Text</xsl:attribute>
        <xsl:attribute name="axf:annotation-font-size">10pt</xsl:attribute>
        <xsl:attribute name="axf:annotation-title">UnknownTitle</xsl:attribute>
        <xsl:attribute name="axf:annotation-text-color">red</xsl:attribute>
        <xsl:attribute name="axf:annotation-icon-name">Comment</xsl:attribute>
        <xsl:attribute name="axf:annotation-color">#FFFF00</xsl:attribute>
    </xsl:attribute-set>

    <!-- [Xslfo#7.17.4] for text-decoration -->
    <xsl:attribute-set name="markDelete">
        <xsl:attribute name="text-decoration">line-through</xsl:attribute>
        <xsl:attribute name="color">red</xsl:attribute>
        <xsl:attribute name="axf:annotation-author">
            <xsl:value-of select="$logonuser"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="markDeleteAxf">
        <xsl:attribute name="axf:annotation-position-horizontal">2pt</xsl:attribute>
        <xsl:attribute name="axf:annotation-position-vertical">
            <xsl:value-of select="$annot-vertical-offset"/>
        </xsl:attribute>
        <xsl:attribute name="axf:annotation-width">70mm</xsl:attribute>
        <xsl:attribute name="axf:annotation-height">42mm</xsl:attribute>
        <xsl:attribute name="axf:annotation-flags">NoRotate</xsl:attribute>
        <xsl:attribute name="axf:annotation-type">Text</xsl:attribute>
        <xsl:attribute name="axf:annotation-icon-name">Comment</xsl:attribute>
        <xsl:attribute name="axf:annotation-font-size">10pt</xsl:attribute>
        <xsl:attribute name="axf:annotation-font-style">normal</xsl:attribute>
        <xsl:attribute name="axf:annotation-font-weight">normal</xsl:attribute>
        <xsl:attribute name="axf:annotation-font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="axf:annotation-title">UnknownTitle</xsl:attribute>
        <xsl:attribute name="axf:annotation-text-color">red</xsl:attribute>
        <xsl:attribute name="axf:annotation-color">#FFA080</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="markComment">
        <xsl:attribute name="background-color">#E0E0E0</xsl:attribute>
        <xsl:attribute name="text-decoration">underline</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="markCommentAxf">
        <xsl:attribute name="axf:annotation-position-horizontal">2pt</xsl:attribute>
        <xsl:attribute name="axf:annotation-position-vertical">
            <xsl:value-of select="$annot-vertical-offset"/>
        </xsl:attribute>
        <xsl:attribute name="axf:annotation-type">Text</xsl:attribute>
        <xsl:attribute name="axf:annotation-font-size">10pt</xsl:attribute>
        <xsl:attribute name="axf:annotation-title">UnknownTitle</xsl:attribute>
        <xsl:attribute name="axf:annotation-text-color">red</xsl:attribute>
        <xsl:attribute name="axf:annotation-icon-name">Comment</xsl:attribute>
        <xsl:attribute name="axf:annotation-color">#FFFF00</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="markCustom">
    </xsl:attribute-set>


    <xsl:attribute-set name="page-sequence.cover" use-attribute-sets="__force__page__count"> </xsl:attribute-set>

    <xsl:attribute-set name="page-sequence.notice" use-attribute-sets="__force__page__count">
        <xsl:attribute name="format">i</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="page-sequence.preface" use-attribute-sets="__force__page__count">
        <xsl:attribute name="format">i</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="page-sequence.toc" use-attribute-sets="__force__page__count">
        <xsl:attribute name="format">i</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="page-sequence.lot" use-attribute-sets="page-sequence.toc"> </xsl:attribute-set>

    <xsl:attribute-set name="page-sequence.lof" use-attribute-sets="page-sequence.toc"> </xsl:attribute-set>

    <xsl:attribute-set name="page-sequence.body" use-attribute-sets="__force__page__count"> </xsl:attribute-set>

    <xsl:attribute-set name="page-sequence.part" use-attribute-sets="__force__page__count"> </xsl:attribute-set>

    <xsl:attribute-set name="page-sequence.appendix" use-attribute-sets="__force__page__count"> </xsl:attribute-set>

    <xsl:attribute-set name="page-sequence.glossary" use-attribute-sets="__force__page__count"> </xsl:attribute-set>

    <xsl:attribute-set name="page-sequence.index" use-attribute-sets="__force__page__count"> </xsl:attribute-set>

</xsl:stylesheet>
