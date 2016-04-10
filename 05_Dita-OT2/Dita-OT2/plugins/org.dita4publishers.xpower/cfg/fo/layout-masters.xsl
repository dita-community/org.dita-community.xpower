<?xml version="1.0"?>

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

    <xsl:template name="createLayoutMasters">
      <xsl:call-template name="createDefaultLayoutMasters"/>
    </xsl:template>

    <xsl:template name="createDefaultLayoutMasters">
        <fo:layout-master-set>
            <!-- Frontmatter simple masters -->
            <!--HSX trying to generate simple master for first using even-odd -->
            <xsl:if test="$mirror-page-margins">
              <fo:simple-page-master master-name="front-matter-first-even" xsl:use-attribute-sets="simple-page-master">
                  <fo:region-body xsl:use-attribute-sets="region-body__frontmatter.even"/>
              </fo:simple-page-master>
            </xsl:if>
            <!--HSX -->
            <fo:simple-page-master master-name="front-matter-first-odd" xsl:use-attribute-sets="simple-page-master">
                <fo:region-body xsl:use-attribute-sets="region-body__frontmatter.odd"/>
            </fo:simple-page-master>

            <fo:simple-page-master master-name="front-matter-last-even" xsl:use-attribute-sets="simple-page-master">
                <fo:region-body xsl:use-attribute-sets="region-body__frontmatter.even"/>
                <fo:region-before  region-name="last-frontmatter-header" xsl:use-attribute-sets="region-before"/>
                <fo:region-after region-name="last-frontmatter-footer" xsl:use-attribute-sets="region-after"/>
            </fo:simple-page-master>

            <fo:simple-page-master master-name="front-matter-last-odd" xsl:use-attribute-sets="simple-page-master">
                <fo:region-body xsl:use-attribute-sets="region-body__frontmatter.odd"/>
                <fo:region-before  region-name="last-frontmatter-header" xsl:use-attribute-sets="region-before"/>
                <fo:region-after region-name="last-frontmatter-footer" xsl:use-attribute-sets="region-after"/>
            </fo:simple-page-master>

            <fo:simple-page-master master-name="preface-last-odd" xsl:use-attribute-sets="simple-page-master">
                <fo:region-body xsl:use-attribute-sets="region-body__frontmatter.odd"/>
                <fo:region-before  region-name="last-body-odd-header" xsl:use-attribute-sets="region-before"/>
                <fo:region-after region-name="last-body-odd-footer" xsl:use-attribute-sets="region-after"/>
            </fo:simple-page-master>

            <fo:simple-page-master master-name="preface-last-even" xsl:use-attribute-sets="simple-page-master">
                <fo:region-body xsl:use-attribute-sets="region-body__frontmatter.odd"/>
                <fo:region-before  region-name="last-body-even-header" xsl:use-attribute-sets="region-before"/>
                <fo:region-after region-name="last-body-even-footer" xsl:use-attribute-sets="region-after"/>
            </fo:simple-page-master>

            <xsl:if test="$mirror-page-margins">
              <fo:simple-page-master master-name="front-matter-even" xsl:use-attribute-sets="simple-page-master">
                  <fo:region-body xsl:use-attribute-sets="region-body__frontmatter.even"/>
                  <fo:region-before region-name="even-frontmatter-header" xsl:use-attribute-sets="region-before"/>
                  <fo:region-after region-name="even-frontmatter-footer" xsl:use-attribute-sets="region-after"/>
              </fo:simple-page-master>
            </xsl:if>

            <fo:simple-page-master master-name="front-matter-odd" xsl:use-attribute-sets="simple-page-master">
                <fo:region-body xsl:use-attribute-sets="region-body__frontmatter.odd"/>
                <fo:region-before region-name="odd-frontmatter-header" xsl:use-attribute-sets="region-before"/>
                <fo:region-after region-name="odd-frontmatter-footer" xsl:use-attribute-sets="region-after"/>
            </fo:simple-page-master>

            <!-- Backcover simple masters -->
            <xsl:if test="$generate-back-cover">
              <!--fo:simple-page-master master-name="back-cover-first" xsl:use-attribute-sets="simple-page-master">
                <fo:region-body xsl:use-attribute-sets="region-body__backcover.odd"/>
              </fo:simple-page-master-->

              <xsl:if test="$mirror-page-margins">
                <fo:simple-page-master master-name="back-cover-even" xsl:use-attribute-sets="simple-page-master">
                  <fo:region-body xsl:use-attribute-sets="region-body__backcover.even"/>
                  <fo:region-before region-name="even-backcover-header" xsl:use-attribute-sets="region-before"/>
                  <fo:region-after region-name="even-backcover-footer" xsl:use-attribute-sets="region-after"/>
                </fo:simple-page-master>
              </xsl:if>

              <fo:simple-page-master master-name="back-cover-odd" xsl:use-attribute-sets="simple-page-master">
                <fo:region-body xsl:use-attribute-sets="region-body__backcover.odd"/>
                <fo:region-before region-name="odd-backcover-header" xsl:use-attribute-sets="region-before"/>
                <fo:region-after region-name="odd-backcover-footer" xsl:use-attribute-sets="region-after"/>
              </fo:simple-page-master>

              <fo:simple-page-master master-name="back-cover-last" xsl:use-attribute-sets="simple-page-master">
                <fo:region-body xsl:use-attribute-sets="region-body__backcover.even"/>
                <fo:region-before region-name="last-backcover-header" xsl:use-attribute-sets="region-before"/>
                <fo:region-after region-name="last-backcover-footer" xsl:use-attribute-sets="region-after"/>
              </fo:simple-page-master>
            </xsl:if>

            <!--TOC simple masters-->
            <xsl:if test="$mirror-page-margins">
              <fo:simple-page-master master-name="toc-even" xsl:use-attribute-sets="simple-page-master">
                  <fo:region-body xsl:use-attribute-sets="region-body.even"/>
                  <fo:region-before region-name="even-toc-header" xsl:use-attribute-sets="region-before"/>
                  <fo:region-after region-name="even-toc-footer" xsl:use-attribute-sets="region-after"/>
              </fo:simple-page-master>
            </xsl:if>

            <fo:simple-page-master master-name="toc-odd" xsl:use-attribute-sets="simple-page-master">
                <fo:region-body xsl:use-attribute-sets="region-body.odd"/>
                <fo:region-before region-name="odd-toc-header" xsl:use-attribute-sets="region-before"/>
                <fo:region-after region-name="odd-toc-footer" xsl:use-attribute-sets="region-after"/>
            </fo:simple-page-master>

            <!--HSX -->
            <fo:simple-page-master master-name="toc-last-even" xsl:use-attribute-sets="simple-page-master">
                <fo:region-body xsl:use-attribute-sets="region-body.even"/>
                <fo:region-before region-name="even-toc-header" xsl:use-attribute-sets="region-before"/>
                <fo:region-after region-name="even-toc-footer" xsl:use-attribute-sets="region-after"/>
            </fo:simple-page-master>

            <fo:simple-page-master master-name="toc-last-odd" xsl:use-attribute-sets="simple-page-master">
                <fo:region-body xsl:use-attribute-sets="region-body.odd"/>
                <fo:region-before region-name="odd-toc-header" xsl:use-attribute-sets="region-before"/>
                <fo:region-after region-name="odd-toc-footer" xsl:use-attribute-sets="region-after"/>
            </fo:simple-page-master>

            <fo:simple-page-master master-name="toc-first" xsl:use-attribute-sets="simple-page-master">
                <fo:region-body xsl:use-attribute-sets="region-body.odd"/>
                <fo:region-before region-name="odd-toc-header" xsl:use-attribute-sets="region-before"/>
                <fo:region-after region-name="odd-toc-footer" xsl:use-attribute-sets="region-after"/>
            </fo:simple-page-master>

            <xsl:if test="$mirror-page-margins">
              <fo:simple-page-master master-name="toc-first-even" xsl:use-attribute-sets="simple-page-master">
                  <fo:region-body xsl:use-attribute-sets="region-body.even"/>
                  <!--HSC change default odd-toc-header to first-toc-even-header since we created
                      the associated template acc. to [DtPrt#8.11.2] -->
                  <fo:region-before region-name="first-toc-even-header" xsl:use-attribute-sets="region-before"/>
                  <!--HSC
                  <fo:region-after region-name="even-toc-footer" xsl:use-attribute-sets="region-after"/>
                  -->
                  <fo:region-after region-name="first-toc-even-footer" xsl:use-attribute-sets="region-after"/>
              </fo:simple-page-master>
            </xsl:if>
            <fo:simple-page-master master-name="toc-first-odd" xsl:use-attribute-sets="simple-page-master">
                <fo:region-body xsl:use-attribute-sets="region-body.odd"/>
                <!--HSC change default odd-toc-header to first-toc-header since we created
                    the associated template acc. to [DtPrt#8.11.2] -->
                <fo:region-before region-name="first-toc-odd-header" xsl:use-attribute-sets="region-before"/>
                <!--HSC
                <fo:region-after region-name="odd-toc-footer" xsl:use-attribute-sets="region-after"/>
                -->
                <fo:region-after region-name="first-toc-odd-footer" xsl:use-attribute-sets="region-after"/>
            </fo:simple-page-master>

            <!--BODY simple masters-->
            <!--HSX -->
            <xsl:if test="$mirror-page-margins">
                <fo:simple-page-master master-name="body-first-even" xsl:use-attribute-sets="simple-page-master">
                <!--HSC providing seperate regions for the first body page by adding the .first suffix [DtPrt#7.12.2] -->
                    <fo:region-body xsl:use-attribute-sets="region-body.first.even"/>
                    <fo:region-before region-name="first-body-even-header" xsl:use-attribute-sets="region-before.first"/>
                    <fo:region-after region-name="first-body-even-footer" xsl:use-attribute-sets="region-after"/>
                </fo:simple-page-master>
            </xsl:if>
            <fo:simple-page-master master-name="body-first-odd" xsl:use-attribute-sets="simple-page-master">
            <!--HSC providing seperate regions for the first body page by adding the .first suffix [DtPrt#7.12.2] -->
                <fo:region-body xsl:use-attribute-sets="region-body.first.odd"/>
                <fo:region-before region-name="first-body-odd-header" xsl:use-attribute-sets="region-before.first"/>
                <fo:region-after region-name="first-body-odd-footer" xsl:use-attribute-sets="region-after"/>
            </fo:simple-page-master>

            <xsl:if test="$mirror-page-margins">
              <fo:simple-page-master master-name="body-even" xsl:use-attribute-sets="simple-page-master">
                  <fo:region-body xsl:use-attribute-sets="region-body.even"/>
                  <fo:region-before region-name="even-body-header" xsl:use-attribute-sets="region-before"/>
                  <fo:region-after region-name="even-body-footer" xsl:use-attribute-sets="region-after"/>
              </fo:simple-page-master>
            </xsl:if>

            <fo:simple-page-master master-name="body-odd" xsl:use-attribute-sets="simple-page-master">
                <fo:region-body xsl:use-attribute-sets="region-body.odd"/>
                <fo:region-before region-name="odd-body-header" xsl:use-attribute-sets="region-before"/>
                <fo:region-after region-name="odd-body-footer" xsl:use-attribute-sets="region-after"/>
            </fo:simple-page-master>

            <fo:simple-page-master master-name="body-last-odd" xsl:use-attribute-sets="simple-page-master">
                <fo:region-body xsl:use-attribute-sets="region-body.odd"/>
                <fo:region-before region-name="last-body-odd-header" xsl:use-attribute-sets="region-before"/>
                <fo:region-after region-name="last-body-odd-footer" xsl:use-attribute-sets="region-after"/>
            </fo:simple-page-master>

            <fo:simple-page-master master-name="body-last-even" xsl:use-attribute-sets="simple-page-master">
                <fo:region-body xsl:use-attribute-sets="region-body.even"/>
                <fo:region-before region-name="last-body-even-header" xsl:use-attribute-sets="region-before"/>
                <fo:region-after region-name="last-body-even-footer" xsl:use-attribute-sets="region-after"/>
            </fo:simple-page-master>

            <fo:simple-page-master master-name="landscape-odd" xsl:use-attribute-sets="landscape-page-master">
                <fo:region-body xsl:use-attribute-sets="region-body.landscape"/>
                <fo:region-before region-name="odd-body-header" xsl:use-attribute-sets="region-before"/>
                <fo:region-after region-name="odd-body-footer" xsl:use-attribute-sets="region-after"/>
            </fo:simple-page-master>

            <fo:simple-page-master master-name="landscape-even" xsl:use-attribute-sets="landscape-page-master">
                <fo:region-body xsl:use-attribute-sets="region-body.landscape"/>
                <fo:region-before region-name="even-body-header" xsl:use-attribute-sets="region-before"/>
                <fo:region-after region-name="even-body-footer" xsl:use-attribute-sets="region-after"/>
            </fo:simple-page-master>

            <!--INDEX simple masters-->
            <xsl:if test="$mirror-page-margins">
                <fo:simple-page-master master-name="index-first-even" xsl:use-attribute-sets="simple-page-master">
                    <fo:region-body xsl:use-attribute-sets="region-body__index.even"/>
                    <fo:region-before region-name="even-index-header" xsl:use-attribute-sets="region-before"/>
                    <fo:region-after region-name="even-index-footer" xsl:use-attribute-sets="region-after"/>
                </fo:simple-page-master>
            </xsl:if>
            <fo:simple-page-master master-name="index-first-odd" xsl:use-attribute-sets="simple-page-master">
                <fo:region-body xsl:use-attribute-sets="region-body__index.odd"/>
                <fo:region-before region-name="odd-index-header" xsl:use-attribute-sets="region-before"/>
                <fo:region-after region-name="odd-index-footer" xsl:use-attribute-sets="region-after"/>
            </fo:simple-page-master>

            <xsl:if test="$mirror-page-margins">
              <fo:simple-page-master master-name="index-even" xsl:use-attribute-sets="simple-page-master">
                  <fo:region-body xsl:use-attribute-sets="region-body__index.even"/>
                  <fo:region-before region-name="even-index-header" xsl:use-attribute-sets="region-before"/>
                  <fo:region-after region-name="even-index-footer" xsl:use-attribute-sets="region-after"/>
              </fo:simple-page-master>
            </xsl:if>

            <fo:simple-page-master master-name="index-odd" xsl:use-attribute-sets="simple-page-master">
                <fo:region-body xsl:use-attribute-sets="region-body__index.odd"/>
                <fo:region-before region-name="odd-index-header" xsl:use-attribute-sets="region-before"/>
                <fo:region-after region-name="odd-index-footer" xsl:use-attribute-sets="region-after"/>
            </fo:simple-page-master>

            <!--GLOSSARY simple masters-->
            <!--HSX -->
            <xsl:if test="$mirror-page-margins">
                <fo:simple-page-master master-name="glossary-first-even" xsl:use-attribute-sets="simple-page-master">
                    <fo:region-body xsl:use-attribute-sets="region-body.even"/>
                    <fo:region-before region-name="even-glossary-header" xsl:use-attribute-sets="region-before"/>
                    <fo:region-after region-name="even-glossary-footer" xsl:use-attribute-sets="region-after"/>
                </fo:simple-page-master>
            </xsl:if>
            <fo:simple-page-master master-name="glossary-first-odd" xsl:use-attribute-sets="simple-page-master">
                <fo:region-body xsl:use-attribute-sets="region-body.odd"/>
                <fo:region-before region-name="odd-glossary-header" xsl:use-attribute-sets="region-before"/>
                <fo:region-after region-name="odd-glossary-footer" xsl:use-attribute-sets="region-after"/>
            </fo:simple-page-master>

            <xsl:if test="$mirror-page-margins">
              <fo:simple-page-master master-name="glossary-even" xsl:use-attribute-sets="simple-page-master">
                  <fo:region-body xsl:use-attribute-sets="region-body.even"/>
                  <fo:region-before region-name="even-glossary-header" xsl:use-attribute-sets="region-before"/>
                  <fo:region-after region-name="even-glossary-footer" xsl:use-attribute-sets="region-after"/>
              </fo:simple-page-master>
            </xsl:if>

            <fo:simple-page-master master-name="glossary-odd" xsl:use-attribute-sets="simple-page-master">
                <fo:region-body xsl:use-attribute-sets="region-body.odd"/>
                <fo:region-before region-name="odd-glossary-header" xsl:use-attribute-sets="region-before"/>
                <fo:region-after region-name="odd-glossary-footer" xsl:use-attribute-sets="region-after"/>
            </fo:simple-page-master>

            <xsl:if test="$mirror-page-margins">
              <fo:simple-page-master master-name="glossary-last-even" xsl:use-attribute-sets="simple-page-master">
                  <fo:region-body xsl:use-attribute-sets="region-body.even"/>
                  <fo:region-before region-name="even-glossary-header" xsl:use-attribute-sets="region-before"/>
                  <fo:region-after region-name="even-glossary-footer" xsl:use-attribute-sets="region-after"/>
              </fo:simple-page-master>
            </xsl:if>

            <fo:simple-page-master master-name="glossary-last-odd" xsl:use-attribute-sets="simple-page-master">
                <fo:region-body xsl:use-attribute-sets="region-body.odd"/>
                <fo:region-before region-name="odd-glossary-header" xsl:use-attribute-sets="region-before"/>
                <fo:region-after region-name="odd-glossary-footer" xsl:use-attribute-sets="region-after"/>
            </fo:simple-page-master>

            <!--HSC inserted backmatter master acc. to [DtPrt#9.2.4] -->
            <!--BACKMATTER simple masters-->
            <!--HSX -->
            <xsl:if test="$mirror-page-margins">
                <fo:simple-page-master master-name="back-matter-first-even"
                  xsl:use-attribute-sets="simple-page-master">
                  <fo:region-body xsl:use-attribute-sets="region-backmatter.first"/>
                </fo:simple-page-master>
            </xsl:if>
            <fo:simple-page-master master-name="back-matter-first-odd"
              xsl:use-attribute-sets="simple-page-master">
              <fo:region-body xsl:use-attribute-sets="region-backmatter.first"/>
            </fo:simple-page-master>

            <xsl:if test="$mirror-page-margins">
              <fo:simple-page-master master-name="back-matter-even"
                xsl:use-attribute-sets="simple-page-master">
                <fo:region-body xsl:use-attribute-sets="region-backmatter.even"/>
              </fo:simple-page-master>
            </xsl:if>
            <fo:simple-page-master master-name="back-matter-odd" xsl:use-attribute-sets="simple-page-master">
              <fo:region-body xsl:use-attribute-sets="region-backmatter.odd"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="back-matter-last-even" xsl:use-attribute-sets="simple-page-master">
              <fo:region-body xsl:use-attribute-sets="region-backmatter.last"/>
            </fo:simple-page-master>
            <fo:simple-page-master master-name="back-matter-last-odd" xsl:use-attribute-sets="simple-page-master">
              <fo:region-body xsl:use-attribute-sets="region-backmatter.last"/>
            </fo:simple-page-master>
            <!-- Backmatter ends -->

            <!--Sequences-->
          <xsl:call-template name="generate-page-sequence-master">
            <xsl:with-param name="master-name" select="'toc-sequence'"/>
            <xsl:with-param name="master-reference" select="'toc'"/>
          </xsl:call-template>
          
          <xsl:call-template name="generate-page-sequence-master">
            <xsl:with-param name="master-name" select="'body-sequence'"/>
             <!--HSC set select="'landscape'" to test landscape format acc. to [DtPrt#7.12.7]
                 default is 'body' -->
            <xsl:with-param name="master-reference" select="'body'"/>
            <!--HSC for the test acc. to [DtPrt#7.12.7] we need to exclude the first/last pages
                because until now we didn't provide extra templates
            <xsl:with-param name="first" select="false()"/>
            <xsl:with-param name="last" select="false()"/>  -->

          </xsl:call-template>
          <xsl:call-template name="generate-page-sequence-master">
            <xsl:with-param name="master-name" select="'ditamap-body-sequence'"/>
            <xsl:with-param name="master-reference" select="'body'"/>
            <!--HSC make maps work like dita bookmaps [DtPrt#7.12.3]: set the following two statements "true()"   -->
            <xsl:with-param name="first" select="false()"/>
            <xsl:with-param name="last" select="false()"/>
          </xsl:call-template>


          <!--HSC create landscape master acc. to [DtPrt#7.12.7] -->
          <xsl:call-template name="generate-page-sequence-master">
            <xsl:with-param name="master-name" select="'landscape-sequence'"/>
            <xsl:with-param name="master-reference" select="'landscape'"/>
            <xsl:with-param name="first" select="false()"/>
            <xsl:with-param name="last" select="false()"/>
          </xsl:call-template>

          <xsl:call-template name="generate-page-sequence-master">
            <xsl:with-param name="master-name" select="'index-sequence'"/>
            <xsl:with-param name="master-reference" select="'index'"/>
            <xsl:with-param name="last" select="false()"/>
          </xsl:call-template>
          <xsl:call-template name="generate-page-sequence-master">
            <xsl:with-param name="master-name" select="'front-matter'"/>
            <xsl:with-param name="master-reference" select="'front-matter'"/>
          </xsl:call-template>
          <xsl:if test="$generate-back-cover">
            <xsl:call-template name="generate-page-sequence-master">
              <xsl:with-param name="master-name" select="'back-cover'"/>
              <xsl:with-param name="master-reference" select="'back-cover'"/>
              <xsl:with-param name="first" select="false()"/>
            </xsl:call-template>
          </xsl:if>
          <xsl:call-template name="generate-page-sequence-master">
            <xsl:with-param name="master-name" select="'glossary-sequence'"/>
            <xsl:with-param name="master-reference" select="'glossary'"/>
            <xsl:with-param name="last" select="false()"/>
          </xsl:call-template>

          <!--HSC add back-matter template acc. to [DtPrt#9.2.3] -->
          <xsl:call-template name="generate-page-sequence-master">
            <xsl:with-param name="master-name" select="'back-matter'"/>
            <xsl:with-param name="master-reference" select="'back-matter'"/>
          </xsl:call-template>

        </fo:layout-master-set>
    </xsl:template>

  <!-- Generate a page sequence master -->
  <xsl:template name="generate-page-sequence-master">
    <xsl:param name="master-name"/>
    <xsl:param name="master-reference"/>
    <xsl:param name="first" select="true()"/>
    <xsl:param name="last" select="true()"/>
    <fo:page-sequence-master master-name="{$master-name}">
      <fo:repeatable-page-master-alternatives>
        <xsl:if test="$first">
          <!--HSX changed first to first-even etc -->
          <xsl:choose>
            <xsl:when test="$mirror-page-margins">
              <fo:conditional-page-master-reference master-reference="{$master-reference}-first-odd"
                                                    odd-or-even="odd"
                                                    page-position="first"/>
              <fo:conditional-page-master-reference master-reference="{$master-reference}-first-even"
                                                    odd-or-even="even"
                                                    page-position="first"/>
            </xsl:when>
            <xsl:otherwise>
                <fo:conditional-page-master-reference master-reference="{$master-reference}-first-odd"
                                                      page-position="first"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
<!--HSC                                                 odd-or-even="even"  -->
        <xsl:if test="$last">
          <xsl:choose>
            <xsl:when test="$mirror-page-margins">
              <fo:conditional-page-master-reference master-reference="{$master-reference}-last-odd"
                                                    odd-or-even="odd"
                                                    page-position="last"/>
              <fo:conditional-page-master-reference master-reference="{$master-reference}-last-even"
                                                    odd-or-even="even"
                                                    page-position="last"/>
                                                <!--blank-or-not-blank="blank"-->
            </xsl:when>
            <xsl:otherwise>
              <fo:conditional-page-master-reference master-reference="{$master-reference}-last-odd"
                                                    page-position="last"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:if>
        <!--HSC if neither $first nor $last is true we shall have the default -->
        <xsl:choose>
          <xsl:when test="$mirror-page-margins">
            <fo:conditional-page-master-reference master-reference="{$master-reference}-odd"
                                                  odd-or-even="odd" />
            <fo:conditional-page-master-reference master-reference="{$master-reference}-even"
                                                  odd-or-even="even" />
          </xsl:when>
          <xsl:otherwise>
            <fo:conditional-page-master-reference master-reference="{$master-reference}-odd"
                                                  page-position="odd"/>
          </xsl:otherwise>
        </xsl:choose>
      </fo:repeatable-page-master-alternatives>
    </fo:page-sequence-master>
  </xsl:template>

</xsl:stylesheet>