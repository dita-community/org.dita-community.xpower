<?xml version="1.0" encoding="UTF-8"?>
<!-- This file is part of the DITA Open Toolkit project.
     See the accompanying license.txt file for applicable licenses. -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:fo="http://www.w3.org/1999/XSL/Format"
                xmlns:opentopic="http://www.idiominc.com/opentopic"
                xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
                xmlns:ditamsg="http://dita-ot.sourceforge.net/ns/200704/ditamsg"
                version="2.0"
                exclude-result-prefixes="xs opentopic dita-ot ditamsg">
  
  <xsl:param name="first-use-scope" select="'document'"/>
  
  <xsl:key name="abbreviated-form-keyref"
           match="*[contains(@class, ' abbrev-d/abbreviated-form ')]
                   [empty(ancestor::opentopic:map) and empty(ancestor::*[contains(@class, ' topic/title ')])]
                   [@keyref]"
           use="@keyref"/>
           
  <!--HSC an element abbreviated-form has the class="+ topic/term abbrev-d/abbreviated-form " -->
  <xsl:template match="*[contains(@class,' abbrev-d/abbreviated-form ')]" name="topic.abbreviated-form">
    <xsl:variable name="keys" select="@keyref"/>
    <xsl:variable name="target" select="key('id', substring(@href, 2))"/>
    <xsl:variable name="mhref" select="@href"/>
    <xsl:variable name="gletarget" select="key('id', substring(substring-before(@href, '/'), 2))/glossentry[@id = substring-after($mhref, '/')]"/>
    
    <xsl:message>
        <xsl:text>HSXT:11[</xsl:text>
        <xsl:value-of select="name()"/>
        <xsl:text>]   &#xA;Parent = </xsl:text>
        <xsl:value-of select="../name()"/>
        
        <xsl:text>   &#xA;Target = </xsl:text>
        <xsl:value-of select="$target/self::*/name()"/>

        <xsl:text>   &#xA;xTarget = </xsl:text>
        <xsl:value-of select="$gletarget/@id"/>
        <!-- yTarget = unique_3_Connect_42_gle_DCI unique_3_Connect_42_gle_ortler unique_3_Connect_42_gle_KHS -->

        <xsl:text>   &#xA;TargetParent = </xsl:text>
        <xsl:value-of select="$target/self::*/../name()"/>
        
        <xsl:text>   &#xA;keys = </xsl:text>
        <xsl:value-of select="$keys"/>
        
        <xsl:text>   &#xA;href = </xsl:text>
        <xsl:value-of select="substring(@href, 2)"/>
        <xsl:text>         </xsl:text>
        <xsl:value-of select="substring-after(@href, '/')"/>
        
    </xsl:message>
    <xsl:choose>
      <xsl:when test="$keys and $gletarget/self::*[contains(@class,' glossentry/glossentry ')]">
          <xsl:message>HSXT:21:</xsl:message>
          <xsl:call-template name="topic.term">
          <xsl:with-param name="contents">
            <xsl:variable name="use-abbreviated-form" as="xs:boolean">
                <xsl:apply-templates select="." mode="use-abbreviated-form"/>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="$use-abbreviated-form">
                  <xsl:apply-templates select="$gletarget" mode="getMatchingAcronym"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="$gletarget" mode="getMatchingSurfaceForm"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:when test="$keys and $target/self::*[contains(@class,' glossentry/glossentry ')]">
          <xsl:message>HSXT:12:</xsl:message>
          <xsl:call-template name="topic.term">
          <xsl:with-param name="contents">
            <xsl:variable name="use-abbreviated-form" as="xs:boolean">
                <xsl:apply-templates select="." mode="use-abbreviated-form"/>
            </xsl:variable>
            <xsl:choose>
              <xsl:when test="$use-abbreviated-form">
                  <xsl:apply-templates select="$target" mode="getMatchingAcronym"/>
              </xsl:when>
              <xsl:otherwise>
                <xsl:apply-templates select="$target" mode="getMatchingSurfaceForm"/>
              </xsl:otherwise>
            </xsl:choose>
          </xsl:with-param>
        </xsl:call-template>
      </xsl:when>
      <xsl:otherwise>
          <xsl:message>HSXT:13:</xsl:message>
          <xsl:apply-templates select="." mode="ditamsg:no-glossentry-for-abbreviated-form">
          <xsl:with-param name="keys" select="$keys"/>
        </xsl:apply-templates>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>

  <!-- Should abbreviated form of glossary entry be used -->
  <xsl:template match="*" mode="use-acbbreviated-form" as="xs:boolean">
    <xsl:variable name="first-use-scope-root" as="element()">
      <xsl:call-template name="get-first-use-scope-root"/>
    </xsl:variable>
      <xsl:message>HSXT:01:</xsl:message>
    <xsl:sequence select="not(generate-id(.) = generate-id(key('abbreviated-form-keyref', @keyref, $first-use-scope-root)[1]))"/>
  </xsl:template>
  
  <xsl:template match="*[contains(@class,' topic/copyright ')]//*" mode="use-abbreviated-form" as="xs:boolean">
      <xsl:message>HSXT:02:</xsl:message>
      <xsl:sequence select="false()"/>
  </xsl:template>
  
  <xsl:template match="*[contains(@class,' topic/title ')]//*" mode="use-abbreviated-form" as="xs:boolean">
      <xsl:message>HSXT:03:</xsl:message>
      <xsl:sequence select="true()"/>
  </xsl:template>  

  <!-- Get element to use as root when  -->
  <xsl:template name="get-first-use-scope-root" as="element()">
    <xsl:choose>
      <xsl:when test="$first-use-scope = 'topic'">
          <xsl:message>HSXT:04:</xsl:message>
          <xsl:sequence select="ancestor::*[contains(@class, ' topic/topic ')][1]"/>
      </xsl:when>
      <xsl:when test="$first-use-scope = 'chapter'">
          <xsl:message>HSXT:05:</xsl:message>
          <xsl:sequence select="ancestor::*[contains(@class, ' topic/topic ')][position() = last()]"/>
      </xsl:when>
      <xsl:otherwise>
          <xsl:message>HSXT:06:</xsl:message>
          <xsl:sequence select="/*"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="*" mode="getMatchingSurfaceForm">
    <xsl:variable name="glossSurfaceForm" select="*[contains(@class, ' glossentry/glossBody ')]/*[contains(@class, ' glossentry/glossSurfaceForm ')]"/>
    <xsl:choose>
      <xsl:when test="$glossSurfaceForm">
          <xsl:message>HSXT:07:</xsl:message>
          <xsl:apply-templates select="$glossSurfaceForm/node()"/>
      </xsl:when>
      <xsl:otherwise>
          <xsl:message>HSXT:08:</xsl:message>
          <xsl:apply-templates select="*[contains(@class, ' glossentry/glossterm ')]/node()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="*" mode="getMatchingAcronym">
    <xsl:variable name="glossAcronym" select="*[contains(@class, ' glossentry/glossBody ')]/*[contains(@class, ' glossentry/glossAlt ')]/*[contains(@class, ' glossentry/glossAcronym ')]"/>
    <xsl:choose>
      <xsl:when test="$glossAcronym">
          <xsl:message>HSXT:09:</xsl:message>
          <xsl:apply-templates select="$glossAcronym[1]/node()"/>
      </xsl:when>
      <xsl:otherwise>
          <xsl:message>HSXT:19:</xsl:message>
          <xsl:apply-templates select="*[contains(@class, ' glossentry/glossterm ')]/node()"/>
      </xsl:otherwise>
    </xsl:choose>
  </xsl:template>
  
  <xsl:template match="*" mode="ditamsg:no-glossentry-for-abbreviated-form">
    <xsl:param name="keys"/>
    <xsl:message>HSXT:20:</xsl:message>
    <xsl:call-template name="output-message">
      <xsl:with-param name="msgnum">060</xsl:with-param>
      <xsl:with-param name="msgsev">W</xsl:with-param>
      <xsl:with-param name="msgparams">%1=<xsl:value-of select="$keys"/></xsl:with-param>
    </xsl:call-template>
  </xsl:template>

</xsl:stylesheet>
