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

    <xsl:attribute-set name="task">
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
    <xsl:attribute-set name="taskbody" use-attribute-sets="body">
        <xsl:attribute name="start-indent">0mm</xsl:attribute>
    </xsl:attribute-set>

    <!--HSC after adding the actual lines acc. to [DtPrt#12.8.1] I myself corrected
        the bad positioning of the statement -->
    <xsl:attribute-set name="actualsteps" use-attribute-sets="section">
      <xsl:attribute name="space-before">10pt</xsl:attribute>
      <xsl:attribute name="space-after">3pt</xsl:attribute>
      <xsl:attribute name="color">#8080FF</xsl:attribute>
      <xsl:attribute name="font-family">sans-serif</xsl:attribute>
      <xsl:attribute name="font-size">10pt</xsl:attribute>
      <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="start-indent">
            <xsl:value-of select="$side-col-width"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="prereq" use-attribute-sets="section">
      <!--HSC changes acc. to [DtPrt#12.6] -->
      <xsl:attribute name="color">
        <xsl:value-of select="$Task-prereq"/>
      </xsl:attribute>
      <xsl:attribute name="font-family">sans-serif</xsl:attribute>
      <xsl:attribute name="font-size">12pt</xsl:attribute>
      <xsl:attribute name="font-weight">bold</xsl:attribute>
      <!--HSC end changes -->
    </xsl:attribute-set>
    <xsl:attribute-set name="prereq__content" use-attribute-sets="section__content">
      <!--HSC changes acc. to [DtPrt#12.6] -->
         <!--HSC change could be applied here to the content of the section -->
      <!--HSC end changes -->
    </xsl:attribute-set>

    <xsl:attribute-set name="context" use-attribute-sets="section">
      <!--HSC changes acc. to [DtPrt#12.6] -->
      <xsl:attribute name="font-family">sans-serif</xsl:attribute>
      <xsl:attribute name="font-size">11.2pt</xsl:attribute>
      <xsl:attribute name="font-weight">bold</xsl:attribute>
      <!--HSC end changes -->
    </xsl:attribute-set>

    <xsl:attribute-set name="context__content" use-attribute-sets="section__content">
      <xsl:attribute name="color">
        <xsl:value-of select="$Task-content"/>
      </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="cmd">
    </xsl:attribute-set>

    <xsl:attribute-set name="info">
        <xsl:attribute name="space-before">3pt</xsl:attribute>
        <xsl:attribute name="space-after">3pt</xsl:attribute>
    <!--HSC Example for changes in [DtPrt#10.4.2]
        <xsl:attribute name="font-size">10pt</xsl:attribute>
    -->
        
    </xsl:attribute-set>

    <xsl:attribute-set name="tutorialinfo">
    </xsl:attribute-set>

    <xsl:attribute-set name="stepresult">
    <!--HSC Example for changes in [DtPrt#10.4.2]
        <xsl:attribute name="font-size">10pt</xsl:attribute>
    -->
    </xsl:attribute-set>

    <xsl:attribute-set name="result" use-attribute-sets="section">
      <!--HSC changes acc. to [DtPrt#12.6] -->
      <xsl:attribute name="color">
        <xsl:value-of select="$Task-result"/>
      </xsl:attribute>
      <xsl:attribute name="font-family">sans-serif</xsl:attribute>
      <xsl:attribute name="font-size">12pt</xsl:attribute>
      <xsl:attribute name="font-weight">bold</xsl:attribute>
      <!--HSC end changes -->
    </xsl:attribute-set>
    <xsl:attribute-set name="result__content" use-attribute-sets="section__content">
         <!--HSC change could be applied here to the content of the section -->
    </xsl:attribute-set>

    <xsl:attribute-set name="task.title" use-attribute-sets="common.title">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>

        <xsl:attribute name="color">
            <xsl:value-of select="$Task-title"/>
        </xsl:attribute>
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="space-before">25.2pt</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>

        <xsl:attribute name="start-indent">
            <xsl:value-of select="'0mm'"/>
        </xsl:attribute>
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

    <xsl:attribute-set name="task.example" use-attribute-sets="example">
      <!--HSC changes acc. to [DtPrt#12.6] -->
      <xsl:attribute name="color">
        <xsl:value-of select="$Task-example"/>
      </xsl:attribute>
      <!--HSC I added the background color -->
       <xsl:attribute name="background-color">#F0F0FF</xsl:attribute>
      <xsl:attribute name="font-family">sans-serif</xsl:attribute>
      <xsl:attribute name="font-size">12pt</xsl:attribute>
      <xsl:attribute name="font-weight">bold</xsl:attribute>
      <!--HSC [DtPrt#12.6] suggests to remove the border by overriding the herited
          information from example (which gets from common.border -->
      <xsl:attribute name="border-top-style">none</xsl:attribute>
      <xsl:attribute name="border-bottom-style">none</xsl:attribute>
      <xsl:attribute name="border-left-style">none</xsl:attribute>
      <xsl:attribute name="border-right-style">none</xsl:attribute>
      <!--HSC end changes -->
    </xsl:attribute-set>
    <xsl:attribute-set name="task.example__content" use-attribute-sets="example__content">
       <!--HSC insertion acc. to [DtPrt#12.6] -->
       <xsl:attribute name="font-size"><xsl:value-of select="$default-font-size"/></xsl:attribute>
       <xsl:attribute name="line-height"><xsl:value-of select="$default-line-height"/></xsl:attribute>
       <xsl:attribute name="color">#010204</xsl:attribute>
       <xsl:attribute name="font-family">sans-serif</xsl:attribute>
       <xsl:attribute name="font-weight">normal</xsl:attribute>
       <!--HSC end insertion-->         
    </xsl:attribute-set>

    <xsl:attribute-set name="postreq" use-attribute-sets="section">
      <!--HSC changes acc. to [DtPrt#12.6] -->
      <xsl:attribute name="color">
        <xsl:value-of select="$Task-postreq"/>
      </xsl:attribute>
      <xsl:attribute name="font-family">sans-serif</xsl:attribute>
      <xsl:attribute name="font-size">12pt</xsl:attribute>
      <xsl:attribute name="font-weight">bold</xsl:attribute>
      <!--HSC end changes -->
    </xsl:attribute-set>
    <xsl:attribute-set name="postreq__content" use-attribute-sets="section__content">
    </xsl:attribute-set>

    <xsl:attribute-set name="stepxmp">
    <!--HSC Example for changes in [DtPrt#10.4.2]
        <xsl:attribute name="font-size">10pt</xsl:attribute>
    -->
    </xsl:attribute-set>

    <!--Unordered steps-->
    <xsl:attribute-set name="steps-unordered" use-attribute-sets="ul">
    </xsl:attribute-set>

    <xsl:attribute-set name="steps-unordered.step" use-attribute-sets="ul.li">
    </xsl:attribute-set>

    <xsl:attribute-set name="steps-unordered.step__label" use-attribute-sets="ul.li__label">
    </xsl:attribute-set>

    <xsl:attribute-set name="steps-unordered.step__label__content" use-attribute-sets="ul.li__label__content">
    </xsl:attribute-set>

    <xsl:attribute-set name="steps-unordered.step__body" use-attribute-sets="ul.li__body">
    </xsl:attribute-set>

    <xsl:attribute-set name="steps-unordered.step__content" use-attribute-sets="ul.li__content">
    </xsl:attribute-set>

    <!--Ordered steps-->
    <xsl:attribute-set name="steps" use-attribute-sets="ol">
    </xsl:attribute-set>

    <xsl:attribute-set name="steps.step" use-attribute-sets="ol.li">
        <xsl:attribute name="space-after">3pt</xsl:attribute>
        <xsl:attribute name="space-before">3pt</xsl:attribute>
    </xsl:attribute-set>


    <xsl:attribute-set name="steps.step__label" use-attribute-sets="ol.li__label">
    </xsl:attribute-set>

    <xsl:attribute-set name="steps.step__label__content" use-attribute-sets="ol.li__label__content">
      <!--HSC separate step numbering according to [DtPrt#12.7] is done here -->
      <xsl:attribute name="font-family">sans-serif</xsl:attribute>
      <xsl:attribute name="font-size"><xsl:value-of select="$default-font-size"/></xsl:attribute>
      <xsl:attribute name="font-weight">bold</xsl:attribute>
      <xsl:attribute name="color">
        <xsl:value-of select="$Task-stepLabel"/>
      </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="steps.step__body" use-attribute-sets="ol.li__body">
    </xsl:attribute-set>

    <xsl:attribute-set name="steps.step__content" use-attribute-sets="ol.li__content">
    </xsl:attribute-set>

    <!-- Stepsection (new in DITA 1.2) -->
    <xsl:attribute-set name="stepsection" use-attribute-sets="ul.li">
        <xsl:attribute name="space-after">2pt</xsl:attribute>
        <xsl:attribute name="space-before">2pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="stepsection__label" use-attribute-sets="ul.li__label">
    </xsl:attribute-set>

    <xsl:attribute-set name="stepsection__label__content" use-attribute-sets="ul.li__label__content">
    </xsl:attribute-set>

    <xsl:attribute-set name="stepsection__body" use-attribute-sets="ul.li__body">
        <xsl:attribute name="start-indent" select="$side-col-width"/>
    </xsl:attribute-set>

    <xsl:attribute-set name="stepsection__content" use-attribute-sets="ul.li__content">
    </xsl:attribute-set>

    <!--Substeps-->
    <xsl:attribute-set name="substeps" use-attribute-sets="ol">
        <xsl:attribute name="space-after">3pt</xsl:attribute>
        <xsl:attribute name="space-before">3pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="substeps.substep" use-attribute-sets="ol.li">
    </xsl:attribute-set>

    <xsl:attribute-set name="substeps.substep__label" use-attribute-sets="ol.li__label">
    </xsl:attribute-set>

    <xsl:attribute-set name="substeps.substep__label__content" use-attribute-sets="ol.li__label__content">
      <xsl:attribute name="font-weight">normal</xsl:attribute>
      <!--HSC [DtPrt#12.7] suggests additional attributes found below -->
      <xsl:attribute name="font-family">sans-serif</xsl:attribute>
      <xsl:attribute name="font-size">10pt</xsl:attribute>
      <xsl:attribute name="font-weight">bold</xsl:attribute>
      <xsl:attribute name="color">
        <xsl:value-of select="$Task-substepLabel"/>
      </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="substeps.substep__body" use-attribute-sets="ol.li__body">
    </xsl:attribute-set>

    <xsl:attribute-set name="substeps.substep__content" use-attribute-sets="ol.li__content">
    </xsl:attribute-set>

    <!--Choices-->
    <xsl:attribute-set name="choices" use-attribute-sets="ul">
    </xsl:attribute-set>

    <xsl:attribute-set name="choices.choice" use-attribute-sets="ul.li">
    <!--HSC Example for changes in [DtPrt#10.4.2]
        <xsl:attribute name="font-size">10pt</xsl:attribute>
    -->
    </xsl:attribute-set>

    <xsl:attribute-set name="choices.choice__label" use-attribute-sets="ul.li__label">
    </xsl:attribute-set>

    <xsl:attribute-set name="choices.choice__label__content" use-attribute-sets="ul.li__label__content">
    </xsl:attribute-set>

    <xsl:attribute-set name="choices.choice__body" use-attribute-sets="ul.li__body">
    </xsl:attribute-set>

    <xsl:attribute-set name="choices.choice__content" use-attribute-sets="ul.li__content">
    </xsl:attribute-set>

    <xsl:attribute-set name="choicetable" use-attribute-sets="base-font">
        <!--It is a table container -->
        <xsl:attribute name="width">100%</xsl:attribute>
        <xsl:attribute name="space-after">10pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="choicetable__body"></xsl:attribute-set>

    <xsl:attribute-set name="chhead"></xsl:attribute-set>

    <xsl:attribute-set name="chhead__row"></xsl:attribute-set>

    <xsl:attribute-set name="chrow"></xsl:attribute-set>

    <xsl:attribute-set name="chhead.choptionhd"></xsl:attribute-set>

    <xsl:attribute-set name="chhead.choptionhd__content" use-attribute-sets="common.table.body.entry common.table.head.entry"></xsl:attribute-set>

    <xsl:attribute-set name="chhead.chdeschd"></xsl:attribute-set>

    <xsl:attribute-set name="chhead.chdeschd__content" use-attribute-sets="common.table.body.entry common.table.head.entry"></xsl:attribute-set>

    <xsl:attribute-set name="chrow.choption"></xsl:attribute-set>

    <xsl:attribute-set name="chrow.choption__keycol-content" use-attribute-sets="common.table.body.entry common.table.head.entry"></xsl:attribute-set>

    <xsl:attribute-set name="chrow.choption__content" use-attribute-sets="common.table.body.entry"></xsl:attribute-set>

    <xsl:attribute-set name="chrow.chdesc"></xsl:attribute-set>

    <xsl:attribute-set name="chrow.chdesc__keycol-content" use-attribute-sets="common.table.body.entry common.table.head.entry"></xsl:attribute-set>

    <xsl:attribute-set name="chrow.chdesc__content" use-attribute-sets="common.table.body.entry"></xsl:attribute-set>

</xsl:stylesheet>