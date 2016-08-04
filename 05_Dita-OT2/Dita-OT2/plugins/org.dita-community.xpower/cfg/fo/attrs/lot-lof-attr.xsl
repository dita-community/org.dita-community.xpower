<?xml version='1.0'?>

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:rx="http://www.renderx.com/XSL/Extensions"
    version="2.0">
    
  <!--HSC Format of lot-lof format is described in [DtPrt#18.4] -->
  <xsl:attribute-set name ="__lotf__heading" use-attribute-sets="__toc__header">
    <xsl:attribute name="color"><xsl:value-of select="$FmColor-RoyalBlue100"/></xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="__lotf__indent" use-attribute-sets="__toc__indent__booklist">
    <xsl:attribute name="start-indent">10pt</xsl:attribute>
    <!--HSC We have to override the space-before/after settings from __toc__indent__book
        if we want to be specific. The actual setting can then be done 
        in the __lotf__content module -->
    <xsl:attribute name="space-before">0pt</xsl:attribute>
    <xsl:attribute name="space-after">0pt</xsl:attribute>
  </xsl:attribute-set>
  
  <xsl:attribute-set name ="__lotf__content" use-attribute-sets="base-font __toc__topic__content__booklist">
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <!--HSC space-before/after determines the extra room between the entries
            before/after add up to the final space. Default was both 5pt -->
    <xsl:attribute name="space-before">0pt</xsl:attribute>
    <xsl:attribute name="space-after">0pt</xsl:attribute>
    <!--HSC [DtPrt#18.7] describes formatting of the entry -->
    <xsl:attribute name="color">#030002</xsl:attribute>
    <!--HSC the text-align-last cancels to span to the right margin.
            I didn't want that so the statment is not active 
    <xsl:attribute name="text-align-last">left</xsl:attribute> -->
  </xsl:attribute-set>

  <xsl:attribute-set name ="__lotf__leader">
    <xsl:attribute name="leader-pattern">dots</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="__lotf__title" use-attribute-sets="__lotf__content">
  </xsl:attribute-set>
  
  <xsl:attribute-set name="__lotf__page-number">
    <!--HSC [DtPrt#18.7] describes formatting of the entry -->
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="keep-together.within-line">always</xsl:attribute>
  </xsl:attribute-set>

</xsl:stylesheet>
