<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xmp="http://ns.adobe.com/xap/1.0/"
    xmlns:pdf="http://ns.adobe.com/pdf/1.3/" xmlns:xmpMM="http://ns.adobe.com/xap/1.0/mm/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:x="adobe:ns:meta/" xmlns:exslt="http://exslt.org/common" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fox="http://www.w3.org/1999/XSL/Formatx" xmlns:my="my:my" xmlns:ditaarch="http://dita.oasis-open.org/"
    exclude-result-prefixes="xsl x fox fn xs dc pdf ditaarch xlink xmpMM xmp my rdf xml" version="2.0">

    <!--
        This stylesheet repairs a master bibliography whose descriptions in the table entries
        might be mssing.
        
        entry[1]/@id = spb_  is expected but if not present we try to recruit from the content [...]
        entry[2]/@id = spd_  will be derived from entry[1]/@id
        entry[3]/@id = spp_  will be derived from entry[1]/@id
        
        The result file is the input file with the suffix '_rep' and needs to be renamed manually to become
        the master bibliography (of course .. that's intentional)
        
        The master file may contain several tables to structure the documents.
        The transfoormation sorts the entries WITHIN the tables.
    
    For use with parameters ... use this instead of the variable
    
    <xsl:param name="MasterPathName" required="no" select="'/F:/scherzer/RefDita/MasterLists/McSpecification.dita'"
        as="xs:string"/>
    -->
    
    <xsl:variable name="MasterPathName" select="base-uri(.)"/>
    <xsl:variable name="folderURI" select="resolve-uri('.', base-uri())"/>

    <xsl:template match="/">
        <xsl:variable name="srcFile" select="base-uri(.)"/>
        <xsl:variable name="targetFile" select="replace($srcFile, '.dita', '_rep.dita')"/>

        <xsl:message>
            <xsl:text>Master:   </xsl:text>
            <xsl:value-of select="base-uri()"/>
        </xsl:message>
        
        
        <!-- Create spcEntries with all sorted entries
             We maintain separate tables in the master file
             and only sort within these tables
        -->
        <xsl:variable name="spcEntries" as="node()*">
            <xsl:apply-templates mode="sortrows"/>
        </xsl:variable>

        <xsl:result-document href="{$targetFile}">
            <xsl:text disable-output-escaping="yes">&#xA;&lt;</xsl:text>
            <xsl:text>&#x21;DOCTYPE concept PUBLIC "-//OASIS//DTD DITA Concept//EN" "concept.dtd"</xsl:text>
            <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
            <xsl:text>&#xA;</xsl:text>
            <xsl:apply-templates select="$spcEntries"/>
        </xsl:result-document>

        <xsl:message>
            <xsl:text>Created: </xsl:text>
            <xsl:value-of select="$targetFile"/>
        </xsl:message>
    </xsl:template>

    <!-- The sortrows-mode lets the rows collect and sort -->
    <xsl:template match="*" mode="sortrows" priority="-1">
        <xsl:call-template name="putXML"/>
    </xsl:template>

    <xsl:template match="tbody" mode="sortrows">
        <xsl:element name="tbody" inherit-namespaces="no">
            <xsl:call-template name="putAttrs"/>
            <xsl:for-each select="row">
                <xsl:sort select="upper-case(entry[1])" order="ascending" data-type="text"/>
                <xsl:element name="row" inherit-namespaces="no">
                    <xsl:call-template name="putAttrs"/>
                    <xsl:copy-of select="*" copy-namespaces="no"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>


    <!-- These templates strip the text content and ignore the paragraph content
         which is meant to isolate the first entry of the biblio table
    -->
    <xsl:template match="text()" mode="stripEntry">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="p" mode="stripEntry"/>


    <xsl:template match="tbody/row">
        <xsl:element name="row">
            <xsl:call-template name="putAttrs"/>

            <xsl:variable name="gleID">
                <xsl:choose>
                    <!-- entry[1]/@id available ... we will use this as reference for
                         the creation of the following spd/spp id
                    -->
                    <xsl:when test="string-length(substring-after((entry[1])/@id, 'spb_')) > 0">
                        <xsl:value-of select="substring-after((entry[1])/@id, 'spb_')"/>
                    </xsl:when>
                    <!-- entry[1]/@id not available, we try to recruit the id from the
                         biblio entry (in brackets [])                        
                    -->
                    <xsl:otherwise>
                        <xsl:variable name="tag">
                            <xsl:apply-templates select="entry[1]" mode="stripEntry"/>
                        </xsl:variable>
                        <xsl:analyze-string select="$tag" regex="{'\[(.*)\]'}">
                            <xsl:matching-substring>
                                <xsl:value-of select="regex-group(1)"/>
                                <xsl:message>
                                    <xsl:text>No Tag - CREATED = </xsl:text>
                                    <xsl:value-of select="regex-group(1)"/>
                                </xsl:message>
                            </xsl:matching-substring>
                        </xsl:analyze-string>

                    </xsl:otherwise>
                </xsl:choose>

            </xsl:variable>

            <xsl:for-each select="entry">
                <xsl:variable name="myPos" select="position()"/>
                <xsl:variable name="prefix">
                    <xsl:choose>
                        <xsl:when test="$myPos = 1">
                            <xsl:value-of select="'spb_'"/>
                        </xsl:when>
                        <xsl:when test="$myPos = 2">
                            <xsl:value-of select="'spd_'"/>
                        </xsl:when>
                        <xsl:when test="$myPos = 3">
                            <xsl:value-of select="'spp_'"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:variable>
                <xsl:element name="entry" inherit-namespaces="no">
                    <!--<xsl:call-template name="putAttrs"/>-->
                    <xsl:attribute name="id" select="concat($prefix, $gleID)"/>
                    <xsl:apply-templates select="* | text() | comment() | processing-instruction()" mode="#default"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template match="*" mode="repl">
        <xsl:call-template name="putXML"/>
    </xsl:template>

    <xsl:template match="* | comment()">
        <xsl:call-template name="putXML"/>
    </xsl:template>

    <!-- transparent throughput of any XML input -->
    <xsl:template name="putXML">
        <xsl:element name="{name()}" inherit-namespaces="no">
            <xsl:for-each
                select="
                    @*[not(name() = 'class')]
                    [not(contains(name(), 'ditaarch'))]
                    [not(contains(name(), 'domains'))]">
                <xsl:copy inherit-namespaces="no"/>
            </xsl:for-each>
            <xsl:apply-templates select="* | text() | comment() | processing-instruction()" mode="#current"/>
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
