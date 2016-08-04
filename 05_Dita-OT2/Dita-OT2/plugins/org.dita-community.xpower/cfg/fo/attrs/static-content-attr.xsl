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

        <xsl:attribute-set name="pagenum">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <!-- add Page number color according to [DtPrt#8.12.3] can also change font as in "odd_footer" -->
        <xsl:attribute name="color">
            <xsl:value-of select="$Footer-pagenum"/>
        </xsl:attribute>
        <xsl:attribute name="start-indent">0mm</xsl:attribute>
        <xsl:attribute name="end-indent">0mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__insertBookinfo">
        <xsl:attribute name="font-size">9pt</xsl:attribute>
        <xsl:attribute name="color">#808182</xsl:attribute>
    </xsl:attribute-set>

    <!-- [Xslfo#7.16.9] describes text-align -->
    <xsl:attribute-set name="__insertBookId">
        <xsl:attribute name="font-size">9pt</xsl:attribute>
        <xsl:attribute name="color">#808182</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="header__layout" >
        <!-- Vertical layout -->
        <xsl:attribute name="space-before">10pt</xsl:attribute>
        <xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
        <!--HSC padding can be seen as space between text and ruler, or as demilitarized zone around text -->
        <!--HSC add padding to adjust header text according to [DtPrt#8.12.1]:4 -->
        <xsl:attribute name="padding-top">5mm</xsl:attribute>
        <!--HSC make distance between border and text acc. to [DtPrt#8.12.3] -->
        <xsl:attribute name="padding-bottom">0pt</xsl:attribute>
        <xsl:attribute name="border-bottom">1pt solid</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$Header-ruler"/>
        </xsl:attribute>

        <!-- Horizontal layout -->
        <xsl:attribute name="start-indent">0mm</xsl:attribute>
        <xsl:attribute name="end-indent">0mm</xsl:attribute>

        <!--HSC Set footer alignment to "justify" to span blocks over entire page [DtPrt#8.12.4] -->
        <xsl:attribute name="text-align">justify</xsl:attribute>
        <xsl:attribute name="text-align-last">justify</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="footer__layout">
        <!-- Vertical layout -->
        <xsl:attribute name="space-after">10pt</xsl:attribute>
        <xsl:attribute name="space-after.conditionality">retain</xsl:attribute>

        <!--HSC padding can be seen as space between text and ruler, or as demilitarized zone around text -->
        <!--HSC add padding to adjust header text according to [DtPrt#8.12.1]:5 -->
        <xsl:attribute name="padding-bottom">0mm</xsl:attribute>
        <!--HSC make distance between border and text acc. to [DtPrt#8.12.3] -->
        <xsl:attribute name="padding-top">2pt</xsl:attribute>
        <xsl:attribute name="border-top">1pt solid</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$Footer-ruler"/>
        </xsl:attribute>

        <!-- Horizontal layout -->
        <xsl:attribute name="start-indent">0mm</xsl:attribute>
        <xsl:attribute name="end-indent">0mm</xsl:attribute>
        <!--HSC Set footer alignment to "justify" to span blocks over entire page [DtPrt#8.12.4] -->
        <xsl:attribute name="text-align">justify</xsl:attribute>
        <xsl:attribute name="text-align-last">justify</xsl:attribute>
    </xsl:attribute-set>

    <!--HSC add margin for the left/right text acc. to [DtPrt#8.12.2] -->
    <xsl:attribute-set name="odd__header" use-attribute-sets="header__layout">
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$page-margin-inside"/>
        </xsl:attribute>
        <xsl:attribute name="margin-right">
            <xsl:value-of select="$page-margin-outside"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="even__header" use-attribute-sets="header__layout">
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$page-margin-outside"/>
        </xsl:attribute>
        <xsl:attribute name="margin-right">
            <xsl:value-of select="$page-margin-inside"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="odd__footer" use-attribute-sets="footer__layout">
        <!--HSC add margin for the left/right text acc. to [DtPrt#8.12.2] -->
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$page-margin-inside"/>
        </xsl:attribute>
        <xsl:attribute name="margin-right">
            <xsl:value-of select="$page-margin-outside"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="even__footer" use-attribute-sets="footer__layout">
        <!--HSC add margin for the left/right text acc. to [DtPrt#8.12.2] -->
        <xsl:attribute name="margin-left">
            <xsl:value-of select="$page-margin-outside"/>
        </xsl:attribute>
        <xsl:attribute name="margin-right">
            <xsl:value-of select="$page-margin-inside"/>
        </xsl:attribute>
    </xsl:attribute-set>

    <!-- Body Odd Header -->
    <xsl:attribute-set name="__body__odd__header" use-attribute-sets="odd__header">
    </xsl:attribute-set>

    <!-- Body Even Header -->
    <xsl:attribute-set name="__body__even__header" use-attribute-sets="even__header">
    </xsl:attribute-set>

    <!-- Body Odd Footer -->
    <xsl:attribute-set name="__body__odd__footer" use-attribute-sets="odd__footer">
    </xsl:attribute-set>

    <!-- Body Even footer -->
    <xsl:attribute-set name="__body__even__footer" use-attribute-sets="even__footer">
    </xsl:attribute-set>


    <!--HSX test only, the fixed width definition for left right allows an absolute placement of the center text.
    By making a fixed length for the left/right header entries, the leader will provide equal spaces
    left/right to the center text. This allows to center the center text.

    There is a remaining problems to get the right text to align to the right side.

    Use the background statement to test the actual size of the left/right text
    <xsl:attribute name="background-color">#f0f0ff</xsl:attribute>
    -->

    <!-- HEADER LAYOUT -->
    <xsl:attribute-set name="header__heading">
        <!--HSC add font acc. to [DtPrt#8.12.3] can be specialized in __body__even_header -->
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$Header-heading"/>
        </xsl:attribute>
        <xsl:attribute name="start-indent">0mm</xsl:attribute>
        <xsl:attribute name="end-indent">0mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="header__heading__inner" use-attribute-sets="header__heading">
        <xsl:attribute name="width">
            <xsl:choose>
                <xsl:when test="contains($dbghs, 'dbg_showLabels')">
                    <xsl:value-of select="'5cm'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'85mm'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="header__heading__center" use-attribute-sets="header__heading">
        <xsl:attribute name="width">
            <xsl:choose>
                <xsl:when test="contains($dbghs, 'dbg_showLabels')">
                    <xsl:value-of select="'5cm'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'1mm'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="text-align-last">center</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="header__heading__outer" use-attribute-sets="header__heading">
        <xsl:attribute name="width">
            <xsl:choose>
                <xsl:when test="contains($dbghs, 'dbg_showLabels')">
                    <xsl:value-of select="'5cm'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'95mm'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <!-- FOOTER LAYOUT -->
    <xsl:attribute-set name="footer__heading">
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="$Footer-heading"/>
        </xsl:attribute>
        <xsl:attribute name="start-indent">0mm</xsl:attribute>
        <xsl:attribute name="end-indent">0mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="footer__heading__inner" use-attribute-sets="footer__heading">
        <xsl:attribute name="width">
            <xsl:choose>
                <xsl:when test="contains($dbghs, 'dbg_showLabels')">
                    <xsl:value-of select="'5cm'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'90mm'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="footer__heading__center" use-attribute-sets="footer__heading">
        <xsl:attribute name="text-align">center</xsl:attribute>
        <xsl:attribute name="text-align-last">center</xsl:attribute>
        <xsl:attribute name="width">
            <xsl:choose>
                <xsl:when test="contains($dbghs, 'dbg_showLabels')">
                    <xsl:value-of select="'5cm'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'1mm'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="footer__heading__outer" use-attribute-sets="footer__heading">
        <xsl:attribute name="width">
            <xsl:choose>
                <xsl:when test="contains($dbghs, 'dbg_showLabels')">
                    <xsl:value-of select="'5cm'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'30mm'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
    </xsl:attribute-set>

    <!-- BODY -->
    <xsl:attribute-set name="__body__odd__header__heading_inner" use-attribute-sets="header__heading__inner">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__body__odd__header__heading_outer" use-attribute-sets="header__heading__outer">
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="text-align-last">right</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__body__odd__header__heading_center"  use-attribute-sets="header__heading__center">
    </xsl:attribute-set>


    <!--HSX test only, the fixed width definition for left right allows an absolute placement of the center text.
    By making a fixed length for the left/right header entries, the leader will provide equal spaces
    left/right to the center text. This allows to center the center text.

    There is a remaining problems to get the right text to align to the right side.

    Use the background statement to test the actual size of the left/right text
    <xsl:attribute name="background-color">#f0f0ff</xsl:attribute>
    -->
    <xsl:attribute-set name="__body__even__header__heading_inner" use-attribute-sets="header__heading__inner">
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="text-align-last">right</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__body__even__header__heading_outer" use-attribute-sets="header__heading__outer">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__body__even__header__heading_center" use-attribute-sets="header__heading__center">
    </xsl:attribute-set>
    <xsl:attribute-set name="__body__even__header__pagenum" use-attribute-sets="pagenum">
    </xsl:attribute-set>

    <xsl:attribute-set name="__body__odd__footer__heading_inner" use-attribute-sets="footer__heading__inner">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__body__odd__footer__heading_outer" use-attribute-sets="footer__heading__outer">
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="text-align-last">right</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__body__odd__footer__heading_center" use-attribute-sets="footer__heading__center">
    </xsl:attribute-set>
    <xsl:attribute-set name="__body__odd__footer__pagenum" use-attribute-sets="pagenum">
    </xsl:attribute-set>

    <xsl:attribute-set name="__body__even__footer__heading_inner" use-attribute-sets="footer__heading__inner">
        <xsl:attribute name="text-align">right</xsl:attribute>
        <xsl:attribute name="text-align-last">right</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__body__even__footer__heading_outer" use-attribute-sets="footer__heading__outer">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="text-align-last">left</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__body__even__footer__heading_center" use-attribute-sets="footer__heading__center">
    </xsl:attribute-set>
    <xsl:attribute-set name="__body__even__footer__pagenum" use-attribute-sets="pagenum">
    </xsl:attribute-set>

    <!--Body First/Last Odd Header LAYOUT / Labels -->
    <xsl:attribute-set name="__body__first__odd__header" use-attribute-sets="odd__header">
    </xsl:attribute-set>
    <xsl:attribute-set name="__body__first__odd__header__heading_inner" use-attribute-sets="__body__odd__header__heading_inner">
    </xsl:attribute-set>
    <xsl:attribute-set name="__body__first__odd__header__heading_outer" use-attribute-sets="__body__odd__header__heading_outer">
    </xsl:attribute-set>

    <xsl:attribute-set name="__body__first__header__pagenum" use-attribute-sets="pagenum">
    </xsl:attribute-set>

    <xsl:attribute-set name="__body__last__odd__header" use-attribute-sets="odd__header">
    </xsl:attribute-set>
    <xsl:attribute-set name="__body__last__odd__header__heading_inner" use-attribute-sets="__body__odd__header__heading_inner">
    </xsl:attribute-set>
    <xsl:attribute-set name="__body__last__odd__header__heading_outer" use-attribute-sets="__body__odd__header__heading_outer">
    </xsl:attribute-set>

    <xsl:attribute-set name="__body__last__header__pagenum" use-attribute-sets="pagenum">
    </xsl:attribute-set>

    <!-- Body First/Last Even Header -->
    <xsl:attribute-set name="__body__first__even__header" use-attribute-sets="even__header">
    </xsl:attribute-set>
    <xsl:attribute-set name="__body__first__even__header__heading_inner" use-attribute-sets="__body__even__header__heading_inner">
    </xsl:attribute-set>
    <xsl:attribute-set name="__body__first__even__header__heading_outer" use-attribute-sets="__body__even__header__heading_outer">
    </xsl:attribute-set>

    <xsl:attribute-set name="__body__last__even__header" use-attribute-sets="even__header">
    </xsl:attribute-set>
    <xsl:attribute-set name="__body__last__even__header__heading_inner" use-attribute-sets="__body__even__header__heading_inner">
    </xsl:attribute-set>
    <xsl:attribute-set name="__body__last__even__header__heading_outer" use-attribute-sets="__body__even__header__heading_outer">
    </xsl:attribute-set>

    <!-- Body First/Last Odd Footer -->
    <xsl:attribute-set name="__body__first__footer__pagenum" use-attribute-sets="pagenum">
    </xsl:attribute-set>

    <xsl:attribute-set name="__body__first__odd__footer" use-attribute-sets="odd__footer">
    </xsl:attribute-set>
    <xsl:attribute-set name="__body__first__odd__footer__heading_outer" use-attribute-sets="__body__odd__footer__heading_outer">
    </xsl:attribute-set>
    <xsl:attribute-set name="__body__first__odd__footer__heading_inner" use-attribute-sets="__body__odd__footer__heading_inner">
    </xsl:attribute-set>

    <xsl:attribute-set name="__body__last__odd__footer" use-attribute-sets="odd__footer">
    </xsl:attribute-set>
    <xsl:attribute-set name="__body__last__odd__footer__heading_outer" use-attribute-sets="__body__odd__footer__heading_outer">
    </xsl:attribute-set>
    <xsl:attribute-set name="__body__last__odd__footer__heading_inner" use-attribute-sets="__body__odd__footer__heading_inner">
    </xsl:attribute-set>

    <!-- Body First/Last Even Footer -->
    <xsl:attribute-set name="__body__first__even__footer" use-attribute-sets="even__footer">
    </xsl:attribute-set>    
    <xsl:attribute-set name="__body__first__even__footer__heading_inner" use-attribute-sets="__body__even__footer__heading_inner">
    </xsl:attribute-set>
    <xsl:attribute-set name="__body__first__even__footer__heading_outer" use-attribute-sets="__body__even__footer__heading_outer">
    </xsl:attribute-set>

    <xsl:attribute-set name="__body__last__even__footer" use-attribute-sets="even__footer">
    </xsl:attribute-set>
    <xsl:attribute-set name="__body__last__even__footer__heading_inner" use-attribute-sets="__body__even__footer__heading_inner">
    </xsl:attribute-set>
    <xsl:attribute-set name="__body__last__even__footer__heading_outer" use-attribute-sets="__body__even__footer__heading_outer">
    </xsl:attribute-set>

    <!-- TOC -->
    <xsl:attribute-set name="__toc__odd__footer" use-attribute-sets="odd__footer">
    </xsl:attribute-set>
    <xsl:attribute-set name="__toc__odd__footer__heading_center" use-attribute-sets="__body__odd__footer__heading_center">
    </xsl:attribute-set>
    <xsl:attribute-set name="__toc__odd__footer__heading_outer" use-attribute-sets="__body__odd__footer__heading_outer">
    </xsl:attribute-set>
    <xsl:attribute-set name="__toc__odd__footer__heading_inner" use-attribute-sets="__body__odd__footer__heading_inner">
    </xsl:attribute-set>
    <xsl:attribute-set name="__toc__odd__footer__pagenum" use-attribute-sets="pagenum">
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__even__footer" use-attribute-sets="even__footer">
    </xsl:attribute-set>
    <xsl:attribute-set name="__toc__even__footer__heading_center" use-attribute-sets="__body__even__footer__heading_center">
    </xsl:attribute-set>
    <xsl:attribute-set name="__toc__even__footer__heading_outer" use-attribute-sets="__body__even__footer__heading_outer">
    </xsl:attribute-set>
    <xsl:attribute-set name="__toc__even__footer__heading_inner" use-attribute-sets="__body__even__footer__heading_inner">
    </xsl:attribute-set>
    <xsl:attribute-set name="__toc__even__footer__pagenum" use-attribute-sets="pagenum">
    </xsl:attribute-set>

    <xsl:attribute-set name="__toc__odd__header" use-attribute-sets="odd__header">
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__toc__odd__header__heading_center" use-attribute-sets="__body__odd__header__heading_center">
    </xsl:attribute-set>
    <xsl:attribute-set name="__toc__odd__header__heading_outer" use-attribute-sets="__body__odd__header__heading_outer">
    </xsl:attribute-set>
    <xsl:attribute-set name="__toc__odd__header__heading_inner" use-attribute-sets="__body__odd__header__heading_inner">
    </xsl:attribute-set>
    <xsl:attribute-set name="__toc__odd__header__pagenum" use-attribute-sets="pagenum">
    </xsl:attribute-set>


    <xsl:attribute-set name="__toc__even__header" use-attribute-sets="even__header">
    </xsl:attribute-set>
    <xsl:attribute-set name="__toc__even__header__heading_center" use-attribute-sets="__body__even__header__heading_center">
    </xsl:attribute-set>    
    <xsl:attribute-set name="__toc__even__header__heading_outer" use-attribute-sets="__body__even__header__heading_outer">
    </xsl:attribute-set>
    <xsl:attribute-set name="__toc__even__header__heading_inner" use-attribute-sets="__body__even__header__heading_inner">
    </xsl:attribute-set>
    <xsl:attribute-set name="__toc__even__header__pagenum" use-attribute-sets="pagenum">
    </xsl:attribute-set>

    <!--- INDEX -->
    <xsl:attribute-set name="__index__odd__header" use-attribute-sets="odd__header">
    </xsl:attribute-set>
    <xsl:attribute-set name="__index__odd__header__heading_inner" use-attribute-sets="__body__odd__header__heading_inner">
    </xsl:attribute-set>
    <xsl:attribute-set name="__index__odd__header__heading_center" use-attribute-sets="__body__odd__header__heading_center">
    </xsl:attribute-set>
    <xsl:attribute-set name="__index__odd__header__heading_outer" use-attribute-sets="__body__odd__header__heading_outer">
    </xsl:attribute-set>
    <xsl:attribute-set name="__index__odd__header__pagenum" use-attribute-sets="pagenum">
    </xsl:attribute-set>

    <xsl:attribute-set name="__index__even__header" use-attribute-sets="even__header">
    </xsl:attribute-set>
    <xsl:attribute-set name="__index__even__header__heading_inner" use-attribute-sets="__body__even__header__heading_inner">
    </xsl:attribute-set>
    <xsl:attribute-set name="__index__even__header__heading_center" use-attribute-sets="__body__even__header__heading_center">
    </xsl:attribute-set>
    <xsl:attribute-set name="__index__even__header__heading_outer" use-attribute-sets="__body__even__header__heading_outer">
    </xsl:attribute-set>
    <xsl:attribute-set name="__index__even__header__pagenum" use-attribute-sets="pagenum">
    </xsl:attribute-set>

    <xsl:attribute-set name="__index__odd__footer" use-attribute-sets="odd__footer">
    </xsl:attribute-set>
    <xsl:attribute-set name="__index__odd__footer__heading_inner" use-attribute-sets="__body__odd__footer__heading_inner">
    </xsl:attribute-set>
    <xsl:attribute-set name="__index__odd__footer__heading_center" use-attribute-sets="__body__odd__footer__heading_center">
    </xsl:attribute-set>
    <xsl:attribute-set name="__index__odd__footer__heading_outer" use-attribute-sets="__body__odd__footer__heading_outer">
    </xsl:attribute-set>
    <xsl:attribute-set name="__index__odd__footer__pagenum" use-attribute-sets="pagenum">
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__index__even__footer" use-attribute-sets="even__footer">
    </xsl:attribute-set>
    <xsl:attribute-set name="__index__even__footer__heading_inner" use-attribute-sets="__body__even__footer__heading_inner">
    </xsl:attribute-set>
    <xsl:attribute-set name="__index__even__footer__heading_center" use-attribute-sets="__body__even__footer__heading_center">
    </xsl:attribute-set>
    <xsl:attribute-set name="__index__even__footer__heading_outer" use-attribute-sets="__body__even__footer__heading_outer">
    </xsl:attribute-set>
    <xsl:attribute-set name="__index__even__footer__pagenum" use-attribute-sets="pagenum">
    </xsl:attribute-set>
    
    <!-- GLOSSARY FORMATTING -->
    <xsl:attribute-set name="__glossary__odd__footer" use-attribute-sets="odd__footer">
    </xsl:attribute-set>
    <xsl:attribute-set name="__glossary__odd__footer__pagenum" use-attribute-sets="pagenum">
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__glossary__even__footer" use-attribute-sets="even__footer">
    </xsl:attribute-set>
    <xsl:attribute-set name="__glossary__even__footer__pagenum" use-attribute-sets="pagenum">
    </xsl:attribute-set>

    <xsl:attribute-set name="__glossary__odd__header" use-attribute-sets="odd__header">
    </xsl:attribute-set>
    <xsl:attribute-set name="__glossary__odd__header__pagenum" use-attribute-sets="pagenum">
    </xsl:attribute-set>

    <xsl:attribute-set name="__glossary__even__header" use-attribute-sets="even__header">
    </xsl:attribute-set>
    <xsl:attribute-set name="__glossary__even__header__pagenum" use-attribute-sets="pagenum">
    </xsl:attribute-set>
    
    <!-- SPECIAL Formatting -->
    
    <xsl:attribute-set name="__body__footnote__separator">
        <!--HSC [DtPrt#15.5.2] changes the footnote separator line acc. to these definitions
        <xsl:attribute name="leader-pattern">rule</xsl:attribute>
        <xsl:attribute name="rule-style">solid</xsl:attribute>
        <xsl:attribute name="color">black</xsl:attribute> -->

        <xsl:attribute name="leader-pattern">dots</xsl:attribute>
        <xsl:attribute name="rule-style">dotted</xsl:attribute>
        <xsl:attribute name="color">#00008A</xsl:attribute>

        <xsl:attribute name="leader-length">25%</xsl:attribute>
        <xsl:attribute name="rule-thickness">0.5pt</xsl:attribute>
    </xsl:attribute-set>


    <!-- FRONTMATTER FORMATTING -->
    
    <!--HSC the frontmatter__name is the chapter name that is automatically
    generated on every new Head1 chapter. Actually we might not want it all
    but here we can change the attributes acc. to [DtPrt#10.3.5]
    That can be done in commons.xsl acc. to [DtPrt#10.3.6] -->
    <xsl:attribute-set name="__chapter__frontmatter__name__container_1">
        <!--HSC tuning the font/color/border of only chapters -->
        <xsl:attribute name="border-top">0pt solid red</xsl:attribute> <!--HSC-->
        <xsl:attribute name="border-top-style">solid</xsl:attribute>
        <xsl:attribute name="border-bottom">0pt solid red</xsl:attribute> <!--HSC-->
        <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
        <!--
        <xsl:attribute name="border-top-width">0pt</xsl:attribute>
        <xsl:attribute name="border-bottom-width">0pt</xsl:attribute>
        -->

        <xsl:attribute name="font-size">16pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="space-before">9pt</xsl:attribute>
        <xsl:attribute name="space-after">9.8pt</xsl:attribute>
        <xsl:attribute name="padding-top">3pt</xsl:attribute>   <!--HSC distance between text and over-line -->

        <xsl:attribute name="color">black</xsl:attribute>
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <!--HSC The statement below determines whether Head1 over-line (border-top)spans only over the title or over the entire page
        This overwrites the topic.title settings in commons.xsl for Head1 CHAPTERS
        [DtPrt#10.3.5] does address this but not explicitly to the extend I'm using it since
        for Head 1 I also want a border-top spanning over the page which can be achieved
        with the "justify" settings below.
        For Head2++ chapters I have it done anyway, but Head1 is special. Took some time to explore ...
        -->
        <!--HSC .. today ... I'm happy that it works, but did not really want it ...
        <xsl:attribute name="text-align">justify</xsl:attribute>
        <xsl:attribute name="text-align-last">justify</xsl:attribute>
        -->

    </xsl:attribute-set>

    <xsl:attribute-set name="__chapter__frontmatter__name__container">
        <!--HSC changes acc. to [DtPrt#10.3.5]
        <xsl:attribute name="font-size">20pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="border-top-style">solid</xsl:attribute>
        <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
        <xsl:attribute name="border-top-width">2pt</xsl:attribute>
        <xsl:attribute name="border-bottom-width">2pt</xsl:attribute>
        <xsl:attribute name="padding-top">10pt</xsl:attribute> -->

        <!--HSC tuning the font/color/border of preface,abstract,notices -->
        <xsl:attribute name="border-top-style">solid</xsl:attribute>
        <xsl:attribute name="border-top-width">5pt</xsl:attribute>
        <xsl:attribute name="border-top-color">
            <xsl:value-of select="$FmColor-RoyalBlue100"/>
        </xsl:attribute>
        <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
        <xsl:attribute name="border-top-width">5pt</xsl:attribute>
        <xsl:attribute name="border-bottom-width">0pt</xsl:attribute>

        <xsl:attribute name="font-size">24pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="space-before">9pt</xsl:attribute>
        <xsl:attribute name="space-after">10.8pt</xsl:attribute>
        <xsl:attribute name="padding-top">3pt</xsl:attribute>   <!--HSC distance between text and over-line -->

        <xsl:attribute name="color">black</xsl:attribute>
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <!--HSC The statement below determines whether Head1 over-line (border-top)spans only over the title or over the entire page
        This overwrites the topic.title settings in commons.xsl for Head1 CHAPTERS
        [DtPrt#10.3.5] does address this but not explicitly to the extend I'm using it since
        for Head 1 I also want a border-top spanning over the page which can be achieved
        with the "justify" settings below.
        For Head2++ chapters I have it done anyway, but Head1 is special. Took some time to explore ...
        -->
        <!--HSC .. today ... I'm happy that it works, but did not really want it ...
        <xsl:attribute name="text-align">justify</xsl:attribute>
        <xsl:attribute name="text-align-last">justify</xsl:attribute>
        -->

    </xsl:attribute-set>

    <!--HSC the frontmatter__number is the chapter number that is autmatically
    generated on every new Head1 chapter. Actually we might not want it all
    but here we can change the attributes acc. to [DtPrt#10.3.5] -->
    <xsl:attribute-set name="__chapter__frontmatter__number__container">
        <!--HSC changes acc. to [DtPrt#10.3.5]
        <xsl:attribute name="font-size">40pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        -->
        <xsl:attribute name="font-size">24pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <!--HSC changed chapter # to be red to identify -->
        <xsl:attribute name="color">#010201</xsl:attribute>
    </xsl:attribute-set>
   
    
    <!--HSC Define Leader layout for space between header/footer items acc. to [DtPrt#8.12.4] -->
    <xsl:attribute-set name="__hdrftr__leader">
        <xsl:attribute name="leader-pattern">space</xsl:attribute>
    </xsl:attribute-set>
    <!--HSC Define attribute for the header image (logo) acc. to [DtPrt#8.12.5] -->
    <xsl:attribute-set name="__header__image">
        <xsl:attribute name="padding-left">10pt</xsl:attribute>
        <!--HSC Test, ruler is at size of the text  <xsl:attribute name="border-left">1pt solid blue</xsl:attribute> -->
    </xsl:attribute-set>
</xsl:stylesheet>