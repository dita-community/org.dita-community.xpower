<?xml version='1.0'?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:fo="http://www.w3.org/1999/XSL/Format"
  version="2.0">
  <!--HSC attributes build after [DtPrt#9.2.6] -->
  <xsl:attribute-set name ="__backmatter__copyright">
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="font-size">14pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="space-after">18pt</xsl:attribute>
    <xsl:attribute name="color">
      <xsl:value-of select="$Backmatter-copyright"/>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name ="__backmatter__text">
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="space-after">6pt</xsl:attribute>
    <xsl:attribute name="line-height">14pt</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name ="__backmatter__text__last">
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="font-size">10pt</xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="space-after">6pt</xsl:attribute>
    <xsl:attribute name="line-height">14pt</xsl:attribute>
    <!--HSC add a  break after the last page acc. to [DtPrt#9.2.6] -->
    <xsl:attribute name="break-after">page</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name ="__backmatter__logo">
    <xsl:attribute name="text-align">right</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name ="__backmatter__item">
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="font-weight">bold</xsl:attribute>
    <xsl:attribute name="space-before">12pt</xsl:attribute>
    <xsl:attribute name="space-after">3pt</xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
    <xsl:attribute name="color">
      <xsl:value-of select="$Backmatter-item"/>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="__backmatter__logo__container">
    <xsl:attribute name="position">absolute</xsl:attribute>
    <xsl:attribute name="top">8.35in</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name ="__backmatter__publish">
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="space-after">3pt</xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name ="__backmatter__language">
    <xsl:attribute name="font-family">sans-serif</xsl:attribute>
    <xsl:attribute name="font-size">9pt</xsl:attribute>
    <xsl:attribute name="font-weight">normal</xsl:attribute>
    <xsl:attribute name="space-after">3pt</xsl:attribute>
    <xsl:attribute name="text-align">right</xsl:attribute>
  </xsl:attribute-set>

</xsl:stylesheet>


