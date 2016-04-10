<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xmp="http://ns.adobe.com/xap/1.0/"
    xmlns:pdf="http://ns.adobe.com/pdf/1.3/" xmlns:xmpMM="http://ns.adobe.com/xap/1.0/mm/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:x="adobe:ns:meta/" xmlns:exslt="http://exslt.org/common" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fox="http://www.w3.org/1999/XSL/Formatx" xmlns:my="my:my" xmlns:ditaarch="http://dita.oasis-open.org/"
    exclude-result-prefixes="xsl x fox fn xs dc pdf ditaarch xlink xmpMM xmp my rdf" version="2.0">

    <xsl:output method="xml" indent="no" use-character-maps="sample" name="xml"/>

    <!--
        This stylesheet creates the bibliography for the files contained in a DITAMAP. Hence
        the scenario shall be applied to the .ditamap

        The scenario includes all items that appear either as ezRead link [ISO4#5.1] or as a direct link
        in form of an XREF topic which uses a key reference spc/spb_term

        The master bibliograpy contains all definitions (maybe 1000 or more)
        but the actual DITAMAP(Book) only uses 37 bibliograpy references. This stylesheet generates
        a bibliograpy (REF_spc_productname.dita) with only the 37 entries which were referenced.

        A reference to a glossary must follow the following rules

        -

        - The master list (the glossary with the 1000 entries) shall have the id's
          bibdescriptor @id = spb_term
          bibcontent    @id = spd_term
          bibpublisher  @id = spp_term
    -->
    <!-- INCLUDE THE PROCESSING FILE -->
    <xsl:include href="spcSelectRefmap.xsl"/>

    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space($DitaToken)) = 0">
                <xsl:message>
                    <xsl:text>Stopped Process: The environment variable $Dita-Token shall have a non-empty target value !</xsl:text>
                    <xsl:text>&#xA;Find more in [MyDita#DoGlossary]</xsl:text>
                </xsl:message>
                <xsl:text>Stopped Process: The environment variable $Dita-Token shall have a non-empty target value !</xsl:text>
                <xsl:text>&#xA;Find more in [MyDita#DoGlossary]</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>
                    <xsl:text>MASTER FILE = </xsl:text>
                    <xsl:value-of select="$MasterPathName"/>
                    <xsl:text>&#xA;</xsl:text>
                    <xsl:value-of select="$DitaToken"/>
                </xsl:message>
                <xsl:variable name="mergedFiles">
                    <xsl:text>&#xA;</xsl:text>
                    
                    <xsl:element name="books" inherit-namespaces="no">
                        <xsl:message>
                            <xsl:text>URI=</xsl:text>
                            <xsl:value-of select="resolve-uri('.', base-uri())"/>
                        </xsl:message>
                        <xsl:call-template name="chktime">
                            <xsl:with-param name="tag" select="'START:'"/>
                        </xsl:call-template>
                        <!-- We are in a ditamap, so we will find the files through @href -->
                        <xsl:variable name="auditMode" select="'all'"/>
                        
                        <!-- in final run, we trash the filenames to be excluded 
                     to allow Bibliograph and Glossary being included in the 
                     check. This will catch glossary entries an bibentries in the
                     final document
                -->
                        <xsl:variable name="gls">
                            <xsl:choose>
                                <xsl:when test="string-length($FirstRun) &gt; 0">
                                    <xsl:value-of select="'Glossary.dita'"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'Trash.png'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        
                        <xsl:variable name="bib">
                            <xsl:choose>
                                <xsl:when test="string-length($FirstRun) &gt; 0">
                                    <xsl:value-of select="'Bibliography.dita'"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'Trash.png'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>
                        
                        <!-- COLLECT THE FILENAMES in $docPile -->
                        <xsl:variable name="docPile" as="node()*">
                            <!-- Visit every file listed in the .ditamap -->
                            <xsl:message>
                                <xsl:text>&#xA;Exclude = </xsl:text>
                                <xsl:value-of select="$bib"/>
                                <xsl:text>&#xA;Exclude = </xsl:text>
                                <xsl:value-of select="$gls"/>
                            </xsl:message>
                            <xsl:for-each select="//*[@href][not(contains(@href,$bib)) and not(contains(@href,$gls))]">
                                <!--
                        <xsl:message>
                            <xsl:text>&#xA;File: </xsl:text>
                            <xsl:value-of select="@href"/>                            
                        </xsl:message>
                        -->
                                <xsl:element name="file">
                                    <xsl:if test="ancestor-or-self::*[@audience]">
                                        <xsl:element name="audience">
                                            <!-- If we ommit the [1] constraint, the next statement
                                         generates a list of audiences which could become attribute
                                         of the future glossentry.
                                    -->
                                            <xsl:choose>
                                                <xsl:when test="contains($auditMode, 'all')">
                                                    <xsl:variable name="clAll">
                                                        <xsl:for-each select="(ancestor-or-self::*[@audience])/@audience">
                                                            <xsl:value-of select="concat(string(.), ' ')"/>
                                                        </xsl:for-each>
                                                    </xsl:variable>
                                                    <xsl:value-of select="normalize-space($clAll)"/>
                                                </xsl:when>
                                                <xsl:otherwise>
                                                    <xsl:value-of select="(ancestor-or-self::*[@audience])[1]/@audience"/>
                                                </xsl:otherwise>
                                            </xsl:choose>
                                        </xsl:element>
                                    </xsl:if>
                                    
                                    <xsl:element name="fn">
                                        <xsl:value-of select="concat($folderURI, @href)"/>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:for-each>
                        </xsl:variable>
                        
                        <!-- Visit all files by filename -->
                        <xsl:for-each select="document($docPile/fn)/*">
                            <xsl:variable name="myPos" select="position()"/>
                            
                            <xsl:if test="contains($unittest, 'prcfiles')">
                                <xsl:message>
                                    <xsl:text>Process: </xsl:text>
                                    <xsl:value-of select="base-uri()"/>
                                    <xsl:text> = </xsl:text>
                                    <xsl:value-of select="./name()"/>
                                </xsl:message>
                            </xsl:if>
                            <xsl:text>&#xA;</xsl:text>
                            
                            <xsl:element name="book" inherit-namespaces="no">
                                <!-- Get the file's filename through document-uri [Xslt#12.1.1] -->
                                <xsl:attribute name="uri" select="document-uri(/)"/>
                                <xsl:if test="$docPile[$myPos]/audience">
                                    <xsl:attribute name="audience" select="$docPile[$myPos]/audience"/>
                                </xsl:if>
                                
                                <!-- Copy the file content -->
                                <xsl:text>&#xA;</xsl:text>
                                <!--<xsl:call-template name="putXML"/>-->
                                <xsl:element name="{name()}" inherit-namespaces="no">
                                    <xsl:apply-templates mode="copy"
                                        select="
                                        @*
                                        [not(contains(name(), 'class'))]
                                        [not(contains(name(), 'DITAArchVersion'))]
                                        [not(contains(local-name(), 'DITAArchVersion'))]
                                        [not(contains(name(), 'domains'))]"/>
                                    <xsl:for-each select="*">
                                        <xsl:apply-templates mode="copy" select="."/>
                                    </xsl:for-each>
                                </xsl:element>
                                <xsl:text>&#xA;</xsl:text>
                            </xsl:element>
                        </xsl:for-each>
                        <xsl:text>&#xA;</xsl:text>
                    </xsl:element>
                </xsl:variable> <!-- mergedFiles -->
                
                <!-- Create the local bibliography {concat($folderURI,-->
                
                
                <xsl:variable name="outFN" select="concat($folderURI, $DitaToken,'/', $bibName)"/>
                <xsl:result-document href="{$outFN}" format="xml">
                    <xsl:apply-templates select="$mergedFiles" mode="spc"/>
                </xsl:result-document>
                
                <xsl:message>
                    <xsl:text>Generated: "</xsl:text>
                    <xsl:value-of select="$outFN"/>
                    <xsl:text>"</xsl:text>
                </xsl:message>
                
                <!-- Create the 'ingore-list' {concat($folderURI,-->
                <xsl:result-document href="{concat($folderURI, $ignName)}" format="xml">
                    <xsl:apply-templates select="$mergedFiles" mode="ign"/>
                </xsl:result-document>
                <xsl:message>
                    <xsl:text>Generated: "</xsl:text>
                    <xsl:value-of select="concat($folderURI, $ignName)"/>
                    <xsl:text>"</xsl:text>
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- CREATE Ignores_local.-->
    <xsl:template match="*" mode="ign">
        <xsl:variable name="ignoresraw" as="node()*">
            <xsl:call-template name="getTextLinks">
                <xsl:with-param name="relaxed-mode" select="2"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:element name="ignores">
            <xsl:for-each-group select="$ignoresraw/*" group-by="TargetTerm">
                <xsl:element name="ignore">
                    <xsl:value-of select="TargetTerm"/>
                </xsl:element>
            </xsl:for-each-group>
        </xsl:element>
    </xsl:template>

    <!-- CREATE THE OUTPUT FILE content -->
    <xsl:template match="*" mode="spc">
        <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
        <xsl:text>&#x21;DOCTYPE concept PUBLIC "-//OASIS//DTD DITA Concept//EN" "concept.dtd"</xsl:text>
        <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
        <xsl:text>&#xA;</xsl:text>
        <xsl:variable name="newBib">
            <xsl:call-template name="createBibliography"/>
        </xsl:variable>

        <!--<xsl:message>
            <xsl:text>newBib</xsl:text>
            <xsl:copy-of select="$newBib"/>
        </xsl:message>-->

        <xsl:apply-templates select="$newBib" mode="copy"/>
    </xsl:template>
</xsl:stylesheet>
