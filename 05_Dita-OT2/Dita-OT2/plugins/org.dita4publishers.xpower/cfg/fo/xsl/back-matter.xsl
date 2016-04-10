<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  xmlns:opentopic="http://www.idiominc.com/opentopic"
  exclude-result-prefixes="opentopic"
  version="2.0">
  
  <xsl:variable name="map" select="//opentopic:map"/>
  <xsl:template name="createBackMatter">
    <fo:page-sequence master-reference="back-matter">
      <fo:flow flow-name="xsl-region-body">
        <fo:block id="endofdoc"/>
        <fo:block>
          <!--HSC adds page content acc. to [DtPrt#9.2.5] -->
          
          <fo:block xsl:use-attribute-sets="__backmatter__copyright">
            <xsl:text>Copyright &#169;</xsl:text>
            <xsl:value-of select="$copyYear"/><xsl:text> </xsl:text>
          </fo:block>
          
          <fo:block xsl:use-attribute-sets="__backmatter__text">
            <xsl:text>For support, contact the DITA Users list: </xsl:text>
            <fo:basic-link external-destination="http://tech.groups.yahoo.com/group/dita-users">http://tech.groups.yahoo.com/group/dita-users</fo:basic-link>
            <xsl:text>. Also refer to the DITA Open Toolkit 1.8 User Documentation: </xsl:text>
            <fo:basic-link external-destination="http://dita-ot.sourceforge.net/doc/ot-userguide/xhtml/">http://dita-ot.sourceforge.net/doc/ot-userguide/xhtml/</fo:basic-link>
            <xsl:text>.</xsl:text>
          </fo:block>
          
          <fo:block xsl:use-attribute-sets="__backmatter__text__last">
            <xsl:text>Neither XML Press nor the author is responsible for any damage to
              equipment or loss of data that might occur as a result of downloading and/or installing
              any software mentioned herein. Nor is XML Press or the author responsible
              for any penalties that might be incurred due to illegal download, installation or usage
            of any software mentioned herein.</xsl:text>
          </fo:block>
          
          <!--HSC adding container to position logo and the others acc. to [DtPrt#9.2.6] -->
          <fo:block-container xsl:use-attribute-sets="__backmatter__logo__container">
            
            <fo:block xsl:use-attribute-sets="__backmatter__logo">
              <fo:external-graphic src="url(Customization/OpenTopic/common/artwork/NfcLogo.jpg)"/>
            </fo:block>
            
            <fo:block xsl:use-attribute-sets="__backmatter__item">
              <xsl:text>Item# </xsl:text><xsl:value-of select="$itemNumber"/>
            </fo:block>
          
            <fo:block xsl:use-attribute-sets="__backmatter__publish">
              <xsl:text>Published </xsl:text><xsl:value-of select="$pubDate"/>
            </fo:block>
            <!--HSC add language specific text acc. to [DtPrt#9.3.1] -->
            <fo:block xsl:use-attribute-sets="__backmatter__language">
              <xsl:choose>
                <xsl:when test="$printedLang = 'de'">
                  <xsl:text>Deutsch</xsl:text>
                </xsl:when>
                <xsl:when test="$printedLang = 'en'">
                  <xsl:text>English</xsl:text>
                </xsl:when>
                <xsl:when test="$printedLang = 'es'">
                  <xsl:text>espanol</xsl:text>
                </xsl:when>
                <xsl:when test="$printedLang = 'fr'">
                  <xsl:text>francais</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                  <xsl:text>[Unspecified]</xsl:text>
                </xsl:otherwise>
              </xsl:choose>
            </fo:block>
            
          </fo:block-container>
        </fo:block>
      </fo:flow>
    </fo:page-sequence>
  </xsl:template>
</xsl:stylesheet>
