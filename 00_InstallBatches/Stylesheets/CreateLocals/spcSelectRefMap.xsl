<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xmp="http://ns.adobe.com/xap/1.0/" xmlns:pdf="http://ns.adobe.com/pdf/1.3/"
    xmlns:xmpMM="http://ns.adobe.com/xap/1.0/mm/" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:x="adobe:ns:meta/" xmlns:exslt="http://exslt.org/common"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:date="java:java.util.Date" xmlns:fox="http://www.w3.org/1999/XSL/Formatx"
    xmlns:my="my:my" xmlns:ditaarch="http://dita.oasis-open.org/"
    exclude-result-prefixes="xsl x fox fn xs xml ditaarch dc pdf xlink xmpMM xmp my rdf date" version="2.0">
    <!--<xsl:output method="xml" use-character-maps="sample"/>-->

    <xsl:param name="MasterPathName" required="no" select="'/F:/scherzer/RefDita/MasterLists/McSpecification.dita'" as="xs:string"/>
    <xsl:param name="FirstRun" required="no" select="''" as="xs:string"/>
    <!-- We shall know where to place the target -->
    <xsl:param name="DitaToken" required="yes" as="xs:string"/>

    <xsl:output method="text" indent="no" use-character-maps="sample" name="text"/>
    <xsl:output method="xml" indent="no" use-character-maps="sample" name="xml"/>

    <xsl:character-map name="sample">
        <!--    <xsl:output-character character="&#x3C;" string="&lt;"/>
        <xsl:output-character character="&#x3E;" string="&gt;"/>-->
        <xsl:output-character character="⊕" string="&amp;#x2295;"/>
        <xsl:output-character character="“" string='"'/>
        <xsl:output-character character="”" string='"'/>
        <!--<xsl:output-character character="&#x26;" string='&amp;'/>-->
    </xsl:character-map>
    <!--========================== SYSTEM VARIABLES ================================= -->

    <!-- MasterPathName: Specify the path to your master file
    <xsl:variable name="MasterPathName" select="'/F:/scherzer/RefDita/MasterLists/McSpecificationEGK.dita'"/>
    -->

    <!-- relaxed: [0|1]

         To find bibliography references, relaxed=0 would strictly search for [...#...] constructs
         which will perfectly match all and only references that follow ezRead notation, (having the chapter after #).

         However, in many documents there is only [...] notation without the hash. Those will not be found if you
         use relaxed=0. Using relaxed=1 you will find all [...] notations but many of them might not actually 'mean'
         a bibliography reference. Technical or math papers will often use [ ] for array indices. You will find
         all of them of course - as you don't have a match in the master file ... they will be indicated
         in the result/local bibliography as "no found".

         RECOMMENDATION:
            - Use relaxed=1 on the first time of after many changes.
            - Determine all unmatched biblio references in the output file and add their entries to the master file
            - Then create the bibliography
    -->
    <xsl:variable name="relaxed" select="1"/>

    <!-- unittest controls messages to be displayed for debugging
         values: prcfiles
    -->
    <xsl:variable name="unittest" select="'chkbib chkEzLinks'"/>

    <!--========================== SYSTEM VARIABLES ================================= -->

    <!-- get entry position either from simple position or from its colname -->
    <!-- acting on 'entry' -->

    <!-- Variables which import the Glossary table -->
    <xsl:variable name="folderURI" select="resolve-uri('.', base-uri())"/>


    <xsl:variable name="ProductNameFN" select="'Local'"/>
    <!--    <xsl:variable name="bibName" select="concat('REF_bib_', $ProductNameFN, '.dita')"/>-->
    <xsl:variable name="bibName" select="'Bibliography.dita'"/>
    <xsl:variable name="ignName" select="concat('Ignore_', $ProductNameFN, '.xml')"/>
    <xsl:variable name="ignoresName" select="'Ignore.xml'"/>
    <!-- opmode can be 'local' or 'conref' -->
    <xsl:variable name="opMode" select="'local'"/>

    <xsl:variable name="McSpecification">
        <xsl:copy-of select="document(concat('//', $MasterPathName))//tbody" copy-namespaces="no"/>
    </xsl:variable>

    <!-- get the ignore tags -->
    <xsl:variable name="ignoreTags">
        <xsl:copy-of select="document(concat($folderURI, $ignoresName))/*" copy-namespaces="no"/>
    </xsl:variable>

    <!--<xsl:template match="/">
        <xsl:variable name="newBiblio">
            <xsl:call-template name="createBibliography"/>
        </xsl:variable>
        <xsl:apply-templates select="$newBiblio" mode="copy"/>
    </xsl:template>-->

    <!-- Deep copy template with cleanup of unwanted attributes


    -->
    <xsl:template match="node() | @*" mode="copy">
        <xsl:copy inherit-namespaces="no">
            <xsl:for-each
                select="
                    @*
                    [not(name() = 'class')]
                    [not(contains(local-name(), 'DITAArchVersion'))]
                    [not(contains(name(), 'domains'))]">
                <xsl:call-template name="putAttrs"/>
            </xsl:for-each>
            <xsl:apply-templates mode="copy"
                select="
                    @*
                    [not(name() = 'class')]
                    [not(contains(name(), 'DITAArchVersion'))]
                    [not(contains(local-name(), 'DITAArchVersion'))]
                    [not(contains(name(), 'domains'))]"/>
            <xsl:apply-templates mode="copy"/>
        </xsl:copy>
    </xsl:template>

    <!-- extract the basename (e.g. APDU) from the actual @keyref = spc/spb_APDU_1 -->
    <xsl:template name="getBiblioRef">
        <xsl:param name="myNode" select="." as="node()*"/>
        <xsl:analyze-string select="$myNode/@keyref" regex="{'.*spc/spb_(.*)_?.*'}">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)"/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>

    <xsl:template name="normalizeName">
        <xsl:param name="myName"/>
        <xsl:value-of select="translate(normalize-space($myName), '_:=@+`/#() &amp;', '..eapps_xy-')"/>
    </xsl:template>


    <!-- CREATE THE OUTPUTFILE CONTENT we are working on $mergedFiles which
         contains all chapters from the ditamap, each of them in a book tag
    -->
    <xsl:template name="createBibliography">
        <xsl:call-template name="chktime">
            <xsl:with-param name="tag" select="'createBibliography'"/>
        </xsl:call-template>

        <!-- put the outer frame to make it a valid concept dita file -->
        <xsl:element name="concept">
            <xsl:attribute name="id" select="'refspec'"/>
            <!-- did not use @anchor -->
            <xsl:element name="title">
                <xsl:value-of select="'Bibliography'"/>
            </xsl:element>
            <xsl:element name="conbody">
                <xsl:element name="table">
                    <xsl:attribute name="rowsep" select="1"/>
                    <xsl:attribute name="colsep" select="0"/>
                    <xsl:attribute name="outputclass" select="'rowcolor=white'"/>
                    <!--<xsl:attribute name="pgwide" select="1"/>-->
                    <xsl:element name="title">
                        <xsl:value-of select="'Local References'"/>
                    </xsl:element>
                    <xsl:element name="tgroup">
                        <xsl:attribute name="cols" select="3"/>
                        <xsl:element name="colspec">
                            <xsl:attribute name="colname" select="'c1'"/>
                            <xsl:attribute name="colnum" select="1"/>
                            <xsl:attribute name="colwidth" select="'32mm'"/>
                        </xsl:element>
                        <xsl:element name="colspec">
                            <xsl:attribute name="colname" select="'c2'"/>
                            <xsl:attribute name="colnum" select="2"/>
                            <xsl:attribute name="colwidth" select="'1.0*'"/>
                        </xsl:element>
                        <xsl:element name="colspec">
                            <xsl:attribute name="colname" select="'c3'"/>
                            <xsl:attribute name="colnum" select="3"/>
                            <xsl:attribute name="colwidth" select="'30mm'"/>
                        </xsl:element>
                        <xsl:element name="thead">
                            <xsl:element name="row">
                                <xsl:element name="entry">
                                    <xsl:value-of select="'BibEnt'"/>
                                </xsl:element>
                                <xsl:element name="entry">
                                    <xsl:value-of select="'Description'"/>
                                </xsl:element>
                                <xsl:element name="entry">
                                    <xsl:value-of select="'Publisher'"/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:element>
                        <xsl:element name="tbody">
                            <xsl:call-template name="selectBibliograpy"/>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
    </xsl:template>

    <!-- Create the rows of the table -->
    <xsl:template name="selectBibliograpy">
        <!-- create unique values but unsorted -->
        <!--
        <xsl:message>
            <xsl:for-each select="/Doc//*[name()='Ref.Glossary']">
                <xsl:value-of select="."/>
            </xsl:for-each>
        </xsl:message>
        -->

        <!-- Parse the current book for its XREF references into the bibliography 
             For $spcref we create a structure of
             <spcref>
                <copy of the xref statement/>
                <TargetTerm>
                    <dummy>
                        <spcref>
                            <xref keyref="<reference>"/>
                            <TargetTerm>[bibvalue]</TargetTerm>
                            <SortTerm>[linktext]</SortTerm>
                        </spcref>
                    </dummy>
                </TargetTerm>
             </spcref>
             <spcref>
             ...
             </spcref>
             
             for each link to a bibliography entry
        -->
        <xsl:variable name="spcref">
            <xsl:for-each-group select="//xref[starts-with(@keyref, 'spc/spb_')]" group-by="@keyref">
                <!--<xsl:message>
                    <xsl:text>SHIT-keyref:</xsl:text>
                    <xsl:value-of select="@keyref"/>
                </xsl:message>-->

                <xsl:variable name="spcselect">
                    <xsl:call-template name="getBiblioRef"/>
                </xsl:variable>

                <xsl:if test="contains($unittest, 'chkbib')">
                    <xsl:message>
                        <xsl:text>Catching:</xsl:text>
                        <xsl:value-of select="$spcselect"/>
                    </xsl:message>
                </xsl:if>

                <xsl:call-template name="getTargetTermFromXref"/>
            </xsl:for-each-group>

        </xsl:variable>
        <xsl:if test="contains($unittest, 'chkspcref')">
            <xsl:message>
                <xsl:text>spcref = </xsl:text>
                <xsl:copy-of select="$spcref"/>
            </xsl:message>
        </xsl:if>

        <xsl:variable name="ezLinks" as="node()*">
            <xsl:call-template name="getTextLinks">
                <xsl:with-param name="mode" select="'createnodes'"/>
                <xsl:with-param name="relaxed-mode" select="0"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:if test="contains($unittest, 'chkEzLinks')">
            <xsl:message>
                <xsl:text>ezLinks:</xsl:text>
                <!--<xsl:copy-of select="$ezLinks"/>-->
                <xsl:for-each select="$ezLinks/*">
                    <xsl:text>&#xA;[</xsl:text>
                    <xsl:value-of select="xref/@keyref"/>
                    <xsl:text>] = </xsl:text>
                    <xsl:value-of select="SortTerm"/>
                    <xsl:text>    </xsl:text>
                    <xsl:value-of select="TargetTerm"/>
                    <xsl:text>    &#xA;</xsl:text>
                </xsl:for-each>
            </xsl:message>
        </xsl:if>

        <!-- ezLinks is available with all matches (and id's) of any ezRead [ ... ] entry

             Now we combine both results
        -->
        <xsl:variable name="spcBoth" as="node()*">
            <xsl:element name="spcref">

                <xsl:variable name="links" as="node()*">
                    <xsl:for-each select="$spcref/*">
                        <xsl:element name="spcref">
                            <!--<xsl:message>
                        <xsl:text>[</xsl:text>
                        <xsl:value-of select="name()"/>
                        <xsl:text>][</xsl:text>
                        <xsl:value-of select="count($spcref/*)"/>
                        <xsl:text>] = </xsl:text>
                        <xsl:copy-of select="*" copy-namespaces="no"/>
                        <xsl:text>&#xA;</xsl:text>
                    </xsl:message>-->
                            <xsl:copy-of select="*" copy-namespaces="no"/>
                        </xsl:element>
                    </xsl:for-each>
                    <xsl:for-each select="$ezLinks/*">
                        <xsl:element name="spcref">
                            <!--<xsl:message>
                                <xsl:text>[</xsl:text>
                                <xsl:value-of select="name()"/>
                                <xsl:text>][</xsl:text>
                                <xsl:value-of select="count($ezLinks/*)"/>
                                <xsl:text>] = </xsl:text>
                                <xsl:copy-of select="*" copy-namespaces="no"/>
                                <xsl:text>&#xA;</xsl:text>
                            </xsl:message>-->
                            <xsl:copy-of select="*" copy-namespaces="no"/>
                        </xsl:element>
                    </xsl:for-each>
                </xsl:variable>
                <!-- HERE WE NEED TO run for-each-group in order to sort out doubles from xref vs. [ ]
                     sort by [   ] = TargetTerm which is better than by xref
                     Links structure =
                       spcref
                           xref/@keyref = spb/spb_DtPrt
                           TargetTerm   = [DtPrt]
                           SortTerm   =   [DitaForPrint]
                       /spcref
                     so we can group by TargetTerm
                     and later sort by SortTerm

                -->
                <!--<xsl:message>
                    <xsl:text>Links Structure:&#xA;</xsl:text>
                    <xsl:copy-of select="$links"/>
                </xsl:message>-->

                <!-- remove duplicates from the called links in $mergedFiles -->
                <xsl:for-each-group select="$links" group-by="TargetTerm">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                </xsl:for-each-group>
            </xsl:element>
        </xsl:variable>

        <!-- <xsl:if test="count($spcBoth) > 0">
            <xsl:message>
                <xsl:text>================== </xsl:text>
                <xsl:value-of select="count($spcBoth)"/>
            </xsl:message>
        </xsl:if>
        <xsl:message>
            <xsl:text>SPCBOTH = &#xA;</xsl:text>
            <xsl:for-each select="$spcBoth">
                <xsl:text>Entry[</xsl:text>
                <xsl:value-of select="name()"/>
                <xsl:text>]</xsl:text>
                <xsl:copy-of select="."/>
                <xsl:text>&#xA;</xsl:text>
            </xsl:for-each>
        </xsl:message>-->

        <!--
            At this point we have removed the duplicates in the calling chapters.
            $spcBoth is an unsorted list of entries that reference a bibliography
            entry, either as an xref to spc_term or as ezLink Ref using the TargetTerm
        -->
        <!-- create sorted list  -->
        <xsl:variable name="spcsort" as="node()*">
            <xsl:for-each select="($spcBoth/spcref)">
                <!--<xsl:sort select="upper-case(.)" order="ascending"/>-->
                <!-- we sort after the TargetTerm which is the following sibling -->
                <xsl:sort select="upper-case(SortTerm)" order="ascending"/>
                <xsl:if test="contains($unittest, 'chktarget')">
                    <xsl:message>
                        <xsl:text>TARGETNAME[</xsl:text>
                        <xsl:value-of select="xref/@keyref"/>
                        <xsl:text>]=</xsl:text>
                        <xsl:value-of select="TargetTerm"/>
                        <xsl:text>  SortedBy [</xsl:text>
                        <xsl:value-of select="SortTerm"/>
                        <xsl:text>]  Prefix [</xsl:text>
                        <xsl:value-of select="Prefix"/>
                        <xsl:text>]</xsl:text>
                    </xsl:message>
                    <!--<xsl:message>
                    <xsl:text>SHOW[</xsl:text>
                    <xsl:value-of select="$myPos"/>
                    <xsl:text>]:</xsl:text>
                    <xsl:copy-of select="($spc/Audience)[$myPos]"/>
                    <xsl:text>&#x0A;</xsl:text>
                </xsl:message>-->
                </xsl:if>
                <xsl:element name="spcsort">
                    <xsl:copy-of select="child::*" copy-namespaces="no"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:variable>

        <xsl:if test="contains($unittest, 'chkspec')">
            <xsl:message>
                <xsl:text>xref=</xsl:text>
                <xsl:for-each select="($spcref/xref)">
                    <xsl:sort select="."/>
                    <xsl:text>&#xA;</xsl:text>
                    <xsl:value-of select="."/>
                </xsl:for-each>
            </xsl:message>
        </xsl:if>

        <!-- create entries  -->
        <xsl:for-each select="$spcsort">
            <xsl:variable name="myPos" select="position()"/>

            <xsl:variable name="spcselect">
                <xsl:call-template name="getBiblioRef">
                    <xsl:with-param name="myNode" select="xref"/>
                </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="basename">
                <xsl:call-template name="normalizeName">
                    <xsl:with-param name="myName" select="$spcselect"/>
                </xsl:call-template>
            </xsl:variable>


            <!--<xsl:message>
                <xsl:value-of select="string(.)"/>
                <xsl:text>:</xsl:text>
                <xsl:value-of select="$basename"/>
            </xsl:message>-->

            <xsl:choose>
                <xsl:when test="string-length($basename) > 0">
                    <xsl:variable name="spbID" select="concat('spb_', $basename)"/>

                    <xsl:choose>
                        <!-- check if our id is unique in McGlossary -->
                        <xsl:when test="count($McSpecification//entry[contains(@id, concat('spb_', $basename, '_'))]) > 0">
                            <!-- we did find the entry, but it was ambigious
                         1. report that as comment - it is not possible to find the correct target since the Ref.Glossary
                            does not
                         -->
                            <xsl:element name="row">
                                <xsl:if test="string-length(Audience) > 0">
                                    <xsl:attribute name="audience" select="string(Audience)"/>
                                </xsl:if>
                                <xsl:attribute name="outputclass" select="'compact'"/>
                                <!-- Col 1 = bibentry -->
                                <xsl:element name="entry">
                                    <xsl:attribute name="id" select="concat($spbID, '_1')"/>
                                    <xsl:call-template name="copyBibentry">
                                        <xsl:with-param name="basename" select="$basename"/>
                                        <xsl:with-param name="prefix" select="Prefix"/>
                                    </xsl:call-template>
                                </xsl:element>

                                <!-- Col 2 = text -->
                                <xsl:element name="entry">
                                    <xsl:attribute name="id" select="concat('spd_', $basename, '_1')"/>
                                    <xsl:attribute name="conref">
                                        <xsl:apply-templates
                                            select="$McSpecification//entry[contains(@id, concat('spb_', $basename, '_1'))]/../entry[2]"/>
                                    </xsl:attribute>
                                    <xsl:call-template name="processTodo">
                                        <xsl:with-param name="cmtText" select="'Fix Glossary Master File!'"/>
                                        <xsl:with-param name="cmtContent"
                                            select="concat('Ambigous bibliography reference to ''', concat('spb_', $basename), '''')"/>
                                    </xsl:call-template>
                                </xsl:element>

                                <!-- Col 3 = publisher -->
                                <xsl:element name="entry">
                                    <xsl:attribute name="id" select="concat('spp_', $basename, '_1')"/>
                                    <xsl:apply-templates
                                        select="$McSpecification//entry[contains(@id, concat('spb_', $basename, '_1'))]/../entry[3]"/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:when>

                        <!-- unique entry to find -->
                        <xsl:when test="count($McSpecification//entry[@id = concat('spb_', $basename)]) > 0">
                            <!-- we could find a unique glossary entry -->
                            <xsl:choose>
                                <!-- LOCAL OPTION MODE: with local option, simply copy the entire row of the master list -->
                                <xsl:when test="$opMode = 'local'">
                                    <xsl:element name="row">
                                        <xsl:if test="string-length(Audience) > 0">
                                            <xsl:attribute name="audience" select="string(Audience)"/>
                                        </xsl:if>
                                        <xsl:attribute name="outputclass" select="'compact'"/>

                                        <!-- Col 1 = bibentry -->
                                        <xsl:element name="entry">
                                            <xsl:attribute name="id" select="$spbID"/>
                                            <xsl:call-template name="copyBibentry">
                                                <xsl:with-param name="basename" select="$basename"/>
                                                <xsl:with-param name="prefix" select="Prefix"/>
                                            </xsl:call-template>
                                        </xsl:element>

                                        <!-- Col 2 = text -->
                                        <xsl:apply-templates
                                            select="$McSpecification//entry[contains(@id, concat('spb_', $basename))]/../entry[2]"/>

                                        <!-- Col 3 = publisher -->
                                        <xsl:apply-templates
                                            select="$McSpecification//entry[contains(@id, concat('spb_', $basename))]/../entry[3]"/>
                                    </xsl:element>
                                    <!-- no more used because I need the prefix ... 
                                        <xsl:apply-templates mode="copy"
                                        select="$McSpecification//row[entry[1]/@id = concat('spb_', $basename)]"/>
                                    -->
                                </xsl:when>

                                <!-- CONREF mode -->
                                <xsl:when test="$opMode = 'conref'">
                                    <xsl:element name="row">
                                        <xsl:if test="string-length(Audience) > 0">
                                            <xsl:attribute name="audience" select="string(Audience)"/>
                                        </xsl:if>
                                        <xsl:attribute name="outputclass" select="'compact'"/>

                                        <!-- Col 1 = bibentry -->
                                        <xsl:element name="entry">
                                            <xsl:attribute name="id" select="concat('spb_', $basename)"/>
                                            <xsl:attribute name="conref">
                                                <xsl:value-of select="concat($MasterPathName, '#ml_specs/spb_', $basename)"/>
                                            </xsl:attribute>
                                        </xsl:element>

                                        <!-- Col 2 = text -->
                                        <xsl:element name="entry">
                                            <xsl:attribute name="id" select="concat('spd_', $basename)"/>
                                            <xsl:attribute name="conref">
                                                <xsl:value-of select="concat($MasterPathName, '#ml_specs/spd_', $basename)"/>
                                            </xsl:attribute>
                                        </xsl:element>

                                        <!-- Col 3 = publisher -->
                                        <xsl:element name="entry">
                                            <xsl:attribute name="id" select="concat('spp_', $basename)"/>
                                            <xsl:attribute name="conref">
                                                <xsl:value-of select="concat($MasterPathName, '#ml_specs/spp_', $basename)"/>
                                            </xsl:attribute>
                                        </xsl:element>
                                    </xsl:element>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:message>INVALID opMode, choose 'text' or 'conref'</xsl:message>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>

                        <!-- we could not find our entry in the master list -->
                        <xsl:otherwise>
                            <xsl:element name="row">
                                <xsl:element name="entry">
                                    <xsl:attribute name="id" select="$spbID"/>
                                    <xsl:value-of select="concat('[', substring-after($spbID, 'spb_'), ']')"/>
                                </xsl:element>
                                <xsl:element name="entry">
                                    <xsl:call-template name="processTodo">
                                        <xsl:with-param name="cmtText" select="'Add term to Specification Master File!'"/>
                                        <xsl:with-param name="cmtContent"
                                            select="concat('Could not find master biblio entry ''', string(.), '''')"/>
                                    </xsl:call-template>
                                </xsl:element>
                                <xsl:element name="entry"> </xsl:element>
                            </xsl:element>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <!-- we received #none# or #ambigous" -->
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="xref/@keyref = '#none#'">
                            <xsl:element name="row">
                                <xsl:element name="entry">
                                    <xsl:attribute name="id" select="concat('spb_', translate(TargetTerm, '[] ', ''))"/>
                                    <xsl:value-of select="TargetTerm"/>
                                </xsl:element>
                                <xsl:element name="entry">
                                    <xsl:attribute name="id" select="concat('spd_', translate(TargetTerm, '[] ', ''))"/>
                                    <xsl:call-template name="processTodo">
                                        <xsl:with-param name="cmtText" select="'Add term to Specification Master File!'"/>
                                        <xsl:with-param name="cmtContent"
                                            select="concat('Could not find master biblio entry ''', string(.), '''')"/>
                                    </xsl:call-template>
                                </xsl:element>
                                <xsl:element name="entry">
                                    <xsl:attribute name="id" select="concat('spp_', translate(TargetTerm, '[] ', ''))"/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:when>
                        <xsl:when test="xref/@keyref = '#ambigous#'">
                            <xsl:element name="row">
                                <xsl:element name="entry">
                                    <xsl:attribute name="id" select="concat('spb_', translate(TargetTerm, '[] ', ''))"/>
                                    <xsl:value-of select="TargetTerm"/>
                                </xsl:element>
                                <xsl:element name="entry">
                                    <xsl:attribute name="id" select="concat('spd_', translate(TargetTerm, '[] ', ''))"/>
                                    <xsl:call-template name="processTodo">
                                        <xsl:with-param name="cmtText" select="'Resolve ambigous term in Specification Master File!'"/>
                                        <xsl:with-param name="cmtContent"
                                            select="concat('Could not resolve master biblio entry ''', string(.), '''')"/>
                                    </xsl:call-template>
                                </xsl:element>
                                <xsl:element name="entry">
                                    <xsl:attribute name="id" select="concat('spp_', translate(TargetTerm, '[] ', ''))"/>
                                </xsl:element>
                            </xsl:element>
                        </xsl:when>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="copyBibentry">
        <xsl:param name="basename"/>
        <xsl:param name="prefix" select="''"/>
        <xsl:variable name="rawText">
            <xsl:value-of select="$McSpecification//entry[contains(@id, concat('spb_', $basename))]/../entry[1]"/>
        </xsl:variable>
        <xsl:choose>
            <!-- if the prefix wants to avoid the link, we propagate this to the bibliography
                 and exchange a potential other prefix of the library
            -->
            <xsl:when test="$prefix = '~'">
                <xsl:analyze-string select="$rawText" regex="{'(.*)(\[.*\])'}">
                    <xsl:matching-substring>
                        <xsl:value-of select="concat($prefix, regex-group(2))"/>
                    </xsl:matching-substring>
                    <xsl:non-matching-substring>
                        <xsl:value-of select="."/>
                    </xsl:non-matching-substring>
                </xsl:analyze-string>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$rawText"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="getTextLinks">
        <xsl:param name="mode" select="'createnodes'"/>
        <xsl:param name="relaxed-mode" select="0"/>
        <xsl:param name="source" select="//text()"/>
        <xsl:element name="dummy">
            <xsl:for-each select="$source">
                <!-- STRICT MATCH requires the hash-# in the reference -->
                <!-- first isolate any [ezRead] group -->
                <xsl:variable name="prefix">
                    <xsl:analyze-string select="." regex="{'([~|!])\[.*\]'}">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(1)"/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>

                </xsl:variable>
                <xsl:analyze-string select="." regex="{'(.*?)(\[.*?\])'}">
                    <xsl:matching-substring>
                        <!-- evaluate the eliminated [ezRead] construction -->
                        <xsl:analyze-string select="regex-group(2)" regex="{'.*?(\[)(.*?):{2}(.*?)#(.*?\])'}">
                            <xsl:matching-substring>
                                <xsl:call-template name="createBaseEntry">
                                    <xsl:with-param name="bibentry" select="concat('[', regex-group(3), ']')"/>
                                    <xsl:with-param name="linktext" select="concat('[', regex-group(2), ']')"/>
                                    <xsl:with-param name="prefix" select="$prefix"/>
                                    <xsl:with-param name="warning" select="$relaxed-mode"/>
                                    <xsl:with-param name="mode" select="$mode"/>
                                </xsl:call-template>
                            </xsl:matching-substring>
                            <xsl:non-matching-substring>
                                <xsl:analyze-string select="." regex="{'.*?(\[.*?)#(.*?\])'}">
                                    <xsl:matching-substring>
                                        <xsl:call-template name="createBaseEntry">
                                            <xsl:with-param name="bibentry" select="concat(regex-group(1), ']')"/>
                                            <xsl:with-param name="linktext" select="concat(regex-group(1), ']')"/>
                                            <xsl:with-param name="prefix" select="$prefix"/>
                                            <xsl:with-param name="warning" select="$relaxed-mode"/>
                                            <xsl:with-param name="mode" select="$mode"/>
                                        </xsl:call-template>
                                    </xsl:matching-substring>
                                    <xsl:non-matching-substring>
                                        <xsl:analyze-string select="." regex="{'.*?\[(.*?):{2}(.*?)\]'}">
                                            <xsl:matching-substring>
                                                <xsl:call-template name="createBaseEntry">
                                                    <xsl:with-param name="bibentry" select="concat('[', regex-group(2), ']')"/>
                                                    <xsl:with-param name="linktext" select="concat('[', regex-group(1), ']')"/>
                                                    <xsl:with-param name="prefix" select="$prefix"/>
                                                    <xsl:with-param name="warning" select="$relaxed-mode"/>
                                                    <xsl:with-param name="mode" select="$mode"/>
                                                </xsl:call-template>
                                            </xsl:matching-substring>
                                            <xsl:non-matching-substring>
                                                <xsl:analyze-string select="." regex="{'.*?(\[.*?\])'}">
                                                    <xsl:matching-substring>
                                                        <xsl:call-template name="createBaseEntry">
                                                            <xsl:with-param name="bibentry" select="regex-group(1)"/>
                                                            <xsl:with-param name="linktext" select="regex-group(1)"/>
                                                            <xsl:with-param name="prefix" select="$prefix"/>
                                                            <xsl:with-param name="warning" select="$relaxed-mode"/>
                                                            <xsl:with-param name="mode" select="$mode"/>
                                                        </xsl:call-template>
                                                    </xsl:matching-substring>
                                                </xsl:analyze-string>
                                            </xsl:non-matching-substring>
                                        </xsl:analyze-string>
                                    </xsl:non-matching-substring>
                                </xsl:analyze-string>
                            </xsl:non-matching-substring>
                        </xsl:analyze-string>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:for-each>
        </xsl:element>
    </xsl:template>

    <xsl:template name="createBaseEntry">
        <xsl:param name="bibentry"/>
        <xsl:param name="linktext"/>
        <xsl:param name="prefix"/>
        <xsl:param name="warning"/>
        <xsl:param name="mode" select="'createnodes'"/>
        <xsl:choose>
            <xsl:when test="$mode = 'createnodes'">
                <xsl:element name="spcref">
                    <xsl:call-template name="getTargetTermFromContent">
                        <xsl:with-param name="bibentry" select="$bibentry"/>
                        <xsl:with-param name="linktext" select="$linktext"/>
                        <xsl:with-param name="prefix" select="$prefix"/>
                        <xsl:with-param name="warning" select="$warning"/>
                    </xsl:call-template>
                </xsl:element>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($prefix, $linktext, '#', $bibentry)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- These templates strip the text content and ignore the paragraph content
         which is meant to isolate the first entry of the biblio table
    -->
    <xsl:template match="text()" mode="stripEntry">
        <xsl:param name="mode" select="'createnodes'"/>
        <xsl:call-template name="getTextLinks">
            <xsl:with-param name="mode" select="$mode"/>
            <xsl:with-param name="source" select="."/>
        </xsl:call-template>
    </xsl:template>

    <!-- Ignore all text in paragraphs, so only the text in the entry will be known -->
    <xsl:template match="p" mode="stripEntry"/>

    <!-- getTargetTermFromXref works on a xref topic (for-each 'xref') and
        returns the master list's biblio tag to be sorted in the next step

        This is important because our xref might have an empty text (to glossary)
        which feeds itself from the target. Hence we cannot sort the biblio entries
        by content unless we get the content from the target too.
   -->
    <xsl:template name="getTargetTermFromXref">
        <!--<xsl:message>getTargetTermFromXref</xsl:message>-->
        <xsl:variable name="spcselect">
            <xsl:call-template name="getBiblioRef"/>
        </xsl:variable>

        <xsl:variable name="basename">
            <xsl:call-template name="normalizeName">
                <xsl:with-param name="myName" select="$spcselect"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="string-length($basename) > 0">
                <xsl:choose>
                    <!-- AMBIGOUS entry in McGlossary identified by spb_term_1 a second underscore show ambiguity -->
                    <xsl:when test="count(($McSpecification//tbody/row/entry[1])[contains(@id, concat('spb_', $basename, '_'))]) > 0">
                        <xsl:value-of select="concat('000-ambigous:', $basename)"/>
                        <xsl:message>
                            <xsl:text>Ambigous link target: </xsl:text>
                            <xsl:value-of select="($McSpecification//tbody/row/entry[1])[@id = concat('spb_', $basename)]"/>
                        </xsl:message>
                    </xsl:when>

                    <!-- we could find a UNIQUE glossary entry -->
                    <xsl:when test="count(($McSpecification//tbody/row/entry[1])[@id = concat('spb_', $basename)]) > 0">
                        <!-- Isolate the entry -->
                        <xsl:variable name="mainEntry">
                            <xsl:copy-of select="($McSpecification//tbody/row/entry[1])[@id = concat('spb_', $basename)]"/>
                        </xsl:variable>
                        <!-- Get entry's [bibent] content and ignore following paragraphs -->
                        <xsl:apply-templates select="$mainEntry" mode="stripEntry"/>

                        <!--<xsl:message>
                            <xsl:text>FOUND-UNIQUE:</xsl:text>
                            <xsl:apply-templates select="$mainEntry" mode="stripEntry"/>
                        </xsl:message>-->
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>
                            <xsl:text>No link target found: </xsl:text>
                            <xsl:value-of select="$basename"/>
                        </xsl:message>
                    </xsl:otherwise>

                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'000-empty'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- getTargetTermFromContent works on a [bibentry] and
         returns the master list's biblio tag to be sorted in the next step

         The function returns the @id of the entry[1] of the master list
   -->
    <xsl:template name="getTargetTermFromContent" as="node()*">
        <xsl:param name="bibentry" select="''"/>
        <xsl:param name="linktext" select="''"/>
        <xsl:param name="prefix" select="''"/>
        <xsl:param name="warning" select="1"/>
        <!-- Collect entries in $nodeMatches -->
        <xsl:variable name="nodeMatches" as="node()*">
            <xsl:element name="nodeMatch">
                <xsl:for-each select="$McSpecification//tbody/row/entry[1]">

                    <!-- stripText = [bibentry] from first col, ignore following paragraphs -->
                    <xsl:variable name="stripText">
                        <xsl:apply-templates select="." mode="stripEntry">
                            <xsl:with-param name="mode" select="'textonly'"/>
                        </xsl:apply-templates>
                    </xsl:variable>

                    <xsl:if test="contains($stripText, $bibentry)">
                        <xsl:element name="ezLink" inherit-namespaces="no">
                            <xsl:value-of select="@id"/>
                        </xsl:element>
                        <xsl:element name="linkText" inherit-namespaces="no">
                            <xsl:value-of select="substring-before($stripText, '#')"/>
                        </xsl:element>
                        <xsl:element name="prefix" inherit-namespaces="no">
                            <xsl:value-of select="$prefix"/>
                        </xsl:element>
                        <xsl:element name="ezText" inherit-namespaces="no">
                            <xsl:value-of select="substring-after($stripText, '#')"/>
                        </xsl:element>
                    </xsl:if>
                </xsl:for-each>
            </xsl:element>
        </xsl:variable>

        <!-- Determine what to return -->
        <xsl:choose>
            <!-- ambigous link -->
            <xsl:when test="count($nodeMatches/ezLink) > 1">
                <xsl:message>
                    <xsl:text>Ambigous [..] target: </xsl:text>
                    <xsl:value-of select="$bibentry"/>
                </xsl:message>
                <xsl:element name="xref" inherit-namespaces="no">
                    <xsl:attribute name="keyref">
                        <xsl:value-of select="'#ambigous#'"/>
                    </xsl:attribute>
                </xsl:element>
                <xsl:element name="TargetTerm" inherit-namespaces="no">
                    <xsl:value-of select="$bibentry"/>
                </xsl:element>
                <xsl:element name="SortTerm" inherit-namespaces="no">
                    <xsl:value-of select="$nodeMatches/linkText"/>
                </xsl:element>
                <xsl:element name="Prefix" inherit-namespaces="no">
                    <xsl:value-of select="$nodeMatches/prefix"/>
                </xsl:element>
                <!--<xsl:message>
                    <xsl:text>Ambigious master entry = </xsl:text>
                    <xsl:value-of select="$bibentry"/>
                </xsl:message>-->
            </xsl:when>

            <!-- unique link -->
            <xsl:when test="count($nodeMatches/ezLink) > 0">
                <xsl:element name="xref" inherit-namespaces="no">
                    <xsl:attribute name="keyref">
                        <xsl:value-of select="concat('spc/', $nodeMatches/ezLink)"/>
                    </xsl:attribute>
                </xsl:element>
                <xsl:element name="TargetTerm" inherit-namespaces="no">
                    <xsl:value-of select="$nodeMatches/ezText"/>
                </xsl:element>
                <xsl:element name="SortTerm" inherit-namespaces="no">
                    <xsl:value-of select="$nodeMatches/linkText"/>
                </xsl:element>
                <xsl:element name="Prefix" inherit-namespaces="no">
                    <xsl:value-of select="$nodeMatches/prefix"/>
                </xsl:element>
                <!--<xsl:message>
                    <xsl:text>FOUND master entry :</xsl:text>
                    <xsl:value-of select="$nodeMatches/ezLink"/>
                    <xsl:text> ======== </xsl:text>
                    <xsl:value-of select="$nodeMatches/ezText"/>
                </xsl:message>-->
            </xsl:when>

            <!-- no link found -->
            <xsl:otherwise>
                <!-- the relaxed checking [ ... ] instead of [ ...#... ] will yield a lot of hits
                     that we might want to avoid. Therefore we can ignore non-existing by a parameter
                     that 'knows' whether we are in relaxed mode
                -->
                <xsl:variable name="cntIgn">
                    <xsl:value-of select="count($ignoreTags/ignores/ignore[. = $bibentry])"/>
                </xsl:variable>

                <!-- <xsl:message>
                    <xsl:text>exp: </xsl:text>
                    <xsl:value-of select="$bibentry"/>
                    <xsl:text> : </xsl:text>
                    <xsl:value-of select="$warning"/>
                    <xsl:text> :: </xsl:text>
                </xsl:message-->

                <xsl:if test="$cntIgn = 0">
                    <xsl:choose>
                        <xsl:when test="$warning = 0">
                            <xsl:message>
                                <xsl:text>No [..#..] target found: </xsl:text>
                                <xsl:value-of select="$bibentry"/>
                                <!--<xsl:text> W-Level = </xsl:text>
                                <xsl:value-of select="$warning"/>-->
                            </xsl:message>
                        </xsl:when>
                        <xsl:when test="$warning = 3">
                            <xsl:message>
                                <xsl:text>No [..] target found: </xsl:text>
                                <xsl:value-of select="$bibentry"/>
                                <!--<xsl:text> W-Level = </xsl:text>
                                <xsl:value-of select="$warning"/>-->
                            </xsl:message>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:element name="xref" inherit-namespaces="no">
                        <xsl:attribute name="keyref">
                            <xsl:value-of select="'#none#'"/>
                        </xsl:attribute>
                    </xsl:element>
                    <xsl:element name="TargetTerm" inherit-namespaces="no">
                        <xsl:value-of select="$bibentry"/>
                    </xsl:element>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- ========================== TEMPLATES FROM TcProcess =========== -->
    <xsl:template name="processTodo">
        <xsl:param name="cmtText"/>
        <xsl:param name="cmtContent"/>
        <xsl:param name="prtText" select="false()"/>
        <xsl:processing-instruction name="oxy_comment_start">
            <xsl:text>author="TC-Toolbox" </xsl:text>
            <xsl:text>timestamp="20150325T155606+0100" </xsl:text>
            <xsl:text>comment="</xsl:text>
            <xsl:choose>
                <xsl:when test="string-length($cmtContent) > 0">
                    <xsl:value-of select="$cmtContent"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="string(.)"/>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text> →</xsl:text>
            <xsl:value-of select="$cmtText"/>
            <xsl:text>"</xsl:text>
        </xsl:processing-instruction>
        <xsl:choose>
            <xsl:when test="$prtText and string-length(normalize-space(.)) > 0">
                <xsl:value-of select="string(.)"/>
            </xsl:when>
            <!-- &#xA0 is a special reserved character to indicate to the commons.xsl
                 not to print text
            -->
            <xsl:otherwise>
                <xsl:text>@</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:processing-instruction name="oxy_comment_end"/>
    </xsl:template>

    <!-- transparent throughput of any XML input -->
    <xsl:template name="putXML">
        <xsl:element name="{name()}">
            <xsl:for-each
                select="
                    @*
                    [not(contains(name(), 'class'))]
                    [not(contains(name(), 'ditaarch'))]
                    [not(contains(name(), 'domains'))]">
                <xsl:copy inherit-namespaces="no"/>
            </xsl:for-each>
            <xsl:apply-templates select="* | text() | comment() | processing-instruction()" mode="#default"/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="putAttrs">
        <xsl:for-each select="@*">
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

    <xsl:template name="putTopic">
        <xsl:element name="{name()}">
            <xsl:call-template name="putAttrs"/>
        </xsl:element>
    </xsl:template>

    <!-- This template overrides the built-in template text [XSLT#2.4.5.3] -->
    <xsl:template match="text()">
        <xsl:value-of select="."/>
    </xsl:template>

    <xsl:template match="*">
        <xsl:call-template name="putXML"/>
    </xsl:template>

    <xsl:template match="processing-instruction()">
        <xsl:copy/>
    </xsl:template>

    <xsl:template name="chktime">
        <xsl:param name="DateInstance" select="date:new()"/>
        <xsl:param name="tag" select="'Timestamp:'"/>
        <xsl:message>
            <!-- Java plain value <xsl:value-of select="date:getTime($DateInstance)"/>-->
            <!--<xsl:value-of select="date:getTime($DateInstance)"/>-->
            <xsl:variable name="curTime">
                <xsl:value-of select='xs:dateTime("1970-01-01T01:00:00") + date:getTime($DateInstance) * xs:dayTimeDuration("PT0.001S")'/>
            </xsl:variable>
            <xsl:value-of select="concat($tag, substring(string($curTime), 12, 8))"/>

        </xsl:message>
    </xsl:template>

</xsl:stylesheet>
