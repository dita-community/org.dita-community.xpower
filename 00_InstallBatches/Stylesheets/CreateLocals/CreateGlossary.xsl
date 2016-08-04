<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xmp="http://ns.adobe.com/xap/1.0/" xmlns:pdf="http://ns.adobe.com/pdf/1.3/"
    xmlns:xmpMM="http://ns.adobe.com/xap/1.0/mm/" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:x="adobe:ns:meta/" xmlns:exslt="http://exslt.org/common"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:fox="http://www.w3.org/1999/XSL/Formatx" xmlns:my="my:my"
    xmlns:ditaarch="http://dita.oasis-open.org/" exclude-result-prefixes="xsl x fox fn xs dc pdf ditaarch xlink xmpMM xmp my rdf"
    version="2.0">

    <xsl:output method="text" indent="no" use-character-maps="sample" name="text"/>
    <xsl:output method="xml" indent="no" use-character-maps="sample" name="xml"/>

    <!--
        This stylesheet creates the glossary for a set of files (stored in the same directory)
        using a master glossary. The master glossary contains all definitions (maybe 1000 or more)
        but the actual DITAMAP(Book) only uses 37 glossary references. This stylesheet generates
        a glossary (REF_gls_Local.dita) with only the 37 entries which were referenced.
        
        A reference to a glossary must follow the following rules
        
        - Must be done as @keyref (I prefer that, could be done for href, but I don't like that)
        
        - Must have the form gls/gls_term or refgls/gls_term. The included glsSelectRef.xsl 
          checks that syntax (approx. line 100 -  xsl:template name="selectGlossary")
        
        - The master list (the glossary with the 1000 entries) shall have the id's
          glossentry:@id = gle_term
          glossterm:@id  = gls_term

    -->
    <!-- INCLUDE THE PROCESSING FILE -->
    <xsl:include href="glsSelectRefmap.xsl"/>

    <xsl:template name="get-file-name">
        <xsl:param name="file-path"/>
        <xsl:choose>
            <xsl:when test="contains($file-path, '\')">
                <xsl:call-template name="get-file-name">
                    <xsl:with-param name="file-path" select="substring-after($file-path, '\')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains($file-path, '/')">
                <xsl:call-template name="get-file-name">
                    <xsl:with-param name="file-path" select="substring-after($file-path, '/')"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$file-path"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:variable name="mapName">
        <xsl:call-template name="get-file-name">
            <xsl:with-param name="file-path" select="base-uri()"/>
        </xsl:call-template>
    </xsl:variable>
    
    <xsl:variable name="DocTag">
        <xsl:analyze-string select="$mapName" regex="{'_([^_]*)_.*'}">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)"/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:variable>
    
    <xsl:variable name="DocToken">
        <xsl:choose>
            <xsl:when test="string-length($DocTag) &gt; 0">
                <xsl:message>
                    <xsl:text>DocToken = </xsl:text>
                    <xsl:value-of select="$DocTag"/>
                </xsl:message>
                <xsl:value-of select="$DocTag"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>
                    <xsl:text>DitaToken = </xsl:text>
                    <xsl:value-of select="$DitaToken"/>
                </xsl:message>
                <xsl:value-of select="$DitaToken"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
        
    <xsl:template match="/">
        <xsl:choose>
            <xsl:when test="string-length(normalize-space($DocToken)) = 0">
                <xsl:message>
                    <xsl:text>Stopped Process: The environment variable $Dita-Token shall have a non-empty target value !</xsl:text>
                    <xsl:text>&#xA;Find more in [MyDita#DoGlossary]</xsl:text>
                </xsl:message>
                <xsl:text>Stopped Process: The environment variable $Dita-Token shall have a non-empty target value !</xsl:text>
                <xsl:text>&#xA;Find more in [MyDita#glsProcess]</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:variable name="folderURI" select="resolve-uri('.', base-uri())"/>

                <xsl:variable name="mergedFiles">
                    <xsl:text>&#xA;</xsl:text>
                    <xsl:element name="books" inherit-namespaces="no">
                        <xsl:message>
                            <xsl:text>URI=</xsl:text>
                            <xsl:choose>
                                <xsl:when test="$FirstRun = 'true'">
                                    <xsl:value-of select="resolve-uri('.', base-uri())"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="base-uri()"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:message>

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

                        <xsl:variable name="docPile" as="node()*">
                            <!-- Visit every file listed in the .ditamap -->
                            <xsl:message>
                                <xsl:text>&#xA;Exclude = </xsl:text>
                                <xsl:value-of select="$bib"/>
                                <xsl:text>&#xA;Exclude = </xsl:text>
                                <xsl:value-of select="$gls"/>
                            </xsl:message>
                            <xsl:for-each select="//*[@href][not(contains(@href, $bib)) and not(contains(@href, $gls))]">
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

                        <xsl:choose>
                            <xsl:when test="$FirstRun = 'true'">
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
                                            <!-- Copy attributes -->
                                            <xsl:apply-templates mode="copy"
                                                select="
                                                    @*
                                                    [not(contains(name(), 'class'))]
                                                    [not(contains(name(), 'DITAArchVersion'))]
                                                    [not(contains(local-name(), 'DITAArchVersion'))]
                                                    [not(contains(name(), 'domains'))]"/>
                                            <!-- Copy elements -->
                                            <xsl:for-each select="*">
                                                <xsl:apply-templates mode="copy" select="."/>
                                            </xsl:for-each>
                                        </xsl:element>
                                        <xsl:text>&#xA;</xsl:text>
                                    </xsl:element>
                                </xsl:for-each>
                                <xsl:text>&#xA;</xsl:text>
                            </xsl:when>
                            <!-- FirstRun = false, we picked up TempGls.dita -->
                            <xsl:otherwise>
                                <xsl:element name="book" inherit-namespaces="no">
                                    <xsl:attribute name="uri" select="base-uri()"/>
                                    <!-- we are reading a glossary but we create an input that
                                         pretends to xref a glossary in order to allow similar
                                         processing as on FirstRun
                                    -->
                                    <xsl:for-each select="//glossentry">
                                        <xsl:element name="xref">
                                            <xsl:attribute name="keyref">
                                                <xsl:value-of select="concat('gls/', glossterm/@id)"/>
                                            </xsl:attribute>
                                            <!--
                                            <xsl:message>
                                                <xsl:text>xref = </xsl:text>
                                                <xsl:value-of select="concat('gls/', glossterm/@id)"/>
                                            </xsl:message>
                                            -->
                                        </xsl:element>
                                    </xsl:for-each>
                                    <!-- parse for new xrefs -->
                                    <xsl:for-each select="//xref[contains(@keyref, 'gls/gls_')]">
                                        <xsl:element name="xref">
                                            <xsl:attribute name="keyref">
                                                <xsl:value-of select="@keyref"/>
                                            </xsl:attribute>
                                            <!--
                                            <xsl:message>
                                                <xsl:text>xref = </xsl:text>
                                                <xsl:value-of select="@keyref"/>
                                            </xsl:message>
                                            -->
                                        </xsl:element>
                                    </xsl:for-each>
                                </xsl:element>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                </xsl:variable>

                <!-- Create the local glossary -->
                <xsl:variable name="outFN">
                    <xsl:choose>
                        <xsl:when test="$FirstRun = 'true'">
                            <xsl:value-of select="concat($folderURI, $DocToken, '/', $glName)"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="concat($folderURI, $glName)"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <xsl:variable name="outFNref" select="concat($folderURI, $DocToken, '/', 'TempGls.dita')"/>
                <xsl:variable name="outputData">
                    <xsl:apply-templates select="$mergedFiles" mode="gls"/>
                </xsl:variable>
                <xsl:result-document href="{$outFN}" format="xml">
                    <xsl:apply-templates select="$mergedFiles" mode="gls"/>
                    <xsl:message>
                        <xsl:text>Generated: "</xsl:text>
                        <xsl:value-of select="$outFN"/>
                        <xsl:text>"</xsl:text>
                    </xsl:message>
                </xsl:result-document>
                <xsl:if test="$FirstRun = 'true'">
                    <xsl:result-document href="{$outFNref}" format="xml">
                        <xsl:apply-templates select="$mergedFiles" mode="gls"/>
                    </xsl:result-document>
                    <xsl:message>
                        <xsl:text>Generated: "</xsl:text>
                        <xsl:value-of select="$outFNref"/>
                        <xsl:text>"</xsl:text>
                    </xsl:message>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="*" mode="gls">
        <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
        <xsl:text>&#x21;DOCTYPE glossgroup PUBLIC "-//OASIS//DTD DITA Glossary Group//EN" "glossgroup.dtd"</xsl:text>
        <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
        <xsl:text>&#xA;</xsl:text>
        <xsl:variable name="newgls">
            <xsl:call-template name="createGlossary"/>
        </xsl:variable>
        <xsl:apply-templates select="$newgls" mode="copy"/>
    </xsl:template>

</xsl:stylesheet>
