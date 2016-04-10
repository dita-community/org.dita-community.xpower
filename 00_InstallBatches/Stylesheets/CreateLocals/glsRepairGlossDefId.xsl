<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xmp="http://ns.adobe.com/xap/1.0/"
    xmlns:pdf="http://ns.adobe.com/pdf/1.3/" xmlns:xmpMM="http://ns.adobe.com/xap/1.0/mm/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:x="adobe:ns:meta/" xmlns:exslt="http://exslt.org/common" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fox="http://www.w3.org/1999/XSL/Formatx" xmlns:my="my:my" xmlns:ditaarch="http://dita.oasis-open.org/"
    exclude-result-prefixes="xsl x fox fn xs dc pdf ditaarch xlink xmpMM xmp my rdf xml" version="2.0">

    <!--
        This stylesheet repairs a master glossary whose descriptions "glossdef" are missing the @id=glc_... atribute
        The glossdef term receives an @id=gls_(term) id in order to allow the creation of conref based
        glossaries using the glsSelectAll[Map].xls scenarios.
        
        The result file is the input file with the suffix '_rep' and needs to be renamed manually to become
        the master glossary (of course .. that's intentional)
    -->

    <xsl:variable name="MasterPathName" select="'/F:/scherzer/RefDita/src/McGlossary.dita'"/>

    <xsl:template match="/">
        <xsl:variable name="srcFile" select="base-uri(.)"/>
        <xsl:variable name="targetFile" select="replace($srcFile, '.dita', '_rep.dita')"/>
        
        <xsl:result-document href="{$targetFile}">
            <xsl:text disable-output-escaping="yes">&#xA;&lt;</xsl:text>
            <xsl:text>&#x21;DOCTYPE glossgroup PUBLIC "-//OASIS//DTD DITA Glossary Group//EN" "glossgroup.dtd"</xsl:text>
            <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
            <xsl:text>&#xA;</xsl:text>
            
            <xsl:variable name="rawgls" as="node()*">
                <xsl:apply-templates/>
            </xsl:variable>
            
            <xsl:element name="glossgroup">
                <xsl:message>
                    <xsl:value-of select="$rawgls/name()"/>
                </xsl:message>
                <xsl:call-template name="putAttrs">
                    <xsl:with-param name="myNode" select="$rawgls"/>
                </xsl:call-template>
                <xsl:apply-templates select="$rawgls/title"/>
                <xsl:for-each select="$rawgls/glossentry">
                    <!-- comment the sort statement if you don't want the result
                         being sorted alhpabetically by glossterm content
                    -->
                    <xsl:sort select="upper-case(glossterm)" order="ascending"/>
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each>
            </xsl:element>
        </xsl:result-document>

        <xsl:message>
            <xsl:text>Created: </xsl:text>
            <xsl:value-of select="$targetFile"/>
        </xsl:message>
    </xsl:template>

    <xsl:template match="glossentry">
        <xsl:variable name="gleID" select="@id"/>
        <xsl:choose>
            <xsl:when test="not(glossdef/@id)">
                <xsl:element name="glossentry" inherit-namespaces="no">
                    <xsl:call-template name="putAttrs"/>
                    <xsl:apply-templates select="*" mode="repl"/>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="putXML"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="glossterm" mode="repl">
        <xsl:call-template name="putXML"/>
    </xsl:template>

    <xsl:template match="glossdef" mode="repl">
        <xsl:element name="glossdef" inherit-namespaces="no">
            <xsl:attribute name="id" select="replace(../@id, 'gle_', 'glc_')"/>
            <xsl:apply-templates/>
        </xsl:element>
    </xsl:template>


    <xsl:template match="* | comment()">
        <xsl:call-template name="putXML"/>
    </xsl:template>



    <!-- transparent throughput of any XML input -->
    <xsl:template name="putXML">
        <!--<xsl:message>
            <xsl:value-of select="name()"/>
        </xsl:message>-->
        <xsl:element name="{name()}">
            <xsl:for-each
                select="
                    @*[not(name() = 'class')]
                    [not(contains(name(), 'ditaarch'))]
                    [not(contains(name(), 'domains'))]">
                <xsl:copy inherit-namespaces="no"/>
            </xsl:for-each>
            <xsl:apply-templates select="* | text() | comment() | processing-instruction()" mode="#default"/>
        </xsl:element>
    </xsl:template>
    
    <xsl:template match="processing-instruction()">
        <xsl:copy inherit-namespaces="no"/>
    </xsl:template>

    <xsl:template name="putAttrs">
        <xsl:param name="myNode" select="." as="node()*"/>
        <xsl:for-each
            select="
                $myNode/@*[not(name() = 'class')]
                [not(contains(name(), 'ditaarch'))]
                [not(contains(name(), 'domains'))]">
            <xsl:choose>
                <xsl:when test="name() = 'xml:id'">
                    <xsl:attribute name="id" select="."/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="{name()}">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

</xsl:stylesheet>
