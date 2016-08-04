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

    <!--HSX We need text-align=left instead of center (the DITA-OT default)
            to allow absolute positioning of the images on the front page
    -->
    <xsl:attribute-set name="__frontmatter">
        <xsl:attribute name="text-align">left</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__frontmatter__bar_before">
        <xsl:attribute name="border-top-width">1.2mm</xsl:attribute>
        <xsl:attribute name="border-top-style">solid</xsl:attribute>
        <xsl:attribute name="border-top-color"><xsl:value-of select="$FmColor-RoyalBlue100"/></xsl:attribute>

        <!-- border-bottom takes precedence over border-after
             The short notation 10pt solid blue did not work reliably (I need to test)
             [Xslfo#4.1] gives good advice on the borders and spaces
        <xsl:attribute name="border-bottom-color">red</xsl:attribute>
        <xsl:attribute name="border-bottom-width">2pt</xsl:attribute>
        <xsl:attribute name="border-bottom-style">solid</xsl:attribute>
        -->
        <xsl:attribute name="border-after-width">0pt</xsl:attribute>

        <!--HSC padding can be seen as space between text and ruler,
                or as demilitarized zone around text -->
        <!--HSC add padding to adjust header text according to [DtPrt#8.12.1]:3 -->
        <xsl:attribute name="padding-top">0mm</xsl:attribute>
        <!--HSC make distance between border and text acc. to [DtPrt#8.12.3] -->
        <xsl:attribute name="end-indent">0pt</xsl:attribute>   <!--HSC this determines how far the ruler goes -->
    </xsl:attribute-set>

    <xsl:attribute-set name="__frontmatter__bar_after">
        <xsl:attribute name="border-top-width">0pt</xsl:attribute>
        <xsl:attribute name="border-after-width">1.2mm</xsl:attribute>
        <xsl:attribute name="border-after-color"><xsl:value-of select="$FmColor-RoyalBlue100"/></xsl:attribute> <!--HSC-->        
        <xsl:attribute name="border-after-style">solid</xsl:attribute>
       <!--HSC make distance between border and text acc. to [DtPrt#8.12.3] -->
        <xsl:attribute name="padding-bottom">3pt</xsl:attribute>
        <xsl:attribute name="end-indent">0pt</xsl:attribute>
    </xsl:attribute-set>


    <!--HSC ... determines front matter title layout and font, implemented BookMasterGothic
    as proposed in [DtPrt#4.5.1] -->
    <xsl:attribute-set name="__frontmatter__title_1" use-attribute-sets="common.title __frontmatter__bar_before">
        <!--HSX nice example how to apply special fonts
        <xsl:attribute name="font-family">BookMasterGothic</xsl:attribute>
        -->
        <xsl:attribute name="text-align">left</xsl:attribute>
        <!--HSC space-before determines how far from the previous block (or top) the text is placed -->
        <xsl:attribute name="space-before">42mm</xsl:attribute>
        <xsl:attribute name="space-after">0mm</xsl:attribute>
        <xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__frontmatter__title_2" use-attribute-sets="common.title __frontmatter__bar_after">
        <!--HSX nice example how to apply special fonts
        <xsl:attribute name="font-family">BookMasterGothic</xsl:attribute>
        -->
        <xsl:attribute name="color">#808081</xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="font-family">serif</xsl:attribute>
        <!--HSC space-before determines how far from the previous block (or top) the text is placed -->
        <xsl:attribute name="space-before">0mm</xsl:attribute>
        <xsl:attribute name="space-before.conditionality">retain</xsl:attribute>
        <xsl:attribute name="font-size">18pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="line-height">100%</xsl:attribute>
    </xsl:attribute-set>

    <!-- SUBTITLE -->
    <!--HSC ... determines front matter subtitle layout and font -->
    <xsl:attribute-set name="__frontmatter__subtitle" use-attribute-sets="common.title">
        <xsl:attribute name="font-family">serif</xsl:attribute>
        <xsl:attribute name="font-size">18pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="line-height">140%</xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="space-before">0mm</xsl:attribute>
        <xsl:attribute name="padding-top">0mm</xsl:attribute>
    </xsl:attribute-set>

    <!-- OWNER CONTAINER CONTENT [never used] -->
    <xsl:attribute-set name="__frontmatter__owner__container_content">
        <xsl:attribute name="text-align">center</xsl:attribute>
    </xsl:attribute-set>

    <!-- MAIN BOOKTITLE -->
    <xsl:attribute-set name="__frontmatter__mainbooktitle">
        <xsl:attribute name="font-family">serif</xsl:attribute>
        <xsl:attribute name="color">black</xsl:attribute>
        <xsl:attribute name="font-size">36pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="line-height">100%</xsl:attribute>
        <xsl:attribute name="padding-top">0mm</xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- BOOKLIBRARY -->
    <xsl:attribute-set name="__frontmatter__booklibrary">
        <xsl:attribute name="padding-top">2mm</xsl:attribute>
        <xsl:attribute name="padding-bottom">2mm</xsl:attribute>
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="color">#808080</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="line-height">100%</xsl:attribute>
        <xsl:attribute name="space-after">0pt</xsl:attribute>
    </xsl:attribute-set>

    <!-- [PRODUCT NAME] and VERSION [DtPrt#9.1.4] --> 
    <xsl:attribute-set name="__frontmatter__product" use-attribute-sets="common.title">
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="font-size">16pt</xsl:attribute>
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="space-before">14mm</xsl:attribute>
    </xsl:attribute-set>

    <!-- PRINT DATE -->
    <xsl:attribute-set name="__frontmatter__printdate" use-attribute-sets="common.title">
        <xsl:attribute name="font-size">9pt</xsl:attribute>
        <xsl:attribute name="color">#808080</xsl:attribute>
        <xsl:attribute name="space-before">0mm</xsl:attribute>
        <xsl:attribute name="padding-top">0.5mm</xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
    </xsl:attribute-set>

    <!-- BOOKMETA -->
    <xsl:attribute-set name="__frontmatter__bookmeta" use-attribute-sets="common.title">
        <xsl:attribute name="space-before">36pt</xsl:attribute>
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="line-height">normal</xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
    </xsl:attribute-set>

    <!-- BOOKMETA CONTAINER -->
    <!-- top/bottom determine the distance from the 
         top/bottom margin of the writable range (respects margins) -->
    <xsl:attribute-set name="__frontmatter__bookmeta__container">
        <xsl:attribute name="position">absolute</xsl:attribute>
        <xsl:attribute name="top">170mm</xsl:attribute>
        <xsl:attribute name="left">0mm</xsl:attribute>
        <xsl:attribute name="height">50mm</xsl:attribute>
        <xsl:attribute name="width">180mm</xsl:attribute>
        <!--
        <xsl:attribute name="background-color">#E0E0FF</xsl:attribute>
        -->
    </xsl:attribute-set>

    <!-- AUTHOR -->
    <xsl:attribute-set name="__frontmatter__author" use-attribute-sets="common.title">
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="space-before">14mm</xsl:attribute>
        <xsl:attribute name="color">black</xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
    </xsl:attribute-set>


    <!-- AUTHOR names -->
    <xsl:attribute-set name="__frontmatter__names" use-attribute-sets="common.title">
        <xsl:attribute name="font-size">
            <xsl:choose>
                <xsl:when test="count(../personname) &gt; 3">
                    <xsl:value-of select="'10pt'"/>
                </xsl:when>
                <xsl:when test="count(../personname) &gt; 1">
                    <xsl:value-of select="'12pt'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'14pt'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="color">black</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- AUTHOR role -->
    <xsl:attribute-set name="__frontmatter__role" use-attribute-sets="common.title">
        <xsl:attribute name="font-size">9pt</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="color">#B0B0B0</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
    </xsl:attribute-set>

    <!-- ORGANIZATION -->
    <xsl:attribute-set name="__frontmatter__organization">
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="color">black</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="line-height">100%</xsl:attribute>
        <xsl:attribute name="padding-top">0mm</xsl:attribute>
        <xsl:attribute name="space-before">10mm</xsl:attribute>
    </xsl:attribute-set>

    <!-- AUTHOR address -->
    <xsl:attribute-set name="__frontmatter__address_street" use-attribute-sets="common.title">
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="color">black</xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__frontmatter__address_city" use-attribute-sets="__frontmatter__address_street">
        <xsl:attribute name="space-before">0pt</xsl:attribute>
    </xsl:attribute-set>
    
    
    
    <!-- TAB OFFSET for phone / email -->
    <xsl:attribute-set name="__frontmatter__taboffset">
        <xsl:attribute name="min-width">20mm</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- CONTACTNUMBER -->
    <xsl:attribute-set name="__frontmatter__contactnumber" use-attribute-sets="common.title">
        <xsl:attribute name="font-size">10pt</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- CONTACTNUMBER Domain -->
    <xsl:attribute-set name="__frontmatter__contactnumber_domain" use-attribute-sets="common.title">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="color">black</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- CONTACTNUMBER Number -->
    <xsl:attribute-set name="__frontmatter__contactnumber_number" use-attribute-sets="common.title">
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="color">#424242</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- EMAILADDRESSES -->
    <xsl:attribute-set name="__frontmatter__emailaddresses" use-attribute-sets="common.title">
        <xsl:attribute name="font-size">10pt</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- EMAILADDRESSES Domain -->
    <xsl:attribute-set name="__frontmatter__emailaddresses_domain" use-attribute-sets="common.title">
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="color">black</xsl:attribute>
    </xsl:attribute-set>
    
    <!-- EMAILADDRESSES Number -->
    <xsl:attribute-set name="__frontmatter__emailaddresses_number" use-attribute-sets="common.title">
        <xsl:attribute name="font-style">normal</xsl:attribute>
        <xsl:attribute name="color">#404080</xsl:attribute>
    </xsl:attribute-set>
    

    <!-- LOGO CONTAINER -->
    <!--HSC use separated attributes for the container [DtPrt#9.1.5] -->
    <xsl:attribute-set name="__frontmatter__logo__container">
        <xsl:attribute name="position">absolute</xsl:attribute>
        <xsl:attribute name="top">0mm</xsl:attribute>
        <!--
        <xsl:attribute name="top">240mm</xsl:attribute>
        -->
        <xsl:attribute name="left">0mm</xsl:attribute>
        <xsl:attribute name="width">100mm</xsl:attribute>
        <!--
        <xsl:attribute name="right">
            <xsl:value-of select="'0mm'"/>
        </xsl:attribute>
        -->
        <xsl:attribute name="height">10mm</xsl:attribute>
        <!--
        <xsl:attribute name="background-color">#E0E0FF</xsl:attribute>
        -->
    </xsl:attribute-set>

    <xsl:attribute-set name="__frontmatter__logo__container_2">
        <xsl:attribute name="position">absolute</xsl:attribute>
        <xsl:attribute name="top">0mm</xsl:attribute>
        <!--
        <xsl:attribute name="top">240mm</xsl:attribute>
        <xsl:attribute name="left">30mm</xsl:attribute>
        -->
        <xsl:attribute name="right">0mm</xsl:attribute>
        <xsl:attribute name="width">100mm</xsl:attribute>
        <xsl:attribute name="height">10mm</xsl:attribute>
        <!--
        <xsl:attribute name="background-color">#E0E0FF</xsl:attribute>
        -->
    </xsl:attribute-set>

    <!-- LOGO -->
    <xsl:attribute-set name="__frontmatter__logo">
        <xsl:attribute name="padding-top">0mm</xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
        <!--
        <xsl:attribute name="background-color">#FFE0E0</xsl:attribute>
        -->
    </xsl:attribute-set>

    <xsl:attribute-set name="__frontmatter__logo_2">
        <xsl:attribute name="padding-top">0mm</xsl:attribute>
        <xsl:attribute name="space-before">0pt</xsl:attribute>
        <xsl:attribute name="text-align">right</xsl:attribute>
        <!--
        <xsl:attribute name="background-color">#FFE0E0</xsl:attribute>
        -->
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__frontmatter__logo_img">
        <xsl:attribute name="content-height">10mm</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__frontmatter__logo_img_2">
        <xsl:attribute name="content-height">10mm</xsl:attribute>
    </xsl:attribute-set>

    <!-- LINK CONTAINER-->
    <xsl:attribute-set name="__frontmatter__link__container">
        <xsl:attribute name="position">absolute</xsl:attribute>
        <xsl:attribute name="top">260mm</xsl:attribute>
        <xsl:attribute name="width">100mm</xsl:attribute>
        <!-- if you like the right position, use the following
        <xsl:attribute name="right">
            <xsl:value-of select="'0mm'"/>
        </xsl:attribute>
        -->
        <xsl:attribute name="left">0mm</xsl:attribute>
        <xsl:attribute name="height">10mm</xsl:attribute>
        <!--
        <xsl:attribute name="background-color">#E0E0FF</xsl:attribute>
        -->
    </xsl:attribute-set>
    <!-- LINK -->
    <xsl:attribute-set name="__frontmatter__link">
        <xsl:attribute name="padding-top">0pt</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="color">#808080</xsl:attribute>
    </xsl:attribute-set>
    
    
    <!--HSX frontmatter backside -->
    <xsl:attribute-set name="__frontmatter__backside__container">
        <xsl:attribute name="position">absolute</xsl:attribute>
        <xsl:attribute name="top">170mm</xsl:attribute>
        <xsl:attribute name="width">180mm</xsl:attribute>
        <!-- if you like the right position, use the following
        <xsl:attribute name="right">
            <xsl:value-of select="'0mm'"/>
        </xsl:attribute>
        -->
        <xsl:attribute name="left">0mm</xsl:attribute>
        <xsl:attribute name="height">90mm</xsl:attribute>
        <!--
        <xsl:attribute name="background-color">#E0E0FF</xsl:attribute>
        -->
    </xsl:attribute-set>

    <xsl:attribute-set name="__frontmatter__backside">
        <xsl:attribute name="padding-top">12pt</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="color">#000102</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="__frontmatter__backside_bold">
        <xsl:attribute name="padding-top">12pt</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="font-weight">bold</xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="color">#000102</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__frontmatter__backside_follow">
        <xsl:attribute name="padding-top">6pt</xsl:attribute>
        <xsl:attribute name="padding-bottom">0pt</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="color">#000102</xsl:attribute>
    </xsl:attribute-set>
    
    <xsl:attribute-set name="back-cover">
        <xsl:attribute name="force-page-count">end-on-even</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="__back-cover">
        <xsl:attribute name="break-before">even-page</xsl:attribute>
    </xsl:attribute-set>

    <xsl:attribute-set name="bookmap.summary">
        <xsl:attribute name="padding-top">4pt</xsl:attribute>
        <xsl:attribute name="font-size">10pt</xsl:attribute>
        <xsl:attribute name="font-weight">normal</xsl:attribute>
        <xsl:attribute name="text-align">left</xsl:attribute>
        <xsl:attribute name="font-family">sans-serif</xsl:attribute>
        <xsl:attribute name="color">#000102</xsl:attribute>
    </xsl:attribute-set>

</xsl:stylesheet>