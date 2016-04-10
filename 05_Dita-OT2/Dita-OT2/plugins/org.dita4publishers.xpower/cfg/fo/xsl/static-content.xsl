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
                xmlns:opentopic="http://www.idiominc.com/opentopic"
                version="2.0">

    <xsl:template name="insertBodyStaticContents">
        <xsl:call-template name="insertBodyFootnoteSeparator"/>

        <!--HSC Footer -->
        <xsl:call-template name="insertBodyOddFooter"/>
        <xsl:call-template name="insertBodyFirstOddFooter"/>
        <xsl:call-template name="insertBodyLastOddFooter"/>
        <xsl:if test="$mirror-page-margins">
            <xsl:call-template name="insertBodyEvenFooter"/>
            <xsl:call-template name="insertBodyFirstEvenFooter"/>
            <xsl:call-template name="insertBodyLastEvenFooter"/>
        </xsl:if>

        <!--HSC Header -->
        <xsl:call-template name="insertBodyOddHeader"/>
        <xsl:call-template name="insertBodyFirstOddHeader"/>
        <xsl:call-template name="insertBodyLastOddHeader"/>

        <xsl:if test="$mirror-page-margins">
            <xsl:call-template name="insertBodyEvenHeader"/>
            <xsl:call-template name="insertBodyFirstEvenHeader"/>
            <xsl:call-template name="insertBodyLastEvenHeader"/>
        </xsl:if>

    </xsl:template>

    <xsl:template name="insertTocStaticContents">
        <xsl:call-template name="insertTocOddFooter"/>
        <xsl:call-template name="insertTocFirstOddFooter"/>
        <!--HSC override the previous template,
        could have been solved with choose statement
        -->
        <xsl:if test="$mirror-page-margins">
            <xsl:call-template name="insertTocFirstEvenFooter"/>
            <xsl:call-template name="insertTocEvenFooter"/>
        </xsl:if>
        <xsl:call-template name="insertTocFirstOddHeader"/>
        <xsl:call-template name="insertTocOddHeader"/>
        <xsl:if test="$mirror-page-margins">
            <xsl:call-template name="insertTocFirstEvenHeader"/>
            <xsl:call-template name="insertTocEvenHeader"/>
        </xsl:if>
        <!--HSC call new template for TocFirstHeader acc to [DtPrt#8.11.2] -->
        <!--HSX -->
    </xsl:template>

    <xsl:template name="insertIndexStaticContents">
        <xsl:call-template name="insertIndexOddFooter"/>
        <xsl:if test="$mirror-page-margins">
            <xsl:call-template name="insertIndexEvenFooter"/>
        </xsl:if>
        <xsl:call-template name="insertIndexOddHeader"/>
        <xsl:if test="$mirror-page-margins">
            <xsl:call-template name="insertIndexEvenHeader"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="insertPrefaceStaticContents">
        <xsl:call-template name="insertPrefaceFootnoteSeparator"/>
        <!--HSC
        -->
        <xsl:call-template name="insertPrefaceOddFooter"/>
        <xsl:call-template name="insertPrefaceFirstOddFooter"/>
        <xsl:call-template name="insertPrefaceLastOddFooter"/>
        <xsl:if test="$mirror-page-margins">
            <xsl:call-template name="insertPrefaceEvenFooter"/>
            <xsl:call-template name="insertPrefaceFirstEvenFooter"/>
            <xsl:call-template name="insertPrefaceLastEvenFooter"/>
        </xsl:if>

        <xsl:call-template name="insertPrefaceOddHeader"/>
        <xsl:call-template name="insertPrefaceFirstOddHeader"/>
        <xsl:call-template name="insertPrefaceLastOddHeader"/>
        <xsl:if test="$mirror-page-margins">
            <xsl:call-template name="insertPrefaceEvenHeader"/>
            <xsl:call-template name="insertPrefaceFirstEvenHeader"/>
            <xsl:call-template name="insertPrefaceLastEvenHeader"/>
        </xsl:if>
        <!--HSC I put these to the odd/even selection above since we cannot
        predict whether the first preface starts on an odd or even page number -->
    </xsl:template>

    <xsl:template name="insertFrontMatterStaticContents">
        <xsl:call-template name="insertFrontMatterFootnoteSeparator"/>
        <xsl:call-template name="insertFrontMatterOddFooter"/>
        <xsl:if test="$mirror-page-margins">
            <xsl:call-template name="insertFrontMatterEvenFooter"/>
        </xsl:if>
        <xsl:call-template name="insertFrontMatterOddHeader"/>
        <xsl:if test="$mirror-page-margins">
            <xsl:call-template name="insertFrontMatterEvenHeader"/>
        </xsl:if>

        <xsl:call-template name="insertPrefaceLastHeader"/>
        <xsl:call-template name="insertPrefaceLastFooter"/>

    </xsl:template>

    <xsl:template name="insertBackCoverStaticContents">
        <xsl:call-template name="insertBackCoverOddFooter"/>
        <xsl:if test="$mirror-page-margins">
            <xsl:call-template name="insertBackCoverEvenFooter"/>
        </xsl:if>
        <xsl:call-template name="insertBackCoverOddHeader"/>
        <xsl:if test="$mirror-page-margins">
            <xsl:call-template name="insertBackCoverEvenHeader"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="insertGlossaryStaticContents">
        <xsl:call-template name="insertGlossaryOddFooter"/>
        <xsl:if test="$mirror-page-margins">
            <xsl:call-template name="insertGlossaryEvenFooter"/>
        </xsl:if>
        <xsl:call-template name="insertGlossaryOddHeader"/>
        <xsl:if test="$mirror-page-margins">
            <xsl:call-template name="insertGlossaryEvenHeader"/>
        </xsl:if>
    </xsl:template>


    <xsl:template name="getHeaderOuterOdd">
        <fo:block>
            <fo:retrieve-marker retrieve-class-name="current-header"/>
        </fo:block>
    </xsl:template>

    <xsl:template name="getHeaderInnerOdd">
        <fo:block>
            <xsl:value-of select="$bookTitle"/>
        </fo:block>
    </xsl:template>

    <xsl:template name="getHeaderOuterEven">
        <fo:block>
            <fo:retrieve-marker retrieve-class-name="current-header"/>
        </fo:block>
    </xsl:template>

    <xsl:template name="getHeaderInnerEven">
        <fo:block>
            <xsl:value-of select="$bookTitle"/>
        </fo:block>
    </xsl:template>

    <xsl:template name="getFooterFirstOdd">
        <xsl:call-template name="getSecurityClass"/>
    </xsl:template>

    <xsl:template name="getFooterFirstEven">
        <xsl:call-template name="getBookinfo"/>
    </xsl:template>

        <xsl:template name="getFooterOdd">
        <xsl:call-template name="getSecurityClass"/>
    </xsl:template>

    <xsl:template name="getFooterEven">
        <xsl:call-template name="getBookinfo"/>
    </xsl:template>

    <xsl:template name="getSecurityClass">
        <xsl:call-template name="markField"/>
        <fo:block xsl:use-attribute-sets="__insertBookinfo">
            <xsl:value-of select="$map/bookmeta/bookrights/bookrestriction/@value"/>
        </fo:block>
    </xsl:template>

    <xsl:template name="getBookinfo">
        <xsl:call-template name="markField"/>
        <fo:block xsl:use-attribute-sets="__insertBookinfo">
            <xsl:call-template name="insertBookinfo"/>
            <!--HSX to get the bookid on a second line, 
                just put it into its own fo:block
                and remove the xsl:text separator -->
            <xsl:variable name="bookId">
                <xsl:call-template name="insertBookId"/>
            </xsl:variable>
            <xsl:if test="string-length($bookId) &gt; 0">
                <xsl:text> / </xsl:text>
                <xsl:call-template name="insertBookId"/>
            </xsl:if>
        </fo:block>
    </xsl:template>

    <!--HSX insert book info -->
    <xsl:template name="insertBookinfo ">
        <!--HSX may use this later
        <xsl:if test="contains($docdesign, 'dsgn_smart')">
            <xsl:copy-of select="$bookLibrary"/>
            <xsl:text>-</xsl:text>
        </xsl:if>
        -->
        <!--HSX book title obsolete, use to have it in the header
        <xsl:copy-of select="$bookTitle"/>
        <xsl:text>&#xA0;</xsl:text>
        -->
        <xsl:text>Edition </xsl:text>
        <xsl:value-of select="$productVersion"/>
        <!--HSX
        <xsl:text> </xsl:text>
        <xsl:value-of select="$pubDate"/>
        -->
    </xsl:template>

    <xsl:template name="insertBookId ">
        <xsl:if test="string-length(normalize-space($productIdNo)) &gt; 0">
            <xsl:text>ID No. </xsl:text>
            <xsl:value-of select="$productIdNo"/>
        </xsl:if>
    </xsl:template>

    <xsl:template name="insertWatermark">
        <xsl:if test="$MapWatermark">                
            <xsl:variable name="wmFile">
                <xsl:analyze-string select="$MapWatermark" regex="{'^.*\.svg$'}">
                    <xsl:matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:variable>
            <xsl:if test="string-length($wmFile)">
                <fo:block-container absolute-position="fixed" top="0mm" left="0mm">
                    <fo:block>
                        <fo:external-graphic src="url({concat('Customization/OpenTopic/common/artwork/', $wmFile)})" />
                    </fo:block>
                </fo:block-container>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template name="insertBodyOddHeader">
        <fo:static-content flow-name="odd-body-header">
            <xsl:call-template name="insertWatermark"/>
            <fo:block xsl:use-attribute-sets="__body__odd__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Body odd header'"/>
                    <xsl:with-param name="params">
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__odd__header__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderInnerOdd"/>
                            </fo:inline-container>
                        </inner>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__odd__header__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertBodyOddHeader</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <outer>

                            <!--HSX The fixed width definition for left right allows an absolute placement of the center text.
                            By making a fixed length for the left/right header entries, the leader will provide equal spaces
                            left/right to the center text. This allows to center the center text. Using fo:inline-container
                            allows to set the correct attributes for the right text (e.g. text-align-last = right).

                            Use the background statement to test the actual size of the left/right text
                            <xsl:attribute name="background-color">#f0f0ff</xsl:attribute>
                            -->
                            <fo:inline-container xsl:use-attribute-sets="__body__odd__header__heading_outer">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderOuterOdd"/>
                            </fo:inline-container>
                        </outer>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyEvenHeader">
        <fo:static-content flow-name="even-body-header">
            <xsl:call-template name="insertWatermark"/>
            <fo:block xsl:use-attribute-sets="__body__even__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Body even header'"/>
                    <xsl:with-param name="params">
                        <outer>
                            <!--HSX Here I provide an example to distinguish the attributes in order
                            to allow the center text to be absolutely aligned to the center of the
                            block - in contrast to be aligned exactly between left and right text.
                            That, involves setting the margin-left in the static-content-attr.xsl. For
                            this example it is demonstrated but not actually switched on.
                            -->
                            <fo:inline-container xsl:use-attribute-sets="__body__even__header__heading_outer">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderOuterEven"/>
                            </fo:inline-container>
                        </outer>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__even__header__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertBodyEvenHeader</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__even__header__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderInnerEven"/>
                            </fo:inline-container>
                        </inner>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyOddFooter">
        <fo:static-content flow-name="odd-body-footer">
            <fo:block xsl:use-attribute-sets="__body__odd__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Body odd footer'"/>
                    <xsl:with-param name="params">
                        <!--HSC comment out heading acc. to [DtPrt#8.11.1]
                        <heading>
                        <fo:inline xsl:use-attribute-sets="__body__odd__footer__heading_inner">
                        <fo:retrieve-marker retrieve-class-name="current-header"/>
                        </fo:inline>
                        </heading>
                        -->
                        <!--HSC add pubdate and copyright from bookmap acc. to [DtPrt#8.11.1] -->
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__odd__footer__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getFooterOdd"/>
                            </fo:inline-container>
                        </inner>
                        <center>
                            <!--HSC make space between the footer items acc. to [DtPrt#8.12.4] -->
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__odd__footer__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertBodyOddFooter</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <outer>
                            <fo:inline-container
                                xsl:use-attribute-sets="__body__odd__footer__heading_outer __body__odd__footer__pagenum">
                                <xsl:call-template name="markField"/>
                                <fo:block>
                                    <xsl:call-template name="insertPageNumber"/>
                                </fo:block>
                            </fo:inline-container>
                        </outer>
                        <!-- end insert -->
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>

    </xsl:template>

    <xsl:template name="insertBodyEvenFooter">
        <fo:static-content flow-name="even-body-footer">
            <!--HSC user body__even__footer__first to allow break acc. do [DtPrt#8.13.1] -->
            <fo:block xsl:use-attribute-sets="__body__even__footer">
                <!--
                <fo:block xsl:use-attribute-sets="__body__even__footer__first">
                -->
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Body even footer'"/>
                    <xsl:with-param name="params">
                        <!--HSC comment out heading acc. to [DtPrt#8.11.1] -->
                        <outer>
                            <fo:inline-container
                                xsl:use-attribute-sets="__body__even__footer__heading_outer __body__even__footer__pagenum">
                                <xsl:call-template name="markField"/>
                                <fo:block>
                                    <xsl:call-template name="insertPageNumber"/>
                                </fo:block>
                            </fo:inline-container>
                        </outer>

                        <!-- current date acc. to [DtPrt#8.13.3] -->
                        <center>
                            <!--HSC make space between the footer items acc. to [DtPrt#8.12.4] -->
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__even__footer__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertBodyEvenFooter</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <!--HSC add pubdate and copyright from bookmap acc. to [DtPrt#8.11.1] -->
                        <inner>
                            <!--HSC make space between the footer items acc. to [DtPrt#8.12.4] -->
                            <fo:inline-container xsl:use-attribute-sets="__body__even__footer__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getFooterEven"/>
                            </fo:inline-container>
                        </inner>

                        <!--HSC optionally, we could break and create another fo-block to get a new line
                        [DtPrt#8.13.1]
                        </xsl:with-param>
                        </xsl:call-template>
                        </fo:block>
                        <fo:block xsl:use-attribute-sets="__body__even__footer">
                        <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'Body even footer'"/>
                        <xsl:with-param name="params">
                        -->
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>


    <xsl:template name="insertBodyFirstEvenHeader">
        <fo:static-content flow-name="first-body-even-header">
            <xsl:call-template name="insertWatermark"/>
            <fo:block xsl:use-attribute-sets="__body__first__even__header">
                <!-- Commenting out acc. to [DtPrt#8.10] -->
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Body first even header'"/>
                    <xsl:with-param name="params">
                        <outer>
                            <fo:inline-container xsl:use-attribute-sets="__body__first__even__header__heading_outer">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderOuterEven"/>
                            </fo:inline-container>
                        </outer>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__even__header__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertBodyFirstEvenHeader</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__first__even__header__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderInnerEven"/>
                            </fo:inline-container>
                        </inner>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyFirstOddHeader">
        <fo:static-content flow-name="first-body-odd-header">
            <xsl:call-template name="insertWatermark"/>
            <fo:block xsl:use-attribute-sets="__body__first__odd__header">
                <!-- Commenting out acc. to [DtPrt#8.10] -->
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Body first odd header'"/>
                    <xsl:with-param name="params">
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__first__odd__header__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderInnerOdd"/>
                            </fo:inline-container>
                        </inner>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__odd__header__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertBodyFirstOddHeader</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <outer>
                            <fo:inline-container xsl:use-attribute-sets="__body__first__odd__header__heading_outer">
                                <!--HSC possible inserting logo acc. to [DtPrt#8.10.1] -->
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderOuterOdd"/>
                            </fo:inline-container>
                        </outer>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>

    </xsl:template>

    <!--HSX -->
    <xsl:template name="insertBodyFirstEvenFooter">
        <fo:static-content flow-name="first-body-even-footer">
            <!--HSC __body__first__footer is found in static-content-attr.xls calls odd__footer -->
            <fo:block xsl:use-attribute-sets="__body__first__even__footer">
                <xsl:call-template name="getVariable">
                    <!--HSC Body first footer is found in en.xml
                    Actually I had to put the calls in en.xml into what is available here.
                    There should always be a match between what this template offers and
                    what is called by en.xml where for this example I corrected "Body first footer" -->
                    <xsl:with-param name="id" select="'Body first even footer'"/>
                    <xsl:with-param name="params">
                        <outer>
                            <fo:inline-container
                                xsl:use-attribute-sets="__body__first__even__footer__heading_outer __body__first__footer__pagenum">
                                <fo:block>
                                    <xsl:call-template name="markField"/>
                                    <xsl:call-template name="insertPageNumber"/>
                                </fo:block>
                            </fo:inline-container>
                        </outer>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__even__footer__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertBodyFirstEvenFooter</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__first__even__footer__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getFooterFirstEven"/>
                                <!--HSC make space between the footer items acc. to [DtPrt#8.12.4]
                                The leader can always be BEHIND the header or BEFORE the pagenum
                                however (!) the actual order has to be read from en.xml, this template
                                only offers the parameters (heading, pagenum) but the order is
                                determined by en.xml -->
                            </fo:inline-container>
                        </inner>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyFirstOddFooter">
        <fo:static-content flow-name="first-body-odd-footer">
            <!--HSC __body__first__footer is found in static-content-attr.xls calls odd__footer -->
            <fo:block xsl:use-attribute-sets="__body__first__odd__footer">
                <xsl:call-template name="getVariable">
                    <!--HSC Body first footer is found in en.xml
                    Actually I had to put the calls in en.xml into what is available here.
                    There should always be a match between what this template offers and
                    what is called by en.xml where for this example I corrected "Body first footer" -->
                    <xsl:with-param name="id" select="'Body first odd footer'"/>
                    <xsl:with-param name="params">
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__first__odd__footer__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getFooterFirstOdd"/>
                            </fo:inline-container>
                        </inner>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__odd__footer__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertBodyFirstOddFooter</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <!--HSC make space between the footer items acc. to [DtPrt#8.12.4]
                            I placed the leader to frame the center entry which is
                            optimal since you can swap outer/inner and don't need to take
                            extra care for the correct placement of the spacer -->
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <outer>
                            <fo:inline-container
                                xsl:use-attribute-sets="__body__first__odd__footer__heading_outer __body__odd__footer__pagenum">
                                <xsl:call-template name="markField"/>
                                <fo:block>
                                    <xsl:call-template name="insertPageNumber"/>
                                </fo:block>
                            </fo:inline-container>
                        </outer>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyLastOddHeader">
        <fo:static-content flow-name="last-body-odd-header">
            <xsl:call-template name="insertWatermark"/>
            <fo:block xsl:use-attribute-sets="__body__last__odd__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Body odd header'"/>
                    <xsl:with-param name="params">
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__last__odd__header__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderInnerOdd"/>
                            </fo:inline-container>
                        </inner>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__odd__header__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertBodyLastOddHeader</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <outer>
                            <fo:inline-container xsl:use-attribute-sets="__body__last__odd__header__heading_outer">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderOuterOdd"/>
                            </fo:inline-container>
                        </outer>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyLastEvenHeader">
        <fo:static-content flow-name="last-body-even-header">
            <xsl:call-template name="insertWatermark"/>
            <fo:block xsl:use-attribute-sets="__body__last__even__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Body even header'"/>
                    <xsl:with-param name="params">
                        <outer>
                            <fo:inline-container xsl:use-attribute-sets="__body__last__even__header__heading_outer">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderOuterEven"/>
                            </fo:inline-container>
                        </outer>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__even__header__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertBodyLastEvenHeader</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__last__even__header__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderInnerEven"/>
                            </fo:inline-container>
                        </inner>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyLastOddFooter">
        <fo:static-content flow-name="last-body-odd-footer">
            <fo:block xsl:use-attribute-sets="__body__last__odd__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Body odd footer'"/>
                    <xsl:with-param name="params">
                        <!--HSC comment out heading acc. to [DtPrt#8.11.1]
                        <heading>
                        <fo:inline xsl:use-attribute-sets="__body__odd__footer__heading">
                        <fo:retrieve-marker retrieve-class-name="current-header"/>
                        </fo:inline>
                        </heading>
                        -->
                        <!--HSC add pubdate and copyright from bookmap acc. to [DtPrt#8.11.1] -->
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__last__odd__footer__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getFooterOdd"/>
                            </fo:inline-container>
                        </inner>
                        <center>
                            <!--HSC make space between the footer items acc. to [DtPrt#8.12.4] -->
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__odd__footer__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertBodyLastOddFooter</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <outer>
                            <fo:inline-container
                                xsl:use-attribute-sets="__body__last__odd__footer__heading_outer __body__odd__footer__pagenum">
                                <xsl:call-template name="markField"/>
                                <fo:block>
                                    <xsl:call-template name="insertPageNumber"/>
                                </fo:block>
                            </fo:inline-container>
                        </outer>
                        <!-- end insert -->
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyLastEvenFooter">
        <fo:static-content flow-name="last-body-even-footer">
            <fo:block xsl:use-attribute-sets="__body__last__even__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Body even footer'"/>
                    <xsl:with-param name="params">
                        <!--HSC comment out heading acc. to [DtPrt#8.11.1] -->
                        <outer>
                            <fo:inline-container
                                xsl:use-attribute-sets="__body__last__even__footer__heading_outer __body__even__footer__pagenum">
                                <xsl:call-template name="markField"/>
                                <fo:block>
                                    <xsl:call-template name="insertPageNumber"/>
                                </fo:block>
                            </fo:inline-container>
                        </outer>

                        <!-- current date acc. to [DtPrt#8.13.3] -->
                        <center>
                            <!--HSC make space between the footer items acc. to [DtPrt#8.12.4] -->
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__even__footer__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertBodyLastEvenFooter</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <!--HSC add pubdate and copyright from bookmap acc. to [DtPrt#8.11.1] -->
                        <inner>
                            <!--HSC make space between the footer items acc. to [DtPrt#8.12.4] -->
                            <fo:inline-container xsl:use-attribute-sets="__body__last__even__footer__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getFooterEven"/>
                            </fo:inline-container>
                        </inner>

                        <!--HSC optionally, we could break and create another fo-block to get a new line
                        [DtPrt#8.13.1] -->
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertBodyFootnoteSeparator">
        <fo:static-content flow-name="xsl-footnote-separator">
            <fo:block>
                <fo:leader xsl:use-attribute-sets="__body__footnote__separator"/>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertTocOddHeader">
        <fo:static-content flow-name="odd-toc-header">
            <fo:block xsl:use-attribute-sets="__toc__odd__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Toc odd header'"/>
                    <!--HSC put boiler plate to TOC/INDEX acc. to [DtPrt#8.10.2] -->
                    <xsl:with-param name="params">
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__toc__odd__header__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderInnerOdd"/>
                            </fo:inline-container>
                        </inner>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__toc__odd__header__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertTocOddHeader</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <outer>
                            <fo:inline-container xsl:use-attribute-sets="__toc__odd__header__heading_outer">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderOuterOdd"/>
                            </fo:inline-container>
                        </outer>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertTocEvenHeader">
        <fo:static-content flow-name="even-toc-header">
            <xsl:call-template name="insertWatermark"/>
            <fo:block xsl:use-attribute-sets="__toc__even__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Toc even header'"/>
                    <xsl:with-param name="params">
                        <!--HSC added booktitle acc. to [DtPrt#8.10.4.4] -->
                        <outer>
                            <fo:inline-container xsl:use-attribute-sets="__toc__even__header__heading_outer">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderOuterEven"/>
                            </fo:inline-container>
                        </outer>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__toc__even__header__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertTocEvenHeader</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__toc__even__header__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderInnerEven"/>
                            </fo:inline-container>
                        </inner>
                        <!--HSC comment out acc. to [DtPrt#8.10.4.4]
                        <inner>
                        <xsl:value-of select="$productName"/>
                        </inner>
                        -->
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>

    </xsl:template>

    <xsl:template name="insertTocOddFooter">
        <fo:static-content flow-name="odd-toc-footer">
            <fo:block xsl:use-attribute-sets="__toc__odd__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Toc odd footer'"/>
                    <xsl:with-param name="params">
                        <!--HSC add pubdate and copyright from bookmap acc. to [DtPrt#8.11.1] -->
                        <inner>
                            <fo:inline-container
                                xsl:use-attribute-sets="__toc__odd__footer__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getFooterOdd"/>
                            </fo:inline-container>
                        </inner>
                        <center>
                            <!--HSC make space between the footer items acc. to [DtPrt#8.12.4] -->
                            <fo:inline-container
                                xsl:use-attribute-sets="__toc__odd__footer__heading_center">
                                <xsl:call-template name="markField"/>
                                <fo:block>
                                    <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                                    <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                        <xsl:text>insertTocOddFooter</xsl:text>
                                    </xsl:if>
                                    <xsl:text>&#xA0;</xsl:text>
                                    <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                                </fo:block>
                            </fo:inline-container>
                        </center>
                        <outer>
                            <fo:inline-container
                                xsl:use-attribute-sets="__toc__odd__footer__heading_outer __toc__odd__footer__pagenum">
                                <xsl:call-template name="markField"/>
                                <fo:block>
                                    <!--HSC adding chapter prefix to footer page num acc. to [DtPrt#8.11.3]:9
                                    Since there is no chapter here .... We could add some variable (e.g. TOC-)
                                    but in general I wouldn't want anything here
                                <fo:retrieve-marker retrieve-class-name="current-chapter-number"/> -->
                                    <xsl:call-template name="insertPageNumber">
                                        <xsl:with-param name="prefix" select="'TOC'"/>
                                    </xsl:call-template>
                                </fo:block>
                            </fo:inline-container>
                        </outer>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertTocEvenFooter">
        <fo:static-content flow-name="even-toc-footer">
            <fo:block xsl:use-attribute-sets="__toc__even__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Toc even footer'"/>
                    <xsl:with-param name="params">
                        <outer>
                            <fo:inline-container
                                xsl:use-attribute-sets="__toc__even__footer__heading_outer __toc__even__footer__pagenum">
                                <xsl:call-template name="markField"/>
                                <fo:block>
                                    <xsl:call-template name="insertPageNumber">
                                        <xsl:with-param name="prefix" select="'TOC'"/>
                                    </xsl:call-template>
                                </fo:block>
                            </fo:inline-container>
                        </outer>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline
                                xsl:use-attribute-sets="__toc__even__footer__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertTocEvenFooter</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <inner>
                            <!--HSC add TOC prefix before the page number -->
                            <!--HSC add pubdate and copyright from bookmap acc. to [DtPrt#8.11.1] -->
                            <fo:inline-container
                                xsl:use-attribute-sets="__toc__even__footer__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getFooterEven"/>
                            </fo:inline-container>
                        </inner>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>

    </xsl:template>

    <!--HSC create template for TocFirstHeader acc. to [DtPrt#8.11.2] -->
    <xsl:template name="insertTocFirstEvenHeader">
        <fo:static-content flow-name="first-toc-even-header">
            <xsl:call-template name="insertWatermark"/>
            <fo:block xsl:use-attribute-sets="__toc__even__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Toc first even header'"/>
                    <xsl:with-param name="params">
                        <outer>
                            <!--HSC using the attribute sets is not relevant for the logo
                        however, it is a nice reservation in case we change later
                        -->
                            <fo:inline-container xsl:use-attribute-sets="__toc__even__header__heading_outer">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderOuterEven"/>
                            </fo:inline-container>
                        </outer>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <!--HSC add TOC prefix before the page number -->
                            <fo:inline xsl:use-attribute-sets="__toc__even__header__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertTocFirstEvenHeader</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <inner>
                            <!--HSC add TOC prefix before the page number -->
                            <fo:inline-container
                                xsl:use-attribute-sets="__toc__even__header__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderInnerEven"/>
                            </fo:inline-container>
                        </inner>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertTocFirstOddHeader">
        <fo:static-content flow-name="first-toc-odd-header">
            <xsl:call-template name="insertWatermark"/>
            <fo:block xsl:use-attribute-sets="__toc__odd__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Toc first odd header'"/>
                    <xsl:with-param name="params">
                        <inner>
                            <!--HSC add TOC prefix before the page number -->
                            <fo:inline-container
                                xsl:use-attribute-sets="__toc__odd__header__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderInnerOdd"/>
                            </fo:inline-container>
                        </inner>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <!--HSC add TOC prefix before the page number -->
                            <fo:inline xsl:use-attribute-sets="__toc__odd__header__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertTocFirstOddHeader</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <outer>
                            <!--HSC using the attribute sets is not relevant for the logo
                        however, it is a nice reservation in case we change later
                        -->
                            <fo:inline-container
                                xsl:use-attribute-sets=" __toc__odd__header__heading_outer">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderOuterOdd"/>
                            </fo:inline-container>
                        </outer>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <!--HSC create template for TocFirstFooter acc. to [DtPrt#8.11.2] -->
    <xsl:template name="insertTocFirstEvenFooter">
        <fo:static-content flow-name="first-toc-even-footer">
            <fo:block xsl:use-attribute-sets="__toc__even__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Toc first even footer'"/>
                    <xsl:with-param name="params">
                        <outer>
                            <fo:inline-container xsl:use-attribute-sets="__toc__even__footer__pagenum">
                                <fo:block
                                    xsl:use-attribute-sets="__toc__even__footer__heading_outer __body__first__footer__pagenum">
                                    <xsl:call-template name="markField"/>
                                    <xsl:call-template name="insertPageNumber">
                                        <xsl:with-param name="prefix" select="'TOC'"/>
                                    </xsl:call-template>
                                </fo:block>
                            </fo:inline-container>
                        </outer>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <!--HSC add TOC prefix before the page number -->
                            <fo:inline
                                xsl:use-attribute-sets="__toc__even__footer__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertTocFirstEvenFooter</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <inner>
                            <!--HSC add TOC prefix before the page number -->
                            <fo:inline-container
                                xsl:use-attribute-sets="__toc__even__footer__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getFooterFirstEven"/>
                            </fo:inline-container>
                        </inner>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertTocFirstOddFooter">
        <fo:static-content flow-name="first-toc-odd-footer">
            <fo:block xsl:use-attribute-sets="__toc__odd__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Toc first odd footer'"/>
                    <xsl:with-param name="params">
                        <inner>
                            <fo:inline-container
                                xsl:use-attribute-sets="__toc__odd__footer__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getFooterFirstOdd"/>
                            </fo:inline-container>
                            <!--HSC make space between the footer items acc. to [DtPrt#8.12.4] -->
                        </inner>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline
                                xsl:use-attribute-sets="__toc__odd__footer__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertTocFirstOddFooter</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <outer>
                            <fo:inline-container
                                xsl:use-attribute-sets="__toc__odd__footer__heading_outer __toc__odd__footer__pagenum">
                                <xsl:call-template name="markField"/>
                                <fo:block>
                                    <xsl:call-template name="insertPageNumber">
                                        <xsl:with-param name="prefix" select="'TOC'"/>
                                    </xsl:call-template>
                                </fo:block>
                            </fo:inline-container>
                        </outer>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertIndexOddHeader">
        <fo:static-content flow-name="odd-index-header">
            <xsl:call-template name="insertWatermark"/>
            <fo:block xsl:use-attribute-sets="__index__odd__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Index odd header'"/>
                    <xsl:with-param name="params">
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__index__odd__header__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderInnerOdd"/>
                            </fo:inline-container>
                        </inner>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__index__odd__header__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertIndexOddHeader</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <outer>
                            <fo:inline-container xsl:use-attribute-sets="__index__odd__header__heading_outer">
                                <!--HSX [Xslfo#6.6.8] -->
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderOuterOdd"/>
                            </fo:inline-container>
                        </outer>
                    </xsl:with-param>
                </xsl:call-template>
                <!--HSC add logo acc. to [DtPrt#8.10.2] -->
                <!-- end add logo -->
            </fo:block>
        </fo:static-content>

    </xsl:template>

    <xsl:template name="insertIndexEvenHeader">
        <fo:static-content flow-name="even-index-header">
            <xsl:call-template name="insertWatermark"/>
            <fo:block xsl:use-attribute-sets="__index__even__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Index even header'"/>
                    <xsl:with-param name="params">
                        <outer>
                            <!--HSX Here I provide an example to distinguish the attributes in order
                        to allow the center text to be absolutely aligned to the center of the
                        block - in contrast to be aligned exactly between left and right text.
                        That, involves setting the margin-left in the static-content-attr.xsl. For
                        this example it is demonstrated but not actually switched on.
                        -->
                            <fo:inline-container xsl:use-attribute-sets="__index__even__header__heading_outer">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderOuterEven"/>
                            </fo:inline-container>
                        </outer>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__index__even__header__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertIndexEvenHeader</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__index__even__header__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderInnerEven"/>
                            </fo:inline-container>
                        </inner>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>

    </xsl:template>

    <xsl:template name="insertIndexOddFooter">
        <fo:static-content flow-name="odd-index-footer">
            <fo:block xsl:use-attribute-sets="__index__odd__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Index odd footer'"/>
                    <xsl:with-param name="params">
                        <inner>
                            <fo:inline-container
                                xsl:use-attribute-sets="__index__odd__footer__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getFooterOdd"/>
                            </fo:inline-container>
                        </inner>
                        <center>
                            <!--HSC make space between the footer items acc. to [DtPrt#8.12.4] -->
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline
                                xsl:use-attribute-sets="__index__odd__footer__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertIndexOddFooter</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <outer>
                            <fo:inline-container
                                xsl:use-attribute-sets="__index__odd__footer__heading_outer __index__odd__footer__pagenum">
                                <xsl:call-template name="markField"/>
                                <fo:block>
                                    <!--HSC adding chapter prefix to footer page num acc. to [DtPrt#8.11.3]:9
                                Since there is no chapter here .... We could add some variable (e.g. TOC-)
                                but in general I wouldn't want anything here
                            <fo:retrieve-marker retrieve-class-name="current-chapter-number"/> -->
                                    <xsl:call-template name="insertPageNumber">
                                        <xsl:with-param name="prefix" select="'INDEX'"/>
                                    </xsl:call-template>
                                </fo:block>
                            </fo:inline-container>
                        </outer>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertIndexEvenFooter">
        <fo:static-content flow-name="even-index-footer">
            <fo:block xsl:use-attribute-sets="__index__even__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Index even footer'"/>
                    <xsl:with-param name="params">
                        <outer>
                            <fo:inline-container
                                xsl:use-attribute-sets="__index__even__footer__heading_outer __index__even__footer__pagenum">
                                <xsl:call-template name="markField"/>
                                <fo:block xsl:use-attribute-sets="__body__first__footer__pagenum">
                                    <xsl:call-template name="insertPageNumber">
                                        <xsl:with-param name="prefix" select="'INDEX'"/>
                                    </xsl:call-template>
                                </fo:block>
                            </fo:inline-container>
                        </outer>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline>
                                <!-- xsl:use-attribute-sets="__index__even__footer"> -->
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertIndexEvenFooter</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <inner>
                            <fo:inline-container
                                xsl:use-attribute-sets="__index__even__footer__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getFooterEven"/>
                            </fo:inline-container>
                            <!--HSC make space between the footer items acc. to [DtPrt#8.12.4] -->
                        </inner>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertPrefaceOddHeader">
        <fo:static-content flow-name="odd-body-header">
            <xsl:call-template name="insertWatermark"/>
            <fo:block xsl:use-attribute-sets="__body__odd__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface odd header'"/>
                    <xsl:with-param name="params">
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__odd__header__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderInnerOdd"/>
                            </fo:inline-container>
                        </inner>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__odd__header__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertPrefaceOddHeader</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <outer>
                            <fo:inline-container xsl:use-attribute-sets="__body__odd__header__heading_outer">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderOuterOdd"/>
                            </fo:inline-container>
                        </outer>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertPrefaceEvenHeader">
        <fo:static-content flow-name="even-body-header">
            <xsl:call-template name="insertWatermark"/>
            <fo:block xsl:use-attribute-sets="__body__even__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface even header'"/>
                    <xsl:with-param name="params">
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__even__header__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderOuterOdd"/>
                            </fo:inline-container>
                        </inner>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__even__header__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertPrefaceEvenHeader</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <outer>
                            <fo:inline-container xsl:use-attribute-sets="__body__even__header__heading_outer">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderInnerOdd"/>
                            </fo:inline-container>
                        </outer>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>

    </xsl:template>

    <xsl:template name="insertPrefaceFirstOddHeader">
        <fo:static-content flow-name="first-body-odd-header">
            <xsl:call-template name="insertWatermark"/>
            <fo:block xsl:use-attribute-sets="__body__first__odd__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface first odd header'"/>
                    <xsl:with-param name="params">
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__odd__header__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderInnerOdd"/>
                            </fo:inline-container>
                        </inner>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__odd__header__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertPrefaceFirstOddHeader</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <outer>
                            <fo:inline-container xsl:use-attribute-sets="__body__odd__header__heading_outer">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderOuterOdd"/>
                            </fo:inline-container>
                        </outer>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertPrefaceFirstEvenHeader">
        <fo:static-content flow-name="first-body-even-header">
            <xsl:call-template name="insertWatermark"/>
            <fo:block xsl:use-attribute-sets="__body__first__even__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface first even header'"/>
                    <xsl:with-param name="params">
                        <outer>
                            <fo:inline-container xsl:use-attribute-sets="__body__even__header__heading_outer">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderOuterEven"/>
                            </fo:inline-container>
                        </outer>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__even__header__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertPrefaceFirstEvenHeader</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__even__header__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderInnerEven"/>
                            </fo:inline-container>
                        </inner>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertPrefaceOddFooter">
        <fo:static-content flow-name="odd-body-footer">
            <fo:block xsl:use-attribute-sets="__body__odd__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface odd footer'"/>
                    <xsl:with-param name="params">
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__odd__footer__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getFooterOdd"/>
                            </fo:inline-container>
                        </inner>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__odd__footer__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertPrefaceOddFooter</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <outer>
                            <fo:inline-container
                                xsl:use-attribute-sets="__body__odd__footer__heading_outer __body__odd__footer__pagenum">
                                <xsl:call-template name="markField"/>
                                <fo:block>
                                    <!--HSC adding chapter prefix to footer page num acc. to [DtPrt#8.11.3]:9 -->
                                    <xsl:call-template name="insertPageNumber"/>
                                </fo:block>
                            </fo:inline-container>
                        </outer>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertPrefaceEvenFooter">
        <fo:static-content flow-name="even-body-footer">
            <fo:block xsl:use-attribute-sets="__body__even__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface even footer'"/>
                    <xsl:with-param name="params">
                        <outer>
                            <fo:inline-container
                                xsl:use-attribute-sets="__body__even__footer__heading_outer __body__even__footer__pagenum">
                                <xsl:call-template name="markField"/>
                                <fo:block>
                                    <!--HSC adding chapter prefix to footer page num acc. to [DtPrt#8.11.3]:9 -->
                                    <xsl:call-template name="insertPageNumber"/>
                                </fo:block>
                            </fo:inline-container>
                        </outer>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__even__footer__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertPrefaceEvenFooter</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <inner>
                            <fo:inline-container
                                xsl:use-attribute-sets="__body__even__footer__heading_inner __body__even__footer__heading">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getFooterEven"/>
                            </fo:inline-container>
                        </inner>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertPrefaceFirstOddFooter">
        <fo:static-content flow-name="first-body-odd-footer">
            <fo:block xsl:use-attribute-sets="__body__odd__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface first odd footer'"/>
                    <xsl:with-param name="params">
                        <!--HSC Fixup preface footer ...-->
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__first__odd__footer__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getFooterFirstOdd"/>
                            </fo:inline-container>
                        </inner>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__odd__footer__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertPrefaceFirstOddFooter</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <outer>
                            <fo:inline-container
                                xsl:use-attribute-sets="__body__first__odd__footer__heading_outer __body__first__footer__pagenum">
                                <xsl:call-template name="markField"/>
                                <fo:block>
                                    <xsl:call-template name="insertPageNumber"/>
                                </fo:block>
                            </fo:inline-container>
                        </outer>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertPrefaceFirstEvenFooter">
        <fo:static-content flow-name="first-body-even-footer">
            <fo:block xsl:use-attribute-sets="__body__even__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface first even footer'"/>
                    <xsl:with-param name="params">
                        <!--HSC Fixup preface footer ...-->
                        <outer>
                            <fo:inline-container
                                xsl:use-attribute-sets="__body__first__even__footer__heading_outer __body__first__footer__pagenum">
                                <xsl:call-template name="markField"/>
                                <fo:block>
                                    <xsl:call-template name="insertPageNumber"/>
                                </fo:block>
                            </fo:inline-container>
                        </outer>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__even__footer__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertPrefaceFirstEvenFooter</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__first__even__footer__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getFooterFirstEven"/>
                            </fo:inline-container>
                        </inner>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertPrefaceLastOddHeader">
        <fo:static-content flow-name="last-body-odd-header">
            <xsl:call-template name="insertWatermark"/>
            <!-- odd-preface-header"> -->
            <fo:block xsl:use-attribute-sets="__body__last__odd__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface odd header'"/>
                    <xsl:with-param name="params">
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__odd__header__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderInnerOdd"/>
                            </fo:inline-container>
                        </inner>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__odd__header__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertPrefaceLastOddHeader</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <outer>
                            <fo:inline-container xsl:use-attribute-sets="__body__odd__header__heading_outer">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderOuterOdd"/>
                            </fo:inline-container>
                        </outer>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertPrefaceLastEvenHeader">
        <fo:static-content flow-name="last-body-even-header">
            <xsl:call-template name="insertWatermark"/>
            <!-- odd-preface-header"> -->
            <fo:block xsl:use-attribute-sets="__body__last__even__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface even header'"/>
                    <xsl:with-param name="params">
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__even__header__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderOuterOdd"/>
                            </fo:inline-container>
                        </inner>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__even__header__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertPrefaceLastEvenHeader</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <outer>
                            <fo:inline-container xsl:use-attribute-sets="__body__even__header__heading_outer">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderInnerOdd"/>
                            </fo:inline-container>
                        </outer>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertPrefaceLastOddFooter">
        <fo:static-content flow-name="last-body-odd-footer">
            <fo:block xsl:use-attribute-sets="__body__last__odd__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface last odd footer'"/>
                    <xsl:with-param name="params">
                        <!--HSC Fixup preface footer ...-->
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__last__odd__footer__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getFooterOdd"/>
                            </fo:inline-container>
                        </inner>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__odd__footer__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertPrefaceLastOddFooter</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <outer>
                            <fo:inline-container
                                xsl:use-attribute-sets="__body__last__odd__footer__heading_outer __body__first__footer__pagenum">
                                <xsl:call-template name="markField"/>
                                <fo:block>
                                    <xsl:call-template name="insertPageNumber"/>
                                </fo:block>
                            </fo:inline-container>
                        </outer>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertPrefaceLastEvenFooter">
        <fo:static-content flow-name="last-body-even-footer">
            <fo:block xsl:use-attribute-sets="__body__last__even__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface last even footer'"/>
                    <xsl:with-param name="params">
                        <!--HSC Fixup preface footer ...-->
                        <outer>
                            <fo:inline-container
                                xsl:use-attribute-sets="__body__last__even__footer__heading_outer __body__first__footer__pagenum">
                                <xsl:call-template name="markField"/>
                                <fo:block>
                                    <xsl:call-template name="insertPageNumber"/>
                                </fo:block>
                            </fo:inline-container>
                        </outer>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__even__footer__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertPrefaceLastEvenFooter</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__last__even__footer__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getFooterEven"/>
                            </fo:inline-container>
                        </inner>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertPrefaceFootnoteSeparator">
        <fo:static-content flow-name="xsl-footnote-separator">
            <fo:block>
                <!--HSX
            <fo:leader xsl:use-attribute-sets="__body__footnote__separator"/>
            -->
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface first odd footer'"/>
                    <xsl:with-param name="params">
                        <!--HSC Fixup preface footer ...-->
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__first__odd__footer__heading_inner">
                                <xsl:call-template name="markField"/>
                                <fo:block>
                                    <fo:retrieve-marker retrieve-class-name="current-header"/>
                                </fo:block>
                            </fo:inline-container>
                        </inner>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__odd__footer__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertPrefaceFootnoteSeparator</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <outer>
                            <fo:inline-container
                                xsl:use-attribute-sets="__body__first__odd__footer__heading_outer __body__first__footer__pagenum">
                                <xsl:call-template name="markField"/>
                                <fo:block>
                                    <xsl:call-template name="insertPageNumber"/>
                                </fo:block>
                            </fo:inline-container>
                        </outer>
                    </xsl:with-param>
                </xsl:call-template>

            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertFrontMatterOddHeader">

        <fo:static-content flow-name="odd-frontmatter-header">
            <xsl:call-template name="insertWatermark"/>
            <fo:block xsl:use-attribute-sets="__body__odd__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface odd header'"/>
                    <xsl:with-param name="params">
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__odd__header__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderInnerOdd"/>
                            </fo:inline-container>
                        </inner>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__odd__header__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertFrontMatterOddHeader</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                                <!--
                            <fo:retrieve-marker retrieve-class-name="current-header"/>
                            -->
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <outer>
                            <fo:inline-container
                                xsl:use-attribute-sets="__body__odd__header__heading_outer">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderOuterOdd"/>
                            </fo:inline-container>
                        </outer>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>

    </xsl:template>

    <xsl:template name="insertFrontMatterEvenHeader">
        <fo:static-content flow-name="even-frontmatter-header">
            <xsl:call-template name="insertWatermark"/>
            <fo:block xsl:use-attribute-sets="__body__even__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface even header'"/>
                    <xsl:with-param name="params">
                        <outer>
                            <fo:inline-container
                                xsl:use-attribute-sets="__body__even__header__heading_outer">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderOuterEven"/>
                            </fo:inline-container>
                        </outer>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__even__header__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertFrontMatterEvenHeader</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__even__header__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderInnerEven"/>
                            </fo:inline-container>
                        </inner>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>


    <xsl:template name="insertFrontMatterLastHeader">
        <fo:static-content flow-name="last-frontmatter-header">
            <xsl:call-template name="insertWatermark"/>
            <fo:block xsl:use-attribute-sets="__body__even__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface even header'"/>
                    <xsl:with-param name="params">
                        <outer>
                            <fo:inline-container
                                xsl:use-attribute-sets="__body__even__header__heading_outer">
                                <xsl:call-template name="markField"/>
                                <fo:block>
                                    <fo:retrieve-marker retrieve-class-name="current-header"/>
                                </fo:block>
                            </fo:inline-container>
                        </outer>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__even__header__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertFrontMatterLastHeader</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__even__header__heading_inner">
                                <fo:block>
                                    <xsl:call-template name="markField"/>
                                    <fo:retrieve-marker retrieve-class-name="current-header"/>
                                </fo:block>
                            </fo:inline-container>
                        </inner>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertFrontMatterLastFooter">
        <fo:static-content flow-name="last-frontmatter-footer">
            <fo:block xsl:use-attribute-sets="__body__last__footer">
                <xsl:text>insertFrontMatterLastFooter</xsl:text>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertFrontMatterFootnoteSeparator">
        <fo:static-content flow-name="xsl-footnote-separator">
            <fo:block>
                <fo:leader xsl:use-attribute-sets="__body__footnote__separator"/>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertFrontMatterOddFooter">
        <fo:static-content flow-name="odd-frontmatter-footer">
            <fo:block xsl:use-attribute-sets="__body__odd__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface odd footer'"/>
                    <xsl:with-param name="params">
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__odd__footer__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getFooterOdd"/>
                            </fo:inline-container>
                        </inner>
                        <center>
                            <fo:inline xsl:use-attribute-sets="__body__odd__footer__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertFrontMatterOddFooter</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                        </center>
                        <outer>
                            <fo:inline-container
                                xsl:use-attribute-sets="__body__odd__footer__heading_outer __body__odd__footer__pagenum">
                                <xsl:call-template name="markField"/>
                                <fo:block>
                                    <xsl:call-template name="insertPageNumber"/>
                                </fo:block>
                            </fo:inline-container>
                        </outer>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertFrontMatterEvenFooter">
        <fo:static-content flow-name="even-frontmatter-footer">
            <fo:block xsl:use-attribute-sets="__body__even__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Preface even footer'"/>
                    <xsl:with-param name="params">
                        <outer>
                            <fo:inline-container
                                xsl:use-attribute-sets="__body__even__footer__heading_outer __body__even__footer__pagenum">
                                <xsl:call-template name="markField"/>
                                <fo:block>
                                    <xsl:call-template name="insertPageNumber"/>
                                </fo:block>
                            </fo:inline-container>
                        </outer>
                        <center>
                            <fo:inline xsl:use-attribute-sets="__body__even__footer__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertFrontMatterEvenFooter</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                        </center>
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__even__header__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getFooterEven"/>
                            </fo:inline-container>
                        </inner>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>

    </xsl:template>

    <!-- ============ GLOSSARY ============ -->
    <xsl:template name="insertGlossaryOddHeader">
        <fo:static-content flow-name="odd-glossary-header">
            <xsl:call-template name="insertWatermark"/>
            <fo:block xsl:use-attribute-sets="__glossary__odd__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Glossary odd header'"/>
                    <xsl:with-param name="params">
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__odd__header__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderInnerOdd"/>
                            </fo:inline-container>
                        </inner>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__odd__header__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertGlossaryOddHeader</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <outer>
                            <fo:inline-container xsl:use-attribute-sets="__body__odd__header__heading_outer">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderOuterOdd"/>
                                <!--HSX [Xslfo#6.6.8] -->
                                <!--HSC inserting logo acc. to [DtPrt#8.10.1]
                                <fo:external-graphic src="url(Customization/OpenTopic/common/artwork/NfcLogo.jpg)"/>
                                -->
                            </fo:inline-container>
                        </outer>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>

    <xsl:template name="insertGlossaryEvenHeader">
        <fo:static-content flow-name="even-glossary-header">
            <xsl:call-template name="insertWatermark"/>
            <fo:block xsl:use-attribute-sets="__glossary__even__header">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Glossary even header'"/>
                    <xsl:with-param name="params">
                        <outer>
                            <!--HSX Here I provide an example to distinguish the attributes in order
                        to allow the center text to be absolutely aligned to the center of the
                        block - in contrast to be aligned exactly between left and right text.
                        That, involves setting the margin-left in the static-content-attr.xsl. For
                        this example it is demonstrated but not actually switched on.
                        -->
                            <fo:inline-container xsl:use-attribute-sets="__body__even__header__heading_outer">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderOuterEven"/>
                            </fo:inline-container>
                        </outer>
                        <center>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__even__header__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertGlossaryEvenHeader</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__even__header__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getHeaderInnerEven"/>
                            </fo:inline-container>
                        </inner>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>

    </xsl:template>

    <xsl:template name="insertGlossaryOddFooter">
        <fo:static-content flow-name="odd-glossary-footer">
            <fo:block xsl:use-attribute-sets="__glossary__odd__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Glossary odd footer'"/>
                    <xsl:with-param name="params">
                        <!--HSC add pubdate and copyright from bookmap acc. to [DtPrt#8.11.1] -->
                        <inner>
                            <fo:inline-container xsl:use-attribute-sets="__body__odd__footer__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getFooterOdd"/>
                            </fo:inline-container>
                        </inner>
                        <center>
                            <!--HSC make space between the footer items acc. to [DtPrt#8.12.4] -->
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__odd__footer__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertGlossaryOddFooter</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <outer>
                            <fo:inline-container
                                xsl:use-attribute-sets="__body__odd__footer__heading_outer __body__odd__footer__pagenum">
                                <fo:block>
                                    <xsl:call-template name="markField"/>
                                    <xsl:call-template name="insertPageNumber"/>
                                </fo:block>
                            </fo:inline-container>
                        </outer>
                        <!-- end insert -->
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>

    </xsl:template>

    <xsl:template name="insertGlossaryEvenFooter">
        <fo:static-content flow-name="even-glossary-footer">
            <fo:block xsl:use-attribute-sets="__glossary__even__footer">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Glossary even footer'"/>
                    <xsl:with-param name="params">
                        <!--HSC comment out heading acc. to [DtPrt#8.11.1] -->
                        <outer>
                            <fo:inline-container
                                xsl:use-attribute-sets="__body__even__footer__heading_outer __body__even__footer__pagenum">
                                <xsl:call-template name="markField"/>
                                <fo:block>
                                    <xsl:call-template name="insertPageNumber"/>
                                </fo:block>
                            </fo:inline-container>
                        </outer>

                        <!-- current date acc. to [DtPrt#8.13.3] -->
                        <center>
                            <!--HSC make space between the footer items acc. to [DtPrt#8.12.4] -->
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                            <fo:inline xsl:use-attribute-sets="__body__even__footer__heading_center">
                                <xsl:call-template name="markField"/>
                                <xsl:if test="contains($dbghs, 'dbg_showLabels')">
                                    <xsl:text>insertGlossaryEvenFooter</xsl:text>
                                </xsl:if>
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:inline>
                            <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                        </center>
                        <!--HSC add pubdate and copyright from bookmap acc. to [DtPrt#8.11.1] -->
                        <inner>
                            <!--HSC make space between the footer items acc. to [DtPrt#8.12.4] -->
                            <fo:inline-container xsl:use-attribute-sets="__body__even__footer__heading_inner">
                                <xsl:call-template name="markField"/>
                                <xsl:call-template name="getFooterEven"/>
                            </fo:inline-container>
                        </inner>
                    </xsl:with-param>
                </xsl:call-template>
            </fo:block>
        </fo:static-content>
    </xsl:template>


    <!--HSC inserting the page number is sensitive to the associated prefix.
The prefix should typically be the chapter number but on certain
types there is not yet a chapter number (notices|abstract|preface).
Hence we have to avoid the connecting dash " - "
-->

    <xsl:template name="insertPageNumber">
        <xsl:param name="prefix"/>

        <xsl:variable name="topicType">
            <xsl:call-template name="determineTopicType"/>
        </xsl:variable>

        <xsl:if test="contains($PageLayout, 'prefix_chapter')">
            <!--HSC if a parameter is given it overrides any default -->
            <xsl:choose>
                <xsl:when test="$prefix">
                    <xsl:value-of select="$prefix"/>
                    <xsl:text> - </xsl:text>
                </xsl:when>
                <!-- otherwise we do the default processing -->
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$topicType = 'topicNotices'">
                            <!--HSC choose whatever you want for the text to be put
                        as prefix to the page number, here I do the topic type title-->
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Notices title'"/>
                            </xsl:call-template>
                            <xsl:text> - </xsl:text>
                        </xsl:when>
                        <xsl:when test="$topicType = 'topicAbstract'">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Abstract title'"/>
                            </xsl:call-template>
                            <xsl:text> - </xsl:text>
                        </xsl:when>
                        <xsl:when test="$topicType = 'topicGlossaryList'">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Glossary title'"/>
                            </xsl:call-template>
                            <xsl:text> - </xsl:text>
                        </xsl:when>
                        <xsl:when test="$topicType = 'topicPreface'">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Preface title'"/>
                            </xsl:call-template>
                            <xsl:text> - </xsl:text>
                        </xsl:when>
                        <xsl:otherwise>
                            <!--HSC adding chapter prefix to footer page num acc. to  [DtPrt#8.11.3]:9 -->
                            <fo:retrieve-marker retrieve-class-name="current-chapter-number"/>
                            <xsl:text>-</xsl:text>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
                <!--HSC no parameter was given -->
            </xsl:choose>
        </xsl:if>
        <!--HSC finally the page number is inserted -->
        <fo:page-number/>
    </xsl:template>

    <!-- mark field with background color -->
    <xsl:template name="markField">
        <xsl:if test="contains($dbghs, 'dbg_markfields')">
            <xsl:attribute name="background-color">
                <xsl:value-of select="$Debug-markField"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>
</xsl:stylesheet>
