<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xmp="http://ns.adobe.com/xap/1.0/"
    xmlns:pdf="http://ns.adobe.com/pdf/1.3/" xmlns:xmpMM="http://ns.adobe.com/xap/1.0/mm/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:x="adobe:ns:meta/" xmlns:exslt="http://exslt.org/common" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fox="http://www.w3.org/1999/XSL/Formatx" xmlns:my="my:my" xmlns:ditaarch="http://dita.oasis-open.org/"
    exclude-result-prefixes="xsl x fox fn xs dc pdf ditaarch xlink xmpMM xmp my rdf" version="2.0">

    <xsl:output method="text" indent="no" use-character-maps="sample" name="text"/>
    <xsl:output method="xml" indent="no" use-character-maps="sample" name="xml"/>

    <!--
        This stylesheet creates the abbreviations for a set of files (stored in the same directory)
        using a master glossary. The master glossary contains all definitions (maybe 1000 or more)
        but the actual DITAMAP(Book) only uses 37 glossary references. This stylesheet generates
        a glossary (REF_acs_Local.dita) with only the 37 entries which were referenced.
        
        A reference to a glossary must follow the following rules
        
        - Must be done as @keyref (I prefer that, could be done for href, but I don't like that)
        
        - Must have the form acs/acs_term. The included glsSelectRef.xsl 
          checks that syntax (approx. line 100 -  xsl:template name="selectGlossary")
        
        - The master list (the glossary with the 1000 entries) shall have the id's
          glossentry:@id = gle_term
          glossterm:@id  = gls_term

    -->
    <!-- INCLUDE THE PROCESSING FILE -->
    <xsl:include href="acsSelectRefmap.xsl"/>

    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space($DitaToken)) = 0">
                <xsl:message>
                    <xsl:text>Stopped Process: The environment variable $Dita-Token shall have a non-empty target value !</xsl:text>
                    <xsl:text>&#xA;Find more in [MyDita#DoAcronyms]</xsl:text>
                </xsl:message>
                <xsl:text>Stopped Process: The environment variable $Dita-Token shall have a non-empty target value !</xsl:text>
                <xsl:text>&#xA;Find more in [MyDita#DoAcronyms]</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="folderURI" select="resolve-uri('.', base-uri())"/>
                
                <xsl:variable name="mergedFiles">
                    <xsl:text>&#xA;</xsl:text>
                    
                    <xsl:element name="books" inherit-namespaces="no">
                        <xsl:message>
                            <xsl:text>URI=</xsl:text>
                            <xsl:value-of select="resolve-uri('.', base-uri())"/>
                        </xsl:message>
                        
                        <xsl:variable name="auditMode" select="'all'"/>
                        
                        <!-- in final run, we trash the filenames to be excluded 
                     to allow Bibliograph and Glossary being included in the 
                     check. This will catch glossary entries an bibentries in the
                     final document
                -->
                        <xsl:variable name="acs">
                            <xsl:choose>
                                <xsl:when test="string-length($FirstRun) &gt; 0">
                                    <xsl:value-of select="'Acronyms.dita'"/>
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
                        
                        <xsl:variable name="docPile" as="node()*">
                            <!-- Visit every file listed in the .ditamap -->
                            <xsl:message>
                                <xsl:text>&#xA;Exclude = </xsl:text>
                                <xsl:value-of select="$bib"/>
                                <xsl:text>&#xA;Exclude = </xsl:text>
                                <xsl:value-of select="$acs"/>
                            </xsl:message>
                            <xsl:for-each select="//*[@href][not(contains(@href, $bib)) and not(contains(@href, $acs))]">
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
                </xsl:variable>
                
                <!-- Create the local acronyms -->
                <xsl:variable name="outFN" select="concat($folderURI, $DitaToken,'/', $acName)"/>
                <xsl:result-document href="{$outFN}" format="xml">
                    <xsl:apply-templates select="$mergedFiles" mode="acs"/>
                </xsl:result-document>
                <xsl:message>
                    <xsl:text>Generated: "</xsl:text>
                    <xsl:value-of select="$outFN"/>
                    <xsl:text>"</xsl:text>
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="*" mode="acs">
        <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
        <xsl:text>&#x21;DOCTYPE concept PUBLIC "-//OASIS//DTD DITA Concept//EN" "concept.dtd"</xsl:text>
        <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
        <xsl:text>&#xA;</xsl:text>
        <xsl:variable name="newacs">
            <xsl:call-template name="createAcronyms"/>
        </xsl:variable>
        <xsl:apply-templates select="$newacs" mode="copy"/>
    </xsl:template>

</xsl:stylesheet>
