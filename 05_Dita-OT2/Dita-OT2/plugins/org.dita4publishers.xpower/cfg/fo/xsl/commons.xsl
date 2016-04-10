<?xml version='1.0'?>

<!--
ToDOs
- allow ezRead linktext notation
- [ezRead with space::ezRead#3.1] does not work due to the spaced text
- Figure/img @outputclass=flow in dl/../dd spills over right margin (perhaps also paragraph in dd?)
- provide formatting for uicontrol

Fixed Bugs
- covering APPENDICES in bookmarks, might find solution around "This block creates the NOTICES Head1 title"
- link into glossary works with keyref, but not with xref(file based reference)
  - there is again a mismatch between the create destination and the reference >> topicmerge.xsl ?
  - cross reference in index to glossary funktioniert nicht (empty xref)
  - cross reference to conrefed-xx doesn't work (see testcpt.dita biblio)
  ++ I checked topicmergeImpl until stage1.xml. The error is already in stage1.xml
     so it is the JAVA code (dost.jar?) that contains the mistake.
  + done in dost.jar/MergeUtils.java:addId (line 69)
  - called by MergeTopicParser:URI handleLocalDita, there the problem is likely to happen
    in line 146 !

- figures are included relative to the output path. If there is a broken link in the source
  the ant script does not copy the figures and files to the output dir and hence figures
  are not linked. To be fixed in the ant script, the copy should be done always

- concept under concept not correctly numbered


[DOTX032E] = ditamsg:cannot-retrieve-linktext
in F:\Dita-OT2\xsl\preprocess\topicpullImpl.xsl
happens if linking a topic without a title but not giving input. Understandable
but my implementation replaces the empty content (in a glossterm) by the target's content
in topicpullImpl.xls
 >>> I can suppress the message in the dost.jar, source code contained in Dita-OT2 source

FIXED BUGS
- source seeks unique_22_Connect_42_D-MU-0011979.1
- target is unique_22
try with setup ... we might not use a subtopic when
linking chapters - solved with extension in topicmerge.xsl
- cannot reference to concept although oxygen allows it (fixed:topicmerge.xsl)
- Head1 titles did not propagate into topic.fo (and could not be referenced) see insertChapterFirstpageStaticContent

FEATURES
- outputclass=compact for list entries (ul, ol, sl), with compact:all also the first
              entry will be compact
- outputclass='checklist' for ul
- outputclass=compact for definition list entries (dlentry)
- outputclass=compact for table rows (differentiates whether rowsep = 0 or 1)
- outputclass=compact for table paragraphs
- repeating table title for tables on pagebreaks (set TitlePosition=table_titleRepeat)
- outputclass=flow | (page or fig:outputclass expanse) for IMAGE with placement=break
- outputclass=compact for <p> to avoid spacing on p (good for first paragraphs)
- outputclass=contains('Block.') on section/title creates separator
- outputclass=newpage:title for title forces a page break
- concept/titlealts/navtitle is supported for the headings/footings to avoid overflow on too long titles
- outputclass=keep:text    in commonattributes and hence available in all text generating topics
- auto-keep lines implemented
- watermark added

- outputclass=tocfirst on concept/task/reference for mini-TOC to come first (the default is nicer mini-TOC coming after the introduction)
              tocfirst is used on topic/concept/task/reference elements which are located
              as chapters  (head1) in the ditamap

- outputclass=checklist for ul list entries
- outputclass=folder for ul list entries
- outputclass=noLabel for notes
- outputclass=noImage for notes
- outputclass=see | onpage | page | pagenumonly | see | noheading | label     for xref
- outputclass=mrg     for 'p' to become marginalia
- outputclass=mrg:<verb> with verb=right,dialog,heading can even be extended
- outputclass='valign=top' for image, useful for images+text in marginalia 'mrg', text will align with the picture

- table row:outputclass rowcolor=<color> defines background color ('#1280FF' or 'yellow')
- table row:outputclass rowcolor         assigns stylesheet default background color variable 'Table-backgroundRow'
- table row:outputclass cellcolor = #1280FF  gives an entry a background color
- simpletable rowcolor and cellcolor support
  otherwise                    assigns stylesheet default background color=antiquewhite
- table:outputclass:rowcolor=#1280FF | yellow | red ... specifies rowcolor for the entire table body.


- if exists bookrights/summary  creates 2nd frontm page with disclaimer information  contains(@name, 'disclaimer')]
- auto "keep-with-previous" for topics after a title controlled by maxKeepLines
- auto figure-in-column figure-on-page if the figure is too large for the column "mmGetFigIndent"
  - same for tables
- ezRead auto linking
- indent subtitle text
    - <xsl:variable name="indentSubtitleText" select="true()"/>
- $bkxChGlossary controls printing subchapters in Bookmarks
- side-col-width support
- watermark (filename.svg in commons/artwork ...) controlled by filename.svg in ditamap modified-field
- front page picture supported by ditamap:prodname.data[name=image value=<filename> name=top-left-width value=100mm 50mm 30mm]
- empty title support (empty title will not show up blank in bookmarks/toc

- unittest contains 'creategls' will output tags to logfile, that lists all used references.
  This is very helpful to create 'matched' glossary and bibliographies (i.e. only those
  entries go to the glossary/bibliography that are USED in the document.
  ... I didn't find a way yet to visit all DITA files to scan for such references.
  creation of main titles for Preface/Glossary/Notices $mainTitles='mainPreface mainGlossary xainGlossTitle mainNotices

- HSX design layout - special for G&D [dsgn_smart | dsgn_gnd]
  support of bookmap/bookmeta/shortdesc/data[@name="style"] 'dsgn_smart' to set style in ditamap
  'dsgn_smart' will currently print the library header above the document title
  <xsl:variable name="docdesign" select="'dsgn_smart'"/>

- concept with empty title can be processed to avoid title there will be no entries in TOC/BKX
- Insert meta information [AHF#21.6] to control books with .book from ditamap
  ... was realized using bookmap/bookmeta/shortdesc/keyword in root-processing.xsl.
  'mainbook' shall indicate the .../books target


Copyright ? 2004-2006 by Idiom Technologies, Inc. All rights reserved.
IDIOM is a registered trademark of Idiom Technologies, Inc. and WORLDSERVER
and WORLDSTART are trademarks of Idiom Technologies, Inc. All other
trademarks are the property of their respective owners.

IDIOM TECHNOLOGIES, INC. IS DELIVERING THE SOFTWARE "AS IS," WITH
ABSOLUTELY NO WARRANTIES WHATSOEVER, WHETHER EXPRESS OR IMPLIED,  AND IDIOM
TECHNOLOGIES, INC. DISCLAIMS ALL WARRANTIES, EXPRESS OR IMPLIED, INCLUDING
BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE AND WARRANTY OF NON-INFRINGEMENT. IDIOM TECHNOLOGIES, INC. SHALL NOT
BE LIABLE FOR INDIRECT, INCIDENTAL, SPECIAL, COVER, PUNITIVE, EXEMPLARY,
RELIANCE, OR CONSEQUENTIAL DAMAGES (INCLUDING BUT NOT LIMITED TO LOSS OF
ANTICIPATED PROFIT), ARISING FROM ANY CAUSE UNDER OR RELATED TO  OR ARISING
OUT OF THE USE OF OR INABILITY TO USE THE SOFTWARE, EVEN IF IDIOM
TECHNOLOGIES, INC. HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES.

Idiom Technologies, Inc. and its licensors shall not be liable for any
damages suffered by any person as a result of using and/or modifying the
Software or its derivatives. In no event shall Idiom Technologies, Inc.'s
liability for any damages hereunder exceed the amounts received by Idiom
Technologies, Inc. as a result of this transaction.

These terms and conditions supersede the terms and conditions in any
licensing agreement to the extent that such terms and conditions conflict
with those set forth herein.

This file is part of the DITA Open Toolkit project hosted on Sourceforge.net.
See the accompanying license.txt file for applicable licenses.
-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fo="http://www.w3.org/1999/XSL/Format" xmlns:opentopic="http://www.idiominc.com/opentopic"
    xmlns:ddwrt="http://schemas.microsoft.com/WebParts/v2/DataView/runtime" xmlns:axf="http://www.antennahouse.com/names/XSL/Extensions"
    xmlns:opentopic-index="http://www.idiominc.com/opentopic/index" xmlns:opentopic-func="http://www.idiominc.com/opentopic/exsl/function"
    xmlns:dita2xslfo="http://dita-ot.sourceforge.net/ns/200910/dita2xslfo" xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
    xmlns:my="my:my" xmlns:ext="http://exslt.org/common"
    xmlns:dita-ot="http://dita-ot.sourceforge.net/ns/201007/dita-ot"
    exclude-result-prefixes="ot-placeholder opentopic opentopic-index opentopic-func dita2xslfo xs my ext axf" version="2.0">

    <!-- IMPORTANT Parameter comes from org.dita2pdf
    The call to

    <xslt style="${temp.transformation.file}" in="${dita.temp.dir}/stage1a.xml" out="${dita.temp.dir}/stage2.fo">

    <param name="project.doc" expression="${ProjDocRel}"/>
    in order to allow the propagation of the ProjDocRel variable. This is the
    relative path from the topic.fo directory into the stub directory

    To find the entry point ... set required="yes" and the system breaks until you provide the variable
    -->

    <!--HSX ============== IMPORTANT: COPY THIS project.doc ALSO TO org.dita.pdf2 =================== -->
    <xsl:param name="project.doc" required="no" as="xs:string" select="'SetProjXDocEnvironmentVariable'"/>
    <xsl:param name="equation.img.scale" required="no" select="100" />
    <!--HSX copy as shown here ....
    <target name="transform.topic2fo.main">
    <makeurl property="artworkPrefixUrl" file="${artworkPrefix}"/>
    ....
    <makeurl property="variable.file.url" file="${variable.file}" validate="no"/>

    <xslt style="${temp.transformation.file}" in="${dita.temp.dir}/stage1a.xml" out="${dita.temp.dir}/stage2.fo">
      <param name="project.doc" expression="${ProjDocRel}"/>
    -->

    <xsl:key name="id" match="*[@id]" use="@id"/>
    <xsl:key name="map-id" match="opentopic:map//*[@id][empty(ancestor::*[contains(@class, ' map/reltable ')])]" use="@id"/>
    <xsl:key name="topic-id" match="*[@id][contains(@class, ' topic/topic ')] | ot-placeholder:*[@id]" use="@id"/>
    <xsl:key name="class" match="*[@class]" use="tokenize(@class, ' ')"/>
    <xsl:key name="fnById" match="*[contains(@class, ' topic/fn ')]" use="@id"/>

    <!--
    A key with all elements that need to be numbered.

    To get the number of an element using this key, you can use the << node
    comparison operator in XPath 2 to get all elements in the key that appear
    before the current element in the tree. For example, to get the number of
    topic/fig elements before the current element, you would do something like:

    <xsl:value-of select="count(key('enumerableByClass', 'topic/fig')[. &lt;&lt; current()])"/>

    This is much faster than using the preceding:: axis and somewhat faster than
    using the <xsl:number> element.
    -->
    <xsl:key name="enumerableByClass"
        match="*[contains(@class, ' topic/fig ')][*[contains(@class, ' topic/title ')]] |
        *[contains(@class, ' topic/table ')][*[contains(@class, ' topic/title ')]] |
        *[contains(@class,' topic/fn ') and empty(@callout)]"
    use="tokenize(@class, ' ')"/>

    <xsl:key name="enumerableById"
        match="*[contains(@class, ' topic/fig ')][*[contains(@class, ' topic/title ')]] |
        *[contains(@class, ' topic/table ')][*[contains(@class, ' topic/title ')]] |
        *[contains(@class,' topic/fn ') and empty(@callout)]"
    use="@id"/>

    <xsl:variable name="msgprefix" select="'PDFX'"/>

    <xsl:variable name="id.toc" select="'ID_TOC_00-0F-EA-40-0D-4D'"/>
    <xsl:variable name="id.index" select="'ID_INDEX_00-0F-EA-40-0D-4D'"/>
    <xsl:variable name="id.lot" select="'ID_LOT_00-0F-EA-40-0D-4D'"/>
    <xsl:variable name="id.lof" select="'ID_LOF_00-0F-EA-40-0D-4D'"/>
    <xsl:variable name="id.glossary" select="'ID_GLOSSARY_00-0F-EA-40-0D-4D'"/>
    <xsl:variable name="root" select="/" as="document-node()"/>


    <!--  In order to not process any data under opentopic:map  -->
    <xsl:template match="opentopic:map"/>

    <!-- get the max chars for shortdesc-->
    <xsl:variable name="maxCharsInShortDesc" as="xs:integer">
        <xsl:call-template name="getMaxCharsForShortdescKeep"/>
    </xsl:variable>

    <!--HSC
       The successful resolution of conref will output elements that do not contain
       @conref anymore. Therefore - if @conref is still found as attribute, the
       following statement will indicated an unresolved conref in the printout
    -->
    <xsl:template match="*[@conref]" priority="99">
        <fo:block xsl:use-attribute-sets="__unresolved__conref">
            <xsl:apply-templates select="." mode="insertReferenceTitle">
                <xsl:with-param name="href" select="@conref"/>
                <xsl:with-param name="titlePrefix" select="'Content-Reference'"/>
            </xsl:apply-templates>
        </fo:block>
    </xsl:template>

    <xsl:template name="startPageNumbering" as="attribute()*">
        <!--BS: uncomment if you need reset page numbering at first chapter-->
        <!--HSC comment finished here according to [DtPrt#8.11.4] first chapter recognized by topic/topic -->
        <!-- commented out the next two lines because they don't do anything anyway
        <xsl:variable name="id" select="ancestor-or-self::*[contains(@class, ' topic/topic ')][1]/@id"/>
        <xsl:variable name="mapTopic" select="key('map-id', $id)"/>

        -->
        <!--HSC comment out the if statement acc. to [DtPrt#8.11.4] this restarts only under certain conditions

        <xsl:if test="not(($mapTopic/preceding::*[contains(@class, ' bookmap/chapter ') or
        contains(@class, ' bookmap/part ')]) or
        ($mapTopic/ancestor::*[contains(@class, ' bookmap/chapter ') or
        contains(@class, ' bookmap/part ')]))">
        end cmt out -->
        <!--HSC I commented this out 20141105 to have continous page numbers
        <xsl:attribute name="initial-page-number">1</xsl:attribute> -->
        <!--HSC </xsl:if> -->
        <!--HSC default comment end -->
    </xsl:template>

    <xsl:template match="*" mode="processTopic">
        <xsl:param name="mode" select="1"/>
        <xsl:if test="contains($unittest, 'chkproc')">
            <xsl:message>
                <xsl:text>ProcTopic   ID: </xsl:text>
                <xsl:value-of select="@id"/>
                <xsl:text>&#xA;      Title ID: </xsl:text>
                <xsl:value-of select="title"/>
            </xsl:message>
        </xsl:if>
        <xsl:if test="not(contains(@outputclass, 'noprint'))">
            <fo:block xsl:use-attribute-sets="topic">
                <xsl:call-template name="chkOrientation">
                    <xsl:with-param name="mode" select="$mode"/>
                </xsl:call-template>
                <xsl:call-template name="chkNewpage"/>
                <!--
                <xsl:attribute name="fox" select="'topic'"/>
                -->
                <xsl:apply-templates select="." mode="commonTopicProcessing">
                    <xsl:with-param name="mode" select="$mode"/>
                </xsl:apply-templates>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!--HSX called on first topic level (concept, reference, task, topic ...)
            We check whether a newpage is requested for the topic and
            apply a 'break-before' when this is found true

            With the $mapToipcrefs we only find topicref, which is OK because
            chapters will get a newpage anyway.
    -->
    <xsl:template name="chkNewpage">
        <xsl:variable name="mapTopicrefs" select="key('map-id', @id)"/>

        <xsl:choose>
            <!-- check whether our parent topicref specifies 'newpage' -->
            <xsl:when test="contains($mapTopicrefs/@outputclass, 'newpage')">
                <xsl:attribute name="break-before" select="'page'"/>
            </xsl:when>

            <!-- check whether this topic enforces 'newpage' -->
            <xsl:when test="contains(@outputclass, 'newpage')">
                <xsl:attribute name="break-before" select="'page'"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="chkOrientation">
        <xsl:param name="mode" select="0"/>
        <xsl:choose>
            <xsl:when test="$mode = 0"/>
            <xsl:when test="contains(@outputclass, 'landscape')">
                <xsl:attribute name="idx" select="'landscape'"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:attribute name="idx" select="'portrait'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--HSC This template is called on topic-concept-task-reference ... level -->
    <xsl:template match="*" mode="commonTopicProcessing">
        <xsl:param name="mode" select="0"/>
        <xsl:if test="contains($unittest, 'chkHead2')">
            <xsl:message>
                <xsl:text>commonTopicProcessing:[</xsl:text>
                <xsl:value-of select="$mode"/>
                <xsl:text>]</xsl:text>
            </xsl:message>
        </xsl:if>
        <xsl:if test="not(contains(@outputclass, 'noprint'))">
            <xsl:call-template name="chkNewpage"/>

            <xsl:variable name="markerNodes" as="node()?">
                <xsl:element name="myTopic">
                    <xsl:copy-of select="(ancestor-or-self::*[contains(@class, ' topic/topic ')])" copy-namespaces="no"/>
                </xsl:element>
            </xsl:variable>

            <xsl:variable name="level" as="xs:integer">
                <!--
                <xsl:apply-templates select="." mode="get-topic-level"/>
                -->
                <xsl:value-of select="count($markerNodes/*)"/>
            </xsl:variable>

            <xsl:variable name="mrkidx" select="min(($level, $topicHeader.numLevel))"/>

            <!--
            <xsl:message>
                <xsl:text>&#xA;Test Marker Nodes[</xsl:text>
                <xsl:value-of select="count($markerNodes/*)"/>
                <xsl:text>]</xsl:text>
                <xsl:for-each select="$markerNodes/*">
                    <xsl:text>&#xA;Node[</xsl:text>
                    <xsl:value-of select="name()"/>
                    <xsl:text>]  Title = </xsl:text>
                    <xsl:value-of select="title"/>
                </xsl:for-each>
            </xsl:message>
            -->

            <xsl:variable name="markerNode" as="node()">
                <xsl:copy-of select="$markerNodes/*[$mrkidx]"/>
            </xsl:variable>

            <!--HSX Pick the deepest title level that can be found in the present topic (e.g. concept) -->
            <xsl:variable name="navtitle">
                <xsl:value-of select="titlealts/navtitle"/>
            </xsl:variable>

            <xsl:if test="contains($unittest, 'chkHeader')">
                <xsl:message>
                    <xsl:variable name="selTitle">
                        <!--
                        <xsl:value-of select="'['"/>
                        <xsl:value-of select="$level"/>
                        <xsl:value-of select="']['"/>
                        <xsl:value-of select="$mrkidx"/>
                        <xsl:value-of select="'] '"/>
                        -->
                        <xsl:text>seltitle::</xsl:text>
                        <xsl:apply-templates select="ancestor-or-self::*[@id = $markerNode/@id]/title" mode="getNumTitle">
                            <xsl:with-param name="navTitle" select="$navtitle"/>
                        </xsl:apply-templates>
                    </xsl:variable>

                    <xsl:text>selected node = </xsl:text>
                    <xsl:for-each select="$markerNodes/*">
                        <xsl:value-of select="title"/>
                        <xsl:text>:</xsl:text>
                    </xsl:for-each>
                    <xsl:text>&#xA;Title[</xsl:text>
                    <xsl:value-of select="$mrkidx"/>
                    <xsl:text>] = </xsl:text>
                    <xsl:value-of select="$markerNode/title"/>
                    <xsl:text>&#xA;FullTitle = </xsl:text>
                    <!--
                    <xsl:value-of select="ancestor-or-self::*[@id = $markerNode/@id]/title"/>
                    <xsl:apply-templates select="ancestor-or-self::*[@id = $markerNode/@id]/title" mode="getNumTitle"/>
                    -->
                    <xsl:value-of select="$selTitle"/>
                    <xsl:text>&#xA;navtitle = </xsl:text>
                    <xsl:value-of select="$navtitle"/>
                    <!--
                    -->
                </xsl:message>
            </xsl:if>

            <!--HSC Visit all title children of topic (e.g. concept) typically there's only one -->
            <xsl:variable name="head2marker" as="node()">
                <fo:marker marker-class-name="current-header">
                    <xsl:apply-templates select="ancestor-or-self::*[@id = $markerNode/@id]/title" mode="getNumTitle">
                        <xsl:with-param name="navTitle" select="$navtitle"/>
                    </xsl:apply-templates>
                </fo:marker>
            </xsl:variable>

            <!--HSX topicHeader.numLevel is a user setting in basic-settings.xsl
                    which allows to determine the maximum header-depth being
                    shown in the page header

                    If we have a value higher than 1, the we consider our
                    preparation of the header text in $head2marker
            -->
            <xsl:if test="($topicHeader.numLevel &gt; 1)">
                <xsl:copy-of select="$head2marker"/>
            </xsl:if>

            <!--HSX print the full title but do this as inline container
                    to avoid anyway unwanted spacing. The block is required
                    because glossterm is a specialization of title and it
                    might be called. The glossterm-template applies attributes
                    which require a parent fo:block, which we provide here.

                    This is only processed in a map, a bookmap will much earlier
                    end in glossary.xsl and find the createGlossary template.
            -->
            <xsl:choose>
                <xsl:when test="$mapType = 'bookmap'">
                    <xsl:apply-templates select="*[contains(@class, ' topic/title ')]"/>
                </xsl:when>
                <xsl:otherwise>
                    <fo:inline-container>
                        <fo:block>
                            <xsl:apply-templates select="*[contains(@class, ' topic/title ')]"/>
                        </fo:block>
                    </fo:inline-container>
                </xsl:otherwise>
            </xsl:choose>
            <!--HSC display topic ID acc. to [DtPrt#10.6.5]
            <xsl:text> (Topic ID: </xsl:text>
            <xsl:value-of select="@oid"/>
            <xsl:text>)</xsl:text> -->

            <xsl:apply-templates select="*[contains(@class, ' topic/prolog ')]"/>
            <xsl:apply-templates select="*[not(contains(@class, ' topic/title ')) and
                                           not(contains(@class, ' topic/prolog ')) and
                                           not(contains(@class, ' topic/topic '))]"/>
            <!--xsl:apply-templates select="." mode="buildRelationships"/-->

            <!--HSX check call to nested concept/task/topic/glossentry -->
            <xsl:choose>
                <xsl:when test="contains($unittest, 'chkSubtopic')">
                    <xsl:variable name="subtc">
                        <xsl:apply-templates select="*[contains(@class,' topic/topic ')]"/>
                    </xsl:variable>
                    <xsl:message>
                        <xsl:text>SubTopicContent[</xsl:text>
                        <xsl:value-of select="$subtc"/>
                        <xsl:text>]</xsl:text>
                    </xsl:message>
                    <xsl:copy-of select="$subtc" copy-namespaces="no"/>
                </xsl:when>
                <!--HSX a simple ditamap uses topicSimple to print the chapters
                        in contrast to a bookmap which processes the parts
                        differently. So for the bookmak we won't revisit the
                        subchapters.
                -->
                <xsl:otherwise>
                    <xsl:if test="not($mapType = 'bookmap')">
                        <xsl:apply-templates select="*[contains(@class,' topic/topic ')]"/>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates select="." mode="topicEpilog"/>
        </xsl:if>

    </xsl:template>

    <!-- Hook that allows common end-of-topic processing (after nested topics). -->
    <xsl:template match="*" mode="topicEpilog"> </xsl:template>

    <!--HSC Process any topicref or chapter -->
    <xsl:template match="*[contains(@class, ' topic/topic ')]">
        <xsl:param name="mode" select="0"/>
        <xsl:variable name="topicType" as="xs:string">
            <xsl:call-template name="determineTopicType"/>
        </xsl:variable>

        <!--HSC Check Head1 topics -->
        <xsl:choose>
            <xsl:when test="$topicType = 'topicChapter'">
                <xsl:call-template name="processTopicChapter"/>
            </xsl:when>
            <xsl:when test="$topicType = 'topicAppendix'">
                <xsl:call-template name="processTopicAppendix"/>
            </xsl:when>
            <xsl:when test="$topicType = 'topicAppendices'">
                <xsl:call-template name="processTopicAppendices"/>
            </xsl:when>
            <xsl:when test="$topicType = 'topicPart'">
                <xsl:call-template name="processTopicPart"/>
            </xsl:when>
            <xsl:when test="$topicType = 'topicPreface'">
                <xsl:call-template name="processTopicPreface"/>
            </xsl:when>
            <xsl:when test="$topicType = 'topicNotices'">
                <xsl:if test="$retain-bookmap-order">
                    <xsl:call-template name="processTopicNotices"/>
                </xsl:if>
            </xsl:when>
            <!--HSX I had to avoid the glossary to fall into the otherwise -->
            <xsl:when test="$topicType = 'topicGlossaryList'"/>

            <!--HSC use outputclass for landscape acc. to [DtPrt#7.12.8] also in line:222-->

            <xsl:when test="($topicType = 'topicSimple') or
                            ($topicType = 'topicBackmatter') or
                            ($topicType = 'topicAppendixFirst')">
                <xsl:variable name="page-sequence-reference">
                    <xsl:choose>
                        <xsl:when test="contains(@outputclass, 'landscape')">
                            <xsl:choose>
                                <xsl:when test="$mapType = 'bookmap'">
                                    <xsl:value-of select="'landscape-sequence'"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'landscape-sequence'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:choose>
                                <xsl:when test="$mapType = 'bookmap'">
                                    <xsl:value-of select="'body-sequence'"/>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:value-of select="'ditamap-body-sequence'"/>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <!--HSC
                <xsl:variable name="page-sequence-reference">
                <xsl:choose>
                <xsl:when test="$mapType = 'bookmap'">
                <xsl:value-of select="'body-sequence'"/>
                </xsl:when>
                <xsl:otherwise>
                <xsl:value-of select="'ditamap-body-sequence'"/>
                </xsl:otherwise>
                </xsl:choose>
                </xsl:variable>
                -->

                <xsl:choose>
                    <!--HSC process Head1 -->
                    <xsl:when
                        test="not(ancestor::*[contains(@class,' topic/topic ')]) and
                        not(contains(@class, ' glossgroup/glossgroup ') and ($mapType = 'bookmap'))">
                        <xsl:if test="contains($unittest, 'chkHead2')">
                            <xsl:message>
                                <xsl:text>PrcHead1[</xsl:text>
                                <xsl:value-of select="name()"/>
                                <xsl:text>] = </xsl:text>
                                <xsl:value-of select="title"/>
                            </xsl:message>
                        </xsl:if>

                        <xsl:variable name="allNodes" as="node()*">
                            <xsl:choose>
                                <xsl:when test="contains(@class,' concept/concept ')">
                                    <xsl:apply-templates select="." mode="processConcept">
                                        <xsl:with-param name="mode" select="$mode"/>
                                    </xsl:apply-templates>
                                </xsl:when>
                                <xsl:when test="contains(@class,' task/task ')">
                                    <xsl:apply-templates select="." mode="processTask">
                                        <xsl:with-param name="mode" select="$mode"/>
                                    </xsl:apply-templates>
                                </xsl:when>
                                <xsl:when test="contains(@class,' reference/reference ')">
                                    <xsl:apply-templates select="." mode="processReference">
                                        <xsl:with-param name="mode" select="$mode"/>
                                    </xsl:apply-templates>
                                </xsl:when>
                                <xsl:otherwise>
                                    <xsl:apply-templates select="." mode="processTopic">
                                        <xsl:with-param name="mode" select="$mode"/>
                                    </xsl:apply-templates>
                                </xsl:otherwise>
                            </xsl:choose>
                        </xsl:variable>

                        <fo:page-sequence master-reference="{$page-sequence-reference}"
                            xsl:use-attribute-sets="__force__page__count">
                            <xsl:call-template name="startPageNumbering"/>
                            <xsl:call-template name="insertBodyStaticContents"/>
                            <fo:flow flow-name="xsl-region-body">
                                <xsl:copy-of select="$allNodes"/>
                            </fo:flow>
                        </fo:page-sequence>
                    </xsl:when>
                    <!--HSC process Head n > 1 -->
                    <xsl:otherwise>
                        <xsl:if test="contains($unittest, 'chkHead2')">
                            <xsl:message>
                                <xsl:text>PrcHeadN[</xsl:text>
                                <xsl:value-of select="$mode"/>
                                <xsl:text>][</xsl:text>
                                <xsl:value-of select="name()"/>
                                <xsl:text>] = </xsl:text>
                                <xsl:value-of select="title"/>
                            </xsl:message>
                        </xsl:if>
                        <xsl:choose>
                            <!--HSX
                            glossgroup test comes first since it contains
                            topic/topic concept/concept glossgroup/glossgroup
                            which would interfere to find the right class

                            TODO: I have no idea why the prior call to "determineTopicType"
                            does not recognize the glossarylist although I can detect it here.
                            The template match doesn't make it

                            I added glossgroup.block in order to reserve some space after the
                            glossgroup
                            -->
                            <xsl:when test="contains(@class,' glossgroup/glossgroup ')">
                                <fo:block xsl:use-attribute-sets="glossgroup.block">
                                    <xsl:apply-templates/>
                                </fo:block>
                            </xsl:when>
                            <xsl:when test="contains(@class,' concept/concept ')">
                                <xsl:apply-templates select="." mode="processConcept">
                                    <xsl:with-param name="mode" select="$mode"/>
                                </xsl:apply-templates>
                            </xsl:when>
                            <xsl:when test="contains(@class,' task/task ')">
                                <xsl:apply-templates select="." mode="processTask">
                                    <xsl:with-param name="mode" select="$mode"/>
                                </xsl:apply-templates>
                            </xsl:when>
                            <xsl:when test="contains(@class,' reference/reference ')">
                                <xsl:apply-templates select="." mode="processReference">
                                    <xsl:with-param name="mode" select="$mode"/>
                                </xsl:apply-templates>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:apply-templates select="." mode="processTopic">
                                    <xsl:with-param name="mode" select="$mode"/>
                                </xsl:apply-templates>
                            </xsl:otherwise>
                        </xsl:choose>
                        <!--HSX We need too see any children in order to supply the
                            output with subchapters, this change came with the
                            installation of sub-chapter landscape format
                            The glossary does this already and will not be subject
                            to this call
                         -->
                         <xsl:if test="not(contains(@class,' glossgroup/glossgroup '))">
                             <xsl:apply-templates select="*[contains(@class,' topic/topic ')]">
                                 <xsl:with-param name="mode" select="$mode"/>
                             </xsl:apply-templates>
                         </xsl:if>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when> <!-- topicSimple topicAppendix topicAppendices -->
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="processUnknowTopic">
                    <xsl:with-param name="topicType" select="$topicType"/>
                </xsl:apply-templates>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--  Bookmap Chapter processing, will only apply to Head1s -->
    <xsl:template name="processTopicChapter">

        <!--HSX provide the current-header marker as variable because we need
                to repeat it in every first fo:block after the fo:flow for the
                landscape/portrait format

                This is done to provide the Head1 chapter for the heading.
                It is used in static-content.xsl:getHeaderOuterEven

                If you wish the actual sub-chapter's title in the heading, you need
                to create a similar variable like head1marker in each of the topic's
                process, this is done with the variable head2marker (see above)
        -->

        <!--HSX search for the navtitle to replace it in the marker -->
        <xsl:variable name="navtitle">
            <xsl:value-of select="titlealts/navtitle"/>
        </xsl:variable>

        <xsl:variable name="head1marker" as="node()">
            <fo:marker marker-class-name="current-header">
                <!--HSC Visit all title children of topic (e.g. concept) typically there's only one -->
                <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
                    <!--HSC                         <xsl:apply-templates select="." mode="getTitle"/> -->
                    <xsl:apply-templates select="." mode="getNumTitle">
                        <xsl:with-param name="sidecol" select="false()"/>
                        <xsl:with-param name="marker" select="false()"/>
                        <xsl:with-param name="navTitle" select="$navtitle"/>
                    </xsl:apply-templates>
                </xsl:for-each>
            </fo:marker>
        </xsl:variable>

        <!--HSX This is the full processTopicChapter from Head1 to Hand2+ -->
        <xsl:variable name="subNodes" as="node()*">
            <xsl:element name="sbnode">
                <fo:block xsl:use-attribute-sets="topic">
                    <!--HSX checkout head-1 orientation -->
                    <xsl:call-template name="chkOrientation">
                        <xsl:with-param name="mode" select="1"/>
                    </xsl:call-template>
                    <xsl:call-template name="commonattributes"/>

                    <!--HSC insert marker for level 1 topics -->
                    <fo:marker marker-class-name="current-topic-number">
                        <xsl:number format="1"/>
                    </fo:marker>

                    <xsl:copy-of select="$head1marker" copy-namespaces="no"/>

                    <!--HSC process topic/prolog -->
                    <xsl:apply-templates select="*[contains(@class,' topic/prolog ')]"/>

                    <xsl:call-template name="insertChapterFirstpageStaticContent">
                        <xsl:with-param name="type" select="'chapter'"/>
                    </xsl:call-template>

                    <!-- ==================== print mini-TOC for chapters ==================== -->
                    <xsl:choose>
                        <xsl:when test="$chapterLayout='BASIC'">
                            <xsl:apply-templates
                                select="*[not(contains(@class, ' topic/topic ') or
                                contains(@class, ' topic/title ') or
                            contains(@class, ' topic/prolog '))]"/>
                            <!--xsl:apply-templates select="." mode="buildRelationships"/-->
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="." mode="createMiniToc"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </fo:block>

                <!--HSC Print all subchapters (!) as seen from the bookmap
                    These will never match processTopicChapter, instead will hit
                    processConcept etc.
                -->
                <xsl:apply-templates select="*[contains(@class,' topic/topic ')]">
                    <xsl:with-param name="mode" select="1"/>
                </xsl:apply-templates>
                <xsl:call-template name="pullPrologIndexTerms.end-range"/>
            </xsl:element>
        </xsl:variable>

        <!--HSC
            Page-landscape support for ANY SUBCHAPTER shall not mandate a page-sequence
            on head-1 level. Instead this will be done for any group of similar layout
            chapters in the
               <xsl:for-each-group select="$subNodes/*" group-adjacent="@idx" exclude-result-prefixes="#all" >
            statement below. The grouping is necessary because we want to avoid
            a new page on every subchapter whereas the change of the layout (@outputclass = landscape)
            of course implies a new page.

        The following statements were removed from the original commons.xsl
        <fo:page-sequence master-reference="{$page-sequence-reference}" xsl:use-attribute-sets="page-sequence.body">
            <fo:page-sequence master-reference="body-sequence" xsl:use-attribute-sets="__force__page__count">
            <xsl:call-template name="startPageNumbering"/>
            <xsl:call-template name="insertBodyStaticContents"/>
        -->
        <xsl:variable name="portrait-sequence">
            <xsl:choose>
                <xsl:when test="$mapType = 'bookmap'">
                    <xsl:value-of select="'body-sequence'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'ditamap-body-sequence'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!--HSX create a dummy fo:test just to pick up the attributes from page-sequence.body
            They must be picked from THIS position. Doing the same within the for-each-group
            statement would reduce the scope of the test (done in force-page-count) and
            result in an error because
                <xsl:when test="/*[contains(@class, ' bookmap/bookmap ')]">
            will not be found under that restricted scope.

            The picked attributes will then be copied from this dummy fo:test
        -->
        <xsl:variable name="pageseq-attrs" as="node()">
            <fo:test xsl:use-attribute-sets="page-sequence.body"/>
        </xsl:variable>

        <xsl:if test="$subNodes/*[not(@idx)]">
            <xsl:message>
                <xsl:text>ALARM:EMPTY-IDX [</xsl:text>
                <xsl:value-of select="name()"/>
                <xsl:text>]</xsl:text>
                <xsl:for-each select="$subNodes/*">
                    <xsl:text>&#xA;idx = </xsl:text>
                    <xsl:value-of select="@idx"/>
                    <xsl:text>  id = </xsl:text>
                    <xsl:value-of select="@id"/>
                </xsl:for-each>
                <xsl:text>]&#xA;Parents = </xsl:text>
                <xsl:call-template name="DebugShowParents"/>
            </xsl:message>
        </xsl:if>


        <xsl:for-each-group select="$subNodes/*" group-adjacent="@idx" exclude-result-prefixes="#all" >
            <xsl:variable name="myPos" select="position()"/>
            <xsl:choose>
                <!--HSX
                   We have given any first level fo:block an idx (to avoid collision with id)
                   which points on either 'portrait' or 'landscape'. According to these
                   mandatory attributes we have grouped and create a page-sequence
                   for every group.
                -->
                <xsl:when test="current-group()[1]/@idx = 'portrait'">
                    <fo:page-sequence master-reference="{$portrait-sequence}">
                        <xsl:for-each select="$pageseq-attrs/@*">
                            <xsl:attribute name="{name()}">
                                <xsl:value-of select="."/>
                            </xsl:attribute>
                        </xsl:for-each>
                        <!--HSX
                            Only on the first chapter (which is always Head1)
                            shall start page numbering (if re-number is selected)
                        -->
                        <xsl:if test="$myPos = 1">
                            <xsl:call-template name="startPageNumbering"/>
                        </xsl:if>
                        <xsl:call-template name="insertBodyStaticContents"/>
                        <fo:flow flow-name="xsl-region-body">
                            <xsl:for-each select="current-group()">
                                <xsl:call-template name="putFO">
                                    <xsl:with-param name="head1marker" select="$head1marker"/>
                                </xsl:call-template>
                            </xsl:for-each>
                        </fo:flow>
                    </fo:page-sequence>
                </xsl:when>
                <xsl:when test="current-group()[1]/@idx = 'landscape'">
                    <fo:page-sequence master-reference="landscape-sequence">
                        <xsl:for-each select="$pageseq-attrs/@*">
                            <xsl:attribute name="{name()}">
                            <xsl:value-of select="."/>
                            </xsl:attribute>
                        </xsl:for-each>
                        <xsl:if test="$myPos = 1">
                            <xsl:call-template name="startPageNumbering"/>
                        </xsl:if>
                        <xsl:call-template name="insertBodyStaticContents"/>
                        <fo:flow flow-name="xsl-region-body">
                            <xsl:for-each select="current-group()">
                                <xsl:call-template name="putFO">
                                    <xsl:with-param name="head1marker" select="$head1marker"/>
                                </xsl:call-template>
                            </xsl:for-each>
                        </fo:flow>
                    </fo:page-sequence>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each-group>
    </xsl:template>

    <xsl:template name="putFO">
        <xsl:param name="head1marker"/>
        <xsl:element name="{name()}">
            <xsl:for-each
                select="@*[not(contains(name(), 'idx'))]">
                <xsl:copy inherit-namespaces="no"/>
            </xsl:for-each>
            <xsl:if test="$topicHeader.numLevel = 1">
                <xsl:copy-of select="$head1marker" copy-namespaces="no"/>
            </xsl:if>
            <xsl:copy-of select="text()"/>
            <xsl:copy-of select="*" copy-namespaces="no"/>
        </xsl:element>
    </xsl:template>

    <!--  Bookmap Appendix processing  -->
    <xsl:template name="processTopicAppendix">
        <!--HSC use outputclass for landscape acc. to [DtPrt#7.12.8] also in line:149-->
        <xsl:variable name="page-sequence-reference">
            <xsl:choose>
                <xsl:when test="contains(@outputclass, 'landscape')">
                    <xsl:choose>
                        <xsl:when test="$mapType = 'bookmap'">
                            <xsl:value-of select="'landscape-sequence'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'landscape-sequence'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$mapType = 'bookmap'">
                            <xsl:value-of select="'body-sequence'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'ditamap-body-sequence'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <fo:page-sequence master-reference="body-sequence" xsl:use-attribute-sets="page-sequence.body">
            <!--HSC ended
            <fo:page-sequence master-reference="body-sequence" xsl:use-attribute-sets="__force__page__count">
            -->
            <xsl:call-template name="startPageNumbering"/>
            <xsl:call-template name="insertBodyStaticContents"/>
            <fo:flow flow-name="xsl-region-body">
                <fo:block xsl:use-attribute-sets="topic">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:variable name="level" as="xs:integer">
                        <xsl:apply-templates select="." mode="get-topic-level"/>
                    </xsl:variable>
                    <xsl:if test="$level eq 1">
                        <fo:marker marker-class-name="current-topic-number">
                            <xsl:variable name="topicref" select="key('map-id', ancestor-or-self::*[contains(@class, ' topic/topic ')][1]/@id)"/>
                            <xsl:for-each select="$topicref">
                                <xsl:number count="*[contains(@class,' bookmap/appendix ')]" format="1"/>
                            </xsl:for-each>
                        </fo:marker>
                        <fo:marker marker-class-name="current-header">
                            <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
                                <!--HSC    <xsl:apply-templates select="." mode="getTitle"/> -->
                                <xsl:apply-templates select="." mode="getNumTitle">
                                    <xsl:with-param name="sidecol" select="false()"/>
                                </xsl:apply-templates>
                            </xsl:for-each>
                        </fo:marker>
                    </xsl:if>

                    <xsl:apply-templates select="*[contains(@class,' topic/prolog ')]"/>

                    <xsl:call-template name="insertChapterFirstpageStaticContent">
                        <xsl:with-param name="type" select="'appendix'"/>
                    </xsl:call-template>

                    <!-- ==================== print mini-TOC for Appendix ==================== -->
                    <xsl:choose>
                        <xsl:when test="$appendixLayout='BASIC'">
                            <xsl:apply-templates
                                select="*[not(contains(@class, ' topic/topic ') or contains(@class, ' topic/title ') or
                            contains(@class, ' topic/prolog '))]"/>
                            <!--xsl:apply-templates select="." mode="buildRelationships"/-->
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="." mode="createMiniToc"/>
                        </xsl:otherwise>
                    </xsl:choose>

                    <xsl:apply-templates select="*[contains(@class,' topic/topic ')]">
                        <xsl:with-param name="mode" select="0"/>
                    </xsl:apply-templates>
                    <xsl:call-template name="pullPrologIndexTerms.end-range"/>
                </fo:block>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>

    <!--  Bookmap appendices processing  -->
    <xsl:template name="processTopicAppendices">
        <!--HSC use outputclass for landscape acc. to [DtPrt#7.12.8] also in line:149-->
        <xsl:variable name="page-sequence-reference">
            <xsl:choose>
                <xsl:when test="contains(@outputclass, 'landscape')">
                    <xsl:choose>
                        <xsl:when test="$mapType = 'bookmap'">
                            <xsl:value-of select="'landscape-sequence'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'landscape-sequence'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$mapType = 'bookmap'">
                            <xsl:value-of select="'body-sequence'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'ditamap-body-sequence'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <fo:page-sequence master-reference="{$page-sequence-reference}" xsl:use-attribute-sets="__force__page__count">
            <!--HSC ended
            <fo:page-sequence master-reference="body-sequence" xsl:use-attribute-sets="__force__page__count">
            -->
            <xsl:call-template name="startPageNumbering"/>
            <xsl:call-template name="insertBodyStaticContents"/>
            <fo:flow flow-name="xsl-region-body">
                <fo:block xsl:use-attribute-sets="topic">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:if test="empty(ancestor::*[contains(@class, ' topic/topic ')])">
                        <fo:marker marker-class-name="current-topic-number">
                            <xsl:variable name="topicref" select="key('map-id', ancestor-or-self::*[contains(@class, ' topic/topic ')][1]/@id)"/>
                            <xsl:for-each select="$topicref">
                                <xsl:apply-templates select="." mode="topicTitleNumber"/>
                            </xsl:for-each>
                        </fo:marker>
                        <fo:marker marker-class-name="current-header">
                            <xsl:for-each select="*[contains(@class,' topic/title ')]">
                                <!--HSC         <xsl:apply-templates select="." mode="getTitle"/> -->
                                <xsl:apply-templates select="." mode="getNumTitle">
                                    <xsl:with-param name="sidecol" select="false()"/>
                                </xsl:apply-templates>
                            </xsl:for-each>
                        </fo:marker>
                    </xsl:if>

                    <xsl:apply-templates select="*[contains(@class,' topic/prolog ')]"/>

                    <xsl:call-template name="insertChapterFirstpageStaticContent">
                        <xsl:with-param name="type" select="'appendices'"/>
                    </xsl:call-template>

                    <fo:block xsl:use-attribute-sets="topic.title">
                        <xsl:call-template name="pullPrologIndexTerms"/>
                        <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
                            <!--      <xsl:when test="contains($class,' bookmap/bookabstract ')"/> -->
                            <!--          <xsl:apply-templates select="." mode="getTitle"/> -->
                            <xsl:apply-templates select="." mode="getNumTitle">
                                <xsl:with-param name="sidecol" select="false()"/>
                            </xsl:apply-templates>
                        </xsl:for-each>
                    </fo:block>

                    <!-- ==================== print mini-TOC for Appendices ==================== -->
                    <xsl:choose>
                        <xsl:when test="$appendicesLayout='BASIC'">
                            <xsl:apply-templates
                                select="*[not(contains(@class, ' topic/topic ') or contains(@class, ' topic/title ') or
                            contains(@class, ' topic/prolog '))]"/>
                            <!--xsl:apply-templates select="." mode="buildRelationships"/-->
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="." mode="createMiniToc"/>
                        </xsl:otherwise>
                    </xsl:choose>

                    <xsl:for-each select="*[contains(@class,' topic/topic ')]">
                        <xsl:variable name="topicType" as="xs:string">
                            <xsl:call-template name="determineTopicType"/>
                        </xsl:variable>
                        <xsl:if test="($topicType = 'topicSimple') or ($topicType = 'topicBackmatter')">
                            <xsl:apply-templates select="."/>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:call-template name="pullPrologIndexTerms.end-range"/>
                </fo:block>
            </fo:flow>
        </fo:page-sequence>
        <xsl:for-each select="*[contains(@class,' topic/topic ')]">
            <xsl:variable name="topicType" as="xs:string">
                <xsl:call-template name="determineTopicType"/>
            </xsl:variable>
            <xsl:if test="not(($topicType = 'topicSimple') or ($topicType = 'topicBackmatter'))">
                <xsl:apply-templates select=".">
                    <xsl:with-param name="mode" select="0"/>
                </xsl:apply-templates>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!--  Bookmap Part processing  -->
    <xsl:template name="processTopicPart">
        <!--HSC use outputclass for landscape acc. to [DtPrt#7.12.8] also in line:149-->
        <xsl:variable name="page-sequence-reference">
            <xsl:choose>
                <xsl:when test="contains(@outputclass, 'landscape')">
                    <xsl:choose>
                        <xsl:when test="$mapType = 'bookmap'">
                            <xsl:value-of select="'landscape-sequence'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'landscape-sequence'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$mapType = 'bookmap'">
                            <xsl:value-of select="'body-sequence'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'ditamap-body-sequence'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <fo:page-sequence master-reference="body-sequence" xsl:use-attribute-sets="page-sequence.part">
            <!--HSC ended
            <fo:page-sequence master-reference="body-sequence" xsl:use-attribute-sets="__force__page__count">
            -->
            <xsl:call-template name="startPageNumbering"/>
            <xsl:call-template name="insertBodyStaticContents"/>
            <fo:flow flow-name="xsl-region-body">
                <fo:block xsl:use-attribute-sets="topic">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:if test="empty(ancestor::*[contains(@class, ' topic/topic ')])">
                        <fo:marker marker-class-name="current-topic-number">
                            <xsl:variable name="topicref" select="key('map-id', ancestor-or-self::*[contains(@class, ' topic/topic ')][1]/@id)"/>
                            <xsl:for-each select="$topicref">
                                <xsl:apply-templates select="." mode="topicTitleNumber"/>
                            </xsl:for-each>
                            <xsl:number format="I"/>
                        </fo:marker>
                        <fo:marker marker-class-name="current-header">
                            <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
                                <!--HSC  <xsl:apply-templates select="." mode="getTitle"/> -->
                                <xsl:apply-templates select="." mode="getNumTitle">
                                    <xsl:with-param name="sidecol" select="false()"/>
                                </xsl:apply-templates>
                            </xsl:for-each>
                        </fo:marker>
                    </xsl:if>

                    <xsl:apply-templates select="*[contains(@class,' topic/prolog ')]"/>

                    <xsl:call-template name="insertChapterFirstpageStaticContent">
                        <xsl:with-param name="type" select="'part'"/>
                    </xsl:call-template>

                    <!-- ==================== print mini-TOC for PARTs ==================== -->
                    <xsl:choose>
                        <xsl:when test="$partLayout='BASIC'">
                            <xsl:apply-templates
                                select="*[not(contains(@class, ' topic/topic ') or
                                contains(@class, ' topic/title ') or
                            contains(@class, ' topic/prolog '))]"/>
                            <!--xsl:apply-templates select="." mode="buildRelationships"/-->
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="." mode="createMiniToc"/>
                        </xsl:otherwise>
                    </xsl:choose>

                    <!--                    <xsl:apply-templates select="*[not(contains(@class, ' topic/topic '))]"/>-->

                    <xsl:for-each select="*[contains(@class,' topic/topic ')]">
                        <xsl:variable name="topicType" as="xs:string">
                            <xsl:call-template name="determineTopicType"/>
                        </xsl:variable>
                        <xsl:if test="($topicType = 'topicSimple') or ($topicType = 'topicBackmatter')">
                            <xsl:apply-templates select=".">
                                <xsl:with-param name="mode" select="0"/>
                            </xsl:apply-templates>
                        </xsl:if>
                    </xsl:for-each>
                    <xsl:call-template name="pullPrologIndexTerms.end-range"/>
                </fo:block>
            </fo:flow>
        </fo:page-sequence>
        <xsl:for-each select="*[contains(@class,' topic/topic ')]">
            <xsl:variable name="topicType" as="xs:string">
                <xsl:call-template name="determineTopicType"/>
            </xsl:variable>
            <xsl:if test="not(($topicType = 'topicSimple') or ($topicType = 'topicBackmatter'))">
                <xsl:apply-templates select="."/>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!--HSC This template produces the notices page content, it does not affect the TOC -->
    <xsl:template name="processTopicNotices">
        <!--HSC use outputclass for landscape acc. to [DtPrt#7.12.8] also in line:149-->
        <!--HSC create the page-sequence-reference  -->
        <xsl:variable name="page-sequence-reference">
            <xsl:choose>
                <xsl:when test="contains(@outputclass, 'landscape')">
                    <xsl:choose>
                        <xsl:when test="$mapType = 'bookmap'">
                            <xsl:value-of select="'landscape-sequence'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'landscape-sequence'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="$mapType = 'bookmap'">
                            <xsl:value-of select="'body-sequence'"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="'ditamap-body-sequence'"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!--HSC call the page-sequence-reference in layout-masters.xsl -->
        <fo:page-sequence master-reference="body-sequence" xsl:use-attribute-sets="page-sequence.notice">
            <!--HSC ended
            <fo:page-sequence master-reference="body-sequence" xsl:use-attribute-sets="__force__page__count">
            -->
            <!--HSC do page numbering -->
            <xsl:call-template name="startPageNumbering"/>

            <!--HSC do page setup -->
            <xsl:call-template name="insertBodyStaticContents"/>
            <fo:flow flow-name="xsl-region-body">
                <fo:block xsl:use-attribute-sets="topic">
                    <!--prepare outline e.g. title with number -->
                    <xsl:call-template name="commonattributes"/>
                    <!--HSC topic/topic finds a Head 1 chapter, marker will be set
                    on any but Head 1 entries -->
                    <xsl:if test="not(ancestor::*[contains(@class, ' topic/topic ')])">
                        <fo:marker marker-class-name="current-topic-number">
                            <xsl:variable name="topicref" select="key('map-id', ancestor-or-self::*[contains(@class, ' topic/topic ')][1]/@id)"/>
                            <xsl:for-each select="$topicref">
                                <xsl:apply-templates select="." mode="topicTitleNumber"/>
                            </xsl:for-each>
                            <xsl:number format="1"/>
                        </fo:marker>
                        <fo:marker marker-class-name="current-header">
                            <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
                                <!--HSC   <xsl:apply-templates select="." mode="getTitle"/> -->
                                <xsl:apply-templates select="." mode="getNumTitle">
                                    <xsl:with-param name="sidecol" select="false()"/>
                                </xsl:apply-templates>
                            </xsl:for-each>
                        </fo:marker>
                    </xsl:if>

                    <!--HSC do the prolog if existing -->
                    <xsl:apply-templates select="*[contains(@class,' topic/prolog ')]"/>

                    <xsl:call-template name="insertChapterFirstpageStaticContent">
                        <xsl:with-param name="type" select="'notices'"/>
                    </xsl:call-template>

                    <!--HSC run down all topic/title contained in the object -->
                    <!-- This block creates the NOTICES Head1 title -->
                    <fo:block xsl:use-attribute-sets="topic.title">
                        <xsl:call-template name="pullPrologIndexTerms"/>
                        <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
                            <!--HSC    <xsl:apply-templates select="." mode="getTitle"/> -->
                            <xsl:apply-templates select="." mode="getNumTitle">
                                <xsl:with-param name="sidecol" select="false()"/>
                            </xsl:apply-templates>
                        </xsl:for-each>
                    </fo:block>

                    <!-- ==================== print mini-TOC for Notices ==================== -->
                    <xsl:choose>
                        <xsl:when test="$noticesLayout='BASIC'">
                            <xsl:apply-templates
                                select="*[not(contains(@class, ' topic/topic ') or contains(@class, ' topic/title ') or
                            contains(@class, ' topic/prolog '))]"/>
                            <!--xsl:apply-templates select="." mode="buildRelationships"/-->
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:apply-templates select="." mode="createMiniToc"/>
                        </xsl:otherwise>
                    </xsl:choose>

                    <xsl:apply-templates select="*[contains(@class,' topic/topic ')]">
                        <xsl:with-param name="mode" select="0"/>
                    </xsl:apply-templates>

                    <xsl:call-template name="pullPrologIndexTerms.end-range"/>
                </fo:block>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>

    <!--HSC ========== Insert PREFACE - GLOSSARY - PART Heading1 etc. INTO TEXT FLOW ONLY ========= -->
    <xsl:template name="insertChapterFirstpageStaticContent">
        <xsl:param name="type" as="xs:string"/>
        <fo:block>
            <xsl:attribute name="id">
                <xsl:call-template name="generate-toc-id"/>
            </xsl:attribute>
            <xsl:if test="contains($unittest, 'chkHead3')">
                <xsl:message>
                    <xsl:text>Type[</xsl:text>
                    <xsl:value-of select="$type"/>
                    <xsl>text>]</xsl>
                </xsl:message>
            </xsl:if>
            <xsl:choose>
                <!--HSC here we create the automatic chapter number/name, changes are
                described in [DtPrt#10.3.6] -->
                <!-- by commenting it out, it will not produced at all ! Something we would want -->
                <xsl:when test="$type = 'chapter'">
                    <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container_1">
                        <!--HSC insert "Chapter" from variable in en.xml -->
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'Chapter with number'"/>
                            <xsl:with-param name="params">
                                <number>
                                    <!--HSC if we do not want to be the chapter on a separate line
                                    we need to replace fo:block (which always does that) by
                                    fo:inline acc. to [DtPrt#10.3.7]
                                    "__chapter__frontmatter__number__container" is specified in static-content-attr.xsl
                                    <fo:block xsl:use-attribute-sets="__chapter__frontmatter__number__container">
                                    <xsl:apply-templates select="key('map-id', @id)[1]" mode="topicTitleNumber"/>
                                    </fo:block>
                                    -->
                                    <!--HSC and this is the tough statement that actually inserts Number !
                                    to remove ... follow [DtPrt#10.6.2] [DitaSpec#2.1.3.4.3.2]-->
                                    <!--HSC          <fo:inline xsl:use-attribute-sets="__chapter__frontmatter__number__container"> -->

                                    <!--HSX Insert Chapter number for Head 1 titles -->
                                    <fo:inline-container>
                                        <fo:block xsl:use-attribute-sets="topic.title">
                                            <!--HSX bug in DITA-OT, it forgets the assigned id
                                               of Head1 chapters' titles, fixed here -->
                                            <xsl:attribute name="id" select="title/@id"/>
                                            <xsl:apply-templates select="key('map-id', @id)[1]" mode="topicTitleNumber"/>

                                            <!--HSC if the chapter title should also be on the same line
                                            then statement below needs to be added [DtPrt#10.3.7] -->
                                            <!--HSC Insert space between chapter number and title
                                            <fo:inline xsl:use-attribute-sets="topic.title">
                                            -->
                                            <xsl:text> </xsl:text>
                                                <!--HSC blank out acc. to [DtPrt#10.6.2]
                                            </fo:inline>
                                            -->

                                            <!--HSC Insert Head1 Chapter Title
                                            The attributes, in particular the "justify" settings for the line
                                            are in static-content-attr "__chapter__frontmatter__name__container"
                                            and not in commons-attr.xls topic.title. Also described in [DtPrt#10.3.5]
                                            The topic.title attributes are only applied if topic.title is
                                            notices, preface or abstract.
                                            -->
                                            <!-- If you don't want character formatting
                                                 then don't format the title ...

                                                 If you don't want character formatting in the toc/bookmarks
                                                 then use navtitle
                                            -->
                                            <xsl:apply-templates select="*[contains(@class, ' topic/title ')]" mode="getNonumTitle"/>
                                        </fo:block>
                                    </fo:inline-container>

                                        <!--HSC ... the following two lines are required if you specify "justify" in
                                        static-content-attr "__chapter__frontmatter__name__container"
                                        to avoid that the actual text justifies (as you only want the line)

                                    <fo:inline xsl:use-attribute-sets="topic.title">
                                        <fo:leader xsl:use-attribute-sets="__hdrftr__leader"/>
                                        <xsl:text>&#xA0;</xsl:text>
                                    </fo:inline>
                                        -->
                                    <!--HSC end of insertion -->
                                </number>
                                <!--HSC avoid restart numbering on parts - does currently not yet work
                                <number>
                                <xsl:variable name="id" select="@id" />
                                <xsl:variable name="topicChapters">
                                <xsl:copy-of select="$map//*[contains(@class, ' bookmap/chapter ')]" />
                                </xsl:variable>
                                <xsl:variable name="chapterNumber">
                                <xsl:number format="1"
                                value="count($topicChapters/*[@id = $id]/preceding-sibling::*) + 1" />
                                </xsl:variable>
                                <xsl:value-of select="$chapterNumber" />
                                </number>
                                -->
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:block>
                </xsl:when>
                <!-- option to comment auto-chapter number/name out -->

                <!--HSX create Chapter number for the appendix -->
                <xsl:when test="$type = 'appendix'">
                    <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Appendix with number'"/>
                                <xsl:with-param name="params">
                                <number>
                                    <fo:inline xsl:use-attribute-sets="__chapter__frontmatter__number__container">
                                        <!--HSX bug in DITA-OT, it forgets the assigned id
                                           of Head1 chapters' titles, fixed here -->
                                        <xsl:attribute name="id" select="title/@id"/>
                                        <xsl:apply-templates select="key('map-id', @id)[1]" mode="topicTitleNumber"/>
                                        <xsl:text> - </xsl:text>
                                        <xsl:value-of select="*[contains(@class, ' topic/title ')]"/>
                                    </fo:inline>
                                </number>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:block>
                </xsl:when>

                <xsl:when test="$type = 'appendices'">
                    <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
                  <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Appendix with number'"/>
                    <xsl:with-param name="params">
                                <number>
                                    <!--HSC if we do not want to be the chapter on a separate line
                                    we need to replace fo:block (which always does that) by
                                    fo:inline acc. to [DtPrt#10.3.7]
                                    <fo:block xsl:use-attribute-sets="__chapter__frontmatter__number__container">
                                    -->
                                    <fo:inline xsl:use-attribute-sets="__chapter__frontmatter__number__container">
                                        <xsl:text>&#xA0;</xsl:text>
                                    </fo:inline>
                                    <!--HSC
                                    </fo:block>
                                    -->
                                </number>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:block>
                </xsl:when>

                <!--HSX This block creates the ENTIRE title for the text flow -->
                <xsl:when test="$type = 'part'">
                    <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
                            <xsl:call-template name="getVariable">
                            <!--HSX put out 'Part' -->
                                <xsl:with-param name="id" select="'Part with number'"/>
                                <xsl:with-param name="params">
                                <number>
                                    <!--HSC if we do not want to be the chapter on a separate line
                                    we need to replace fo:block (which always does that) by
                                    fo:inline acc. to [DtPrt#10.3.7]
                                    <fo:block xsl:use-attribute-sets="__chapter__frontmatter__number__container">
                                    -->
                                    <!-- Put out the part number -->
                                    <fo:inline xsl:use-attribute-sets="__chapter__frontmatter__number__container">
                                        <xsl:apply-templates select="key('map-id', @id)[1]" mode="topicTitleNumber"/>
                                        <!--HSC
                                        </fo:block>
                                        -->
                                    </fo:inline>
                                </number>
                                <titletext>
                                    <xsl:call-template name="getNavTitle"/>
                                </titletext>
                            </xsl:with-param>
                        </xsl:call-template>
                    </fo:block>
                </xsl:when>
                <!--HSX entire title is printed. -->

                <xsl:when test="($type = 'preface') and contains($mainTitles, 'mainPreface')">
                    <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Preface title'"/>
                        </xsl:call-template>
                    </fo:block>
                </xsl:when>
                <xsl:when test="($type = 'notices') and contains($mainTitles, 'mainNotices')">
                    <fo:block xsl:use-attribute-sets="__chapter__frontmatter__name__container">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Notices title'"/>
                        </xsl:call-template>
                    </fo:block>
                </xsl:when>
            </xsl:choose>
        </fo:block>
    </xsl:template>

    <!--HSX ... found a log entry transform.topic2fo.main:[xslt] No topicTitleNumber mode template for notices
    which fixes here, as empty, we do not generate a number on notices -->
    <xsl:template match="*[contains(@class, ' bookmap/notices ')] |
        opentopic:map/*[contains(@class, ' map/topicref ')]" mode="topicTitleNumber"
    priority="-1"/>


    <!--HSX create Chapter prefix (e.g. "chapter") for Head 1 titles -->
    <xsl:template match="*[contains(@class, ' bookmap/chapter ')] |
        opentopic:map/*[contains(@class, ' map/topicref ')]"
        mode="topicTitleNumber" priority="-1">
        <!--HSC add marker to catch chapter number acc. to [DtPrt#8.11.3] -->

        <fo:inline>
            <fo:marker marker-class-name="current-chapter-number">
                <!--HSC the chapter number can be numeric but also take other formats
                like 1,I,i,A and a acc. to [DtPrt#10.3.6] -->
                <xsl:number format="1" count="*[contains(@class, ' bookmap/chapter ')]"/>
            </fo:marker>
        </fo:inline>
        <xsl:number format="1" count="*[contains(@class, ' bookmap/chapter ')]"/>
    </xsl:template>

    <xsl:template match="math">
        <fo:block width="20mm">
            <xsl:apply-templates/>
        </fo:block>

    </xsl:template>

    <xsl:template match="semantics">
        <fo:block width="20mm">
            <xsl:value-of select="@lang"/>
        </fo:block>

    </xsl:template>



    <!--HSX create TOC and chapter entry for the appendix -->
    <xsl:template match="*[contains(@class, ' bookmap/appendix ')]" mode="topicTitleNumber">
        <xsl:param name="fromBkx" select="false()"/>
        <!--HSC add marker to catch appendix number acc. to [DtPrt#8.11.3], but only for TOC -->
        <xsl:if test="not($fromBkx)">
            <fo:inline>
                <fo:marker marker-class-name="current-chapter-number">
                    <xsl:number format="A" count="*[contains(@class, ' bookmap/appendix ')]"/>
                </fo:marker>
            </fo:inline>
        </xsl:if>
        <xsl:number format="A" count="*[contains(@class, ' bookmap/appendix ')]"/>
    </xsl:template>

    <!--HSX caller chain =
        <xsl:template name="createBookmarks">
            <xsl:template match="*[contains(@class, ' topic/topic ')]" mode="bookmark">
                 ... creating $topicTitle
                 createBookmarkEntryAndChildren
                     <xsl:template match="*[contains(@class, ' bookmap/part ')]" mode="tocPrefix">
    -->
    <xsl:template match="*[contains(@class, ' bookmap/part ')]" mode="topicTitleNumber">
        <xsl:param name="isFromBkx" select="false()" />

        <!--HSX Very important - if we come from bookmarks.xsl we have to create
                the prefix "Part n - " for the bookmarks section. This, however,
                shall not have a marker, whereas the same call to the actual chapter
                should do the marker. The parameter isFromBkx does help to distinguish
        -->
        <xsl:if test="not($isFromBkx)">
            <!--HSC add marker to catch Part number acc. to [DtPrt#8.11.3] -->
            <fo:inline>
                <fo:marker marker-class-name="current-chapter-number">
                    <xsl:number format="I" count="*[contains(@class, ' bookmap/part ')]"/>
                </fo:marker>
            </fo:inline>
        </xsl:if>
        <xsl:number format="I" count="*[contains(@class, ' bookmap/part ')]"/>
    </xsl:template>

    <xsl:template match="*" mode="topicTitleNumber" priority="-10">
        <xsl:message>No topicTitleNumber mode template for <xsl:value-of select="name()"/>
        </xsl:message>
    </xsl:template>

    <!--HSX created this template because I wanted to change order of printing
    when mini-TOC is done in the Head1 chapter-numbe
    -->
    <xsl:template name="printProlog">
        <fo:block>
            <xsl:apply-templates select="*[contains(@class,' topic/titlealts ')]"/>
            <!--HSC This part prints the shortdesc after the mini-toc in Head1 chapters -->

            <xsl:if test="contains($PageLayout, 'print_shortdesc')">
                <xsl:if test="*[contains(@class,' topic/shortdesc ')
                    or contains(@class, ' topic/abstract ')]/node()">
                    <!--HSX taking format from 'p' is not what I like ... hence I gave it
                    another attribute
                    <fo:block xsl:use-attribute-sets="p">
                    -->
                    <fo:block xsl:use-attribute-sets="minitoc__shortdesc">
                        <xsl:apply-templates
                            select="*[contains(@class,' topic/shortdesc ')
                        or contains(@class, ' topic/abstract ')]/node()"/>
                    </fo:block>
                </xsl:if>
            </xsl:if>
            <xsl:apply-templates select="*[contains(@class,' topic/body ')]/*"/>
        </fo:block>
    </xsl:template>

    <!--HSX
    <fo:block space-before="10pt" />
    <fo:float float="start" clear="both" xsl:use-attribute-sets="p_marginalia_heading">
    <fo:block-container padding-top="1pt">
    <xsl:attribute name="width">
    <xsl:value-of select="$mrgWidth" />
    </xsl:attribute>
    <fo:block>
    <xsl:apply-templates/>
    </fo:block>
    </fo:block-container>
    </fo:float>
    -->
    <xsl:template name="printMiniToc">
        <xsl:variable name="mmSideColWidth">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="$side-col-width"/>
                <xsl:with-param name="inUnitsOf" select="'mm'"/>
            </xsl:call-template>
        </xsl:variable>

        <!--HSX specify marginalia-text gap as 4mm -->
        <xsl:variable name="mrgWidth">
            <xsl:choose>
                <xsl:when test="($mmSideColWidth - $mmMarginaliaGap) &gt; 10">
                    <xsl:value-of select="concat($mmSideColWidth - $mmMarginaliaGap,'mm')"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$side-col-width"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!--HSX do the entire mini-TOC: space-after determines space after the mini-TOC -->

        <xsl:variable name="mtContent" as="node()*">
            <xsl:apply-templates select="*[contains(@class, ' topic/topic ')]" mode="in-this-chapter-list"/>
        </xsl:variable>

        <!--HSX Only print the mini-TOC if subchapters are available with non-empty title
        -->
        <xsl:variable name="smtContent">
             <xsl:value-of select="$mtContent"/>
        </xsl:variable>

        <xsl:if test="string-length(normalize-space($smtContent)) &gt; 0">
            <fo:block space-after="11.2mm" xsl:use-attribute-sets="__toc__mini">
                <xsl:if test="*[contains(@class, ' topic/topic ')]">
                    <!--HSC Print the title -->
                    <xsl:choose>
                        <xsl:when test="contains(@outputclass, 'tocfirst')">
                            <fo:block space-before="8mm">
                                <xsl:text>&#xA0;</xsl:text>
                            </fo:block>
                        <!--HSX I found it more readable if on tocfirst we don't need the header 'Topics'
                                it is too obvious what we are doing
                            <fo:block xsl:use-attribute-sets="__toc__mini__header">
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="'Mini Toc'"/>
                                </xsl:call-template>
                            </fo:block>
                        -->
                        </xsl:when>
                        <xsl:otherwise>
                            <fo:block xsl:use-attribute-sets="__toc__mini_float"/>
                            <!--HSX the space-before determines the distance for marginalia text as well as the
                            following paragraph text -->
                            <fo:block space-before="0pt"/>
                            <fo:float float="start" clear="both" xsl:use-attribute-sets="__toc__mini_float">
                                <fo:block-container padding-top="1pt">
                                    <xsl:attribute name="width">
                                        <xsl:value-of select="$mrgWidth"/>
                                    </xsl:attribute>
                                    <fo:block>
                                        <!--HSX debug background color to sort out correct block size
                                        <xsl:attribute name="background-color">#FFC0C0</xsl:attribute>
                                        -->
                                    <xsl:call-template name="getVariable">
                                        <xsl:with-param name="id" select="'Mini Toc'"/>
                                        </xsl:call-template>
                                    </fo:block>
                                </fo:block-container>
                            </fo:float>
                        </xsl:otherwise>
                    </xsl:choose>

                    <!--HSC Print the mini-Toc table -->
                    <fo:list-block xsl:use-attribute-sets="__toc__mini__list">
                        <xsl:copy-of select="$mtContent"/>
                    </fo:list-block>
                </xsl:if>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <!-- ============================ Create mini-TOC with intro text ================= -->
    <xsl:template match="*" mode="createMiniToc">
        <!--HSC [DtPrt#16.15.4] removes the mini-TOC from a table. So we comment out
        the associated entries below
        <fo:table xsl:use-attribute-sets="__toc__mini__table">
        <fo:table-column xsl:use-attribute-sets="__toc__mini__table__column_1"/>
        <fo:table-column xsl:use-attribute-sets="__toc__mini__table__column_2"/>
        <fo:table-body xsl:use-attribute-sets="__toc__mini__table__body">
        <fo:table-row>
        <fo:table-cell>
        -->

        <!--HSC At this point we are always in a concept/task/topic/reference and can check
        elements like 'title' or the topic's outputclass
        -->
        <xsl:choose>
            <xsl:when test="contains(@outputclass, 'tocfirst')">
                <xsl:call-template name="printMiniToc"/>
                <xsl:call-template name="printProlog"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="printProlog"/>
                <xsl:call-template name="printMiniToc"/>
            </xsl:otherwise>
        </xsl:choose>
        <!--HSC
        </fo:table-cell>
        <fo:table-cell xsl:use-attribute-sets="__toc__mini__summary">
        -->
        <!--Really, it would be better to just apply-templates, but the attribute sets for shortdesc, body
        and abstract might indent the text.  Here, the topic body is in a table cell, and should
        not be indented, so each element is handled specially.-->
        <!-- manage the related-links -->
        <fo:block>

            <xsl:if
                test="*[contains(@class,' topic/related-links ')]//
                *[contains(@class,' topic/link ')][not(@role) or @role!='child']">
                <xsl:apply-templates select="*[contains(@class,' topic/related-links ')]"/>
            </xsl:if>
        </fo:block>
        <!--HSC
        </fo:table-cell>
        </fo:table-row>
        </fo:table-body>
        </fo:table>
        -->
    </xsl:template>
    <!--HSC ======================= Create the mini-TOC ======================= -->
    <xsl:template match="*[contains(@class, ' topic/topic ')]" mode="in-this-chapter-list">
        <xsl:choose>
            <!--HSX2:emptyTitle do not act on empty titles -->
            <xsl:when test="string-length(normalize-space(title)) = 0"/>
            <xsl:otherwise>
                <!--HSX __toc__mini__entry determines spacing between entries -->
                <fo:list-item xsl:use-attribute-sets="__toc__mini__entry">
                    <!--HSC I didn't like the dot at the beginning of the mini-TOC entries -->
                    <fo:list-item-label xsl:use-attribute-sets="ul.li__label">
                        <fo:block xsl:use-attribute-sets="ul.li__label__content">
                            <!--HSC
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'Unordered List bullet'"/>
                            </xsl:call-template>
                            -->
                            <xsl:text>&#xA0;&#xA0;</xsl:text>
                        </fo:block>
                    </fo:list-item-label>

                    <fo:list-item-body xsl:use-attribute-sets="__toc__mini__body">
                        <fo:block xsl:use-attribute-sets="xref__mini__toc">
                            <!--HSC to have own format for the mini-TOC we provide separate attribute set
                            I added 'justify' to the xref__mini__toc to get the leaders out to the margin
                            <fo:basic-link internal-destination="{@id}" xsl:use-attribute-sets="xref">
                            -->
                            <fo:basic-link internal-destination="{@id}">
                                <!-- xsl:use-attribute-sets="xref__mini__toc" not req -->

                                <!--HSC add chapter numbers to the mini-TOC, Helmut's special ....
                                    otherwise use the statement below
                                    We let the user variable (basic-settings.xsl) decide whether the
                                    mini-TOC shall use the navtitle (if present) or not
                                 -->
                                <fo:inline>
                                    <xsl:call-template name="getNavTitle">
                                        <xsl:with-param name="isFromToc"   select="true()"/>
                                        <xsl:with-param name="useNavTitle" select="$useNavTitle-minitoc"/>
                                    </xsl:call-template>
                                    <xsl:text>&#xA0;</xsl:text>
                                </fo:inline>
                                <!--HSC otherwise ... no chapter numbers ....
                                <xslk:value-of select="child::*[contains(@class, ' topic/title ')]"/>
                                -->
                            </fo:basic-link>
                            <!--HSC [DtPrt#16.15.3] adds page numbers to the mini-TOC -->
                            <!--HSC I stole the leaders from the full TOC, this will give us leaders
                            in the mini-TOC. Comment it out if you don't like it
                            -->
                            <fo:inline>
                                <fo:leader xsl:use-attribute-sets="__toc__leader"/>
                                <xsl:text>&#xA0;&#xA0;</xsl:text>
                                <!--HSC [DtPrt#16.11] allows to add chapter number prior to the TOC page number
                                I improved it to be generally selectable through 'prefix_chapter' -->
                                <xsl:if test="contains($PageLayout, 'prefix_chapter')">
                                    <xsl:variable name="ChapterPrefix">
                                        <xsl:call-template name="getChapterPrefix"/>
                                    </xsl:variable>
                                    <xsl:choose>
                                        <xsl:when test="$ChapterPrefix = ''"/>
                                        <xsl:otherwise>
                                            <xsl:value-of select="$ChapterPrefix"/>
                                            <xsl:text>-</xsl:text>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </xsl:if>
                                <fo:page-number-citation ref-id="{concat('_OPENTOPIC_TOC_PROCESSING_', generate-id())}"/>
                            </fo:inline>
                            <!--HSC end of insertion -->
                        </fo:block>
                    </fo:list-item-body>
                </fo:list-item>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!-- h[n] -->
    <!--HSC Match chapter numbering for any chapter -->
    <xsl:template match="*[contains(@class,' topic/topic ')]/*[contains(@class,' topic/title ')]">
        <xsl:variable name="topicType" as="xs:string">
            <xsl:call-template name="determineTopicType"/>
        </xsl:variable>
        <xsl:choose>
            <!--  Disable chapter title processing when mini TOC is created -->
            <xsl:when test="(topicType = 'topicChapter') or (topicType = 'topicAppendix')"/>
            <!--   Normal processing         -->
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="processTopicTitle"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--HSC processTopitTitle processes all Level Headn  n=[2 ...9999] title levels
    in the document. It does not manage bookmarks or TOC
    Head1:Level 1 is processed in insertChapterFirstpageStaticContent
    -->
    <!--HSX2:emptyTitle do not act on empty titles -->
    <xsl:template name="txtContent" as="xs:integer">
        <xsl:variable name="textContent">
            <xsl:apply-templates select="text()"/>
        </xsl:variable>
        <xsl:value-of select="string-length(normalize-space($textContent))"/>
    </xsl:template>

    <xsl:template match="*" mode="processTopicTitle">
        <xsl:variable name="txtLen" as="xs:integer">
            <xsl:call-template name="txtContent"/>
        </xsl:variable>

       <xsl:variable name="topicType">
            <xsl:call-template name="determineTopicType"/>
        </xsl:variable>

        <!--HSX do not print glossary title since it is provided in the text again -->
        <xsl:variable name="chkGlossary" select="ancestor-or-self::*[contains(name(), 'glossarylist')]"/>
        <xsl:choose>
            <xsl:when test="$txtLen = 0"/>
            <xsl:when test="(count($chkGlossary) &gt; 0) and not(contains($mainTitles, 'mainGlossTitle'))">
            </xsl:when>

            <!--HSC Print the Title (from Head2 on) -->
            <xsl:otherwise>

                <!--HSX It is possible to put a topicref under backmatter. This makes it a level-1 chapter
                        however, as it is 'topicref' it is not really processed as level-1 by the page
                        processor. To get the right formatting, we need to fake the level +1 if we
                        detect the topicType = 'backmatter' (which we get from determineTopicType.
                -->

                <xsl:variable name="level" as="xs:integer">
                    <xsl:variable name="rawLevel">
                        <xsl:apply-templates select="." mode="get-topic-level"/>
                    </xsl:variable>
                    <xsl:choose>
                        <xsl:when test="$topicType = 'topicBackmatter'">
                            <xsl:value-of select="$rawLevel + 1"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$rawLevel"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>
                <!--HSC apply the title's attributes,
                produces topic.topic.topic.title -->
                <xsl:variable name="attrSet1">
                    <xsl:apply-templates select="." mode="createTopicAttrsName">
                        <xsl:with-param name="theCounter" select="$level"/>
                    </xsl:apply-templates>
                </xsl:variable>
                <!--HSC create content caller variable -->
                <xsl:variable name="attrSet2" select="concat($attrSet1, '__content')"/>
                <fo:block>
                    <!-- commonattributes would generate a keep-with-previous which
                         we never want on new chapters
                    <xsl:call-template name="commonattributes"/>

                         We therefore use the statement of commonattributes select="@id"
                    -->
                    <xsl:apply-templates select="@id"/>

                    <xsl:call-template name="processAttrSetReflection">
                        <xsl:with-param name="attrSet" select="$attrSet1"/>
                        <xsl:with-param name="path" select="'../../cfg/fo/attrs/commons-attr.xsl'"/>
                    </xsl:call-template>

                    <!--
                    <xsl:call-template name="chkNewpage"/>
                    -->

                    <fo:block>
                        <xsl:call-template name="processAttrSetReflection">
                            <xsl:with-param name="attrSet" select="$attrSet2"/>
                            <xsl:with-param name="path" select="'../../cfg/fo/attrs/commons-attr.xsl'"/>
                        </xsl:call-template>
                        <xsl:if test="$level = 1">
                            <fo:marker marker-class-name="current-header">
                                <!--HSC    <xsl:apply-templates select="." mode="getTitle"/> -->
                                <xsl:apply-templates select="." mode="getNumTitle">
                                    <xsl:with-param name="sidecol" select="false()"/>
                                </xsl:apply-templates>
                            </fo:marker>
                        </xsl:if>
                        <xsl:if test="$level = 2">
                            <fo:marker marker-class-name="current-h2">
                                <!--HSC    <xsl:apply-templates select="." mode="getTitle"/> -->
                                <xsl:apply-templates select="." mode="getNumTitle">
                                    <xsl:with-param name="sidecol" select="false()"/>
                                </xsl:apply-templates>
                            </fo:marker>

                            <!--HSC Example what current-header above does to maintain the marker info
                            <fo:marker marker-class-name="current-header">
                            <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
                            <xsl:apply-templates select="." mode="getTitle"/>
                            </xsl:for-each>
                            </fo:marker>
                            -->

                        </xsl:if>
                        <fo:inline id="{parent::node()/@id}"/>
                        <fo:inline>
                            <xsl:attribute name="id">
                                <xsl:call-template name="generate-toc-id">
                                    <xsl:with-param name="element" select=".."/>
                                </xsl:call-template>
                            </xsl:attribute>
                        </fo:inline>
                        <xsl:call-template name="pullPrologIndexTerms"/>

                        <!-- ==================== TITLE PRINTING Head2 ... Head n /HeadN =============== -->
                        <!--HSX Do not number glossary chapters, they would start at 1 and there's no
                        point to do numbering for the chapters expected in a glossary.

                        This prints the title in the text ... it is not responsible for the TOC and Bookmarks
                        -->
                        <xsl:choose>
                            <xsl:when test="count($chkGlossary) &gt; 0">
                                <xsl:apply-templates select="." mode="getNonumTitle">
                                    <xsl:with-param name="sidecol" select="true()"/>
                                </xsl:apply-templates>
                            </xsl:when>
                            <!--HSC         <xsl:apply-templates select="." mode="getTitle"/> -->
                            <!--HSC The following call generates the actual title line in the body text
                            It is not responsible for the TOC -->
                            <xsl:otherwise>
                                <xsl:apply-templates select="." mode="getNumTitle">
                                    <xsl:with-param name="sidecol" select="true()"/>
                                </xsl:apply-templates>
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:block>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--HSC this template works on concept/task/reference etc. -->
    <xsl:template match="*" mode="get-topic-level" as="xs:integer">
        <xsl:variable name="topicref" select="key('map-id', ancestor-or-self::*[contains(@class,' topic/topic ')][1]/@id)"/>
        <xsl:sequence
            select="count(ancestor-or-self::*[contains(@class,' topic/topic ')]) -
            count($topicref/ancestor-or-self::*[(contains(@class,' bookmap/part ') and
            ((exists(@navtitle) or
            *[contains(@class,' map/topicmeta ')]/*[contains(@class,' topic/navtitle ')]) or
            (exists(@href) and
            (empty(@format) or @format eq 'dita') and
            (empty(@scope) or @scope eq 'local')))) or
            (contains(@class,' bookmap/appendices ') and
            exists(@href) and
            (empty(@format) or @format eq 'dita') and
            (empty(@scope) or @scope eq 'local'))])"
        />
    </xsl:template>

    <!--HSC rekursive call into myself to add .topic as many as theCounter is -->
    <xsl:template match="*" mode="createTopicAttrsName">
        <xsl:param name="theCounter" as="xs:integer"/>
        <xsl:param name="theName" select="''" as="xs:string"/>
        <xsl:choose>
            <xsl:when test="$theCounter > 0">
                <xsl:apply-templates select="." mode="createTopicAttrsName">
                    <xsl:with-param name="theCounter" select="$theCounter - 1"/>
                    <xsl:with-param name="theName" select="concat($theName, 'topic.')"/>
                </xsl:apply-templates>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($theName, 'title')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/section ')]/*[contains(@class,' topic/title ')]">

        <xsl:variable name="mmSideColWidth">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="$side-col-width"/>
                <xsl:with-param name="inUnitsOf" select="'mm'"/>
            </xsl:call-template>
        </xsl:variable>

        <!--HSX specify marginalia space as 4mm -->
        <xsl:variable name="mrgWidth">
            <xsl:value-of select="concat($mmSideColWidth - 4,'mm')"/>
        </xsl:variable>

        <!--
        <fo:block space-before="10pt" />
        <fo:float float="start" clear="both" xsl:use-attribute-sets="p_marginalia_heading">
        <fo:block-container padding-top="1pt">
        <xsl:attribute name="width">
        <xsl:value-of select="$mrgWidth" />
        -->
        <!-- process section/title where section@outputclass = Block. ..... -->
        <xsl:choose>
            <xsl:when test="contains(../@outputclass, 'Block.') or contains(../@outputclass, 'mrg')">
                <fo:block xsl:use-attribute-sets="section.title.Block">
                    <xsl:call-template name="commonattributes"/>
                </fo:block>
                <!--HSX the space-before determines the distance for marginalia text as well as the
                following paragraph text -->
                <fo:block space-before="0pt"/>
                <fo:float float="start" clear="both" xsl:use-attribute-sets="p_marginalia_heading">
                    <!--HSX the next padding determines the top margin of the marginalia text only -->
                    <fo:block-container padding-top="1pt">
                        <xsl:attribute name="width">
                            <xsl:value-of select="$mrgWidth"/>
                        </xsl:attribute>
                        <fo:block>
                            <xsl:apply-templates select="." mode="getNumTitle">
                                <xsl:with-param name="sidecol" select="false()"/>
                            </xsl:apply-templates>
                        </fo:block>
                    </fo:block-container>
                </fo:float>
            </xsl:when>

            <xsl:when test="contains(../@outputclass, 'flow')">
                <fo:block xsl:use-attribute-sets="section.title.flow">
                    <xsl:call-template name="commonattributes"/>
                    <fo:block xsl:use-attribute-sets="section.title.flow.text">
                        <xsl:apply-templates select="." mode="getNumTitle">
                            <xsl:with-param name="sidecol" select="false()"/>
                        </xsl:apply-templates>
                    </fo:block>
                </fo:block>
            </xsl:when>

            <xsl:when test="contains(../@outputclass, 'page')">
                <fo:block xsl:use-attribute-sets="section.title.page">
                    <xsl:call-template name="commonattributes"/>
                    <fo:block xsl:use-attribute-sets="section.title.page.text">
                        <xsl:apply-templates select="." mode="getNumTitle">
                            <xsl:with-param name="sidecol" select="false()"/>
                        </xsl:apply-templates>
                    </fo:block>
                </fo:block>
            </xsl:when>

            <xsl:otherwise> <!--HSX currently same as outputclass contains "page" -->
                <fo:block xsl:use-attribute-sets="section.title.page">
                    <xsl:call-template name="commonattributes"/>
                    <fo:block xsl:use-attribute-sets="section.title.page.text">
                        <xsl:apply-templates select="." mode="getNumTitle">
                            <xsl:with-param name="sidecol" select="false()"/>
                        </xsl:apply-templates>
                    </fo:block>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/example ')]/*[contains(@class,' topic/title ')]">
        <fo:block xsl:use-attribute-sets="example.title">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/fig ')]/*[contains(@class,' topic/title ')]">
        <xsl:choose>
            <xsl:when test="contains($TitlePosition, 'fig_titleAbove')">
                <fo:block xsl:use-attribute-sets="fig.title.top">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'InsertFigure'"/>
                        <xsl:with-param name="params">
                            <number>
                                <!--HSC add chapter prefix acc. to [DtPrt#14.4] -->
                                <xsl:if test="contains($EnumerationMode, 'fig_prefix')">
                                    <xsl:call-template name="getChapterPrefix"/>
                                    <xsl:text>-</xsl:text>
                                </xsl:if>
                                <!--HSC add restart numbering acc. to [DtPrt#14.4] I added the configurability -->
                                <xsl:choose>
                                    <xsl:when test="contains($EnumerationMode, 'fig_numrestart')">
                                        <xsl:choose>
                                            <xsl:when
                                                test="count(ancestor-or-self::*[contains(@class, ' topic/topic')][position()=last()][count(preceding-sibling::*[contains(@class, ' topic/topic')]) &gt; 0])">
                                                <xsl:value-of
                                                    select="count(./preceding::*[contains(@class, ' topic/fig ')][child::*[contains(@class, ' topic/title ')]][ancestor-or-self::*[contains(@class, ' topic/topic')][position()=last()]])- count(ancestor-or-self::*[contains(@class, ' topic/topic')][position()=last()]/preceding-sibling::*[contains(@class, ' topic/topic')]//*[contains(@class, ' topic/fig ')][child::*[contains(@class, ' topic/title ')]])+1"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of
                                                    select="count(./preceding::*[contains(@class, ' topic/fig ')][child::*[contains(@class, ' topic/title ')]][ancestor-or-self::*[contains(@class, ' topic/topic')][position()=last()]])+1"
                                                />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:number level="any"
                                        count="*[contains(@class, ' topic/fig ')][child::*[contains(@class, ' topic/title ')]]" from="/"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </number>
                            <title>
                                <fo:inline xsl:use-attribute-sets="fig.title.top.text">
                                    <xsl:apply-templates/>
                                </fo:inline>
                            </title>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:block>
            </xsl:when>
            <xsl:otherwise>
                <fo:block xsl:use-attribute-sets="fig.title.bottom">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'InsertFigure'"/>
                        <xsl:with-param name="params">
                            <number>
                                <!--HSC add chapter prefix acc. to [DtPrt#14.4] -->
                                <xsl:if test="contains($EnumerationMode, 'fig_prefix')">
                                    <xsl:call-template name="getChapterPrefix"/>
                                    <xsl:text>-</xsl:text>
                                </xsl:if>
                                <!--HSC add restart numbering acc. to [DtPrt#14.4] I added the configurability -->
                                <xsl:choose>
                                    <xsl:when test="contains($EnumerationMode, 'fig_numrestart')">
                                        <xsl:choose>
                                            <xsl:when
                                                test="count(ancestor-or-self::*[contains(@class, ' topic/topic')][position()=last()][count(preceding-sibling::*[contains(@class, ' topic/topic')]) &gt; 0])">
                                                <xsl:value-of
                                                    select="count(./preceding::*[contains(@class, ' topic/fig ')][child::*[contains(@class, ' topic/title ')]][ancestor-or-self::*[contains(@class, ' topic/topic')][position()=last()]])- count(ancestor-or-self::*[contains(@class, ' topic/topic')][position()=last()]/preceding-sibling::*[contains(@class, ' topic/topic')]//*[contains(@class, ' topic/fig ')][child::*[contains(@class, ' topic/title ')]])+1"
                                                />
                                            </xsl:when>
                                            <xsl:otherwise>
                                                <xsl:value-of
                                                    select="count(./preceding::*[contains(@class, ' topic/fig ')][child::*[contains(@class, ' topic/title ')]][ancestor-or-self::*[contains(@class, ' topic/topic')][position()=last()]])+1"
                                                />
                                            </xsl:otherwise>
                                        </xsl:choose>
                                    </xsl:when>
                                    <xsl:otherwise>
                                        <xsl:number level="any"
                                        count="*[contains(@class, ' topic/fig ')][child::*[contains(@class, ' topic/title ')]]" from="/"/>
                                    </xsl:otherwise>
                                </xsl:choose>
                            </number>
                            <title>
                                <fo:inline xsl:use-attribute-sets="fig.title.bottom.text">
                                    <xsl:apply-templates/>
                                </fo:inline>
                            </title>
                        </xsl:with-param>
                    </xsl:call-template>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- The following three template matches are based on class attributes
    that do not exist. They have been commented out starting with
    the DITA-OT 1.5 release, with SourceForge tracker #2882085. -->
    <!--<xsl:template match="*[contains(@class, ' topic/dita ')]">
    <xsl:apply-templates/>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' topic/topichead ')]">
    <fo:block xsl:use-attribute-sets="topichead" id="{@id}">
    <xsl:apply-templates/>
    </fo:block>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' topic/topicgroup ')]">
    <fo:block xsl:use-attribute-sets="topicgroup" id="{@id}">
    <xsl:apply-templates/>
    </fo:block>
    </xsl:template>
    -->

    <xsl:template match="*[contains(@class, ' topic/tm ')]">
        <fo:inline xsl:use-attribute-sets="tm">
            <xsl:apply-templates/>
            <xsl:choose>
                <xsl:when test="@tmtype='service'">
                    <fo:inline xsl:use-attribute-sets="tm__content__service">SM</fo:inline>
                </xsl:when>
                <!--HSC special handling for tm possible acc. to [DtPrt#10.4.5] -->
                <xsl:when test="@tmtype='tm'">
                    <fo:inline xsl:use-attribute-sets="tm__content__tm">&#8482;</fo:inline>
                </xsl:when>
                <xsl:when test="@tmtype='reg'">
                    <fo:inline xsl:use-attribute-sets="tm__content">&#174;</fo:inline>
                </xsl:when>
                <xsl:otherwise>
                    <fo:inline xsl:use-attribute-sets="tm__content">
                        <xsl:text>Error in tm type.</xsl:text>
                    </fo:inline>
                </xsl:otherwise>
            </xsl:choose>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/term ')]" name="topic.term">
        <xsl:param name="keys" select="@keyref" as="attribute()?"/>
        <xsl:param name="contents" as="node()*">
            <xsl:variable name="target" select="key('id', substring(@href, 2))"/>
            <xsl:choose>
                <xsl:when test="not(normalize-space(.)) and $keys and $target/self::*[contains(@class,' topic/topic ')]">
                    <xsl:apply-templates select="$target/*[contains(@class, ' topic/title ')]/node()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:param>
        <xsl:variable name="topicref" select="key('map-id', substring(@href, 2))"/>
        <xsl:choose>
            <xsl:when test="$keys and @href and not($topicref/ancestor-or-self::*[@linking][1]/@linking = ('none', 'sourceonly'))">
                <fo:basic-link xsl:use-attribute-sets="xref term">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:call-template name="buildBasicLinkDestination"/>
                    <xsl:copy-of select="$contents"/>
                </fo:basic-link>
            </xsl:when>
            <xsl:otherwise>
                <fo:inline xsl:use-attribute-sets="term">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:copy-of select="$contents"/>
                </fo:inline>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/author ')]">
        <!--
        <fo:block xsl:use-attribute-sets="author">
        <xsl:apply-templates/>
        </fo:block>
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/source ')]">
        <!--
        <fo:block xsl:use-attribute-sets="source">
        <xsl:apply-templates/>
        </fo:block>
        -->
    </xsl:template>


    <xsl:template match="*[contains(@class, ' topic/publisher ')]">
        <!--
        <fo:block xsl:use-attribute-sets="publisher">
        <xsl:apply-templates/>
        </fo:block>
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/copyright ')]">
        <!--
        <fo:block xsl:use-attribute-sets="copyright">
        <xsl:apply-templates/>
        </fo:block>
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/copyryear ')]">
        <!--
        <fo:block xsl:use-attribute-sets="copyryear">
        <xsl:apply-templates/>
        </fo:block>
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/copyrholder ')]">
        <!--
        <fo:block xsl:use-attribute-sets="copyrholder">
        <xsl:apply-templates/>
        </fo:block>
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/critdates ')]">
        <!--
        <fo:block xsl:use-attribute-sets="critdates">
        <xsl:apply-templates/>
        </fo:block>
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/created ')]">
        <!--
        <fo:block xsl:use-attribute-sets="created">
        <xsl:apply-templates/>
        </fo:block>
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/revised ')]">
        <!--
        <fo:block xsl:use-attribute-sets="revised">
        <xsl:apply-templates/>
        </fo:block>
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/permissions ')]">
        <!--
        <fo:block xsl:use-attribute-sets="permissions">
        <xsl:apply-templates/>
        </fo:block>
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/category ')]">
        <!--
        <fo:block xsl:use-attribute-sets="category">
        <xsl:apply-templates/>
        </fo:block>
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/audience ')]">
        <!--
        <fo:block xsl:use-attribute-sets="audience">
        <xsl:apply-templates/>
        </fo:block>
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/keywords ')]">
        <!--
        <fo:block xsl:use-attribute-sets="keywords">
        <xsl:apply-templates/>
        </fo:block>
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/prodinfo ')]">
        <!--
        <fo:block xsl:use-attribute-sets="prodinfo">
        <xsl:apply-templates/>
        </fo:block>
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/prodname ')]">
        <!--
        <fo:block xsl:use-attribute-sets="prodname">
        <xsl:apply-templates/>
        </fo:block>
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/vrmlist ')]">
        <!--
        <fo:block xsl:use-attribute-sets="vrmlist">
        <xsl:apply-templates/>
        </fo:block>
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/vrm ')]">
        <!--
        <fo:block xsl:use-attribute-sets="vrm">
        <xsl:apply-templates/>
        </fo:block>
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/brand ')]">
        <!--
        <fo:block xsl:use-attribute-sets="brand">
        <xsl:apply-templates/>
        </fo:block>
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/series ')]">
        <!--
        <fo:block xsl:use-attribute-sets="series">
        <xsl:apply-templates/>
        </fo:block>
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/platform ')]">
        <!--
        <fo:block xsl:use-attribute-sets="platform">
        <xsl:apply-templates/>
        </fo:block>
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/prognum ')]">
        <!--
        <fo:block xsl:use-attribute-sets="prognum">
        <xsl:apply-templates/>
        </fo:block>
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/featnum ')]">
        <!--
        <fo:block xsl:use-attribute-sets="featnum">
        <xsl:apply-templates/>
        </fo:block>
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/component ')]">
        <!--
        <fo:block xsl:use-attribute-sets="component">
        <xsl:apply-templates/>
        </fo:block>
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/othermeta ')]">
        <!--
        <fo:block xsl:use-attribute-sets="othermeta">
        <xsl:apply-templates/>
        </fo:block>
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/resourceid ')]">
        <!--
        <fo:block xsl:use-attribute-sets="resourceid">
        <xsl:apply-templates/>
        </fo:block>
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class, ' concept/concept ')]" mode="processTopic" name="processConcept">
        <xsl:param name="mode" select="0"/>
        <xsl:if test="contains($unittest, 'chkproc')">
            <xsl:message>
                <xsl:text>ProcConcept ID[</xsl:text>
                <xsl:value-of select="$mode"/>
                <xsl:text>] :</xsl:text>
                <xsl:value-of select="@id"/>
                <xsl:text>&#xA;      Title ID: </xsl:text>
                <xsl:value-of select="title"/>
            </xsl:message>
        </xsl:if>
        <fo:block xsl:use-attribute-sets="concept">
            <xsl:call-template name="chkOrientation">
                <xsl:with-param name="mode" select="$mode"/>
            </xsl:call-template>
            <!--
            <xsl:attribute name="fox" select="concat('concept:',@id)"/>
            -->
            <xsl:apply-templates select="." mode="commonTopicProcessing">
                <xsl:with-param name="mode" select="$mode"/>
            </xsl:apply-templates>
        </fo:block>
    </xsl:template>
    <!-- Deprecated, retained for backwards compatibility -->
    <xsl:template match="*" mode="processConcept">
        <xsl:param name="mode" select="0"/>
        <xsl:call-template name="processConcept">
            <xsl:with-param name="mode" select="$mode"/>
        </xsl:call-template>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' concept/conbody ')]" priority="1">
        <xsl:variable name="level" as="xs:integer">
            <xsl:apply-templates select="." mode="get-topic-level"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="not(node())"/>
            <xsl:when test="$level = 1">
                <fo:block xsl:use-attribute-sets="body__toplevel conbody">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:when>
            <xsl:when test="$level = 2">
                <fo:block xsl:use-attribute-sets="body__secondLevel conbody">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:when>
            <xsl:otherwise>
                <fo:block xsl:use-attribute-sets="conbody">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="processReference">
        <xsl:param name="mode" select="1"/>
        <xsl:if test="contains($unittest, 'chkproc')">
            <xsl:message>
                <xsl:text>ProcRef     ID: </xsl:text>
                <xsl:value-of select="@id"/>
                <xsl:text>&#xA;      Title ID: </xsl:text>
                <xsl:value-of select="title"/>
            </xsl:message>
        </xsl:if>
        <fo:block xsl:use-attribute-sets="reference">
            <xsl:call-template name="chkOrientation">
                <xsl:with-param name="mode" select="$mode"/>
            </xsl:call-template>
            <xsl:apply-templates select="." mode="commonTopicProcessing">
                <xsl:with-param name="mode" select="$mode"/>
            </xsl:apply-templates>
        </fo:block>
    </xsl:template>


    <!-- Gets navigation title of current topic, used for bookmarks/TOC/glossary subchapters -->
    <xsl:template name="getNavTitle">
        <xsl:param name="isFromToc"   select="false()"/>
        <xsl:param name="useNavTitle" select="false()"/>
        <xsl:variable name="isFromNav" select="not($isFromToc)"/>

        <xsl:variable name="topicref" select="key('map-id', @id)[1]"/>

        <xsl:choose>
            <!--HSC check whether map:metadata has a navtitle -->
            <xsl:when
                test="$topicref/@locktitle='yes' and
                $topicref/*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/navtitle ')]">
                <!--HSX we store the result in pNavTitle to be more flexible in number management
                <xsl:apply-templates select="$topicref/*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/navtitle ')]/node()"/>
                -->
                <xsl:variable name="pNavTitle">
                    <xsl:apply-templates select="$topicref/*[contains(@class, ' map/topicmeta ')]/*[contains(@class, ' topic/navtitle ')]/node()"/>
                </xsl:variable>

                <!-- for debugging only
                <xsl:variable name="resNumTitle1">
                <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="getNumTitle">
                <xsl:with-param name="sidecol" select="false()"/>
                <xsl:with-param name="navTitle" select="$pNavTitle"/>
                </xsl:apply-templates>
                </xsl:variable>
                -->

                <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="getNumTitle">
                    <xsl:with-param name="sidecol" select="false()"/>
                    <xsl:with-param name="navTitle" select="$pNavTitle"/>
                    <xsl:with-param name="isFromNav" select="$isFromNav"/>
                </xsl:apply-templates>

            </xsl:when>
            <!--HSC Check whether @locktitle enforces a navtitle -->
            <xsl:when test="$topicref/@locktitle='yes' and
                $topicref/@navtitle">
                <!--HSX
                <xsl:value-of select="$topicref/@navtitle"/>
                -->
                <xsl:variable name="pNavTitle">
                    <xsl:value-of select="$topicref/@navtitle"/>
                </xsl:variable>

                <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="getNumTitle">
                    <xsl:with-param name="sidecol" select="false()"/>
                    <xsl:with-param name="navTitle" select="$pNavTitle"/>
                    <xsl:with-param name="isFromNav" select="$isFromNav"/>
                </xsl:apply-templates>
            </xsl:when>
            <!-- The following "otherwise creates the titles in the BOOKMARKS and the TOC.
            It is not responsible for the actual chapters, those are handled in 'processTopicTitle'

            The mode determines whether the result gets a number prefix or not !
            -->
            <xsl:otherwise>
                <!--HSC         <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="getTitle"/> -->
                <!--HSX Do not number glossary chapters, they would start at 1 and there's no
                point to do numbering for the chapters expected in a glossary.
                -->
                <xsl:variable name="chkGlossary" select="ancestor-or-self::*[contains(name(), 'glossarylist')]"/>

                <!--HSX support navtitle in the Bookmarks to avoid mess-up with too long titles in TOC and Bookmarks

                    We interprete the user variables useNavTitle-toc and its derivates (basic-settings.xsl)
                -->
                <xsl:variable name="pNavTitle">
                    <xsl:if test="$useNavTitle">
                        <xsl:value-of select="titlealts/navtitle"/>
                    </xsl:if>
                </xsl:variable>

                <xsl:choose>
                    <!-- print nothing if we don't want subchapters for the glossary -->
                    <xsl:when test="count($chkGlossary) &gt; 0">
                        <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="getNonumTitle">
                            <xsl:with-param name="sidecol" select="false()"/>
                        </xsl:apply-templates>
                    </xsl:when>
                    <!--HSC Most Cases end up here .... call getNumTitle -->
                    <xsl:otherwise>
                        <xsl:apply-templates select="*[contains(@class,' topic/title ')]" mode="getNumTitle">
                            <xsl:with-param name="sidecol" select="false()"/>
                            <xsl:with-param name="isFromNav" select="$isFromNav"/>
                            <xsl:with-param name="navTitle" select="$pNavTitle"/>
                        </xsl:apply-templates>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="getNonumTitle">
        <xsl:choose>
            <!-- add keycol here once implemented -->
            <xsl:when test="@spectitle">
                <xsl:value-of select="@spectitle"/>
            </xsl:when>
            <xsl:otherwise>
                <!--HSC put a prefix e.g. Exercise on all task/task [DtPrt#10.6.6] -->
                <xsl:apply-templates/>
                <!--HSC Use this to apply [DtPrt#10.6.6] which also gives alterantives
                <xsl:choose>
                <xsl:when test="parent::*[contains(@class,' task/task ')]">
                or graphics         <fo:external-graphic src="url(Customization/OpenTopic/common/artwork/task.png)"/>
                <xsl:text>Exercise: </xsl:text>
                <xsl:apply-templates/>
                </xsl:when>
                <xsl:otherwise>
                <xsl:apply-templates/>
                </xsl:otherwise>
                </xsl:choose>
                -->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <!--HSX@func
    getSuffix strips the suffix from an entry (e.g. 23.4.2 to .4.2) to allow replacing
    the first entry as part of the GetAppendixNo template
    -->
    <xsl:template name="getSuffix">
        <xsl:param name="rawSuffix"/>
        <!--HSX http://www.xml.com/pub/a/2003/06/04/tr.html [XSLT#14] -->
        <xsl:variable name="rsx">
            <xsl:analyze-string select="$rawSuffix" regex="{'([0-9]+){1}([\.,0-9]*)'}">
                <xsl:matching-substring>
                    <xsl:value-of select="regex-group(2)"/>
                </xsl:matching-substring>
                <!--
                <xsl:non-matching-substring>
                <xsl:text>??</xsl:text>
                <xsl:value-of select="."/>
                <xsl:text>??</xsl:text>
                </xsl:non-matching-substring>
                -->
            </xsl:analyze-string>
        </xsl:variable>
        <xsl:value-of select="$rsx"/>
    </xsl:template>

    <!--HSX@func
    getAppendixNo returns the corrected appendix header. The correction is
    necessary since the [DitaSpec#1] was using ditamaps in the abstract which
    turned the chapter numbering upside down. Find more below unter 'Francois Masson'
    -->
    <xsl:template name="getAppendixNo">
        <xsl:param name="cutfirst" as="xs:boolean" select="false()"/>

        <xsl:variable name="normPrefix">
            <xsl:number count="*[contains(@class,' topic/topic ')][@id = //*/appendix/@id|//*/(topicref|topicset)/@id]" level="multiple" format="A.1"/>
        </xsl:variable>

        <xsl:variable name="apSuffix">
            <xsl:number count="*[contains(@class,' topic/topic ')][@id = //*/appendiy/@id|//*/(topicref|topicset)/@id]" level="multiple" format=".1"/>
        </xsl:variable>

        <!--HSX I removed the 3rd test  + count(preceding::*[contains(@class,' topic/topic ')][@id = //*/appendix/@id])
        which finally made the correct result if file based appendix comes first-->
        <xsl:variable name="apPrefix">
            <xsl:number
                value="count(preceding::*/@outputclass[contains(., 'appendix')]) +
                count(ancestor::*/@outputclass[contains(., 'appendix')])
                "
            format="A"/>
        </xsl:variable>

        <xsl:variable name="apPrefixNo">
            <xsl:number
                value="count(preceding::*/@outputclass[contains(., 'appendix')]) +
                count(ancestor::*/@outputclass[contains(., 'appendix')])
                "
            format="1"/>
        </xsl:variable>

        <xsl:variable name="finSuffix">
            <xsl:call-template name="getSuffix">
                <xsl:with-param name="rawSuffix" select="$apSuffix"/>
            </xsl:call-template>
        </xsl:variable>

        <!--HSX numbering in [XSLT#4.3] -->
        <!--HSXD Debug to find correct numbering for appendix
        <xsl:message>
        <xsl:text>No1:=[</xsl:text>
        <xsl:value-of select="count(preceding::*[contains(@class,' topic/topic ')][@id = //*/appendix/@id])"/>
        <xsl:text>:</xsl:text>
        <xsl:value-of select="count(preceding::*[contains(@class,' topic/topic ')])"/>

        <xsl:text>]&#xA;No2:=[</xsl:text>
        <xsl:value-of select="count(preceding-sibling::*[contains(@class,' topic/topic ')][@id = //*/appendix/@id])"/>
        <xsl:text>:</xsl:text>
        <xsl:value-of select="count(preceding-sibling::*[contains(@class,' topic/topic ')])"/>

        <xsl:text>]&#xA;No3:=[</xsl:text>
        <xsl:value-of select="count(ancestor::*/@outputclass[contains(., 'appendix')])" />
        <xsl:text>:</xsl:text>
        <xsl:value-of select="count(ancestor::*[@id = //*/appendix/@id|//*/topicref/@id])"/>

        <xsl:text>]&#xA;No4:=[</xsl:text>
        <xsl:value-of select="$apPrefix" />

        <xsl:text>]&#xA;No5:=[</xsl:text>
        <xsl:value-of select="$apSuffix" />

        <xsl:text>]&#xA;No6:=[</xsl:text>
        <xsl:value-of select="$finSuffix" />

        <xsl:text>]&#xA;No7:=[</xsl:text>
        <xsl:value-of select="$normPrefix" />

        <xsl:text>]&#xA;No8:=[</xsl:text>
        <xsl:choose>
        <xsl:when test="$apPrefix = '0'">
        <xsl:value-of select="$normPrefix" />
        </xsl:when>
        <xsl:otherwise>
        <xsl:choose>
        <xsl:when test="$cutfirst = true()">
        <xsl:value-of select="concat($apPrefix, $finSuffix)" />
        </xsl:when>
        <xsl:otherwise>
        <xsl:value-of select="concat($apPrefix, $apSuffix)" />
        </xsl:otherwise>
        </xsl:choose>
        </xsl:otherwise>
        </xsl:choose>
        <xsl:text>]&#xA;</xsl:text>
        </xsl:message>
        -->

        <xsl:choose>
            <xsl:when test="$cutfirst = true()">
                <xsl:value-of select="concat($apPrefix, $finSuffix)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:choose>
                    <!--HSX we can play the 'outputclass'=appendix only if there's one
                    like that in the bookmap (test:apPrefixNo). For all other bookmaps that do not
                    use ditamaps in appendices, we provide the normPrefix which
                    computes the subordinate title numbers correctly -->
                    <xsl:when test="$apPrefixNo = 0">
                        <xsl:value-of select="$normPrefix"/>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="concat($apPrefix, $apSuffix)"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:text> </xsl:text>
    </xsl:template>

    <!-- Francois Masson 08-23-2012 Outline numbering, improved by Helmut Scherzer to leave
    preface, abstract and notices unnumbered. Further (extensive) effort I had to invest
    in getting the DITA specification numbering correctly, in particular in the appendix.
    So Francois' contribution was a precious startup, however, much additional research
    had to be done until the final version worked throughout preface, abstract, notices, chapters, appendix
    in TOC and chapter naming.

    This specification uses topicrefs to ditamaps. If one of the files of that appendix/ditamaps
    is processed, there is no evidence from the ancestors that we are in an appendix. On files
    directory included in the appendix, the DITA-OT delivers the @id of the appendix which can therefore
    be compared to detect the appendix flavour. For the dita-mapped files that doesn't work.

    I had to solve several problems
    1. A ditamap-based topicref did not show up as appendix in the TOC except for the Head 1 entry
    2. The numbering of subchapters in such situation did not follow the A,B,C concept but started
    to continue normal chapters.
    3. The numbering of subchapters included the numbered Head1 number instead of the appendix letter
    (6.1.2 instead of B.1.2) where "6=continued from chapters" and "B=correct Appendix prefix"

    The final fix has several patches, two of them are not very satisfactory, but they work.

    a.) To detect that a chapter is from an appendix, the DitaSpec did set "outputclass=appendix" in the files
    This is not a nice thing but I didn't have to do that myself - it was done by the authors already
    where I suspect that they had similar problems when they tried numbering with their plugin.

    b.) To fix the use of the chapter numbering in the ditamap-case I really strip that first number
    from the created number and I do replace it with the computed Appendix Letter. This is done in
    the 'getAppendixNo' above.
    I would like a more elegant way, however, it took days to get over it and I might come back on
    nicer implementation later.

    -->


    <!-- Number topics down to level = $topicTitle.numLevel -->
    <xsl:template name="getTitleNumber">
        <!-- Find the -->
        <xsl:variable name="level" select="ancestor::*[contains(@class,' topic/topic ')]"/>
        <xsl:variable name="appendix" select="//*[contains(@class,' bookmap/appendix ')]"/>

        <xsl:variable name="topicType" as="xs:string">
            <xsl:call-template name="determineTopicType"/>
        </xsl:variable>

        <!--HSX collect all appendix id's in the $map -->
        <xsl:variable name="pID"  select="../@id"/>
        <xsl:variable name="axId" select="$map//*[contains(@class, 'appendix')]/@id"/>

        <!--get our own parent's id, we are are 'title' this will be concept/task/reference
            unless we are in a figure (which is not critical)>
        -->

        <!--HSC Appendix Handler shall be prior to chapter handler since it is more specific -->
        <xsl:variable name="chkAppendixOutputclass">
            <xsl:value-of select="(ancestor::*/@outputclass[contains(., 'appendix')]) = 'appendix'"/>
        </xsl:variable>

        <xsl:choose>
            <!--HSC Appendix Level 1 ... special handling, [DtPrt#11.5] tells more about the number construct -->
            <xsl:when test="count($level)=1 and (count(index-of($axId, $pID)) &gt; 0)">
                <xsl:number value="index-of($axId, $pID)" format="A"/>
            </xsl:when>

            <xsl:when test="not(count($level) &gt; $topicTitle.numLevel) and
                           (contains($topicType, 'topicAppendix') or ($chkAppendixOutputclass = true())) ">


                <!--HSX tough conditions to avoid the the topicref condition matches other than
                    topics that are children of an appendix.
                    Using ditamaps in the appendix does not allow an easy check like ancestor::appendix
                    because the ditamaps hides the ancestor 'appendix'.
                    That's why we need to do the ancestor-or-self check in addition to the
                    topicref check.

                    @id = $map//*[contains(@class, 'appendix')]/@id
                         only claims the ids of appendix topics

                    [@id = ($map//*[ancestor-or-self::*[contains(@class, 'appendix')]])/@id]
                         claims that the investigated id shall match any node that is child of
                         'appendix'.

                    <xsl:number count="*
                         [contains(@class,' topic/topic ')]
                         [@id = ($map//*[ancestor-or-self::*[contains(@class, 'appendix')]])/@id]
                         [@id = $map//*[contains(@class, 'appendix')]/@id or $map//*/topicref/@id]"
                         level="multiple" format="A.1"/>

                -->

                <xsl:variable name="rawCnt">
                    <xsl:number count="*
                         [contains(@class,' topic/topic ')]
                         [@id = ($map//*[ancestor-or-self::*[contains(@class, 'appendix')]])/@id]
                         [$map//*/(topicref|topicset)/@id]"
                         level="multiple" format="A.1"/>
                </xsl:variable>

                <xsl:value-of select="$rawCnt"/>
                <xsl:text> </xsl:text>
            </xsl:when>

            <!--HSX Do not print chapter numbers for titles in the backmatter (that's what backmatter is for)
                <xsl:when test="../preceding::*[contains(name(), 'backmatter')]"/>
            -->
            <xsl:when test="$topicType = 'topicBackmatter'"/>

            <!--HSC Head 1 ... special handling, level = 1 -->
            <xsl:when test="count($level)=1 and
                ((parent::*/@id[. = //*/chapter/@id])
                or (parent::*/@id[. = //*/topicref/@id]))">
                <xsl:for-each select="$level">

                    <!--HSC HERE we are only when we are having a chapter 1..4 -->

                    <!-- test whether below is equal ... it is, so I'm going after the definition stolen from the appendix
                    <xsl:value-of
                    select="count(preceding-sibling::*/@id[. = //*/chapter/@id]) + 1"/>
                    -->
                    <!--HSC This statement replaces the original proposal and only counts, if we are in a chapter
                    <xsl:call-template name="DebugShowParents"/>
                    <xsl:call-template name="DebugShowParentsAttr"/>

                    -->

                    <xsl:value-of
                        select="count(preceding-sibling::*[contains(@class,' topic/topic ')][@id = //*/chapter/@id]) +
                    count(preceding-sibling::*[contains(@class,' topic/topic ')][@id = //*/topicref/@id]) + 1"/>

                    <!--HSC I removed this below in order to "not count" the abstract, preface and notices which also classify topic/topic
                    <xsl:value-of
                    select="count(preceding-sibling::*[contains(@class,' topic/topic ')]) + 1"/>
                    end removed original -->
                    <xsl:text> </xsl:text>
                </xsl:for-each>
            </xsl:when>

            <!--HSX Create Heading n>1 less or equal maxlevel
            <xsl:when test="not(count($level) &gt; $topicTitle.numLevel)"> this is the original
            -->

            <!--HSX To match only the current topic we would use ..
            not(@id = //*/chapter/@id|//*/notices/@id) and
            not(@id = //*/chapter/@id|//*/preface/@id) and
            not(@id = //*/chapter/@id|//*/abstract/@id)
            however, to leave any special (notices/preface/abstract) topicref child
            in the map without chapter numbering we have to apply
            not(ancestor-or-self::*/@id = //*/notices/@id) and ... etc.
            -->
            <xsl:when
                test="not(count($level) &gt; $topicTitle.numLevel) and
                not(ancestor-or-self::*/@id = //*/notices/@id) and
                not(ancestor-or-self::*/@id = //*/preface/@id) and
                not(ancestor-or-self::*/@id = //*/glossarylist/@id) and
                not(ancestor-or-self::*/@id = //*/abstract/@id)">
                <xsl:choose>
                    <!--HSX we should never end up here because we did already handle any appendix before -->
                    <xsl:when test="$topicType='topicAppendix'">
                        <xsl:number count="*[contains(@class,' topic/topic ')][@id = //*/chapter/@id | //*/(topicref|topicset)/@id]" level="multiple" format="A.1"/>
                    </xsl:when>

                    <!-- ====================== THIS COMPUTES THE CHAPTER's TITLE ========= -->
                    <xsl:otherwise>
                        <!--HSX2:emptyTitle do not act on empty titles, inserted the string-length test -->
                        <!-- the original ...
                        <xsl:message>
                            <xsl:text>TobeDone:FixChapterTitle</xsl:text>
                            <xsl:copy-of
                                select="*
                                [contains(@class,' topic/topic ')]
                                [string-length(normalize-space(title)) &gt; 0]
                                [@id = //*/chapter/@id|//*/topicref/@id]"
                            />
                        </xsl:message>
                        -->

                        <!--HSX2 the new version -->
                        <xsl:number
                            count="*
                            [contains(@class,' topic/topic ')]
                            [string-length(normalize-space(title)) &gt; 0]
                            [@id = //*/chapter/@id|//*/(topicref|topicset)/@id]"
                        level="multiple" format="1.1"/>
                    </xsl:otherwise>
                </xsl:choose>

                <!--HSC I removed this below in order to "not count" the abstract, preface and notices which also classify topic/topic
                <xsl:number count="*[contains(@class,' topic/topic ')]" level="multiple" format="1.1" />
                end removed original
                -->
                <xsl:text> </xsl:text>
            </xsl:when>
            <xsl:otherwise/>

            <!-- no title numbering at nth level where n > $topicTitle.numLevel -->
        </xsl:choose>
    </xsl:template>

    <xsl:template name="DebugShowMap">
        <xsl:param name="cnode"  as="node()"/>
        <xsl:param name="indent" as="xs:string"/>
        <xsl:text>&#xA;</xsl:text>
        <xsl:value-of select="concat($indent, $cnode/name())"/>
        <xsl:text>[</xsl:text>
        <xsl:value-of select="$cnode/position()"/>
        <xsl:text>][</xsl:text>
        <xsl:value-of select="@id"/>
        <xsl:text>]   </xsl:text>
        <xsl:for-each select="$cnode/@*">
            <xsl:text>   </xsl:text>
            <xsl:value-of select="name()"/>
            <xsl:text>=</xsl:text>
            <xsl:value-of select="."/>
        </xsl:for-each>
        <xsl:if test="count($cnode/ancestor::*) &lt; 5">
            <xsl:for-each select="$cnode/child::*">
                <xsl:call-template name="DebugShowMap">
                    <xsl:with-param name="cnode" select="."/>
                    <xsl:with-param name="indent" select="concat($indent, '  ')"/>
                </xsl:call-template>
            </xsl:for-each>
        </xsl:if>
    </xsl:template>

    <xsl:template name="debugShowNameClass">
        <xsl:message>
            <xsl:text>NameClass:&#xA;</xsl:text>
            <xsl:for-each select="$map/bookmeta/bookrights/child::*">
                <xsl:text>[</xsl:text>
                <xsl:value-of select="name()"/>
                <xsl:text>]=</xsl:text>
                <xsl:value-of select="@class"/>
                <xsl:text>]=&#xA;</xsl:text>
            </xsl:for-each>
        </xsl:message>
    </xsl:template>

    <xsl:template name="DebugShowTree">
        <xsl:message>
            <xsl:for-each select="/descendant-or-self::node()">
                <xsl:variable name="cnt">
                    <xsl:value-of select="count(ancestor::*)"/>
                </xsl:variable>

                <xsl:variable name="tname">
                    <xsl:value-of select="name(.)"/>
                </xsl:variable>

                <xsl:if test="not($tname = '')">
                    <xsl:for-each select="for $i in 1 to $cnt return ' '">
                        <xsl:text>    </xsl:text>
                    </xsl:for-each>

                    <xsl:value-of select="name(.)"/>
                    <xsl:text>&#xA;</xsl:text>
                </xsl:if>

            </xsl:for-each>
        </xsl:message>
    </xsl:template>

    <xsl:template name="DebugShowChildrenNames">
        <xsl:text>&#xA;DebugShowChildrenNames[</xsl:text>
        <xsl:value-of select="name(.)"/>
        <xsl:text>]&#xA;</xsl:text>
        <xsl:call-template name="NextChildName"/>
    </xsl:template>

    <xsl:template name="NextChildName">
        <xsl:for-each select="child::*[not(self::root or self::path)]">
            <xsl:variable name="cnt">
                <xsl:value-of select="count(ancestor::*)"/>
            </xsl:variable>

            <xsl:variable name="tname">
                <xsl:value-of select="name(.)"/>
            </xsl:variable>

            <xsl:if test="not($tname = '')">
                <!-- insert spaces to get indents -->
                <xsl:for-each select="for $i in 1 to $cnt return ' '">
                    <xsl:text>    </xsl:text>
                </xsl:for-each>

                <!-- print out own name -->
                <xsl:value-of select="$tname"/>
                <xsl:if test="$tname = 'title'">
                    <xsl:text>= </xsl:text>
                    <xsl:value-of select="."/>
                </xsl:if>
                <xsl:text>&#xA;</xsl:text>
            </xsl:if>
            <!-- print all nested children -->
            <xsl:choose>
                <xsl:when test="child::*">
                    <xsl:call-template name="NextChildName"/>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <xsl:template name="DebugShowChildrenClasses">
        <xsl:text>&#xA;DebugShowChildrenClasses[</xsl:text>
        <xsl:value-of select="name(.)"/>
        <xsl:text>]&#xA;</xsl:text>
        <xsl:call-template name="NextChildClass"/>
    </xsl:template>

    <xsl:template name="NextChildClass">
        <xsl:for-each select="child::*[not(self::root or self::path)]">
            <xsl:variable name="cnt">
                <xsl:value-of select="count(ancestor::*)"/>
            </xsl:variable>

            <xsl:variable name="tname">
                <xsl:value-of select="name(.)"/>
            </xsl:variable>

            <xsl:if test="not($tname = '')">
                <!-- insert spaces to get indents -->
                <xsl:for-each select="for $i in 1 to $cnt return ' '">
                    <xsl:text>    </xsl:text>
                </xsl:for-each>

                <!-- print out own name -->
                <xsl:value-of select="@class"/>
                <xsl:if test="$tname = 'title'">
                    <xsl:text>= </xsl:text>
                    <xsl:value-of select="."/>
                </xsl:if>
                <xsl:text>&#xA;</xsl:text>
            </xsl:if>
            <!-- print all nested children -->
            <xsl:choose>
                <xsl:when test="child::*">
                    <xsl:call-template name="NextChildClass"/>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>


    <xsl:template name="DebugShowParentsWithTitle">
        <xsl:message>
            <xsl:text>DebugShowParents2:</xsl:text>
        </xsl:message>
        <xsl:message>
            <xsl:text>StartTopic = </xsl:text>
            <xsl:value-of select="name(.)"/>
            <xsl:text>[id=(</xsl:text>
            <!-- show the topic class -->
            <xsl:value-of select="@id"/>
            <xsl:text>)]:</xsl:text>
            <!-- show the topic class -->
            <xsl:value-of select="@class"/>
            <xsl:text>&#xA;Parents =</xsl:text>

            <xsl:for-each select="ancestor::*[not(self::root or self::path)]">
                <!-- Show the title -->
                <xsl:for-each select="child::*[contains(@class,' topic/title ')]">
                    <xsl:value-of select="."/>
                </xsl:for-each>

                <!-- generate blanks -->
                <xsl:variable name="cnt">
                    <xsl:value-of select="count(ancestor::*)"/>
                </xsl:variable>

                <xsl:variable name="tname">
                    <!-- show the topic name -->
                    <xsl:value-of select="name(.)"/>
                    <xsl:text>:</xsl:text>
                    <!-- show the topic class -->
                    <xsl:value-of select="@class"/>
                </xsl:variable>

                <xsl:text>&#xA;</xsl:text>
                <xsl:if test="not($tname = '')">
                    <xsl:for-each select="for $i in 1 to $cnt return ' '">
                        <xsl:text>    </xsl:text>
                    </xsl:for-each>

                    <xsl:value-of select="name(.)"/>
                    <xsl:text>&#xA;</xsl:text>

                </xsl:if>

            </xsl:for-each>
        </xsl:message>
    </xsl:template>

    <xsl:template name="DebugShowParents">
        <xsl:message>
            <xsl:text>DebugShowParents1:</xsl:text>
        </xsl:message>
        <xsl:message>
            <!--HSX no more required since I'm using ancestor-or-self
            <xsl:value-of select="name(.)"/>
            -->

            <!-- Original version
            <xsl:for-each select="ancestor::*[not(self::root or self::path)]">
            -->
            <xsl:for-each select="ancestor-or-self::*">

                <xsl:variable name="id" select="./@id"/>
                <xsl:variable name="mapTopics" select="key('map-id', $id)"/>
                <!-- [DitaSpec#2.1.3.4.3.2] -->


                <xsl:variable name="cnt">
                    <xsl:value-of select="count(ancestor::*)"/>
                </xsl:variable>

                <xsl:variable name="tname">
                    <xsl:value-of select="name($mapTopics)"/>
                    <xsl:text>::</xsl:text>
                    <xsl:value-of select="name(../..)"/>
                    <xsl:text>::</xsl:text>
                    <xsl:value-of select="name(..)"/>
                    <xsl:text>::</xsl:text>
                    <xsl:value-of select="name(.)"/>
                </xsl:variable>

                <xsl:text>&#xA;</xsl:text>
                <xsl:if test="not($tname = '')">
                    <xsl:for-each select="for $i in 1 to $cnt return ' '">
                        <xsl:text>    </xsl:text>
                    </xsl:for-each>
                    <xsl:value-of select="$tname"/>
                </xsl:if>

            </xsl:for-each>
        </xsl:message>
    </xsl:template>

    <xsl:template name="DebugShowParentsAttr">
        <xsl:message>
            <xsl:text>DebugShowParents3:</xsl:text>
        </xsl:message>
        <xsl:message>
            <!--HSX no more required since I'm using ancestor-or-self
            <xsl:value-of select="name(.)"/>
            -->

            <!-- Original version
            <xsl:for-each select="ancestor::*[not(self::root or self::path)]">
            -->
            <xsl:for-each select="ancestor-or-self::*[not(self::root or self::path)]">
                <xsl:variable name="cnt">
                    <xsl:value-of select="count(ancestor::*)"/>
                </xsl:variable>

                <xsl:variable name="tname">
                    <xsl:value-of select="name(.)"/>
                    <!-- HSX show all attributes -->
                    <xsl:for-each select="attribute::*">
                        <xsl:text>|</xsl:text>
                        <xsl:value-of select="name(.)"/>
                        <xsl:text>=</xsl:text>
                        <xsl:value-of select="."/>
                    </xsl:for-each>
                </xsl:variable>

                <xsl:text>&#xA;</xsl:text>
                <xsl:if test="not($tname = '')">
                    <xsl:for-each select="for $i in 1 to $cnt return ' '">
                        <xsl:text>    </xsl:text>
                    </xsl:for-each>
                    <xsl:value-of select="$tname"/>
                </xsl:if>
            </xsl:for-each>
        </xsl:message>
    </xsl:template>

    <xsl:template name="DebugShowTest1">
        <xsl:message>
            <xsl:if test="ancestor::*/@id[. = //*/appendix/@id]">

                <xsl:variable name="topic" select="ancestor-or-self::*[contains(@class, ' topic/topic ')][1]"/>
                <xsl:variable name="id" select="$topic/@id"/>
                <xsl:variable name="mapTopics" select="key('map-id', $id)"/>


                <xsl:text>Test211:containsAppendix(</xsl:text>
                <xsl:value-of select="ancestor::*/@id"/>
                <xsl:text>)1(</xsl:text>
                <xsl:value-of select="ancestor::*/@outputclass"/>

                <xsl:text>)2(</xsl:text>
                <xsl:value-of select="//*/appendix/@id"/>

                <xsl:text>)3({</xsl:text>
                <xsl:value-of select="name($topic)"/>
                <xsl:text>}[</xsl:text>
                <xsl:value-of select="$id"/>
                <xsl:text>]</xsl:text>
                <xsl:value-of select="name($mapTopics)"/>

                <xsl:text>)-</xsl:text>
                <!--
                <xsl:call-template name="DebugShowParentsAttr" />
                -->
            </xsl:if>
        </xsl:message>
    </xsl:template>

    <xsl:template name="DebugShowTest2">
        <xsl:message>

            <xsl:variable name="topic" select="ancestor-or-self::*[contains(@class, ' topic/topic ')][1]"/>
            <xsl:variable name="id" select="$topic/@id"/>
            <xsl:variable name="mapTopics" select="key('map-id', $id)"/>


            <xsl:text>Test212:containsAppendix(</xsl:text>
            <xsl:value-of select="ancestor::*/@id"/>
            <xsl:text>)1(</xsl:text>
            <xsl:value-of select="ancestor::*/@outputclass"/>

            <!-- The ID of the appendix in the bookmap [DitaSpec#3.2.5.1.1] -->
            <xsl:text>)2(</xsl:text>
            <xsl:value-of select="//*/appendix/@id"/>
            <!-- The present node's topic type (e.g. concept) -->
            <xsl:text>)3({</xsl:text>
            <xsl:value-of select="name($topic)"/>
            <xsl:text>}[</xsl:text>
            <!-- The present node's id (e.g. unique_79) -->
            <xsl:value-of select="$id"/>
            <xsl:text>]</xsl:text>
            <!-- The present node's dita topic VERY GOOD (e.g. topicref) -->
            <xsl:value-of select="name($mapTopics)"/>

            <xsl:text>)-</xsl:text>
            <!--
            <xsl:call-template name="DebugShowParentsAttr" />
            -->
        </xsl:message>
    </xsl:template>

    <!--HSX Get the numbered title, this template has proven to match only 'title' topics
        For the computation of the title number see getTitleNumber
    -->
    <xsl:template match="*" mode="getNumTitle">
        <xsl:param name="sidecol" as="xs:boolean" select="false()"/>
        <xsl:param name="navTitle" as="xs:string" select="string('')"/>
        <xsl:param name="isFromNav" as="xs:boolean" select="false()"/>

        <!--
        <xsl:variable name="level" select="count(ancestor::*[contains(@class,' topic/topic ')])"/>
        -->

        <xsl:variable name="topicType">
            <xsl:call-template name="determineTopicType"/>
        </xsl:variable>

        <xsl:if test="contains($unittest, 'chkHead1')">
            <xsl:message>
                <xsl:text>[</xsl:text>
                <xsl:value-of select="$topicType"/>
                <xsl:text>] level=[</xsl:text>
                <xsl:value-of select="count(ancestor::*[contains(@class,' topic/topic ')])"/>
                <xsl:text>] pid=[</xsl:text>
                <xsl:value-of select="../@id"/>
                <xsl:text>] id=[</xsl:text>
                <xsl:value-of select="@id"/>
                <xsl:text>][</xsl:text>
                <xsl:value-of select="name()"/>
                <xsl:text>] ancs=[</xsl:text>
                <xsl:value-of select="ancestor::*/name()"/>



                <xsl:text>] backmatterid=[</xsl:text>
                <xsl:value-of select="$map//backmatter/@id"/>

                <xsl:variable name="myId" select="../@id"/>
                <xsl:variable name="nameOk">
                    <xsl:value-of select="($map//*[@id = $myId])/name()"/>
                </xsl:variable>

                <xsl:variable name="mapTopics" select="key('map-id', $myId)"/>


                <xsl:if test="string-length($nameOk) &gt; -1">
                    <xsl:text>] bmPos=[</xsl:text>
                    <xsl:value-of select="count($map//backmatter/preceding::*)"/>
                    <xsl:variable name="myId" select="../@id"/>
                    <xsl:text>] myPos=[</xsl:text>
                    <xsl:value-of select="$myId"/>
                    <xsl:text>]&#xA; prec:[</xsl:text>
                    <xsl:value-of select="$nameOk"/>
                    <xsl:text>]&#xA; My[</xsl:text>
                    <xsl:value-of select="../name()"/>
                    <xsl:text>]ParentAnc's[</xsl:text>
                    <xsl:value-of select="($map//*[@id = $myId])/ancestor::*/name()"/>
                    <xsl:text>]&#xA;==============================================&#xA;title = </xsl:text>
                    <xsl:apply-templates/>
                    <xsl:text>&#xA;==============================================</xsl:text>
                </xsl:if>

                <xsl:if test="contains(@id, 'HSXT:xtrx')">
                    <xsl:text>&#xA;YYYYY map YYYYYY&#xA;</xsl:text>
                    <xsl:call-template name="DebugShowMap">
                        <xsl:with-param name="cnode" select="$map"/>
                        <xsl:with-param name="indent" select="''"/>
                    </xsl:call-template>
                    <xsl:text>&#xA;YYYYY ENDE YYYYYY&#xA;</xsl:text>
                </xsl:if>


                <xsl:if test="contains(@id, 'HSXT:xtx')">
                    <xsl:text>&#xA;ZZZZ mapTopics ZZZZZ&#xA;</xsl:text>
                    <xsl:call-template name="DebugShowMap">
                        <xsl:with-param name="cnode" select="$mapTopics"/>
                        <xsl:with-param name="indent" select="''"/>
                    </xsl:call-template>
                    <xsl:text>&#xA;ZZZZ ENDE ZZZZZ&#xA;</xsl:text>
                </xsl:if>

                <!--
                <xsl:text>&#xA;[</xsl:text>
                <xsl:for-each select="ancestor::*/@class">
                    <xsl:text>(</xsl:text>
                    <xsl:value-of select="."/>
                    <xsl:text>)  </xsl:text>
                </xsl:for-each>
                <xsl:text>]&#xA;[</xsl:text>
                -->
            </xsl:message>
        </xsl:if>

        <xsl:variable name="titleNumber">
            <!--Add title numbers to topic titles ONLY-->
            <!-- trademark is bookmap/concept/topic/title  .. there's no path to the bookmap association -->

            <!--HSC this did a lot of help to determine the prime topic type,
            I had to extend 'determineTopicType' to catch abstract
            <xsl:variable name="topic" select="ancestor-or-self::*[contains(@class, ' topic/topic ')][1]" />
            <xsl:variable name="id" select="$topic/@id" />
            <xsl:variable name="mapTopics" select="key('map-id', $id)" />
            <xsl:message>
            <xsl:for-each select="$mapTopics[1]">
            <xsl:value-of select="name(.)"/>
            </xsl:for-each>
            </xsl:message>
            -->

            <xsl:choose>
                <xsl:when test="$topicType = 'topicPreface'"> </xsl:when>
                <xsl:when test="$topicType = 'topicAbstract'"> </xsl:when>
                <!--HSX2:emptyTitle avoids printing chapter number of empty titles
                However, the actual title number is created in getTitleNumber
                -->
                <xsl:when test="string-length(normalize-space(.)) = 0"> </xsl:when>
                <xsl:when test="$topicType = 'topicNotices'"> </xsl:when>
                <xsl:otherwise>
                    <!--HSC was very helpful to learn parent structure, I discovered that the
                    actual notice content appears a normal concept topic, you cannot learn from it
                    to be part of frontmatter. The solution was the other way around to detect
                    whether something is part of a chapter

                    [DtPrt11.5] also shows an example to search/specify a whole parent chain
                    <xsl:message>
                    <xsl:call-template name="DebugShowParents" />
                    </xsl:message>
                    -->

                    <!--Debug attributes  - also was very helpful
                    <xsl:message>
                    <xsl:for-each select="attribute::*">
                    <xsl:value-of select="name(.)"/>="<xsl:value-of select="."/>"
                    </xsl:for-each>
                    </xsl:message>
                    -->

                    <!--HSX This call provides the title number for the chapters -->
                    <xsl:if test="parent::*[contains(@class,' topic/topic ')]">
                        <xsl:call-template name="getTitleNumber"/>
                    </xsl:if>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <!-- add keycol here once implemented-->
            <xsl:when test="@spectitle">
                <xsl:value-of select="@spectitle"/>
            </xsl:when>
            <!-- Suppress numbering of the glossary subchapters -->
            <xsl:when test="parent::*[contains(@class,'topic/topic')][@id = //*/glossarylist/@id]">
                <xsl:apply-templates/>
            </xsl:when>

            <xsl:otherwise>
                <!--HSC determine whether title number contains '.'
                This is to avoid sub-numbering on notices/preface (abstract doesn't allow subchapters)

                If there is no '.' then we have not seen a chapter before (notices/preface/first chapter)
                which could, however, also occur for the first chapter
                Therefore, before we avoid numbering, we need to check the chapter/@id -->
                <xsl:variable name="titleNum">
                    <xsl:value-of select="$titleNumber"/>
                </xsl:variable>
                <!--                <xsl:value-of select="$titleNum" />   -->
                <!--HSC we need to be explicit not to drop the first occurrence of a chapter -->

                <!--HSX Here we create the title number for Head 1 chapters
                    for all chapters, topicref, topicset as ancestors
                -->
                <xsl:if test="not(contains($titleNumber, '.'))">
                    <xsl:variable name="tempId1">
                        <xsl:value-of select="ancestor-or-self::*/@id[. = //*/chapter/@id]"/>
                        <!-- opentopic:map/*[contains(@class, ' map/topicref ')] -->
                    </xsl:variable>

                    <xsl:variable name="tempId2">
                        <xsl:value-of select="ancestor-or-self::*/@id[. = //*/topicref/@id]"/>
                        <!-- opentopic:map/*[contains(@class, ' map/topicref ')] -->
                    </xsl:variable>

                    <xsl:variable name="tempId3">
                        <xsl:value-of select="ancestor-or-self::*/@id[. = //*/topicset/@id]"/>
                        <!-- opentopic:map/*[contains(@class, ' map/topicref ')] -->
                    </xsl:variable>

                    <xsl:if test="contains($unittest, 'chkHead2')">
                        <xsl:message>
                            <xsl:text>from21:[</xsl:text>
                            <xsl:value-of select="$titleNumber"/>
                            <xsl:text>] tempId1 = </xsl:text>
                            <xsl:value-of select="$tempId1"/>
                            <xsl:text>tempId2 = </xsl:text>
                            <xsl:value-of select="$tempId2"/>
                        </xsl:message>
                    </xsl:if>

                    <!--HSX Print the title number -->
                    <xsl:choose>
                        <!--HSX if our topic type is appendix, we do not want to generate a number.
                        The handling for the creation of the Appendix letter is already done
                        in
                        TOC: toc.xsl     <xsl:template match="*[contains(@class, ' bookmap/appendix ')]" mode="tocPrefix">
                        TXT: commons.xsl <xsl:template name="insertChapterFirstpageStaticContent">

                        We know being appendix from the $topicType
                        -->
                        <xsl:when test="$topicType ='topicAppendix'"/>

                        <xsl:when test="not($tempId1 = '')">
                            <xsl:value-of select="$titleNum"/>
                        </xsl:when>
                        <xsl:when test="not($tempId2 = '')">
                            <xsl:value-of select="$titleNum"/>
                        </xsl:when>
                        <xsl:when test="not($tempId3 = '')">
                            <xsl:value-of select="$titleNum"/>
                        </xsl:when>
                    </xsl:choose>
                </xsl:if>

                <!--HSC on normal subchapters, we proceed normally -->

                <!--HSX
                Convert the side-col-width in mm
                (you may choose any other unit of your personal preference
                in the 'inUnitsOf' parameter)
                This is important to allow later comparison with a number
                that doesn't have a unit.
                -->
                <xsl:variable name="mmSideColWidth">
                    <xsl:call-template name="convertUnits">
                        <xsl:with-param name="numUnit" select="$side-col-width"/>
                        <xsl:with-param name="inUnitsOf" select="'mm'"/>
                    </xsl:call-template>
                </xsl:variable>

                <!--HSC HERE WE PRINT THE TITLE NUMBER for any subchapter -->
                <xsl:if test="contains($titleNumber, '.')">
                    <xsl:choose>
                        <xsl:when test="$indentSubtitleText and $sidecol and ($mmSideColWidth &gt;= $minSideColWidth-mm)">
                            <fo:float float="start" clear="both">
                                <fo:block-container font-size="from-nearest-specified-value(font-size)"
                                                    font-weight="from-nearest-specified-value(font-weight)">
                                    <xsl:attribute name="width">
                                        <xsl:value-of select="$side-col-width"/>
                                    </xsl:attribute>
                                    <!--HSX padding-top=0pt is important since it adds to the previous one-->
                                    <fo:block padding-top="0pt">
                                        <xsl:value-of select="$titleNum"/>
                                    </fo:block>
                                </fo:block-container>
                            </fo:float>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$titleNum"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:if>

                <!--HSX test whether we allow indent of Heading Text to side-col-width
                1. $sidecol shall be true - the caller determines whether he
                wants the margin being set, important, since we need to
                avoid to indent on TOC, bookmarks etc.

                2. We are in a numbered chapter - all other types
                (notices, abstract preface etc.)shall not apply for
                indenting the text

                3. side-col-width is larger 20 mm to avoid crashing with long
                chapter numbering.

                <xsl:variable name="HeadtextIndent">
                <xsl:choose>
                <xsl:when test="$AHF=0">
                <xsl:value-of select='concat(format-number($mmSideColWidth,"#.00"), "mm")' />
                </xsl:when>
                <xsl:otherwise>
                <xsl:value-of select='concat(format-number($mmSideColWidth div 2,"#.00"), "mm")' />
                </xsl:otherwise>
                </xsl:choose>
                </xsl:variable>
                -->

                <xsl:choose>
                    <xsl:when test="$sidecol and ($mmSideColWidth &gt;= $minSideColWidth-mm) and contains($titleNumber, '.')">
                        <!--HSX Get chapter level
                        <xsl:variable name="level" as="xs:integer">
                        <xsl:apply-templates select="." mode="get-topic-level"/>
                        </xsl:variable>
                        -->
                        <!--HSX Create attribute name
                        <xsl:variable name="upshift">
                        <xsl:value-of select="concat('upshift.', $level)"/>
                        </xsl:variable>
                        -->

                        <!--HSX Create the fo-block with the actual output, you cannot use fo:inline-block since you cannot place that
                        to an absolute position -->
                        <fo:inline-container>
                            <!-- [XslFO#6.6.8] -->

                            <!--HSX here we shift the block with the text up to the number position
                            Since I found a solution with fo:inline-container width=$side-col-width (see above) I
                            do not need to upshift the flow anymore. But it was a good exercise to understand "processAttrSetReflection"
                            <xsl:call-template name="processAttrSetReflection">
                            <xsl:with-param name="attrSet" select="$upshift"/>
                            <xsl:with-param name="path" select="'../../cfg/fo/attrs/commons-attr.xsl'"/>
                            </xsl:call-template>
                            -->
                            <!--HSX set the left margin, if we are antenna-house, then we need to  devide the margin-left value
                            since it seems to be doubled by the following block statement <xsl:value-of select="$HeadtextIndent" />
                            -->
                            <xsl:attribute name="margin-left">0mm</xsl:attribute>
                            <xsl:attribute name="start-indent">0mm</xsl:attribute>

                            <!--HSC HERE WE PRINT THE TITLE TEXT with side-col-width indent,
                                we respect a possible navtitle from the caller
                            -->
                            <xsl:choose>
                                <!--HSC ============= HERE we print the PAGE TITLE NAVTITLE text (if given) ========== -->
                                <xsl:when test="string-length($navTitle) &gt; 0">
                                    <fo:block>
                                        <xsl:value-of select="$navTitle"/>
                                    </fo:block>
                                </xsl:when>
                                <!--HSC ============= HERE we print the PAGE TITLE text ========== -->
                                <xsl:otherwise>
                                    <fo:block>
                                        <!--HSC fo:block described in [Xslfo#fo:block] , line building on [Xslfo#4.7.2] -->
                                        <xsl:apply-templates/>
                                    </fo:block>
                                </xsl:otherwise>
                            </xsl:choose>
                        </fo:inline-container>
                    </xsl:when>
                    <xsl:otherwise>

                        <!--HSC HERE WE PRINT THE TITLE TEXT w/o side-col-width aligment
                            or whenever we have a head 1 title-->
                        <xsl:choose>
                            <!--HSC ============= HERE we print the BOOKMARKS/TOC NAVTITLE text (if given) ========== -->
                            <xsl:when test="string-length($navTitle) &gt; 0">
                                <xsl:value-of select="$navTitle"/>
                            </xsl:when>
                            <!--HSX if we print TOC and Bookmarks, then only the
                                    text is allowed [xslfo#6.11.3], hence we
                                    only deliver the plain text. This should not
                                    be critical, but can be improved to allow at least
                                    'sup' and 'sub' for correct display
                            -->
                            <!--HSC ============= HERE we print the BOOKMARKS title text ========== -->
                            <xsl:when test="$isFromNav">
                                <!--HSX value-of in order to avoid unallowed elements in bookmarks -->
                                <xsl:value-of select="."/>
                            </xsl:when>
                            <!--HSC ============= HERE we print the TOC title text, allows elements ========== -->
                            <xsl:otherwise>
                                <xsl:apply-templates/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--HSX
    http://stackoverflow.com/questions/6083800/xsl-convert-translate-template

    Below we find the factors for a specific unit into mm
    -->
    <my:units>
        <unit name="pt">19.95</unit>
        <unit name="in">1440</unit>
        <unit name="cm">567</unit>
        <unit name="mm">56.7</unit>
        <unit name="em">240</unit>
        <unit name="px">15</unit>
        <unit name="pc">240</unit>
    </my:units>

    <xsl:variable name="vUnits" select="document('')/*/my:units/*"/>

    <xsl:template name="convertUnits" as="xs:double">
        <xsl:param name="numUnit"/>
        <xsl:param name="inUnitsOf"/>
        <xsl:variable name="vQ">
            <xsl:analyze-string select="$numUnit" regex="{'[0-9,\.]+'}">
                <xsl:matching-substring>
                    <number>
                        <xsl:value-of select="."/>
                    </number>
                </xsl:matching-substring>
            </xsl:analyze-string>
        </xsl:variable>

        <xsl:variable name="vU">
            <xsl:variable name="sUnit">
                <xsl:analyze-string select="$numUnit" regex="{'[a-z]+'}">
                    <xsl:matching-substring>
                        <number>
                            <xsl:value-of select="."/>
                        </number>
                    </xsl:matching-substring>
                </xsl:analyze-string>
            </xsl:variable>
            <xsl:choose>
                <xsl:when test="string-length(normalize-space($sUnit)) = 0">
                    <!--HSX apply millimeter as default -->
                    <xsl:value-of select="'mm'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$sUnit"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="normUnit">
            <num>
                <xsl:value-of select="$vQ * $vUnits[@name=$vU] div $vUnits[@name=$inUnitsOf]"/>
            </num>
        </xsl:variable>
        <xsl:value-of select="$normUnit"/>

        <!--HSX
        <xsl:message>
        <xsl:text>vU=</xsl:text>
        <xsl:value-of select="$vU" />
        </xsl:message>

        <xsl:message>
        <xsl:text>vQ=</xsl:text>
        <xsl:value-of select="$vQ" />
        </xsl:message>

        <xsl:message>
        <xsl:text>normUnit=</xsl:text>
        <xsl:value-of select="$normUnit" />
        </xsl:message>

        <xsl:text>&#xA;</xsl:text>
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/titlealts ')]">
        <xsl:if test="$DRAFT='yes'">
            <xsl:if test="*">
                <fo:block xsl:use-attribute-sets="titlealts">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:if>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/navtitle ')]">
        <fo:block xsl:use-attribute-sets="navtitle">
            <xsl:call-template name="commonattributes"/>
            <fo:inline xsl:use-attribute-sets="navtitle__label">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Navigation title'"/>
                </xsl:call-template>
                <xsl:text>: </xsl:text>
            </fo:inline>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <!-- Map uses map/searchtitle, topic uses topic/searchtitle. This will likely be changed
    to a single value in DITA 2.0, but for now, recognize both. -->
    <xsl:template
        match="*[contains(@class,' topic/titlealts ')]/*[contains(@class,' topic/searchtitle ')] |
        *[contains(@class,' topic/titlealts ')]/*[contains(@class,' map/searchtitle ')]">
        <fo:block xsl:use-attribute-sets="searchtitle">
            <xsl:call-template name="commonattributes"/>
            <fo:inline xsl:use-attribute-sets="searchtitle__label">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Search title'"/>
                </xsl:call-template>
                <xsl:text>: </xsl:text>
            </fo:inline>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/abstract ')]">
        <fo:block xsl:use-attribute-sets="abstract">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <!-- For SF Bug 2879171: modify so that shortdesc is inline when inside
    abstract with only other text or inline markup. -->
    <xsl:template match="*[contains(@class,' topic/shortdesc ')]">
        <xsl:variable name="format-as-block" as="xs:boolean">
            <xsl:choose>
                <xsl:when test="not(parent::*[contains(@class,' topic/abstract ')])">
                    <xsl:sequence select="true()"/>
                </xsl:when>
                <xsl:when
                    test="preceding-sibling::*[contains(@class,' topic/p ') or contains(@class,' topic/dl ') or
                    contains(@class,' topic/fig ') or contains(@class,' topic/lines ') or
                    contains(@class,' topic/lq ') or contains(@class,' topic/note ') or
                    contains(@class,' topic/ol ') or contains(@class,' topic/pre ') or
                    contains(@class,' topic/simpletable ') or contains(@class,' topic/sl ') or
                    contains(@class,' topic/table ') or contains(@class,' topic/ul ')]">
                    <xsl:sequence select="true()"/>
                </xsl:when>
                <xsl:when
                    test="following-sibling::*[contains(@class,' topic/p ') or contains(@class,' topic/dl ') or
                    contains(@class,' topic/fig ') or contains(@class,' topic/lines ') or
                    contains(@class,' topic/lq ') or contains(@class,' topic/note ') or
                    contains(@class,' topic/ol ') or contains(@class,' topic/pre ') or
                    contains(@class,' topic/simpletable ') or contains(@class,' topic/sl ') or
                    contains(@class,' topic/table ') or contains(@class,' topic/ul ')]">
                    <xsl:sequence select="true()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:sequence select="false()"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="$format-as-block">
                <xsl:apply-templates select="." mode="format-shortdesc-as-block"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="." mode="format-shortdesc-as-inline"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="format-shortdesc-as-block">
        <!--
        fo:block xsl:use-attribute-sets="shortdesc" id="{@id}">
        <xsl:apply-templates/>
        </fo:block
        -->
        <!--compare the length of shortdesc with the got max chars-->
        <fo:block xsl:use-attribute-sets="topic__shortdesc">
            <xsl:call-template name="commonattributes"/>
            <!-- If the shortdesc is sufficiently short, add keep-with-next. -->
            <xsl:if test="string-length(.) lt $maxCharsInShortDesc">
                <!-- Low-strength keep to avoid conflict with keeps on titles. -->
                <xsl:attribute name="keep-with-next.within-page">5</xsl:attribute>
            </xsl:if>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*" mode="format-shortdesc-as-inline">
        <fo:inline xsl:use-attribute-sets="shortdesc">
            <xsl:call-template name="commonattributes"/>
            <xsl:if test="preceding-sibling::* | preceding-sibling::text()">
                <xsl:text> </xsl:text>
            </xsl:if>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class,' map/shortdesc ')]">
        <xsl:apply-templates select="." mode="format-shortdesc-as-block"/>
    </xsl:template>

    <!--HSX future extension - match data field of any front-page extension
    <xsl:template match="data" mode="dita-ot:text-only">
        <xsl:text>DATAMATCH</xsl:text>
    </xsl:template>
    -->

    <!--HSC This template prints the shortdesc on Head2+ chapters -->
    <xsl:template match="*[contains(@class, ' topic/topic ')]/*[contains(@class,' topic/shortdesc ')]" priority="1">
        <xsl:variable name="topicType" as="xs:string">
            <xsl:call-template name="determineTopicType"/>
        </xsl:variable>
        <xsl:if test="contains($PageLayout, 'print_shortdesc')">
            <xsl:choose>
                <!--  Disable chapter summary processing when mini TOC is created -->
            <xsl:when test="$topicType = ('topicChapter', 'topicAppendix') and
                            $chapterLayout != 'BASIC'"/>
                <!--   Normal processing         -->
                <xsl:otherwise>
                    <xsl:apply-templates select="." mode="format-shortdesc-as-block"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
    </xsl:template>

    <xsl:template name="getMaxCharsForShortdescKeep" as="xs:integer">
        <!-- These values specify the length of a short description that will
        render with keep-with-next set, which should be (approximately) the
        character count in three lines of rendered shortdesc text. If you customize the
        default font, page margins, or shortdesc attribute sets, you may need
        to change these values. -->
        <xsl:choose>
            <xsl:when test="$locale = 'en_US' or $locale = 'fr_FR'">
                <xsl:sequence select="360"/>
            </xsl:when>
            <xsl:when test="$locale = 'ja_JP'">
                <xsl:sequence select="141"/>
            </xsl:when>
            <xsl:when test="$locale = 'zh_CN'">
                <xsl:sequence select="141"/>
            </xsl:when>
            <!-- Other languages require a template override to generate
            keep-with-next
            on shortdesc. Data was not available at the time this code released.
            -->
            <xsl:otherwise>
                <xsl:sequence select="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- this is the fallthrough body for nested topics -->
    <xsl:template match="*[contains(@class,' topic/body ')]">
        <xsl:variable name="level" as="xs:integer">
            <xsl:apply-templates select="." mode="get-topic-level"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="not(node())"/>
            <xsl:when test="$level = 1">
                <fo:block xsl:use-attribute-sets="body__toplevel">
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:when>
            <xsl:when test="$level = 2">
                <fo:block xsl:use-attribute-sets="body__secondLevel">
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:when>
            <xsl:otherwise>
                <fo:block xsl:use-attribute-sets="body">
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/bodydiv ')]">
        <fo:block>
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/section ')]
        [@spectitle != '' and not(*[contains(@class, ' topic/title ')])]"
        mode="dita2xslfo:section-heading" priority="10">
        <fo:block xsl:use-attribute-sets="section.title">
            <xsl:call-template name="commonid"/>
            <xsl:variable name="spectitleValue" as="xs:string" select="string(@spectitle)"/>
            <xsl:variable name="resolvedVariable">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="$spectitleValue"/>
                </xsl:call-template>
            </xsl:variable>
            <xsl:sequence
                select="if (not(normalize-space($resolvedVariable)))
                then $spectitleValue
            else $resolvedVariable"/>
        </fo:block>

    </xsl:template>
    <xsl:template match="*[contains(@class,' topic/section ')]" mode="dita2xslfo:section-heading">
        <!-- Specialized section elements may override this rule to add
        default headings for a section. By default, titles are processed
        where they exist within the section, so overrides may need to
        check for the existence of a title first. -->
    </xsl:template>

    <!--HSX changed:do not set section attributes if the title does it anyway-->
    <!--HSX:20150429 I pulled back, not knowing what I wanted to solve with the choose.
    Problem was ... with my change a section didn't get an id anymore, which is
    important, however, to have to allow referring to a section. In particular
    the xref handler checks whether the referred section has a title and will
    insert the title if the xref itself doesn't have its own text -->
    <xsl:template match="*[contains(@class,' topic/section ')]">
        <!-- removed my own change -->
        <xsl:choose>
            <xsl:when test="title and (string-length(normalize-space(title)) &gt; 0)">
                <fo:block xsl:use-attribute-sets="section">
                    <xsl:call-template name="chkNewpage"/>
                    <xsl:call-template name="commonid"/>
                    <xsl:apply-templates select="." mode="dita2xslfo:section-heading"/>
                    <xsl:apply-templates/>        
                </fo:block>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="*[not(contains(@class, ' topic/title '))]"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/sectiondiv ')]">
        <fo:block>
            <xsl:call-template name="commonid"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/example ')]">
        <fo:block xsl:use-attribute-sets="example">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/desc ')]">
        <fo:inline xsl:use-attribute-sets="desc">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/prolog ')]"/>
    <!--
    <fo:block xsl:use-attribute-sets="prolog">
    <xsl:apply-templates/>
    </fo:block>
    -->
    <!--xsl:copy-of select="node()"/-->
    <!--xsl:apply-templates select="descendant::opentopic-index:index.entry[not(parent::opentopic-index:index.entry)]"/-->
    <!--/xsl:template-->

    <xsl:template name="pullPrologIndexTerms">
        <!-- index terms and ranges from topic -->
        <xsl:apply-templates
            select="ancestor-or-self::*[contains(@class, ' topic/topic ')][1]/*[contains(@class, ' topic/prolog ')]
        //opentopic-index:index.entry[not(parent::opentopic-index:index.entry) and not(@end-range = 'true')]"/>
        <!-- index ranges from map -->
        <xsl:variable name="topicref" select="key('map-id', @id)"/>
        <xsl:apply-templates
            select="$topicref/
            *[contains(@class, ' map/topicmeta ')]/
            *[contains(@class, ' topic/keywords ')]/
            descendant::opentopic-index:index.entry[@start-range = 'true']"
        />
    </xsl:template>

    <xsl:template name="pullPrologIndexTerms.end-range">
        <!-- index ranges from topic -->
        <xsl:apply-templates
            select="ancestor-or-self::*[contains(@class, ' topic/topic ')][1]/
            *[contains(@class, ' topic/prolog ')]/
            descendant::opentopic-index:index.entry[not(parent::opentopic-index:index.entry) and
        @end-range = 'true']"/>
        <!-- index ranges from map -->
        <xsl:variable name="topicref" select="key('map-id', @id)"/>
        <xsl:apply-templates
            select="$topicref/
            *[contains(@class, ' map/topicmeta ')]/
            *[contains(@class, ' topic/keywords ')]/
            descendant::opentopic-index:index.entry[@end-range = 'true']"
        />
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/metadata ')]">
        <!--
        <fo:block xsl:use-attribute-sets="metadata">
        <xsl:apply-templates/>
        </fo:block>
        -->
        <xsl:apply-templates select="descendant::opentopic-index:index.entry[not(parent::opentopic-index:index.entry)]"/>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/div ')]">
        <fo:block xsl:use-attribute-sets="div">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>


    <!-- Count preceding siblings, get distance from title
    The following template counts the number of preceding topics
    (ancestor or sibling) until a title topic (or none) is found.
    The return value is the distance to the prior title.
    If zero (0), then we did not find any title.
    -->

    <xsl:template name="condKeep">
        <xsl:variable name="titleDistance">
            <xsl:call-template name="getDist"/>
        </xsl:variable>

        <xsl:if test="(($titleDistance &gt; 0) and ($titleDistance &lt; $maxKeepLines)) or
            contains(@outputclass, 'keep')">
            <!--
            <xsl:attribute name="keep-with-previous.within-column" select="'always'"/>
            -->
            <xsl:attribute name="keep-with-previous" select="'1'"/>
        </xsl:if>
    </xsl:template>

    <!--HSX we want to count the number of topics between the current topic
            and any previous title
    -->
    <xsl:template name="getDist">
        <xsl:choose>
            <xsl:when test="(ancestor::*/title)[last()]">
                <xsl:variable name="MyAncestors" select="ancestor-or-self::*" as="node()*"/>

                <xsl:call-template name="chkDist">
                    <xsl:with-param name="anclevel" select="count($MyAncestors)"/>
                    <xsl:with-param name="anclist" select="$MyAncestors" as="node()*"/>
                    <xsl:with-param name="chkNode" select="."/>
                    <xsl:with-param name="cnt" select="1"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="0"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--HSX visit preceding node or ancestor until 'title' with
        'endid' is found or no further node
    -->
    <xsl:template name="chkDist">
        <xsl:param name="anclevel"/>
        <xsl:param name="anclist" as="node()*"/>
        <xsl:param name="chkNode" as="node()"/>
        <xsl:param name="cnt"/>

        <!-- proving that conbody does not return any neighbours
        <xsl:if test="$chkNode/name() = 'conbody'">
            <xsl:message>
                <xsl:text>CONBODY:&#xA;parent = </xsl:text>
                <xsl:value-of select="$chkNode/../name()"/>
                <xsl:text>&#xA;cntPrecSib = </xsl:text>
                <xsl:value-of select="count($chkNode/preceding-sibling::*)"/>
                <xsl:text>&#xA;cntPreceding = </xsl:text>
                <xsl:value-of select="count($chkNode/preceding::*)"/>
                <xsl:text>&#xA;cntChildren = </xsl:text>
                <xsl:value-of select="count($chkNode/child::*)"/>
                <xsl:text>&#xA;cntAnc = </xsl:text>
                <xsl:value-of select="count($chkNode/ancestor::*)"/>
                <xsl:text>&#xA;Anc = </xsl:text>
                <xsl:value-of select="($chkNode/ancestor::*[last()])/name()"/>
            </xsl:message>
        </xsl:if>
        -->

        <xsl:variable name="myId" select="generate-id($chkNode)"/>
        <xsl:variable name="addofs" select="count(preceding-sibling::*[string-length(normalize-space(.)) &gt; 0])"/>

        <xsl:choose>
            <!--HSX First check whether we are within a title, if yes report no distance
                because the title never needs to connect to any previous topic
            -->
            <xsl:when test="$chkNode/../name() = 'title'">
                <xsl:value-of select="0"/>
            </xsl:when>

            <!--HSX if we hit the upper parents bookmap/topic-concept-task-glossary-reference
                    the we may give up with the present count, no reason to continue search

                    Honestly .. we should never see this, we wouldn't be here if there was
                    no title to meet before
            -->
            <xsl:when test="$anclevel = 1">
                <xsl:value-of select="$cnt"/>
                <xsl:message>
                    <xsl:text>Fatal Error - SHOULD NOT APPEAR</xsl:text>
                    <xsl:for-each select="ancestor::*">
                        <xsl:value-of select="name()"/>
                        <xsl:text> : </xsl:text>
                    </xsl:for-each>
                </xsl:message>
            </xsl:when>

            <!--HSX we do not count the title text to be correct, hence -1 -->
            <xsl:when test="$chkNode/preceding-sibling::title">
                <xsl:value-of select="$cnt + $addofs - 1"/>
            </xsl:when>

            <!--HSX if chkNode=concept there's a system problem, conbody doesn't
                    not provide any preceding-siblings. Hence we jump to its
                    parent (concept) and check whether it has a child:title.
                    The existance allows to know that we are at the end
                    of our quest.
            -->
            <xsl:when test="$chkNode/child::title">
                <xsl:value-of select="$cnt + $addofs"/>
            </xsl:when>

            <!-- We have not found a title in the preceding-siblings
                 therefore we select the parent. We have to go throughout
                 $anclist because a conbody would not deliver its parent
                 by conbody/parent::
            -->
            <xsl:otherwise>
                 <xsl:variable name="nextanc" as="node()">
                     <xsl:copy-of select="$anclist[$anclevel - 1]"/>
                 </xsl:variable>

                 <xsl:call-template name="chkDist">
                     <xsl:with-param name="anclevel" select="$anclevel - 1"/>
                     <xsl:with-param name="anclist"  select="$anclist"/>
                     <xsl:with-param name="chkNode"  select="$nextanc" as="node()"/>
                     <xsl:with-param name="cnt" select="$cnt + $addofs"/>
                 </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>



    <!--HSX since the paragraph can also be applied to text within other parents (e.g. example)
    the indentation needs to come from the parent in such a case. An "example" topic with
    a paragraph tag p did put the paragraph to normal attributs (commonattibutes) although
    it should have inherited its indentation from the example parent.

    So the base definition of paragraph is not enough and it it fixed here
    -->

    <xsl:template match="*[contains(@class, ' topic/p ')]">
        <!--HSX
        check how far we are away from the previous title,
        commonattibutes could later do the general check

        if we are away from a previous title ancestor ....
        set keep-with-previous.within-column="always"  attribute

        -->

        <xsl:variable name="mmSideColWidth">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="$side-col-width"/>
                <xsl:with-param name="inUnitsOf" select="'mm'"/>
            </xsl:call-template>
        </xsl:variable>

        <!--HSX specify marginalia space as 4mm -->
        <xsl:variable name="mrgWidth">
            <xsl:value-of select="concat($mmSideColWidth - 4,'mm')"/>
        </xsl:variable>

        <xsl:variable name="myPos" select="position()"/>

        <!-- HSX3 TCT specific -->
        <xsl:variable name="ancPos" select="ancestor::*[contains(@outputclass, 'Block.')][last()]/position()"/>

        <!-- HSX avoid indentation if the parent is something special, e.g. example or table entry -->
        <xsl:choose>
            <xsl:when
                test="ancestor::*[contains(@class, ' topic/example ') or
                contains(@class, ' glossgroup/glossgroup ') or
                contains(@class, ' topic/stentry ') or
                contains(@class, ' topic/entry ')]">
                <fo:block xsl:use-attribute-sets="compact p parent__indent">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:call-template name="checkCompact"/>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:when>

            <!-- avoid any 'p' formatting in lists and note -->
            <xsl:when
                test="ancestor::*[contains(@class, ' topic/sl ') or
                contains(@class, ' topic/note ') or
                contains(@class, ' pr-d/plentry ') or
                contains(@class, ' topic/ol ') or
                contains(@class, ' topic/dlentry ') or
                contains(@class, ' topic/ul ')
                ]">
                <fo:block xsl:use-attribute-sets="compact">
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:when>

            <!--HSX We allow 'mrg' but also 'mrg:heading' where 'heading'
            specifies the style. In the following when- section we
            can suppport different layouts for the potential styles
            -->

            <xsl:when test="@outputclass[contains(., 'mrg')]">
                <xsl:variable name="style">
                    <!-- \S means all chars but spaces, \s means spaces [Xslt#14.10] -->
                    <xsl:analyze-string select="@outputclass" regex="{'mrg:(\S+).*'}">
                        <xsl:matching-substring>
                            <xsl:value-of select="regex-group(1)"/>
                        </xsl:matching-substring>
                    </xsl:analyze-string>
                </xsl:variable>

                <!--HSX take in the id and set the keep conditions -->
                <fo:block space-before="10pt">
                    <xsl:call-template name="commonattributes"/>
                </fo:block>

                <xsl:choose>
                    <!--HSX if outputclass=heading, then we need a paragraph that works
                    in the marginalia flow but has just some other formatting
                    -->
                    <xsl:when test="$style = 'heading'">
                        <fo:float float="start" clear="both" xsl:use-attribute-sets="p_marginalia_heading">
                            <xsl:call-template name="condKeep"/>
                            <fo:block-container padding-top="1pt">
                                <xsl:attribute name="width">
                                    <xsl:value-of select="$mrgWidth"/>
                                </xsl:attribute>
                                <fo:block>
                                    <xsl:apply-templates/>
                                </fo:block>
                            </fo:block-container>
                        </fo:float>
                    </xsl:when>
                    <xsl:when test="$style = 'dialog'">
                        <fo:float float="start" clear="both" xsl:use-attribute-sets="p_marginalia_dialog">
                            <xsl:call-template name="condKeep"/>
                            <fo:block-container xsl:use-attribute-sets="p_marginalia_dialog_content">
                                <xsl:attribute name="width">
                                    <xsl:value-of select="$mrgWidth"/>
                                </xsl:attribute>
                                <fo:block>
                                    <!--HSC external graphic in [Xslfo#6.6.5] -->
                                    <fo:external-graphic src="url(Customization/OpenTopic/common/artwork/dialog.png)"/>
                                </fo:block>
                            </fo:block-container>
                        </fo:float>
                        <fo:block xsl:use-attribute-sets="p_marginalia_dialog_text">
                            <xsl:call-template name="commonattributes"/>
                            <xsl:apply-templates/>
                        </fo:block>
                    </xsl:when>
                    <xsl:when test="$style = 'right'">
                        <fo:float float="start" clear="both" xsl:use-attribute-sets="p_marginalia">
                            <xsl:call-template name="condKeep"/>
                            <fo:block-container padding-top="2pt">
                                <xsl:attribute name="width">
                                    <xsl:value-of select="$mrgWidth"/>
                                </xsl:attribute>
                                <fo:block text-align="end" text-align-last="end">
                                    <xsl:apply-templates/>
                                </fo:block>
                            </fo:block-container>
                        </fo:float>
                    </xsl:when>
                    <xsl:otherwise>
                        <fo:float float="start" clear="both" xsl:use-attribute-sets="p_marginalia">
                            <xsl:call-template name="condKeep"/>
                            <fo:block-container padding-top="2pt">
                                <xsl:attribute name="width">
                                    <xsl:value-of select="$mrgWidth"/>
                                </xsl:attribute>
                                <fo:block>
                                    <xsl:apply-templates/>
                                </fo:block>
                            </fo:block-container>
                        </fo:float>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>

            <!--HSX do not advance paragraph if marginalia was set on previous topic
            We might have a section or a section with title, so we have to check
            the preceding siblings [1][2] to catch a paragraph that just follows
            a section
            -->
            <xsl:when
                test="contains(preceding-sibling::*[1]/@outputclass, 'mrg')">
                <fo:block xsl:use-attribute-sets="p_noSpaces">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:when>

            <xsl:when test="@outputclass[contains(., 'compact')]">
                <fo:block xsl:use-attribute-sets="p_noSpaces">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:when>

            <!--HSX p_titleBefore aligns first text with title of section:outputclass=mrg -->
            <xsl:when
                test="contains(preceding-sibling::*[1]/@class, ' topic/title ')">
                <fo:block xsl:use-attribute-sets="p_titleBefore">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:when>

            <xsl:otherwise>
                <fo:block xsl:use-attribute-sets="p">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:apply-templates/>
                </fo:block>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="checkCompact">
        <xsl:choose>
            <xsl:when test="@outputclass[contains(., 'compact')]">
                <xsl:attribute name="space-before" select="'0pt'"/>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*" mode="placeNoteLabel">
        <xsl:call-template name="commonattributes"/>
        <!--
        I improved that using outputclass
        removed:
        <xsl:when test="@type='note' or not(@type)">
        replaced
        -->
        <xsl:if test="not (contains(@outputclass, 'noLabel'))">
            <xsl:choose>
                <!--HSC 'note' is the default type -->
                <xsl:when test="@type='note' or not(@type)">
                    <!--HSC
                    if the entire label should  be deleted [DtPrt#10.5.3]
                    then we need to comment out the next fo:inline block

                    Also cconsider this for the separator (:) below
                    -->
                    <fo:inline xsl:use-attribute-sets="note__label note__label__note">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Note'"/>
                        </xsl:call-template>
                    </fo:inline>

                    <!--HSC this would be the end to comment out -->
                </xsl:when>
                <xsl:when test="@type='notice'">
                    <fo:inline xsl:use-attribute-sets="note__label note__label__notice">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Notice'"/>
                        </xsl:call-template>
                    </fo:inline>
                </xsl:when>
                <xsl:when test="@type='attention'">
                    <fo:inline xsl:use-attribute-sets="note__label note__label__attention">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'Attention'"/>
                        </xsl:call-template>
                    </fo:inline>
                </xsl:when>
                <xsl:when test="@type='caution'">
                    <fo:inline xsl:use-attribute-sets="note__label note__label__caution">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'Caution'"/>
                        </xsl:call-template>
                    </fo:inline>
                </xsl:when>
                <xsl:when test="@type='tip'">
                    <fo:inline xsl:use-attribute-sets="note__label note__label__tip">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Tip'"/>
                        </xsl:call-template>
                    </fo:inline>
                </xsl:when>
                <xsl:when test="@type='danger'">
                    <fo:inline xsl:use-attribute-sets="note__label note__label__danger">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'Danger'"/>
                        </xsl:call-template>
                    </fo:inline>
                </xsl:when>
                <xsl:when test="@type='warning'">
                    <fo:inline xsl:use-attribute-sets="note__label note__label__warning">
                        <xsl:call-template name="getVariable">
                            <xsl:with-param name="id" select="'Warning'"/>
                        </xsl:call-template>
                    </fo:inline>
                </xsl:when>
                <xsl:when test="@type='fastpath'">
                    <fo:inline xsl:use-attribute-sets="note__label note__label__fastpath">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Fastpath'"/>
                        </xsl:call-template>
                    </fo:inline>
                </xsl:when>
                <xsl:when test="@type='important'">
                    <fo:inline xsl:use-attribute-sets="note__label note__label__important">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Important'"/>
                        </xsl:call-template>
                    </fo:inline>
                </xsl:when>
                <xsl:when test="@type='remember'">
                    <fo:inline xsl:use-attribute-sets="note__label note__label__remember">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Remember'"/>
                        </xsl:call-template>
                    </fo:inline>
                </xsl:when>
                <xsl:when test="@type='restriction'">
                    <fo:inline xsl:use-attribute-sets="note__label note__label__restriction">
                            <xsl:call-template name="getVariable">
                                <xsl:with-param name="id" select="'Restriction'"/>
                        </xsl:call-template>
                    </fo:inline>
                </xsl:when>
                <xsl:when test="@type='trouble'">
                    <fo:inline xsl:use-attribute-sets="note__label note__label__trouble">
                        <xsl:call-template name="getVariable">
                          <xsl:with-param name="id" select="'Trouble'"/>
                        </xsl:call-template>
                    </fo:inline>
                </xsl:when>
                <xsl:when test="@type='other'">
                    <fo:inline xsl:use-attribute-sets="note__label note__label__other">
                        <xsl:choose>
                            <!--HSC adding a new "other" type 'bestpractice' is explained
                            in [DtPrt#10.5.7] -->
                            <xsl:when test="@othertype='bestpractice'">
                                <!--HSC hard coding the text can be improved by
                                variable in [DtPrt#10.5.7]
                                <xsl:text>Best Practice</xsl:text>  -->
                                <xsl:call-template name="getVariable">
                                    <xsl:with-param name="id" select="'Best Practice'"/>
                                </xsl:call-template>
                            </xsl:when>
                            <!--HSC end of new 'when' section -->
                            <xsl:when test="@othertype">
                                <xsl:value-of select="@othertype"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:text>[</xsl:text>
                                <xsl:value-of select="@type"/>
                                <xsl:text>]</xsl:text>
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:inline>
                </xsl:when>
            </xsl:choose>
            <!--HSC if the entire label should  be deleted [DtPrt#10.5.3]
            we need to consider the separator :,  hence we need to
            test for our particular case (here type='couldbenote' for 'note') and
            consider it in a choose:block -->
            <fo:inline xsl:use-attribute-sets="note__label">
                <xsl:choose>
                    <xsl:when test="@type='couldbenote'">
                        <!--don't insert separator-->
                    </xsl:when>
                    <xsl:otherwise>
                <xsl:call-template name="getVariable">
                  <xsl:with-param name="id" select="'#note-separator'"/>
                        </xsl:call-template>
                    </xsl:otherwise>
                </xsl:choose>
                <!--HSC end of the choose block -->
            </fo:inline>
        </xsl:if>
        <!--HSC the next statement seems to add spaces until the actual text
        is inserted
        -->
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/note ')]" mode="setNoteImagePath">
        <xsl:variable name="noteType" as="xs:string">
            <xsl:choose>
                <!--<xsl:when test="@type = 'other' and @othertype">
                <xsl:value-of select="@othertype"/>
                </xsl:when>
                -->
                <xsl:when test="@type">
                    <xsl:value-of select="@type"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="'note'"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!--HSX I extended the choices to have no image by the
        outputclass = noLabel noImage
        -->
        <xsl:choose>
            <xsl:when test="contains(@outputclass, 'noImage')">
                <xsl:value-of select="''"/>
            </xsl:when>
            <xsl:otherwise>
      <xsl:call-template name="getVariable">
          <xsl:with-param name="id" select="concat($noteType, ' Note Image Path')"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/note ')]">
        <!--HSC in [DtPrt#10.6.3] there's a bit of another example by call-templated
        as here we have apply-templates-->
        <!--HSC here is the target for the cut acc. to [DtPrt#10.6.3] -->
        <!--HSC the entire fo:table shall be cut out to work along [DtPrt#10.6.3] -->
        <xsl:variable name="noteImagePath">
            <xsl:apply-templates select="." mode="setNoteImagePath"/>
        </xsl:variable>
        <fo:table xsl:use-attribute-sets="note__table">
            <xsl:call-template name="condKeep"/>
            <xsl:call-template name="setListMargin"/>
            <fo:table-column xsl:use-attribute-sets="note__image__column"/>
            <fo:table-column xsl:use-attribute-sets="note__label__column"/>
            <fo:table-column xsl:use-attribute-sets="note__text__column"/>
            <fo:table-body>
                <fo:table-row>
                    <fo:table-cell xsl:use-attribute-sets="note__image__entry">
                        <!--HSC here is the potential selection of image vs. text acc. to [DtPrt#10.6.3]
                        <xsl:choose>
                        <xsl:when test="not($noteImagePath = '')">
                        <fo:block>
                        <fo:external-graphic src="url({concat($artworkPrefix, $noteImagePath)})" xsl:use-attribute-sets="image"/>
                        </fo:block>
                        </xsl:when>
                        <xsl:otherwise>
                        </xsl:otherwise>
                        </xsl:choose>
                        -->
                        <!--HSC end of choose block for [DtPrt#10.6.3] -->
                        <xsl:if test="not(contains(@outputclass, 'noImage')) and not($noteImagePath = '')">
                            <fo:block>
                                <fo:external-graphic src="url('{concat($artworkPrefix, $noteImagePath)}')" xsl:use-attribute-sets="image"/>
                            </fo:block>
                        </xsl:if>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="note__label__entry note__borders">
                        <!--HSX the border formatting could also be individualized
                        by the @type attribute -->
                        <fo:block>
                            <xsl:apply-templates select="." mode="placeNoteLabel"/>
                        </fo:block>
                    </fo:table-cell>
                    <fo:table-cell xsl:use-attribute-sets="note__text__entry note__borders">
                        <fo:block>
                            <xsl:apply-templates/>
                        </fo:block>
                    </fo:table-cell>
                </fo:table-row>
            </fo:table-body>
        </fo:table>
        <!--HSC end of potential cut acc. to [DtPart#10.6.3] -->
    </xsl:template>

    <!--HSC process long quote lq -->
    <xsl:template match="*[contains(@class,' topic/lq ')]">
        <fo:block>
            <xsl:call-template name="commonattributes"/>
            <xsl:choose>
                <xsl:when test="@href or @reftitle">
                    <xsl:call-template name="processAttrSetReflection">
                        <xsl:with-param name="attrSet" select="'lq'"/>
                        <xsl:with-param name="path" select="'../../cfg/fo/attrs/commons-attr.xsl'"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:call-template name="processAttrSetReflection">
                        <xsl:with-param name="attrSet" select="'lq_simple'"/>
                        <xsl:with-param name="path" select="'../../cfg/fo/attrs/commons-attr.xsl'"/>
                    </xsl:call-template>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:apply-templates/>
        </fo:block>
        <xsl:choose>
            <xsl:when test="@href">
                <fo:block xsl:use-attribute-sets="lq_link">
                    <fo:basic-link>
                        <xsl:call-template name="buildBasicLinkDestination">
                            <xsl:with-param name="scope" select="@scope"/>
                            <xsl:with-param name="format" select="@format"/>
                            <xsl:with-param name="href" select="@href"/>
                        </xsl:call-template>

                        <xsl:choose>
                            <xsl:when test="@reftitle">
                                <xsl:value-of select="@reftitle"/>
                            </xsl:when>
                            <xsl:when test="not(@type = 'external' or @format = 'html')">
                                <xsl:apply-templates select="." mode="insertReferenceTitle">
                                    <xsl:with-param name="href" select="@href"/>
                                    <xsl:with-param name="titlePrefix" select="''"/>
                                </xsl:apply-templates>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="@href"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:basic-link>
                </fo:block>
            </xsl:when>
            <xsl:when test="@reftitle">
                <fo:block xsl:use-attribute-sets="lq_title">
                    <xsl:value-of select="@reftitle"/>
                </fo:block>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/q ')]">
        <fo:inline xsl:use-attribute-sets="q">
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="'#quote-start'"/>
            </xsl:call-template>
            <xsl:apply-templates/>
            <xsl:call-template name="getVariable">
                <xsl:with-param name="id" select="'#quote-end'"/>
            </xsl:call-template>
        </fo:inline>
    </xsl:template>

    <xsl:template name="mmGetAvailWidth" as="xs:double">
        <xsl:variable name="mmPgWidth" as="xs:double">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="$page-width"/>
                <xsl:with-param name="inUnitsOf" select="'mm'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="mmSideColWidth" as="xs:double">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="$side-col-width"/>
                <xsl:with-param name="inUnitsOf" select="'mm'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="mmPgMgIn" as="xs:double">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="$page-margin-inside"/>
                <xsl:with-param name="inUnitsOf" select="'mm'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="mmPgMgOut" as="xs:double">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="$page-margin-outside"/>
                <xsl:with-param name="inUnitsOf" select="'mm'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="number(($mmPgWidth - $mmSideColWidth - $mmPgMgOut - $mmPgMgIn))"/>
    </xsl:template>

    <xsl:template name="mmGetEndIndent" as="xs:string">
        <xsl:param name="startIndent"/>

        <xsl:variable name="mmWidthAvail" as="xs:double">
            <xsl:call-template name="mmGetAvailWidth"/>
        </xsl:variable>

        <xsl:variable name="imgWidth" as="xs:double">
            <xsl:choose>
                <xsl:when test="image/@width">
                    <xsl:call-template name="convertUnits">
                        <xsl:with-param name="numUnit" select="image/@width"/>
                        <xsl:with-param name="inUnitsOf" select="'mm'"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$mmWidthAvail"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:variable name="mmPgWidth" as="xs:double">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="$page-width"/>
                <xsl:with-param name="inUnitsOf" select="'mm'"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="mmPgMgIn" as="xs:double">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="$page-margin-inside"/>
                <xsl:with-param name="inUnitsOf" select="'mm'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="mmPgMgOut" as="xs:double">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="$page-margin-outside"/>
                <xsl:with-param name="inUnitsOf" select="'mm'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="valEndIndent" as="xs:double">
            <xsl:value-of select="round(10 * number(($mmPgWidth - $imgWidth - $mmPgMgOut - $mmPgMgIn))) div 10"/>
        </xsl:variable>

        <xsl:if test="contains($unittest, 'figfrm')">
            <xsl:message>
                <xsl:text>UnitTest-mmGetEndIndent.StartIndent=</xsl:text>
                <xsl:value-of select="$startIndent"/>
                <xsl:text>&#xA;mmPgWidth=</xsl:text>
                <xsl:value-of select="$mmPgWidth"/>
                <xsl:text>&#xA;imgWidth=</xsl:text>
                <xsl:value-of select="$imgWidth"/>
                <xsl:text>&#xA;mmPgMgOut=</xsl:text>
                <xsl:value-of select="$mmPgMgOut"/>
                <xsl:text>&#xA;mmPmmPgMgIngWidth=</xsl:text>
                <xsl:value-of select="$mmPgMgIn"/>
                <xsl:text>&#xA;valEndIndent=</xsl:text>
                <xsl:value-of select="$valEndIndent"/>
                <xsl:text>&#xA;EndIndent=</xsl:text>
                <xsl:value-of select="concat($valEndIndent, 'mm - ', $startIndent)"/>
            </xsl:message>
        </xsl:if>

        <xsl:value-of select="concat($valEndIndent, 'mm - ', $startIndent)"/>
    </xsl:template>

    <xsl:template name="mmGetFigIndent">
        <!--HSX compute image width ... acc. to its value sets
        start-indent to 0pt or $side-col-width
        child::/image/@width
        -->

        <xsl:variable name="mmWidthAvail" as="xs:double">
            <xsl:call-template name="mmGetAvailWidth"/>
        </xsl:variable>

        <xsl:variable name="mmSideColWidth" as="xs:double">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="$side-col-width"/>
                <xsl:with-param name="inUnitsOf" select="'mm'"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="mmFigWidth" as="xs:double">
            <xsl:choose>
                <xsl:when test="image/@width">
                    <xsl:call-template name="convertUnits">
                        <xsl:with-param name="numUnit" select="image/@width"/>
                        <xsl:with-param name="inUnitsOf" select="'mm'"/>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="$mmWidthAvail"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!--HSX determine the start-indent -->
        <xsl:choose>
            <!-- in a table ... start-indent is always 0 -->
            <xsl:when test="ancestor::table">
                <xsl:value-of select="'0'"/>
            </xsl:when>
            <xsl:when test="@expanse">
                <xsl:choose>
                    <!--HSX for columns there should be not additional indent -->
                    <xsl:when
                        test="(@expanse = 'page') or
                        (@expanse = 'spread') or
                        (@expanse = 'column')">
                        <xsl:value-of select="'0'"/>
                    </xsl:when>

                    <!--HSX textline implies start-indent = the present textflow -->
                    <xsl:when test="@expanse = 'textline'">
                        <xsl:value-of select="$mmSideColWidth"/>
                    </xsl:when>

                    <!--HSX any other stupid value of expanse will do the dynamic default -->
                    <xsl:otherwise>
                        <xsl:choose>
                            <xsl:when test="contains(image/@outputclass, 'flow')">
                                <xsl:value-of select="$mmSideColWidth"/>
                            </xsl:when>

                            <xsl:when test="$mmFigWidth &gt; $mmWidthAvail">
                                <xsl:value-of select="'0'"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="mmSideColWidth"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>

            <!--HSX do not put margin out if we enforce flow -->
            <xsl:when test="contains(image/@outputclass, 'flow')">
                <xsl:value-of select="$mmSideColWidth"/>
            </xsl:when>

            <xsl:when test="$mmFigWidth &gt; $mmWidthAvail">
                <xsl:value-of select="'0'"/>
            </xsl:when>

            <xsl:otherwise>
                <xsl:value-of select="'from-parent(start-indent)'"/>
                <!--HSX-20150625 removed to improve frame following image width
                <xsl:attribute name="end-indent" select="'from-parent(end-indent)'"/>
                -->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/fig ')]">
        <!--HSC [DtPrt#14.5] shows how to put the figure title above.

        <xsl:attribute name="end-indent">3pt + from-parent(end-indent)</xsl:attribute>
        </xsl:attribute-set>

        <xsl:attribute-set name="__border__left" use-attribute-sets="common.border__left">
        <xsl:attribute name="padding-left">3pt</xsl:attribute>
        <xsl:attribute name="start-indent">3pt + from-parent(start-indent)</xsl:attribute>

        I made it conditional, the otherwise case is the original one -->
        <xsl:choose>
            <xsl:when test="contains($TitlePosition, 'fig_titleAbove')">
                <fo:block xsl:use-attribute-sets="fig.titleAbove">
                    <xsl:attribute name="start-indent">
                        <xsl:call-template name="attrStartIndent"/>
                    </xsl:attribute>
                    <xsl:apply-templates select="*[contains(@class,' topic/title ')]"/>
                </fo:block>
            </xsl:when>
        </xsl:choose>

        <fo:block xsl:use-attribute-sets="fig">
            <xsl:call-template name="chkNewpage"/>
            <xsl:call-template name="setFrame"/>

            <xsl:variable name="startIndent">
                <xsl:call-template name="attrStartIndent"/>
            </xsl:variable>

            <xsl:variable name="endIndent">
                 <xsl:call-template name="mmGetEndIndent">
                     <xsl:with-param name="startIndent" select="$startIndent"/>
                 </xsl:call-template>
            </xsl:variable>

            <!--HSX finally set the start-/end-indent of the figure block -->
            <xsl:attribute name="start-indent" select="$startIndent"/>

            <!--HSX check whether image width is specified  "not(image/@width)"
                is not really necessary because the prior call to mmGetEndIndent
                 fixes the end-indent already correctly, so we do paranoia rules here
            -->
            <xsl:choose>
                <xsl:when test="(image/@align = 'right') or
                                (image/@align = 'center') or
                                (@expanse = 'page') or
                                not(image/@width)
                                ">
                    <xsl:attribute name="end-indent" select="'0mm'"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="end-indent" select="$endIndent"/>
                </xsl:otherwise>
            </xsl:choose>

            <xsl:choose>
                <xsl:when test="not(@id)">
                    <xsl:attribute name="id">
                        <xsl:call-template name="get-id"/>
                    </xsl:attribute>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:attribute name="id" select="@id"/>
                </xsl:otherwise>
            </xsl:choose>
            <!--HSX we didn't care for space before because we don't want space
                between a title-above and the figure.
                However, if there is no title-above, yes ... we want some space
                HSTODO: This test can also go to the attribute-set "fig"
            -->
            <xsl:if test="not(contains($TitlePosition, 'fig_titleAbove'))">
                <xsl:attribute name="space-before" select="'5.31mm'"/>
            </xsl:if>

            <!--HSC call the figure's children (e.g. image etc) -->
            <xsl:apply-templates select="*[not(contains(@class,' topic/title '))]"/>
        </fo:block>
        <!--HSC [DtPrt#14.5] shows how to put the figure title above.
        I made it conditional, the otherwise case is the original one -->
        <xsl:choose>
            <xsl:when test="not(contains($TitlePosition, 'fig_titleAbove'))">
                <fo:block xsl:use-attribute-sets="fig.titleBelow">
                    <xsl:attribute name="start-indent">
                        <xsl:call-template name="attrStartIndent"/>
                     </xsl:attribute>
                    <xsl:apply-templates select="*[contains(@class,' topic/title ')]"/>
                </fo:block>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="attrStartIndent">
        <xsl:variable name="startIndent">
            <xsl:call-template name="mmGetFigIndent"/>
        </xsl:variable>
        <xsl:choose>
            <xsl:when test="contains($startIndent, 'from-')">
                <xsl:value-of select="$startIndent"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="concat($startIndent, 'mm')"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>


    <xsl:template match="*[contains(@class,' topic/figgroup ')]">
        <fo:inline xsl:use-attribute-sets="figgroup">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/pre ')]">
        <xsl:call-template name="setSpecTitle"/>
        <fo:block xsl:use-attribute-sets="pre">
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="setFrame"/>
            <xsl:call-template name="setScale"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <xsl:template name="setSpecTitle">
        <xsl:if test="@spectitle">
            <fo:block xsl:use-attribute-sets="__spectitle">
                <xsl:value-of select="@spectitle"/>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <xsl:template name="setScale">
        <xsl:if test="@scale">
            <!-- For applications that do not yet take percentages. need to divide by 10 and use "pt" -->
            <xsl:attribute name="font-size">
                <xsl:value-of select="concat(@scale, '%')"/>
            </xsl:attribute>
        </xsl:if>
    </xsl:template>

    <!-- Process the frame attribute -->
    <!-- frame styles (setframe) must be called within a block that defines the content being framed -->
    <xsl:template name="setFrame" as="attribute()*">
        <xsl:variable name="container" as="element()*">
            <xsl:choose>
                <xsl:when test="@frame = 'top'">
                    <element xsl:use-attribute-sets="__border__top"/>
                </xsl:when>
                <xsl:when test="@frame = 'bot'">
                    <element xsl:use-attribute-sets="__border__bot"/>
                </xsl:when>
                <xsl:when test="@frame = 'topbot'">
                    <element xsl:use-attribute-sets="__border__topbot"/>
                </xsl:when>
                <xsl:when test="@frame = 'sides'">
                    <element xsl:use-attribute-sets="__border__sides"/>
                </xsl:when>
                <xsl:when test="@frame = 'all'">
                    <element xsl:use-attribute-sets="__border__all"/>
                </xsl:when>
            </xsl:choose>
        </xsl:variable>
        <xsl:sequence select="$container/@*"/>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/lines ')]">
        <xsl:call-template name="setSpecTitle"/>
        <fo:block xsl:use-attribute-sets="lines">
            <xsl:call-template name="commonattributes"/>
            <xsl:call-template name="setFrame"/>
            <xsl:call-template name="setScale"/>
            <xsl:apply-templates/>
        </fo:block>
    </xsl:template>

    <!-- The text element has no default semantics or formatting -->
    <xsl:template match="*[contains(@class,' topic/text ')]">
        <fo:inline>
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/keyword ')]" name="topic.keyword">
        <xsl:param name="keys" select="@keyref" as="attribute()?"/>
        <xsl:param name="contents" as="node()*">
            <xsl:variable name="target" select="key('id', substring(@href, 2))"/>
            <xsl:choose>
                <xsl:when test="not(normalize-space(.)) and $keys and $target/self::*[contains(@class,' topic/topic ')]">
                    <xsl:apply-templates select="$target/*[contains(@class, ' topic/title ')]/node()"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:apply-templates/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:param>
        <xsl:variable name="topicref" select="key('map-id', substring(@href, 2))"/>
        <xsl:choose>
            <xsl:when test="$keys and @href and not($topicref/ancestor-or-self::*[@linking][1]/@linking = ('none', 'sourceonly'))">
                <fo:basic-link xsl:use-attribute-sets="xref keyword">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:call-template name="buildBasicLinkDestination"/>
                    <xsl:copy-of select="$contents"/>
                </fo:basic-link>
            </xsl:when>
            <xsl:otherwise>
                <fo:inline xsl:use-attribute-sets="keyword">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:copy-of select="$contents"/>
                </fo:inline>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/ph ')]">
        <fo:inline xsl:use-attribute-sets="ph">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/boolean ')]">
        <fo:inline xsl:use-attribute-sets="boolean">
            <xsl:call-template name="commonattributes"/>
            <xsl:value-of select="name()"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="@state"/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/state ')]">
        <fo:inline xsl:use-attribute-sets="state">
            <xsl:call-template name="commonattributes"/>
            <xsl:value-of select="name()"/>
            <xsl:text>: </xsl:text>
            <xsl:value-of select="@name"/>
            <xsl:text>=</xsl:text>
            <xsl:value-of select="@value"/>
        </fo:inline>
    </xsl:template>

    <xsl:template name="getHREF">
        <xsl:param name="href"/>
        <xsl:if test="string-length($href) &gt; 0">
            <xsl:value-of select="if (@scope = 'external' or opentopic-func:isAbsolute($href)) then
                        $href
                        else
                        concat($input.dir.url, $href)"/>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/image ')]">
        <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')]" mode="outofline"/>

        <!-- build any pre break indicated by style -->
        <xsl:choose>
            <xsl:when test="parent::fig">
                <!-- NOP if there is already a break implied by a parent property -->
                <xsl:if test="contains($unittest, 'chkfig')">
                    <xsl:message>
                        <xsl:text>Processing Image :</xsl:text>
                        <xsl:value-of select="../title"/>
                    </xsl:message>
                </xsl:if>
            </xsl:when>
            <xsl:otherwise>
                <xsl:if test="not(@placement='inline')">
                    <!-- generate an FO break here -->
                    <!--HSX There seems to be not point given (or commented) why this break
                            is generated. placement != inline will start the image within fo:block
                            anyway, so the whitespace generated here does not help but to the point
                            that it moves the image down one line. This, however is bad style and
                            hence I object the following statement (from the official distribution)
                    <fo:block>&#xA0;</fo:block>
                    -->
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>

        <!--HSX get the full pathname -->
        <xsl:variable name="xhref">
            <xsl:call-template name="getHREF">
                <xsl:with-param name="href" select="@href"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:variable name="equation_scale" as="xs:integer">
            <xsl:choose>
                <xsl:when test="parent::equation-block">
                    <xsl:choose>
                        <!--HSX highest priority for the local scale attribute -->
                        <xsl:when test="@scale">
                            <xsl:value-of select="@scale"/>
                        </xsl:when>
                        <!--HSX 2nd priority goes to the build-parameter, if non trivial (100) -->
                        <xsl:when test="not(number($equation.img.scale) = 100)">
                            <xsl:value-of select="number($equation.img.scale)"/>
                        </xsl:when>
                        <!--HSX 3rd priority goes to DITA-OT plugin defaul setting -->
                        <xsl:otherwise>
                            <xsl:value-of select="$EquationScale"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <!--HSX if we are not in equation-block, send trivial value (100%) -->
                <xsl:otherwise>
                    <xsl:value-of select="100"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="not(@placement = 'inline')">
                <!--                <fo:float xsl:use-attribute-sets="image__float">-->

                <!--HSX allow width='page' to span over any float ONLY if we are not
                child of a paragraph. Otherwise we would start with side-col-width which
                is not funny because our hard width definition would then spill over
                the right margin
                -->
                <xsl:variable name="cntAncP" select="count(ancestor::p)"/>

                <xsl:variable name="sWidth">
                    <xsl:choose>
                        <xsl:when test="@width">
                            <xsl:value-of select="@width"/>
                        </xsl:when>
                        <!--HSX if there is a fixed height,
                            we do not apply automatic width correction
                        -->
                        <xsl:when test="@height"/>

                        <xsl:when test="(contains(@outputclass, 'page') and ($cntAncP = 0)) or
                              (ancestor::*[contains(name(), 'fig')]/@expanse = 'page')">
                            <xsl:value-of select="$pagewide"/>
                        </xsl:when>
                        <xsl:when test="contains(@outputclass, 'flow')">
                            <xsl:value-of select="$flowwide"/>
                        </xsl:when>
                        <xsl:when test="contains(@scalefit, 'yes')">
                            <xsl:value-of select="$flowwide"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <!--
                            <xsl:value-of select="$flowwide"/>
                            -->
                            <xsl:value-of select="0"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:variable>

                <fo:block xsl:use-attribute-sets="image__block">
                    <xsl:call-template name="commonattributes"/>
                    <xsl:apply-templates select="." mode="placeImage">
                        <xsl:with-param name="imageAlign" select="@align"/>
                        <xsl:with-param name="href" select="$xhref"/>
                        <xsl:with-param name="height" select="@height"/>
                        <!--HSX use the previously computed $swidth instead of @width -->
                        <xsl:with-param name="width" select="$sWidth"/>
                        <xsl:with-param name="eqscale" select="$equation_scale"/>
                    </xsl:apply-templates>
                </fo:block>
                <!--                </fo:float>-->
            </xsl:when>
            <!-- processing inline -->
            <xsl:otherwise>
                <fo:inline xsl:use-attribute-sets="image__inline">
                    <xsl:call-template name="commonattributes"/>
                    <!--HSX
                           fo processor has a small problem to determine the auto-width
                           if we have a side-col-width. Therefore we use the pre-computed
                           fixed value "$flowwide" in case that 'auto' is meant by ommitting
                           the @width.
                    -->
                    <xsl:variable name="swidth">
                        <xsl:choose>
                            <xsl:when test="@width">
                                <xsl:value-of select="@width"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <!--
                                <xsl:value-of select="$flowwide"/>
                                -->
                                <xsl:value-of select="0"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>

                    <xsl:apply-templates select="." mode="placeImage">
                        <xsl:with-param name="imageAlign" select="@align"/>
                        <xsl:with-param name="href" select="$xhref"/>
                        <xsl:with-param name="height" select="@height"/>
                        <xsl:with-param name="width" select="$swidth"/>
                    </xsl:apply-templates>
                </fo:inline>
                <xsl:if test="$artLabel='yes'">
                  <xsl:apply-templates select="." mode="image.artlabel"/>
                </xsl:if>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-endprop ')]" mode="outofline"/>
    </xsl:template>

    <xsl:template match="*" mode="image.artlabel">
      <fo:inline xsl:use-attribute-sets="image.artlabel">
        <xsl:text> </xsl:text>
        <xsl:value-of select="@href"/>
        <xsl:text> </xsl:text>
      </fo:inline>
    </xsl:template>

    <!-- Test whether URI is absolute -->
    <!--HSX I had to fix this function to respect Windows path notation \ instead of / -->
    <xsl:function name="opentopic-func:isAbsolute" as="xs:boolean">
        <xsl:param name="uri" as="xs:anyURI"/>
        <xsl:sequence select="some $prefix in ('/', 'file:') satisfies starts-with($uri, $prefix) or
            contains($uri, '://')
        or contains($uri, ':/') or contains($uri, ':\')"/> <!--HSC added Windows fullpath, :// becomes obsolete but I left it -->
    </xsl:function>

    <xsl:template match="*" mode="placeImage">
        <xsl:param name="imageAlign"/>
        <xsl:param name="href"/>
        <xsl:param name="height" as="xs:string?"/>
        <xsl:param name="width" as="xs:string?"/>
        <xsl:param name="eqscale" select="100" as="xs:integer"/>
        <!--HSC [DtPrt#14.7] aligns figures by default unless specified in attributes
        If found that this only works with placement=break -->
        <xsl:choose>
            <xsl:when test="not(@align)">
                <xsl:call-template name="processAttrSetReflection">
                    <!--HSC change the default 'center' to any other value 'left' 'right' -->
                    <xsl:with-param name="attrSet" select="concat('__align__', 'left')"/>
                    <xsl:with-param name="path" select="'../../cfg/fo/attrs/commons-attr.xsl'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:call-template name="processAttrSetReflection">
                    <xsl:with-param name="attrSet" select="concat('__align__', $imageAlign)"/>
                    <xsl:with-param name="path" select="'../../cfg/fo/attrs/commons-attr.xsl'"/>
                </xsl:call-template>
            </xsl:otherwise>
        </xsl:choose>
        <!--HSC end of insertion -->


        <!--Using image:align attribute set according to image @align attribute-->
        <xsl:call-template name="processAttrSetReflection">
            <xsl:with-param name="attrSet" select="concat('__align__', $imageAlign)"/>
            <xsl:with-param name="path" select="'../../cfg/fo/attrs/commons-attr.xsl'"/>
        </xsl:call-template>
        <fo:external-graphic src="url('{$href}')" xsl:use-attribute-sets="image">
            <!--HSX2 very rude implementation of top alignment, can be improved on demand -->
            <xsl:if test="contains(@outputclass, 'valign=top')">
                <xsl:attribute name="vertical-align" select="'top'"/>
            </xsl:if>
            <!--Setting image height if defined-->
            <xsl:if test="$height and number(replace($height, '[A-Z,a-z]', '')) &gt; 0">
                <xsl:if test="$width and number(replace($width, '[A-Z,a-z]', '')) &gt; 0">
                    <xsl:attribute name="scaling" select="'non-uniform'"/>
                    <xsl:attribute name="scaling-method" select="'integer-pixels'"/>
                </xsl:if>
                <xsl:attribute name="content-height">
                    <!--The following test was commented out because most people found the behavior
                    surprising.  It used to force images with a number specified for the dimensions
                    *but no units* to act as a measure of pixels, *if* you were printing at 72 DPI.
                    Uncomment if you really want it.
                    -->
                    <xsl:choose>
                        <!--xsl:when test="not(string(number($height)) = 'NaN')">
                        <xsl:value-of select="concat($height div 72,'in')"/>
                        </xsl:when>
                        -->
                        <xsl:when test="not(string(number($height)) = 'NaN')">
                            <xsl:value-of select="concat($height, 'px')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$height"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:if>
            <!--Setting image width if defined-->
            <xsl:if test="$width and not($width = '0')">
                <xsl:attribute name="content-width">
                    <xsl:choose>
                        <!--xsl:when test="not(string(number($width)) = 'NaN')">
                        <xsl:value-of select="concat($width div 72,'in')"/>
                        </xsl:when>
                        -->
                        <xsl:when test="not(string(number($width)) = 'NaN')">
                            <xsl:value-of select="concat($width, 'px')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="$width"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:attribute>
            </xsl:if>
            <xsl:if test="(not($width) or ($width = '0')) and (not($height) or ($height = '0'))">
                <xsl:choose>
                    <!--HSX if no $eqscale parameter was non trivial(100) then
                            we buy the scale from this parameter
                    -->
                    <xsl:when test="not($eqscale = 100)">
                        <xsl:attribute name="content-width">
                            <xsl:value-of select="concat($eqscale,'%')"/>
                        </xsl:attribute>
                    </xsl:when>
                    <!--HSX if no $eqscale parameter was given we check for @scale -->
                    <xsl:when test="@scale">
                        <xsl:attribute name="content-width">
                            <xsl:value-of select="concat(@scale,'%')"/>
                        </xsl:attribute>
                    </xsl:when>
                </xsl:choose>
            </xsl:if>

            <!--HSX scalefit is considered above in a better way
            <xsl:if test="@scalefit = 'yes' and not($width) and not($height) and not(@scale)">
                <xsl:attribute name="width">100%</xsl:attribute>
                <xsl:attribute name="height">100%</xsl:attribute>
                <xsl:attribute name="content-width">scale-to-fit</xsl:attribute>
                <xsl:attribute name="content-height">scale-to-fit</xsl:attribute>
                <xsl:attribute name="scaling">uniform</xsl:attribute>
            </xsl:if>
            -->

            <!--HSX2 Bug in Dita-OT 2.0 the except statement does generate a line feed in the output.
            Although this should be considered uncritical whitespace, the XEP renderer broke the fo-formatting
            with the error "external-source must not contain content".
            However, this can be fixed here if we do not use the "except" statement but put the
            apply-templates into an "if" constuct which tests its condition.

            Version 2.1.1 seemed to fix, so the below was valid improvement until 2.1.1
            <xsl:if test="not(*[contains(@class, ' topic/alt ') or contains(@class, ' topic/longdescref ')])">
                <xsl:apply-templates select="node()"/>
                /* HSX2 But except (*[contains(@class, ' topic/alt ') or
                contains(@class, ' topic/longdescref ')])"/>
                */
            </xsl:if>
            -->

          <xsl:apply-templates select="node() except (text(),
                                                      *[contains(@class, ' topic/alt ') or
                                                        contains(@class, ' topic/longdescref ')])"/>


        </fo:external-graphic>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/alt ')]">
        <fo:block xsl:use-attribute-sets="alt"> </fo:block>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/object ')]">
        <fo:inline xsl:use-attribute-sets="object">
            <xsl:call-template name="commonattributes"/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/param ')]">
        <fo:inline xsl:use-attribute-sets="param">
            <xsl:call-template name="commonattributes"/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/foreign ')]"/>
    <xsl:template match="*[contains(@class,' topic/unknown ')]"/>

    <xsl:template match="*[contains(@class,' topic/draft-comment ')]">
        <xsl:if test="$publishRequiredCleanup = 'yes' or $DRAFT='yes'">
            <fo:block xsl:use-attribute-sets="draft-comment">
                <xsl:call-template name="commonattributes"/>
                <fo:block xsl:use-attribute-sets="draft-comment__label">
                    <xsl:text>Disposition: </xsl:text>
                    <xsl:value-of select="@disposition"/>
                    <xsl:text> / </xsl:text>
                    <xsl:text>Status: </xsl:text>
                    <xsl:value-of select="@status"/>
                </fo:block>
                <xsl:apply-templates/>
            </fo:block>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/required-cleanup ')]">
        <xsl:if test="$publishRequiredCleanup = 'yes' or $DRAFT='yes'">
            <fo:inline xsl:use-attribute-sets="required-cleanup">
                <xsl:call-template name="commonattributes"/>
                <fo:inline xsl:use-attribute-sets="required-cleanup__label">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'Required-Cleanup'"/>
                    </xsl:call-template>
                    <xsl:if test="string(@remap)">
                        <xsl:text>(</xsl:text>
                        <xsl:value-of select="@remap"/>
                        <xsl:text>)</xsl:text>
                    </xsl:if>
                    <xsl:text>: </xsl:text>
                </fo:inline>
                <xsl:apply-templates/>
            </fo:inline>
        </xsl:if>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/fn ')]">
        <!--HSC [DtPrt#15.5.3] adds brackets around the footnote number -->
        <fo:inline xsl:use-attribute-sets="fn__callout">
            <xsl:text>[</xsl:text>
        </fo:inline>
        <!--HSC end insertion -->
        <fo:inline>
            <xsl:call-template name="commonattributes"/>
        </fo:inline>
        <fo:footnote>
            <xsl:choose>
                <xsl:when test="not(@id)">
                    <fo:inline xsl:use-attribute-sets="fn__callout">

                        <xsl:choose>
                            <xsl:when test="@callout">
                                <xsl:value-of select="@callout"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="count(key('enumerableByClass', 'topic/fn')[. &lt;&lt; current()]) + 1"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </fo:inline>
                </xsl:when>
                <xsl:otherwise>
                    <!-- Footnote with id does not generate its own callout. -->
                    <fo:inline/>
                </xsl:otherwise>
            </xsl:choose>

            <fo:footnote-body>
                <fo:list-block xsl:use-attribute-sets="fn__body">
                    <fo:list-item>
                        <fo:list-item-label end-indent="label-end()">
                            <fo:block text-align="right">
                                <fo:inline xsl:use-attribute-sets="fn__callout">
                                    <xsl:choose>
                                        <xsl:when test="@callout">
                                            <xsl:value-of select="@callout"/>
                                        </xsl:when>
                                        <xsl:otherwise>
                                            <xsl:value-of select="count(key('enumerableByClass', 'topic/fn')[. &lt;&lt; current()]) + 1"/>
                                        </xsl:otherwise>
                                    </xsl:choose>
                                </fo:inline>
                            </fo:block>
                        </fo:list-item-label>
                        <fo:list-item-body start-indent="body-start()">
                            <fo:block>
                                <xsl:apply-templates/>
                            </fo:block>
                        </fo:list-item-body>
                    </fo:list-item>
                </fo:list-block>
            </fo:footnote-body>
        </fo:footnote>
        <!--HSC [DtPrt#15.5.3] adds brackets around the footnote number -->
        <fo:inline xsl:use-attribute-sets="fn__callout">
            <xsl:text>]</xsl:text>
        </fo:inline>
        <!--HSC end insertion -->
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/indexterm ')]">
        <fo:inline>
            <xsl:call-template name="commonattributes"/>
        </fo:inline>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/indextermref ')]">
        <fo:inline xsl:use-attribute-sets="indextermref">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="*[contains(@class,' topic/cite ')]">
        <fo:inline xsl:use-attribute-sets="cite">
            <xsl:call-template name="commonattributes"/>
            <xsl:apply-templates/>
        </fo:inline>
    </xsl:template>

    <xsl:template match="@platform | @product | @audience | @otherprops | @importance | @rev | @status"/>

    <!-- Template to copy original IDs -->

    <xsl:template match="@id">
        <!--HSC matches any attribute with the value "id" -->
        <xsl:attribute name="id">
            <xsl:value-of select="."/>
        </xsl:attribute>
    </xsl:template>

    <!-- Process common attributes -->
    <xsl:template name="commonattributes">
        <xsl:apply-templates select="@id"/>
        <xsl:call-template name="condKeep"/>
        <xsl:apply-templates select="*[contains(@class,' ditaot-d/ditaval-startprop ')] |
                                     *[contains(@class,' ditaot-d/ditaval-endprop ')]" mode="flag-attributes"/>
    </xsl:template>

    <!--HSX avoids condKeep in situations where we do not want to
            connect to previous paragraphs
    -->
    <xsl:template name="commonid">
        <xsl:apply-templates select="@id"/>
    </xsl:template>

    <!-- Get ID for an element, generate ID if not explicitly set. -->
    <xsl:template name="get-id">
        <xsl:param name="element" select="."/>
        <xsl:choose>
            <xsl:when test="$element/@id">
                <xsl:value-of select="$element/@id"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="generate-id($element)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- Generate TOC ID -->
    <xsl:template name="generate-toc-id">
        <xsl:param name="element" select="."/>
        <xsl:value-of select="concat('_OPENTOPIC_TOC_PROCESSING_', generate-id($element))"/>
    </xsl:template>

    <!-- BS: Template owerwrited to define new topic types (List's),
    to create special processing for any of list you should use <template name="processUnknowTopic"/>
    example below.-->
    <xsl:template name="determineTopicType">
        <xsl:variable name="foundTopicType" as="xs:string?">
            <xsl:choose>
                <xsl:when test="contains(name(), 'ot-placeholder:glossarylist')">
                    <xsl:text>topicGlossaryList</xsl:text>
                </xsl:when>

                <xsl:otherwise>
                    <xsl:variable name="topic" select="ancestor-or-self::*[contains(@class, ' topic/topic ')][1]"/>
                    <xsl:variable name="id" select="$topic/@id"/>
                    <xsl:variable name="mapTopics" select="key('map-id', $id)"/>
                    <xsl:apply-templates select="$mapTopics[1]" mode="determineTopicType"/>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:variable>

        <!--HSX as we manage 'title' our parent is a candidate for $map -->
        <xsl:variable name="myId" select="(ancestor-or-self::*[last() - 1])/@id"/>
        <!--
        <xsl:variable name="axId" select="$map//*[contains(@class, 'appendix')]/@id"/>
        -->

        <xsl:if test="contains($unittest, 'chkHead1')">
            <xsl:message>
                <xsl:text>ANCESTOR-2 myName=(</xsl:text>
                <xsl:value-of select="./name()"/>
                <xsl:text>) myId=[</xsl:text>
                <xsl:value-of select="@id"/>
                <xsl:text>] pID=[</xsl:text>
                <xsl:value-of select="../@id"/>
                <xsl:text>] anc[-2]name= </xsl:text>
                <xsl:value-of select="(ancestor-or-self::*[last() - 1])/name()"/>
                <xsl:text>  anc[-2]id=</xsl:text>
                <xsl:value-of select="(ancestor-or-self::*[last() - 1])/@id"/>
                <xsl:text>  ancs = </xsl:text>
                <xsl:for-each select="ancestor-or-self::*">
                    <xsl:value-of select="name()"/>
                    <xsl:text>   </xsl:text>
                </xsl:for-each>
            </xsl:message>
        </xsl:if>
        <xsl:variable name="cntBackm" select="count(($map//*[@id = $myId])/ancestor-or-self::*[contains(name(), 'backmatter')])"/>


        <xsl:choose>
            <xsl:when test="exists($foundTopicType) and $foundTopicType != ''">
                <xsl:choose>
                    <xsl:when test="$cntBackm &gt;0">
                        <xsl:text>topicBackmatter</xsl:text>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:value-of select="$foundTopicType"/>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>

            <!--HSX I checked ... this is never reached because the default
                template below will always deliver topicSimple if we didn't
                find anything else
            -->
            <xsl:when test="$cntBackm &gt;0">
                <xsl:text>topicBackmatter</xsl:text>
            </xsl:when>
            <!--
            <xsl:when test="$cntAnnex &gt;0">
                <xsl:text>topicAppendix</xsl:text>
            </xsl:when>
            -->
            <xsl:otherwise>
                <xsl:text>topicSimple</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--HSX
     Templates to match nodes under the scope of determineTopicType

     I used this earlier to get to appendices Head n (n>2) appendices
     but it is no more used in the plugin
    <xsl:template match="*" mode="determineTopicType">
        <xsl:variable name="axId" select="$map//*[contains(@class, 'appendix')]/@id"/>
        <xsl:variable name="cntAnnex" select="count(ancestor-or-self::*[@id = $axId])"/>
        <xsl:choose>
            <xsl:when test="$cntAnnex &gt;0">
                <xsl:text>topicAppendixChild</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>topicSimple</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    -->

    <!-- Templates to match nodes under the scope of determineTopicType -->
    <xsl:template match="*" mode="determineTopicType">
        <!-- Default, when not matching a bookmap type, is topicSimple -->
        <xsl:text>topicSimple</xsl:text>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' bookmap/chapter ')]" mode="determineTopicType">
        <xsl:text>topicChapter</xsl:text>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' bookmap/appendix ')]" mode="determineTopicType">
        <xsl:text>topicAppendix</xsl:text>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' bookmap/preface ')]" mode="determineTopicType">
        <xsl:text>topicPreface</xsl:text>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' bookmap/bookabstract ')]" mode="determineTopicType">
        <xsl:text>topicAbstract</xsl:text>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' bookmap/appendices ')]" mode="determineTopicType">
        <xsl:text>topicAppendices</xsl:text>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' bookmap/part ')]" mode="determineTopicType">
        <xsl:text>topicPart</xsl:text>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' bookmap/abbrevlist ')]" mode="determineTopicType">
        <xsl:text>topicAbbrevList</xsl:text>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' bookmap/bibliolist ')]" mode="determineTopicType">
        <xsl:text>topicBiblioList</xsl:text>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' bookmap/booklist ')]" mode="determineTopicType">
        <xsl:text>topicBookList</xsl:text>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' bookmap/figurelist ')]" mode="determineTopicType">
        <xsl:text>topicFigureList</xsl:text>
    </xsl:template>
    <xsl:template match="*[contains(@class, ' bookmap/indexlist ')]" mode="determineTopicType">
        <xsl:text>topicIndexList</xsl:text>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' bookmap/toc ')]" mode="determineTopicType">
        <xsl:text>topicTocList</xsl:text>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' bookmap/trademarklist ')]" mode="determineTopicType">
        <xsl:text>topicTradeMarkList</xsl:text>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' bookmap/notices ')]" mode="determineTopicType">
        <xsl:text>topicNotices</xsl:text>
    </xsl:template>

    <xsl:template match="*[contains(@class, ' topic/data ')]"/>
    <xsl:template match="*[contains(@class, ' topic/data ')]" mode="insert-text"/>
    <xsl:template match="*[contains(@class, ' topic/data-about ')]"/>

    <xsl:function name="opentopic-func:determineTopicType" as="xs:string">
        <xsl:variable name="topicType" as="xs:string">
            <xsl:call-template name="determineTopicType"/>
        </xsl:variable>
        <xsl:sequence select="$topicType"/>
    </xsl:function>

</xsl:stylesheet>
