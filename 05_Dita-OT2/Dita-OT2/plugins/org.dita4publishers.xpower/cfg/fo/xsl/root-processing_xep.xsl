<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:rx="http://www.renderx.com/XSL/Extensions"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                version="2.0" exclude-result-prefixes="dita-ot xs">

  <xsl:template match="/" name="rootTemplate">
    <xsl:call-template name="validateTopicRefs"/>
      <fo:root xsl:use-attribute-sets="__fo__root">
        <xsl:call-template name="createLayoutMasters"/>
        <xsl:call-template name="createMetadata"/>
        <xsl:call-template name="createBookmarks"/>
        <xsl:call-template name="createFrontMatter"/>
        <!--HSC TOC can be avoided from print if from bookmap [DtPrt#16.16.6] 
            We extend the test to check for bookmap anchestor -->
        <xsl:if test="(//*[contains(@class, ' map/map bookmap/bookmap ')]//*[contains(@class, 'bookmap/toc ')])"> 
          <xsl:if test="not($retain-bookmap-order)">
            <xsl:call-template name="createToc"/>
          </xsl:if>
        </xsl:if>
        
        <xsl:apply-templates/>
        <!--HSC INDEX can be avoided from print if from bookmap [DtPrt#17.13.4] 
            We extend the test to check for bookmap anchestor -->
          <xsl:if test="(//*[contains(@class, ' map/map bookmap/bookmap')]//*[contains(@class, ' bookmap/indexlist ')])">
            <xsl:if test="not($retain-bookmap-order)">
              <xsl:call-template name="createIndex"/>
            </xsl:if>
          </xsl:if>
        <!--HSC endif , if used acc. to [DtPrt#17.13.4] -->
        
        <!--HSC generate back master acc. to [DtPrt#9.2.2] 
          <xsl:call-template name="createBackMatter"/>
        -->
     </fo:root>
  </xsl:template>
 
  <xsl:template name="createMetadata">
    <rx:meta-info>
      <xsl:variable name="title" as="xs:string?">
        <xsl:apply-templates select="." mode="dita-ot:title-metadata"/>
      </xsl:variable>
      <xsl:if test="exists($title)">
        <rx:meta-field name="title" value="{$title}"/>
      </xsl:if>
      <xsl:variable name="author" as="xs:string?">
        <xsl:apply-templates select="." mode="dita-ot:author-metadata"/>
      </xsl:variable>
      <xsl:if test="exists($author)">
        <rx:meta-field name="author" value="{$author}"/>
      </xsl:if>
      <xsl:variable name="keywords" as="xs:string*">
        <xsl:apply-templates select="." mode="dita-ot:keywords-metadata"/>
      </xsl:variable>
      <xsl:if test="exists($keywords)">
        <rx:meta-field name="keywords">
          <xsl:attribute name="value" select="$keywords" separator=", "/>
        </rx:meta-field>
      </xsl:if>
      <xsl:variable name="subject" as="xs:string?">
        <xsl:apply-templates select="." mode="dita-ot:subject-metadata"/>
      </xsl:variable>
      <xsl:if test="exists($subject)">
        <rx:meta-field name="subject" value="{$subject}"/>
      </xsl:if>
      <rx:meta-field name="creator" value="DITA Open Toolkit"/>
    </rx:meta-info>
  </xsl:template>

</xsl:stylesheet>