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

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format" version="2.0">

    <xsl:attribute-set name="__index__label">
        <!--HSC [DtPrt#17.8] describes changing the attributes of the index 
        The commented values are imported from __chapter__frontmatter__name__container
        <xsl:attribute name="space-before">20pt</xsl:attribute>
        <xsl:attribute name="space-after">20pt</xsl:attribute>
        <xsl:attribute name="space-after.conditionality">retain</xsl:attribute>
        <xsl:attribute name="font-size">20pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="color">black</xsl:attribute>
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="border-bottom-style">none</xsl:attribute>
        <xsl:attribute name="border-bottom-width">0pt</xsl:attribute>
        <xsl:attribute name="border-bottom-color">#0080FF</xsl:attribute>
         -->

        <!--HSC end of insertion -->
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <xsl:attribute name="span">all</xsl:attribute>
        
        <xsl:attribute name="border-top-style">solid</xsl:attribute>
        <xsl:attribute name="border-top-width">5.1pt</xsl:attribute>
        <xsl:attribute name="border-top-color">
            <xsl:value-of select="$FmColor-RoyalBlue100"/>
        </xsl:attribute>

    </xsl:attribute-set>

    <xsl:attribute-set name="__index__page__link" use-attribute-sets="common.link">
        <xsl:attribute name="page-number-treatment">link</xsl:attribute>
        <!--HSC [DtPrt#17.11] allows formatting of index page numbers  -->
        <xsl:attribute name="color">
            <xsl:value-of select="Index-pageLink"/>
        </xsl:attribute>
        <xsl:attribute name="font-style">italic</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__index__letter-group">
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="space-after">7pt</xsl:attribute>
        <xsl:attribute name="keep-with-next.within-column">always</xsl:attribute>
        <!--HSC [DtPrt#17.9] describes changing the index letter headings format -->
        <xsl:attribute name="font-size">12pt</xsl:attribute>
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="color">
            <xsl:value-of select="Index-letterGroup"/>
        </xsl:attribute>
        <!--HSC end insertion -->
    </xsl:attribute-set>

    <!-- FIXME: Incorrectly named, should be index.group -->
    <xsl:attribute-set name="index.entry">
        <xsl:attribute name="space-after">14pt</xsl:attribute>
        <!--HSC [DtPrt#17.10] allows changing the format of index entries
        <xsl:attribute name="font-size">9pt</xsl:attribute> -->
        <xsl:attribute name="font-size">11pt</xsl:attribute>
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="color">#000000</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="index.term">
    </xsl:attribute-set>

    <!--HSC to control indentation, we disable this section acc. to [DtPrt#17.12]
            other changes are in index_xep.xsl>
    <xsl:attribute-set name="index-indents">
        <xsl:attribute name="end-indent">5pt</xsl:attribute>
        <xsl:attribute name="last-line-end-indent">0pt</xsl:attribute>
        <xsl:attribute name="start-indent">36pt</xsl:attribute>
        <xsl:attribute name="text-indent">-36pt</xsl:attribute>
        <xsl:attribute name="font-size">11pt</xsl:attribute>
    </xsl:attribute-set>
    -->
    <!--HSX This entry determines the first level index entries -->
    <xsl:attribute-set name="index-indents">
        <xsl:attribute name="end-indent">5pt</xsl:attribute>
        <xsl:attribute name="last-line-end-indent">0pt</xsl:attribute>
        <xsl:attribute name="start-indent">36pt</xsl:attribute>
        <xsl:attribute name="text-indent">-36pt</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
    </xsl:attribute-set>

    <!--HSX This entry determines the sub-level index entries -->
    <xsl:attribute-set name="index.entry__content">
        <xsl:attribute name="start-indent">18pt</xsl:attribute>
        <!--HSC [DtPrt#17.10] allows changing the format of index entries  -->
        <xsl:attribute name="font-size">9pt</xsl:attribute>
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="color">#8A8A87</xsl:attribute>
    </xsl:attribute-set>

  <xsl:attribute-set name="index.see-also-entry__content" use-attribute-sets="index.entry__content">
  </xsl:attribute-set>

  <xsl:attribute-set name="index.see.label">
    <xsl:attribute name="font-style">italic</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="index.see-also.label">
    <xsl:attribute name="font-style">italic</xsl:attribute>
  </xsl:attribute-set>

</xsl:stylesheet>