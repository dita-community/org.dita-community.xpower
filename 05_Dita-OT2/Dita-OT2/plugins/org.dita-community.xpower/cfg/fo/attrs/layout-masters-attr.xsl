<?xml version="1.0" encoding="UTF-8"?>
<!--
  This file is part of the DITA Open Toolkit project.
  See the accompanying license.txt file for applicable licenses.
-->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                version="2.0">

  <xsl:attribute-set name="simple-page-master">
    <xsl:attribute name="page-width">
      <xsl:value-of select="$page-width"/>
    </xsl:attribute>
    <xsl:attribute name="page-height">
      <xsl:value-of select="$page-height"/>
    </xsl:attribute>
  </xsl:attribute-set>

  <!--HSC create the landscape master acc. to [DtPrt#7.12.7] -->
  <xsl:attribute-set name="landscape-page-master">
    <xsl:attribute name="page-width">
      <xsl:value-of select="$page-width-landscape"/>
    </xsl:attribute>
    <xsl:attribute name="page-height">
      <xsl:value-of select="$page-height-landscape"/>
    </xsl:attribute>
  </xsl:attribute-set>

  <!-- legacy attribute set -->
  <xsl:attribute-set name="region-body" use-attribute-sets="region-body.odd"/>

  <!--HSC define gaps between region-start and region-body [DtPrt#7.9] -->
  <xsl:attribute-set name="region-body.odd">
    <xsl:attribute name="margin-top">
      <xsl:value-of select="$region-top-margin"/>
    </xsl:attribute>
    <xsl:attribute name="margin-bottom">
      <xsl:value-of select="$region-bottom-margin"/>
    </xsl:attribute>
    <!--HSC make region background gray to allow it being visible for test
    <xsl:attribute name="background-color">#DDDDDD</xsl:attribute>
    -->

    <!--HSC ... change columns for the pages [DtPrt#7.12.5]
       actually since we have different layouts for the different
       pages ... we need to do this for all   types that are relevant 
      
       The statement below only applies to odd chapter pages which are NOT the first chapter page 
    <xsl:attribute name="column-count">2</xsl:attribute>
    <xsl:attribute name="column-gap">1in</xsl:attribute> -->

    <xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-left' else 'margin-right'}">
      <xsl:value-of select="$page-margin-inside"/>
    </xsl:attribute>
    <xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-right' else 'margin-left'}">
      <xsl:value-of select="$page-margin-outside"/>
    </xsl:attribute>
  </xsl:attribute-set>


  <!-- region-body.landscape attribute set acc to [DtPrt#7.12.7] -->
  <xsl:attribute-set name="region-body.landscape.even">
    <xsl:attribute name="margin-top">
      <xsl:value-of select="$region-top-margin"/>
    </xsl:attribute>
    <xsl:attribute name="margin-bottom">
      <xsl:value-of select="$region-bottom-margin"/>
    </xsl:attribute>

    <xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-left' else 'margin-right'}">
      <xsl:value-of select="$page-margin-outside"/>
    </xsl:attribute>
    <xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-right' else 'margin-left'}">
      <xsl:value-of select="$page-margin-inside"/>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="region-body.landscape.odd">
    <xsl:attribute name="margin-top">
      <xsl:value-of select="$region-top-margin"/>
    </xsl:attribute>
    <xsl:attribute name="margin-bottom">
      <xsl:value-of select="$region-bottom-margin"/>
    </xsl:attribute>

    <xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-left' else 'margin-right'}">
      <xsl:value-of select="$page-margin-inside"/>
    </xsl:attribute>
    <xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-right' else 'margin-left'}">
      <xsl:value-of select="$page-margin-outside"/>
    </xsl:attribute>
  </xsl:attribute-set>



  <!--HSC ... add attributes for the first body page (different from following body pages [DtPrt#7.12.2] -->
  <xsl:attribute-set name="region-body.first.even">
    <xsl:attribute name="margin-top">
      <xsl:value-of select="$page-margin-top-first"/>
    </xsl:attribute>
    <xsl:attribute name="margin-bottom">
      <xsl:value-of select="$page-margin-bottom"/>
    </xsl:attribute>
    <!--HSC make region background gray to allow it being visible for test 
    <xsl:attribute name="background-color">#EEEEEE</xsl:attribute> -->

    <xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-left' else 'margin-right'}">
      <xsl:value-of select="$page-margin-outside"/>
    </xsl:attribute>
    <xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-right' else 'margin-left'}">
      <xsl:value-of select="$page-margin-inside"/>
    </xsl:attribute>
  </xsl:attribute-set>
  
  
  <xsl:attribute-set name="region-body.first.odd">
    <xsl:attribute name="margin-top">
      <xsl:value-of select="$page-margin-top-first"/>
    </xsl:attribute>
    <xsl:attribute name="margin-bottom">
      <xsl:value-of select="$page-margin-bottom"/>
    </xsl:attribute>
    <!--HSC make region background gray to allow it being visible for test
    <xsl:attribute name="background-color">#EEEEEE</xsl:attribute> -->

    <xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-left' else 'margin-right'}">
      <xsl:value-of select="$page-margin-inside"/>
    </xsl:attribute>
    <xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-right' else 'margin-left'}">
      <xsl:value-of select="$page-margin-outside"/>
    </xsl:attribute>
  </xsl:attribute-set>

  <!--HSC define gaps between region-start and region-body [DtPrt#7.9] -->
  <xsl:attribute-set name="region-body.even">
    <xsl:attribute name="margin-top">
      <xsl:value-of select="$region-top-margin"/>
    </xsl:attribute>
    <xsl:attribute name="margin-bottom">
      <xsl:value-of select="$region-bottom-margin"/>
    </xsl:attribute>

    <!--HSC make region background light blue to allow it being visible for test -->
    <!--  <xsl:attribute name="background-color">#DDDDDD</xsl:attribute> -->

    <xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-left' else 'margin-right'}">
      <xsl:value-of select="$page-margin-outside"/>
    </xsl:attribute>
    <xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-right' else 'margin-left'}">
      <xsl:value-of select="$page-margin-inside"/>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="region-body__frontmatter.odd" use-attribute-sets="region-body.odd">
  <!--HSC adding margins over the default settings for the front page [DtPrt#7.10] -->
    <xsl:attribute name="margin-top">
      <xsl:value-of select="$page-margin-top-front"/>
    </xsl:attribute>
    <xsl:attribute name="margin-bottom">
      <xsl:value-of select="$page-margin-bottom-front"/>
    </xsl:attribute>

    <!--HSC make region background gray to allow it being visible for test
    <xsl:attribute name="background-color">#FFC0FF</xsl:attribute> -->
    <!--HSC add background image (watermark) acc. to [DtPrt#7.12.4] acc to [XepUg#D] will be interpreted as 120dpi
        Image size can be directory scaled acc. to [XslFo#7.15.13] -->
    <!-- not really wanted 
    <xsl:attribute name="background-image">url(Customization/OpenTopic/common/artwork/TopSecret.png)</xsl:attribute>
    <xsl:attribute name="background-repeat">no-repeat</xsl:attribute>
    <xsl:attribute name="background-position">0mm 0mm</xsl:attribute>  
    -->

    <xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-left' else 'margin-right'}">
      <xsl:value-of select="$page-margin-inside"/>
    </xsl:attribute>
    <xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-right' else 'margin-left'}">
      <xsl:value-of select="$page-margin-outside"/>
    </xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="region-body__frontmatter.even" use-attribute-sets="region-body.even">
    <xsl:attribute name="margin-top">
      <xsl:value-of select="$page-margin-top-front"/>
    </xsl:attribute>
    <xsl:attribute name="margin-bottom">
      <xsl:value-of select="$page-margin-bottom-front"/>
    </xsl:attribute>
    <!--HSC make region background gray to allow it being visible for test
    <xsl:attribute name="background-color">#FFC0FF</xsl:attribute> -->

    <xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-left' else 'margin-right'}">
      <xsl:value-of select="$page-margin-inside"/>
    </xsl:attribute>
    <xsl:attribute name="{if ($writing-mode = 'lr') then 'margin-right' else 'margin-left'}">
      <xsl:value-of select="$page-margin-outside"/>
    </xsl:attribute>
  </xsl:attribute-set>

  <!-- legacy attribute set -->
  <xsl:attribute-set name="region-body__index" use-attribute-sets="region-body__index.odd"/>

  <xsl:attribute-set name="region-body__index.odd" use-attribute-sets="region-body.odd">
    <xsl:attribute name="column-count">2</xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="region-body__index.even" use-attribute-sets="region-body.even">
    <xsl:attribute name="column-count">2</xsl:attribute>
  </xsl:attribute-set>

  <!--HSC add backmatter attributes acc. to [DtPrt#9.2.4] -->
  <xsl:attribute-set name="region-backmatter.first">
    <xsl:attribute name="margin-top"><xsl:value-of select="$page-margins"/></xsl:attribute>
    <xsl:attribute name="margin-bottom"><xsl:value-of select="$page-margins"/></xsl:attribute>
    <xsl:attribute name="margin-left"><xsl:value-of select="$page-margins"/></xsl:attribute>
    <xsl:attribute name="margin-right"><xsl:value-of select="$page-margins"/></xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="region-backmatter.even">
    <xsl:attribute name="margin-top"><xsl:value-of select="$page-margins"/></xsl:attribute>
    <xsl:attribute name="margin-bottom"><xsl:value-of select="$page-margins"/></xsl:attribute>
    <xsl:attribute name="margin-left"><xsl:value-of select="$page-margins"/></xsl:attribute>
    <xsl:attribute name="margin-right"><xsl:value-of select="$page-margins"/></xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="region-backmatter.odd">
    <xsl:attribute name="margin-top"><xsl:value-of select="$page-margins"/></xsl:attribute>
    <xsl:attribute name="margin-bottom"><xsl:value-of select="$page-margins"/></xsl:attribute>
    <xsl:attribute name="margin-left"><xsl:value-of select="$page-margins"/></xsl:attribute>
    <xsl:attribute name="margin-right"><xsl:value-of select="$page-margins"/></xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="region-backmatter.last">
    <xsl:attribute name="margin-top"><xsl:value-of select="$page-margins"/></xsl:attribute>
    <xsl:attribute name="margin-bottom"><xsl:value-of select="$page-margins"/></xsl:attribute>
    <xsl:attribute name="margin-left"><xsl:value-of select="$page-margins"/></xsl:attribute>
    <xsl:attribute name="margin-right"><xsl:value-of select="$page-margins"/></xsl:attribute>
  </xsl:attribute-set>

  <xsl:attribute-set name="region-before">
    <xsl:attribute name="extent">
      <xsl:value-of select="$page-margin-top"/>
    </xsl:attribute>
    <xsl:attribute name="display-align">before</xsl:attribute>
    <!--HSC make background gray to make regions visible
    <xsl:attribute name="background-color">#DDDDDD</xsl:attribute> -->
  </xsl:attribute-set>

  <!--HSC add seperate region-befor for the first body page -->
  <xsl:attribute-set name="region-before.first">
    <xsl:attribute name="extent">
      <xsl:value-of select="$header-extent-first"/>
    </xsl:attribute>
    <xsl:attribute name="display-align">before</xsl:attribute>
    <!--HSC make background gray to make regions visible
    <xsl:attribute name="background-color">#DDDDDD</xsl:attribute> -->
  </xsl:attribute-set>

  <xsl:attribute-set name="region-after">
    <xsl:attribute name="extent">
      <xsl:value-of select="$page-margin-bottom"/>
    </xsl:attribute>
    <xsl:attribute name="display-align">after</xsl:attribute>
    <!--HSC make background gray to make regions visible
    <xsl:attribute name="background-color">#DDDDDD</xsl:attribute> -->
  </xsl:attribute-set>

</xsl:stylesheet>