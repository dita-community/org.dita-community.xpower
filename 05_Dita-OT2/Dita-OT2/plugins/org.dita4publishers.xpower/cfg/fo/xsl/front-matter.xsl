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
    xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:opentopic="http://www.idiominc.com/opentopic"
    exclude-result-prefixes="opentopic xs"
    version="2.0">

    <xsl:template match="*[contains(@class, ' map/topicmeta ')]">
        <fo:block-container xsl:use-attribute-sets="__frontmatter__bookmeta__container">
            <xsl:apply-templates/>
        </fo:block-container>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/author ')]">
        <fo:block xsl:use-attribute-sets="author" >
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' bookmap/bookrights ')]">
        <fo:block xsl:use-attribute-sets="author" >
            <!--
            <xsl:apply-templates select="child::*//organization"/>
            <xsl:apply-templates select="child::*[contains(@class, ' topic/data bookmap/copyrfirst ')]/year"/>
            -->
            <xsl:apply-templates select="child::*//organization"/>
            <xsl:apply-templates select="child::*[contains(@class, ' topic/data bookmap/copyrfirst ')]/year"/>
        </fo:block>
    </xsl:template>

    <!--HSX on multiple companies (we support 2) list the company names
            separated by a slash
    -->
    <xsl:template match="*[contains(@class, ' bookmap/organization ')]">
        <xsl:if test="count(preceding-sibling::organization) &gt; 0">
            <xsl:text>&#xA0;/&#xA0;</xsl:text>
        </xsl:if>
        <xsl:apply-templates/>
    </xsl:template>
        
    <xsl:template match="*[contains(@class, ' bookmap/copyrfirst ')]">
        <fo:block xsl:use-attribute-sets="author" >
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' bookmap/copyrlast ')]">
        <fo:block xsl:use-attribute-sets="author" >
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/bookowner ')]">
        <fo:block xsl:use-attribute-sets="author" >
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/organization ')]">
        <fo:block xsl:use-attribute-sets="author" >
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' bookmap/year ')]">
        <fo:block xsl:use-attribute-sets="author" >
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/publisher ')]">
        <fo:block xsl:use-attribute-sets="publisher" >
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/copyright ')]">
        <fo:block xsl:use-attribute-sets="copyright" >
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/copyryear ')]">
        <fo:inline xsl:use-attribute-sets="copyryear" >
            <xsl:value-of select="@year"/><xsl:text> </xsl:text>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/copyrholder ')]">
        <fo:inline xsl:use-attribute-sets="copyrholder" >
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:variable name="map" select="//opentopic:map"/>

    <xsl:template name="createFrontMatter">
        <xsl:if test="$generate-front-cover">
        <fo:page-sequence master-reference="front-matter" xsl:use-attribute-sets="page-sequence.cover">
                <xsl:call-template name="insertFrontMatterStaticContents"/>
                <fo:flow flow-name="xsl-region-body">
                    <fo:block-container xsl:use-attribute-sets="__frontmatter">
                        <xsl:call-template name="createFrontCoverContents"/>
                    </fo:block-container>
                </fo:flow>
            </fo:page-sequence>

            <xsl:if test="$map/bookmeta/bookrights/summary">
                <fo:page-sequence master-reference="front-matter" xsl:use-attribute-sets="__force__page__count">
                    <xsl:call-template name="insertFrontMatterStaticContents"/>
                    <fo:flow flow-name="xsl-region-body">
                        <fo:block-container xsl:use-attribute-sets="__frontmatter">
                            <xsl:call-template name="createFrontCoverContents2"/>
                        </fo:block-container>
                    </fo:flow>
                </fo:page-sequence>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <!--HSX support front picture from 
       ditamap:prodname.data[name=image value=<filename>] [name=top-left-width value=100mm 50mm 30mm]
       You can have any filename without a dot which is invalid but has the advantage that the attribute field
       doesn't disappear in oxygen, if you don't want a front image
    -->
    <xsl:variable name="hRef">
        <xsl:call-template name="getHREF">
                <xsl:with-param name="href" select="$FrontPicture"/>
        </xsl:call-template>  
    </xsl:variable>
    
    <xsl:template name="insertFrontPicture">       
        <xsl:if test="(string-length($FrontPicture) &gt; 0) and contains($FrontPicture, '.')">
            <xsl:variable name="coords" select="tokenize($FrontPicturePos, ' ')"/>
            <xsl:variable name="top" select="subsequence($coords, 1, 1)"/>
            <xsl:variable name="left" select="subsequence($coords, 2, 1)"/>
            <xsl:variable name="width" select="subsequence($coords, 3, 1)"/>            
                <fo:block-container absolute-position="fixed" top="{$top}" left="{$left}">
                    <fo:block>
                        <fo:external-graphic content-width="{$width}" 
                            src="url({$hRef})" />                        
                    </fo:block>
                </fo:block-container>
        </xsl:if>
    </xsl:template>

    <!--HSC [DtPrt#9.1.3] demonstrates how to change the content of the frontmatter. -->
    <xsl:template name="createFrontCoverContents">

        <!-- Print the debug anchor -->
        <xsl:if test="contains($dbghs, 'dbg_showLabels')">
            <fo:block xsl:use-attribute-sets="__frontmatter__product">
                <xsl:text>front-matter/createFrontCoverContents;</xsl:text>
            </fo:block>
        </xsl:if>
        <xsl:call-template name="insertWatermark"/>
        <xsl:call-template name="insertFrontPicture"/>
        
        
        <!-- set the title -->
        <fo:block xsl:use-attribute-sets="__frontmatter__title_1">
            <!--
            Order of precedence:
            topic/title > bookmap/mainbooktitle > ditamap/title > any next available title
            -->
            <xsl:choose>
                <xsl:when test="$map/*[contains(@class,' topic/title ')][1]">
                    <xsl:apply-templates select="$map/*[contains(@class,' topic/title ')][1]"/>
                </xsl:when>
                <xsl:when test="$map//*[contains(@class,' bookmap/mainbooktitle ')][1]">
                    <xsl:apply-templates select="$map//*[contains(@class,' bookmap/mainbooktitle ')][1]"/>
                </xsl:when>
                <xsl:when test="//*[contains(@class, ' map/map ')]/@title">
                    <xsl:value-of select="//*[contains(@class, ' map/map ')]/@title"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="/descendant::*[contains(@class, ' topic/topic ')][1]/*[contains(@class, ' topic/title ')]"/>
                </xsl:otherwise>
            </xsl:choose>
        </fo:block>

        <!-- Next block, title line 2
        This block can be (text) empty but it must be called in order to create the
        bottom rule
        -->
        <fo:block xsl:use-attribute-sets="__frontmatter__title_2">
            <!-- set the subtitle -->
            <xsl:apply-templates select="$map//*[contains(@class,' bookmap/booktitlealt ')]"/>
        </fo:block>

        <!-- [PRODUCT NAME] and VERSION [DtPrt#9.1.4] -->
        <fo:block xsl:use-attribute-sets="__frontmatter__product">
            <xsl:if test="(string-length(normalize-space($productVersion)) &gt; 0) and
                          (string-length(normalize-space($productName))    &gt; 0)">
                    <xsl:value-of select="$productName"/>
                    <xsl:text>&#xA0;</xsl:text>
                <xsl:value-of select="$productVersion"/>
            </xsl:if>
        </fo:block>

        <!-- PRINT DATE -->
        <fo:block xsl:use-attribute-sets="__frontmatter__printdate">
            <xsl:text>Printed on </xsl:text>
            <xsl:value-of select="$currentDateVerbose"/>
        </fo:block>

        <!-- AUTHOR-->
        <!-- could be done here, but will be part of the general bookmeta information below
        <fo:block xsl:use-attribute-sets="__frontmatter__author">
            <xsl:apply-templates select="$map//*[contains(@class,' bookmap/bookmeta ')]/*[contains(@class, ' topic/author ')]"/>
        </fo:block>
        -->

        <!-- OWNER -->
        
        <!-- The original template made a dirty trick. Actually  the call
            <xsl:apply-templates select="$map//*[contains(@class,' bookmap/bookmeta ')]"/>
            would reach the entire bookmeta information in the DITAMAP.
            Since there is only one text node (author) this call generates the author only.
            
            However, if we would (and I do) provide templates for the other nodes e.g. 'bookrights' etc.
            then these templates would automatically be visited by the original call and they would place
            their information lie they are designed to do. The order of their execution, however, is not
            really under control (in the appearance of the templates) and that is little satisfactory.
            Therefore the trick is a bit dirty.
            
            SOLUTION 1: leave the 'dirty' call to a common bookmap/bookmeta template but there we dispatch
                        The associated catch template does already exist and is
                         
                            <xsl:template match="*[contains(@class, ' bookmap/bookmeta ')]" priority="1">
                            
                        It simply puts the call through with an apply-templates, so here we could do the dispatcher
                        and later modifications about any printing of the bookmeta information.
                        Using more specific call with the apply-template (select="child::*//contains(@class, '...')") would
                        invoke the associated templates in controlled order and format.
            
            SOLUTION 2: call the specific node within the bookmap.
            
                        <xsl:apply-templates select="$map//*[contains(@class,' bookmap/bookmeta ')]/*[contains(@class, ' bookmap/bookrights ')]"/>
                        
                        would do such a specific call whereas the matching template has to be
                        
                            <xsl:template match="*[contains(@class, ' bookmap/bookrights ')]">
                            
            I finally prefered solution 1 which allows to switch on/off the entire bookmeta information.
            The template isn't good for anything else, so there's a good point to use it for the collective bookmeta info.
            As such it can also be moved in a box and placed whereelse.

        -->
        
        <!--
        Example 1: calling a specific sub-topic of the bookmeta
        <xsl:apply-templates select="$map//*[contains(@class,' bookmap/bookmeta ')]/*[contains(@class, ' topic/data bookmap/bookrights ')]"/>
        
        Example 2: calling the general bookmeta dispatcher
        <xsl:apply-templates select="$map//*[contains(@class,' bookmap/bookmeta ')]"/>
        -->

        <fo:block xsl:use-attribute-sets="__frontmatter__bookmeta">
            <xsl:apply-templates select="$map//*[contains(@class,' bookmap/bookmeta ')]"/>
        </fo:block>

        <!-- LOGO -->
        <!--HSC [DtPrt#9.1.3] Step 6 adds the logo, [DtPrt#9.1.5] sets the position with the container -->
        <xsl:if test="count($map/bookmeta/bookrights/bookowner/organization) &gt; 0">
            <xsl:variable name="xhref">               
                <xsl:call-template name="getHREF">
                    <xsl:with-param name="href" select="$map/bookmeta/bookrights/bookowner/organization[1]/data[contains(@name, 'logo')]/@value"/>
                </xsl:call-template>  
            </xsl:variable>
            <!--HSX We allow to set the logo height because sometimes a logo appears to because
                    optically smaller/larger than the actual dimensions specify
                    The feature is supported by a data field with name=height value=<size>
            -->
            <xsl:variable name="xheight">               
                <xsl:value-of select="$map/bookmeta/bookrights/bookowner/organization[1]/data[contains(@name, 'height')]/@value"/>
            </xsl:variable>
                        
            <xsl:if test="string-length($xhref) &gt; 0">
                <fo:block-container xsl:use-attribute-sets="__frontmatter__logo__container">
                    <xsl:if test="string-length($xheight) &gt; 0">
                        <xsl:attribute name="height" select="$xheight"/>
                    </xsl:if>
                    <fo:block xsl:use-attribute-sets="__frontmatter__logo">
                        <!--
                        <fo:external-graphic  xsl:use-attribute-sets="__frontmatter__logo_img" src="url({translate($xhref, '\', '/')})"/>
                        -->
                        <fo:external-graphic  xsl:use-attribute-sets="__frontmatter__logo_img">
                            <xsl:if test="string-length($xheight) &gt; 0">
                                <xsl:attribute name="content-height" select="$xheight"/>
                            </xsl:if>
                            <xsl:attribute name="src" select="concat('url(', translate($xhref, '\', '/'), ')')"/>
                        </fo:external-graphic>
                        <!--
                        -->
                    </fo:block>
                </fo:block-container>
            </xsl:if>
        </xsl:if>
        <xsl:if test="count($map/bookmeta/bookrights/bookowner/organization) &gt; 1">
            <xsl:variable name="xhref">               
                <xsl:call-template name="getHREF">
                    <xsl:with-param name="href" select="$map/bookmeta/bookrights/bookowner/organization[2]/data[contains(@name, 'logo')]/@value"/>
                </xsl:call-template>  
            </xsl:variable>
            <xsl:variable name="xheight">               
                <xsl:value-of select="$map/bookmeta/bookrights/bookowner/organization[2]/data[contains(@name, 'height')]/@value"/>
            </xsl:variable>
            <!--HSX see [Xslfo#6.6.5] -->
            <xsl:if test="string-length($xhref) &gt; 0">
                <fo:block-container xsl:use-attribute-sets="__frontmatter__logo__container_2">
                    <xsl:if test="string-length($xheight) &gt; 0">
                        <xsl:attribute name="height" select="$xheight"/>
                    </xsl:if>
                    <fo:block xsl:use-attribute-sets="__frontmatter__logo_2">
                        <fo:external-graphic xsl:use-attribute-sets="__frontmatter__logo_img_2">
                        <xsl:if test="string-length($xheight) &gt; 0">
                            <xsl:attribute name="content-height" select="$xheight"/>
                        </xsl:if>
                        <xsl:attribute name="src" select="concat('url(', translate($xhref, '\', '/'), ')')"/>
                        </fo:external-graphic>
                    </fo:block>
                </fo:block-container>
            </xsl:if>
        </xsl:if>
        <fo:block-container xsl:use-attribute-sets="__frontmatter__link__container">
             <!--HSC Attribute changes are made acc. to [DtPrt#9.1.4] -->
             <xsl:apply-templates select="$map/bookmeta/authorinformation/organizationinfo/child::*[contains(@class, ' xnal-d/urls ')]"/>
         </fo:block-container>
    </xsl:template>
    
    <!--HSC
    ID No. 10000031787
     © Copyright 2013 by
     Giesecke & Devrient GmbH
     Prinzregentenstr. 159
     Postfach 80 07 29
     D-81607 München
     This document as well as the information or material contained is copyrighted. Any use not explicitly permitted
     by copyright law requires prior consent of Giesecke & Devrient GmbH. This applies to any reproduction,
     revision, translation, storage on microfilm as well as its import and processing in electronical
     systems, in particular.
     Subject to technical changes.
     Trademarks
     STARCOS is a registered trademark of Giesecke Devrient GmbH, München.
     -->
    <xsl:template name="createFrontCoverContents2">
        <fo:block-container xsl:use-attribute-sets="__frontmatter__backside__container">
            <!--HSC Attribute changes are made acc. to [DtPrt#9.1.4] -->
                <fo:block xsl:use-attribute-sets="__frontmatter__backside">
                    <xsl:call-template name="insertWatermark"/>
                    <fo:block>
                        <xsl:text>ID No.</xsl:text>
                        <xsl:value-of select="$productIdNo"/>
                    </fo:block>
                    <fo:block>
                        <xsl:text>© Copyright </xsl:text>
                        <!--HSX fo:inline container required as the template creates its
                                own block. Otherwise that block would start a new line
                        -->
                        <fo:inline-container>                    
                            <xsl:apply-templates select="$map//*[contains(@class, ' topic/data bookmap/copyrfirst ')]/year"/>
                        </fo:inline-container>
                        <xsl:text> by</xsl:text>
                    </fo:block>
                    <fo:block>
                        <fo:inline-container>
                            <!--HSX the bookowner/organization template does not create its
                                    own block, hence we have to put it in blocks right here
                            -->
                            <fo:block>
                                <xsl:apply-templates select="$map//*[contains(@class, ' topic/data bookmap/bookowner ')]/organization[1]"/>
                            </fo:block>                    
                        </fo:inline-container>
                    </fo:block>
                    <xsl:apply-templates select="$map/bookmeta/authorinformation/organizationinfo/addressdetails"/>
                </fo:block>
                <!--HSX style determined by template 
                     <xsl:template match="*[contains(@class, ' bookmap/summary ')]">
                     xsl:use-attribute-sets="bookmap.summary"
                -->
                <xsl:apply-templates select="$map/bookmeta/bookrights/summary"/>                    
                
        </fo:block-container>
    </xsl:template>

        
    <!--HSX use bookrights/summary/data to transport disclaimer on 2nd front page -->
    <xsl:template match="data[contains(@name, 'disclaimer')]">
        <fo:block space-before="6pt">
            <xsl:apply-templates mode="#default"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="data[contains(@name, 'trademark')]">
        <xsl:if test="not(contains(preceding-sibling::*[1]/@name, 'trademark'))">
            <fo:block xsl:use-attribute-sets="__frontmatter__backside_bold">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'TrademarkLabel'"/>
                </xsl:call-template>            
            </fo:block>
        </xsl:if>
        <fo:block xsl:use-attribute-sets="__frontmatter__backside_follow">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' bookmap/bookmeta ')]" priority="1">
        <xsl:variable name="chkAddr">
            <xsl:apply-templates select="authorinformation/organizationinfo/child::*[contains(@class, ' xnal-d/emailaddresses ')]"/>
        </xsl:variable>
        <!-- implicit option ... if no correct (seek @) emailaddresses are given ... do not print the meta info -->
        <xsl:if test="contains(normalize-space(string($chkAddr)), '@')">
            <fo:block-container xsl:use-attribute-sets="__frontmatter__bookmeta__container">
                <fo:block >
                    <!-- cathing any organization (there are two of them) is less complicated ... 
                      <xsl:apply-templates select=".//child::*[contains(@class, ' bookmap/organization ')]"/>
                    -->
                    <xsl:apply-templates select="authorinformation/organizationinfo/child::*[contains(@class, ' xnal-d/namedetails ')]"/>
                    
                    <fo:block xsl:use-attribute-sets="__frontmatter__organization" >
                        <xsl:apply-templates select=".//child::*[contains(@class, ' bookmap/bookowner ')]/organization"/>
                    </fo:block>
                    <xsl:apply-templates select="authorinformation/organizationinfo/child::*[contains(@class, ' xnal-d/addressdetails ')]"/>
                    <xsl:apply-templates select="authorinformation/organizationinfo/child::*[contains(@class, ' xnal-d/contactnumbers ')]"/>
                    <xsl:apply-templates select="authorinformation/organizationinfo/child::*[contains(@class, ' xnal-d/emailaddresses ')]"/>
                </fo:block>
            </fo:block-container>
        </xsl:if>
    </xsl:template>
        
    <!--HSC print the main book title block including the bars -->
    <xsl:template match="*[contains(@class, ' bookmap/booktitle ')]" priority="2">

        <xsl:variable name="txt">
            <xsl:apply-templates select="*[contains(@class, ' bookmap/booklibrary ')]"/>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="contains($dbghs, 'dbg_showLabels')">
                <fo:block xsl:use-attribute-sets="__frontmatter__booklibrary">
                    <xsl:text>__frontmatter__booklibrary</xsl:text>
                </fo:block>
            </xsl:when>
            <xsl:when test="contains($docdesign, 'dsgn_smart') and (string-length(normalize-space($txt//text())) &gt; 0)">
                <fo:block xsl:use-attribute-sets="__frontmatter__booklibrary">
                    <xsl:apply-templates select="*[contains(@class, ' bookmap/booklibrary ')]"/>
                </fo:block>
            </xsl:when>
            <xsl:otherwise>
                <fo:block xsl:use-attribute-sets="__frontmatter__booklibrary">
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
        <fo:block xsl:use-attribute-sets="__frontmatter__mainbooktitle">
            <xsl:apply-templates select="*[contains(@class,' bookmap/mainbooktitle ')]"/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' bookmap/booktitlealt ')]" priority="2">
        <xsl:if test="contains($dbghs, 'dbg_showLabels')">
            <fo:block xsl:use-attribute-sets="__frontmatter__subtitle">
                <xsl:text>__frontmatter__subtitle</xsl:text>
            </fo:block>
        </xsl:if>
        <fo:block xsl:use-attribute-sets="__frontmatter__subtitle">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <!-- Print first/last name -->
    <xsl:template match="*[contains(@class, ' xnal-d/personname ')]">
        <fo:block xsl:use-attribute-sets="author" >
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <!-- very good description in [DitaSpec#3.2.6.5] -->
    <xsl:template match="*[contains(@class, ' xnal-d/firstname ')]">
        <fo:inline>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' xnal-d/lastname ')]">
        <fo:inline>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' xnal-d/otherinfo ')]">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="*[contains(@class, ' xnal-d/middlename ')]">
        <fo:inline>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' xnal-d/namedetails ')]">
            <xsl:for-each select="personname">
                <fo:block xsl:use-attribute-sets="__frontmatter__names">
                    <!-- here as an example I am using an abbreviated catch. I we ignore the
                         first blank in ' firstname ' to make it 'firstname ' then the xnal-d part
                         of the class will be skipped and the class if found by the suffix
                         The approach works but is not as clean as the full syntax
                    -->
                    <xsl:apply-templates select="*[contains(@class, 'firstname ')]"/>
                    <xsl:text>&#xA0;</xsl:text>
                    <xsl:variable name="midName">
                        <xsl:apply-templates select="*[contains(@class, ' middlename ')]"/>
                    </xsl:variable>
                    <xsl:if test="string-length(normalize-space(midName)) &gt; 0">
                        <xsl:value-of select="$midName"/>
                        <xsl:text>&#xA0;</xsl:text>
                    </xsl:if>
                    <xsl:apply-templates select="*[contains(@class, ' xnal-d/lastname ')]"/>
                    <fo:inline xsl:use-attribute-sets="__frontmatter__role">
                        <xsl:text>&#xA0;(</xsl:text>
                        <xsl:apply-templates select="*[contains(@class, ' xnal-d/otherinfo ')]"/>
                        <xsl:text>)</xsl:text>
                    </fo:inline>
                </fo:block>
            </xsl:for-each>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/data ')][contains(@name, 'postbox')]">
        <xsl:call-template name="getVariable">
            <xsl:with-param name="id" select="'Post Box'"/>
        </xsl:call-template>
        <xsl:value-of select="@value"/>
    </xsl:template>
        
    <xsl:template match="*[contains(@class, ' xnal-d/addressdetails ')]">
        <fo:block xsl:use-attribute-sets="__frontmatter__address_street">
            <xsl:apply-templates select="thoroughfare"/>
        </fo:block>
        <fo:block xsl:use-attribute-sets="__frontmatter__address_city">
            <xsl:variable name="zipcode">
                <xsl:apply-templates select="locality/*[contains(@class, ' xnal-d/postalcode ')]"/>
                <xsl:text>&#xA0;</xsl:text>
            </xsl:variable>
            <xsl:if test="string-length(normalize-space($zipcode)) &gt; 0">
                <xsl:value-of select="$zipcode"/>
            </xsl:if>
            <xsl:apply-templates select="locality/*[contains(@class, ' xnal-d/localityname ')]"/>
        </fo:block>
        
        <xsl:if test="contains(locality/data/@name, 'postbox')">
            <fo:block>
                <xsl:apply-templates select="locality/*[contains(@class, ' topic/data ')]"/>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' xnal-d/thoroughfare ')]">
        <fo:block>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>
    
    <!-- create table to get correct position see [Xslfo#6.7.10] -->
    <xsl:template match="*[contains(@class, ' xnal-d/contactnumbers ')]">
        <fo:table space-before="6pt"> 
            <fo:table-body start-indent="0pt">
                <xsl:for-each select="contactnumber">
                    <xsl:variable name="fText">
                        <xsl:value-of select="normalize-space(@name)"/>
                    </xsl:variable>
                    <fo:table-row>
                        <xsl:if test="string-length($fText) &gt; 0">
                            <fo:table-cell xsl:use-attribute-sets="__frontmatter__taboffset">
                                <fo:block xsl:use-attribute-sets="__frontmatter__contactnumber_domain">
                                    <xsl:value-of select="@name"/>
                                    <xsl:text>:</xsl:text>
                                </fo:block>
                            </fo:table-cell>
                        </xsl:if>
                        <fo:table-cell>
                            <fo:block xsl:use-attribute-sets="__frontmatter__contactnumber_number">
                                <xsl:value-of select="@value"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:for-each>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' xnal-d/emailaddresses ')]">
        <fo:table space-before="6pt">
            <fo:table-body start-indent="0pt">
                <xsl:for-each select="emailaddress">
                    <xsl:variable name="fText">
                        <xsl:value-of select="normalize-space(@name)"/>
                    </xsl:variable>
                    <fo:table-row>
                        <xsl:if test="string-length($fText) &gt; 0">
                            <fo:table-cell xsl:use-attribute-sets="__frontmatter__taboffset">
                                <fo:block xsl:use-attribute-sets="__frontmatter__emailaddresses_domain">
                                    <xsl:value-of select="@name"/>
                                    <xsl:text>:</xsl:text>
                                </fo:block>
                            </fo:table-cell>
                        </xsl:if>
                        <fo:table-cell>
                            <fo:block xsl:use-attribute-sets="__frontmatter__emailaddresses_number">
                                <xsl:value-of select="@value"/>
                            </fo:block>
                        </fo:table-cell>
                    </fo:table-row>
                </xsl:for-each>
            </fo:table-body>
        </fo:table>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' xnal-d/urls ')]">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' xnal-d/url ')]">
        <fo:block xsl:use-attribute-sets="__frontmatter__link">
            <xsl:variable name="link">
                <xsl:choose>
                    <xsl:when test="starts-with(., 'http://')">
                        <xsl:value-of select="."/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat('http://', .)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:variable>
            <fo:basic-link>
                <xsl:attribute name="external-destination" select="$link"/>
            </fo:basic-link>
            <xsl:value-of select="."/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' bookmap/bookowner ')]">
        <fo:block xsl:use-attribute-sets="author">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' bookmap/summary ')]">
        <fo:block xsl:use-attribute-sets="bookmap.summary">
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template name="createBackCover">
        <xsl:if test="$generate-back-cover">
            <fo:page-sequence master-reference="back-cover" xsl:use-attribute-sets="back-cover">
                <xsl:call-template name="insertBackCoverStaticContents"/>
                <fo:flow flow-name="xsl-region-body">
                    <fo:block-container xsl:use-attribute-sets="__back-cover">
                        <xsl:call-template name="createBackCoverContents"/>
                    </fo:block-container>
                </fo:flow>
            </fo:page-sequence>
        </xsl:if>
    </xsl:template>

    <xsl:template name="createBackCoverContents">
      <fo:block></fo:block>
    </xsl:template>

</xsl:stylesheet>
