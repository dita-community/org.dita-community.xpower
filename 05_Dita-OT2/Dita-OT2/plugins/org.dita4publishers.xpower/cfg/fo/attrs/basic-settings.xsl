<?xml version="1.0" encoding="utf-8"?>
<!-- This file is part of the DITA Open Toolkit project.
     See the accompanying license.txt file for applicable licenses. -->
<!-- (c) Copyright Suite Solutions -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:xs="http://www.w3.org/2001/XMLSchema"
                version="2.0"
                exclude-result-prefixes="xs">

  <xsl:param name="locale"/>
  <xsl:param name="customizationDir.url"/>
  <xsl:param name="artworkPrefix"/>
  <xsl:param name="publishRequiredCleanup"/>
  <xsl:param name="DRAFT"/>
  <xsl:param name="artLabel" select="'no'"/>
  <xsl:param name="output.dir.url"/>
  <xsl:param name="work.dir.url"/>
  <xsl:param name="input.dir.url"/>
  <xsl:param name="pdfFormatter" select="'fop'"/>
  <xsl:param name="antArgsGenerateTaskLabels"/>
  
  <!--HSC unittests generate messages to learn process
  values are: chkproc todo gls prcattrs replid chghref chref chg42 copyel oxycmt chklinks chkSubtopic
              chkHeader = check construction of page headers
              chkHead[1|2|3]
  -->
  <xsl:variable name="unittest" select="'none'"/>
  
  <!--
  <xsl:param name="tocMaximumLevel" select="6"/>
  -->
  
    <!--HSC [DtPrt#16.8] explains how to change the maximum level for the TOC -->
    <xsl:variable name="tocMaxLevel" select="5"/>
    <!-- Maximum level to which Topic titles are numbered. See "getTitleNumber" template below -->
    <xsl:variable name="topicTitle.numLevel">6</xsl:variable>

    <!-- maximum heading level displayed in headers values from 1 .. n -->
    <xsl:variable name="topicHeader.numLevel">3</xsl:variable>

    <!-- IMPORTANT Parameter comes from org.dita2pdf
    The call to

    <xslt style="${temp.transformation.file}" in="${dita.temp.dir}/stage1a.xml" out="${dita.temp.dir}/stage2.fo">
    <param name="project.doc" expression="${ProjDocRel}"/>

    needs to add the param project.doc
    <param name="project.doc" expression="${ProjDocRel}"/>
    in order to allow the propagation of the ProjDocRel variable. This is the
    relative path from the topic.fo directory into the stub directory

    To find the entry point ... set required="yes" and the system breaks until you provide the variable
    -->
    <xsl:param name="project.doc" required="no" as="xs:string" select="'SetProjDocEnvironmentVariable'"/>


    <!--HSC Helmut's control variables -->
    <xsl:variable name="logonuser" select="'scherzer'"/>

    <!--revmode can contain values
    change-bars     : shows change bars in insert/delete
    show-annot      : shows oxygen comments and annotations in PDF (can be annoying if too many of them)
    -->
    <xsl:variable name="revmode" select="'change-bars show-annot'"/>

    <!-- ezRead path to project docu, required to resolve links automatically -->
    <xsl:variable name="DocuPath" select="$project.doc"/>
    <!--
    -->
    <!--HSX $bkxChGlossary controls printing subchapters in Glossary Bookmarks -->
    <xsl:variable name="bkxChGlossary" select="false()"/>
    
    <!--HSX $GlossaryTitle controls the name of the glossary title [default|target] -->
    <xsl:variable name="GlossaryTitle" select="'target'"/>

    <!--HSX $ezRead controls automatic scan and xref insertion on ezRead [] notation 
            set 'link' if you want to have ezRead links, otherwise set the value
            to anything else that does not contain 'link'
    -->
    <xsl:variable name="ezRead" select="'link'"/>
    
    <!--HSX use the navtitle for to avoid large title text crashing boundaries -->
    <xsl:variable  name="useNavTitle-toc"       select="true()"/>
    <xsl:variable  name="useNavTitle-minitoc"   select="true()"/>
    <xsl:variable  name="useNavTitle-bookmarks" select="true()"/>

    <!--HSX maxKeepLines determines a topic's distance from a prior title
    in order to insert a keep-with-previous -->
    <xsl:variable name="maxKeepLines" select="4"/>

    <!--HSC debugmsg controls the debugging mode -->
    <!--HSC side-col-width = 25mm is declared in basic-settings.xsl -->

    <!--HSX valid variables are
    dbg_code        : send messages
    dbg_showLabels  : puts page type into header/footer center
    dbg_fields      : shows fields if they don't exist in input source (currently unused)
    dbg_markfields  : give fields a background color -->
    <xsl:variable name="dbghs" select="'dbg_code dbg_fields dbg_NoshowLabels dbg_Nomarkfields'"/>
    
    <!--HSX date time formats to get the current date/time -->
    <xsl:variable name="currentDate" select="format-date(current-date(),'[D01].[M01].[Y0001]')"/>
    <!-- [XSLT#4.5] -->
    <xsl:variable name="currentDateVerbose" select="format-date(current-date(),'[D1o] [MNn] [Y0001]')"/>
    <xsl:variable name="currentTime" select="format-time(current-time(), '[H01]:[m01]')"/>
    <xsl:variable name="currentDateTime" select="format-dateTime(current-dateTime(),'[D01].[M01].[Y0001] at [H01]:[m01]')"/>

    <!--HSC EnumerationMode controls a chapter prefix on tables/figures as well as
    restarting table/figure numbering with the next chapter/appendix
    tbl_prefix / tbl_numrestart / fig_prefix / fig_numrestart / eq_prefix / eq_numrestart can be
    concatenated in the variable
    tbl_prefix/fig_prefix add the chapter number in the table/figure caption
    _numrestart will restart numbering of tables/figures with each chapter, only useful
    in connection with tbl_prefix/fig_prefix
    -->
    <xsl:variable name="EnumerationMode" select="'tbl_noprefix tbl_nonumrestart fig_noprefix fig_Nonumrestart eq_Noprefix eq_NOnumrestart'"/>

    <!--HSX Default scaling of images with parent::equation-block -->
    <xsl:variable name="EquationScale" select="50"/>

    <!--HSC Determine the position of the titles
    table_titleBelow :  puts table title below table
    table_titleRepeat:  puts table title top table and repeats it on page break
    fig_titleAbove   :  puts figure title above figure
    both of them just the opposite way as normal
    -->
    <xsl:variable name="TitlePosition" select="'table_titleRepeat fig_xitleAbove'"/>
    
    <!--HSX Alignment of the table title -->
    <xsl:variable name="TableTitleAlign" select="'left'"/>

    <xsl:variable name="OmitTableHdrOnPageBreak" select="'false'"/>
    
    <!--HSC PageLayout controls the layout of pages  -->
    <xsl:variable name="PageLayout" select="'print_shortdesc prefixNot_chapter'"/>

  <xsl:param name="antArgsBookmarkStyle"/>
  <!-- Values are COLLAPSED or EXPANDED. If a value is passed in from Ant, use that value. -->
  <xsl:variable name="bookmarkStyle" select="if (normalize-space($antArgsBookmarkStyle)) then $antArgsBookmarkStyle else 'COLLAPSE'"/>

  <!-- Determine how to style topics referenced by <chapter>, <part>, etc. Values are:
         MINITOC: render with a MiniToc on left, content indented on right.
         BASIC: render the same way as any topic. -->
  <xsl:param name="antArgsChapterLayout"/>
  <xsl:variable name="chapterLayout" select="if (normalize-space($antArgsChapterLayout)) then $antArgsChapterLayout else 'MINITOC'"/>

  <xsl:param name="appendixLayout" select="$chapterLayout"/>
  <xsl:param name="appendicesLayout" select="$chapterLayout"/>
  <xsl:param name="partLayout" select="$chapterLayout"/>
  <xsl:param name="noticesLayout" select="$chapterLayout"/>

  <!-- list of supported link roles -->
  <xsl:param name="include.rellinks"/>
  <xsl:variable name="includeRelatedLinkRoles" select="tokenize(normalize-space($include.rellinks), '\s+')" as="xs:string*"/>

    <!-- The default of 215.9mm x 279.4mm is US Letter size (8.5x11in) -->
<!--HSC ... changes default page format 8,27 x 11,69 (210x297mm) is DIN A4 -->
    <xsl:variable name="page-width">210.0mm</xsl:variable>
    <xsl:variable name="page-height">297.0mm</xsl:variable>

    <!--HSC provide size for landscape pages acc. to [DtPrt#12.7.7] -->
    <xsl:variable name="page-width-landscape">297.0mm</xsl:variable>
    <xsl:variable name="page-height-landscape">210.0mm</xsl:variable>
    <xsl:variable name="page-margin-landscape">20.0mm</xsl:variable>

    <!-- This is a default value useable for any vertical setting,
         it is not relevant unless used by following specifications -->
    <xsl:variable name="page-margins">15mm</xsl:variable>

    <!--HSC make a gap between region top/bottom and the region-before/after [DtPrt#7.9] -->
    <xsl:variable name="body-margin">25mm</xsl:variable>
    <!--HSC alternatively I do allow different definitions for region top/body
        These values are the allowed size, not the reserved size
    -->
    <xsl:variable name="region-top-margin">20mm</xsl:variable>
    <xsl:variable name="region-bottom-margin">25mm</xsl:variable>

    <!-- Change these if your page has different margins on different sides [DtPrt#7.12.2] -->
    <xsl:variable name="page-margin-inside">15.0mm</xsl:variable> <!-- $page-margins"/> -->
    <xsl:variable name="page-margin-outside">8mm</xsl:variable>
    <xsl:variable name="page-margin-top" select="$page-margins"/>
    <!-- reserve more space than default to allow multi-line footers -->
    <xsl:variable name="page-margin-bottom" select="'25mm'"/>

    <!--HSC provide separate margin variables for the front page -->
    <xsl:variable name="page-margin-outside-front" select="$page-margins"/>
    <xsl:variable name="page-margin-top-front" select="$page-margins"/>
    <xsl:variable name="page-margin-bottom-front" select="$page-margins"/>

    <!--HSC provide separate margin variables for the first body  [DtPrt#7.12.2] -->
    <xsl:variable name="page-margin-top-first">25mm</xsl:variable>
    <xsl:variable name="header-extent-first">0mm</xsl:variable>

    <!--The side column width is the amount the body text is indented relative to the margin. -->
    <!--HSC ... changes default indent of the text, originally = 25pt -->
    <xsl:variable name="side-col-width">25mm</xsl:variable>
    
    <!--HSX minSideColWidth-mm determines the minimum side-col-width to
            put out title text to side-col-width.
            (e.g. 1.2         File system) instead of (1.2 File system)
            If side-col-width is too small, then it will generate a collision between the
            heading number (e.g. head 6) and the heading text and we would not allow
            the text placement to the (too small) side-col-width.
            minSideColWidth-mm is the maximum size of a Head-N entry in mm.
    -->
    <xsl:variable name="minSideColWidth-mm">20</xsl:variable>

    <!--HSX mmMarginaliaGap specifies the gap between marginalia and text in mm -->
    <xsl:variable name="mmMarginaliaGap">4</xsl:variable>

    <xsl:variable name="pagewide">
        <xsl:variable name="pgwidthMM">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="$page-width"/>
                <xsl:with-param name="inUnitsOf" select="'mm'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="mrgleftMM">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="$page-margin-inside"/>
                <xsl:with-param name="inUnitsOf" select="'mm'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="mrgrightMM">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="$page-margin-outside"/>
                <xsl:with-param name="inUnitsOf" select="'mm'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="concat($pgwidthMM - $mrgleftMM - $mrgrightMM, 'mm')"/>
    </xsl:variable>

    <xsl:variable name="flowwide">
        <xsl:variable name="flowwideMM">
            <xsl:call-template name="mmGetAvailWidth"/>
        </xsl:variable>
        <!-- done by mmGetAvailWidth
        <xsl:variable name="pgwidthMM">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="$page-width"/>
                <xsl:with-param name="inUnitsOf" select="'mm'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="mrgleftMM">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="$page-margin-inside"/>
                <xsl:with-param name="inUnitsOf" select="'mm'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="mrgrightMM">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="$page-margin-outside"/>
                <xsl:with-param name="inUnitsOf" select="'mm'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:variable name="sdCol">
            <xsl:call-template name="convertUnits">
                <xsl:with-param name="numUnit" select="$side-col-width"/>
                <xsl:with-param name="inUnitsOf" select="'mm'"/>
            </xsl:call-template>
        </xsl:variable>
        <xsl:value-of select="concat($pgwidthMM - $mrgleftMM - $mrgrightMM - $sdCol, 'mm')"/>
        -->
        <xsl:value-of select="concat($flowwideMM, 'mm')"/>
    </xsl:variable>

    <!--HSX indentSubtitleText=true() indents the text of subtitles to $side-col-width
            if $side-col-width isn't too small, which is determined by $side-col-width &gt; $minSideColWidth-mm
            see: <xsl:if test="contains($titleNumber, '.')">
    -->
    <xsl:variable name="indentSubtitleText" select="true()"/>

    <!--HSC ... "true" changes to two-sided output toggling the page info left-right [DtPrt#7.6] -->
    <xsl:variable name="mirror-page-margins" select="true()"/>

    <!--HSX creation of main titles for Preface/Glossary/Notices -->
    <xsl:variable name="mainTitles" select="'xainPreface mainGlossary xainGlossTitle mainNotices'"/>

    <!--HSX default design layout - special for G&D [dsgn_smart | dsgn_gnd]
        The default value is only taken if the map does not contain bookmap/bookmeta/shortdesc
        where the shortdesc may suggest style:myStyle or any style check to be found in the
        document
    -->
    <xsl:variable name="docdesign">
        <xsl:choose>
            <xsl:when test="$map/bookmeta/shortdesc/data[@name='style']">
                <xsl:value-of select="$map/bookmeta/shortdesc/data[@name='style']"/>
                <!--
                <xsl:analyze-string select="$map/bookmeta/shortdesc/data[@name='style']" regex="{'.*style:(\S*)'}">
                    <xsl:matching-substring>
                        <xsl:message>Found:DESIGN-SMART</xsl:message>
                        <xsl:value-of select="regex-group(1)"/>
                    </xsl:matching-substring>  
                    <xsl:non-matching-substring>
                        <xsl:message>
                            <xsl:text>NoMatch:DESIGN-SMART</xsl:text>
                            <xsl:value-of select="."/>
                        </xsl:message>
                    </xsl:non-matching-substring>                  
                </xsl:analyze-string>
                -->
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'dsgn_gnd'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>

<!--HSC ... changes default font size of many children [DtPrt#5.7] -->
<!--HSC also discussed in [DtPrt#10.4.2] I already use the FrameMaker settings -->
    <xsl:variable name="default-font-size">10pt</xsl:variable>
<!--HSC ... changing default line height part of [DtPrt#10.4.4]
    <xsl:variable name="default-line-height">12pt</xsl:variable>  -->
<!--HSC other suggestion for default-line-height from [DtPrt#10.4.4]  -->
    <xsl:variable name="default-line-height">120%</xsl:variable>
    
    <!--HSC padding between a Level 1 entry and the following level 2 entries -->
    <xsl:variable name="toc2padding" select="'7pt'"/>

<!-- [DtPrt#5.7] suggested very often $990033 -->
<!--HSC ... FrameMaker's color definitions -->

    <xsl:variable name="FmColor-RoyalBlue100">#128AFF</xsl:variable>
    <xsl:variable name="FmColor-RoyalBlue30">#1BCFFF</xsl:variable>


    <xsl:variable name="Frame-color">#708090</xsl:variable>
    <xsl:variable name="Table-backgroundHeader">#E6E6FF</xsl:variable>
    <xsl:variable name="Table-backgroundRow">#F0F8FF</xsl:variable>
    <xsl:variable name="Table-highlightRow">#C0FFE0</xsl:variable>

    <xsl:variable name="Table-frameTop">#656565</xsl:variable>
    <xsl:variable name="Table-frameBottom">#656565</xsl:variable>
    <xsl:variable name="Table-frameRight">#656565</xsl:variable>
    <xsl:variable name="Table-frameLeft">#656565</xsl:variable>
    <xsl:variable name="Table-frameWidth">0.5pt</xsl:variable>


    <xsl:variable name="Table-ruleTop">#808080</xsl:variable>
    <xsl:variable name="Table-ruleBottom">#808080</xsl:variable>
    <xsl:variable name="Table-ruleRight">#808080</xsl:variable>
    <xsl:variable name="Table-ruleLeft">#808080</xsl:variable>

    <xsl:variable name="Toc-level-1">black</xsl:variable>
    <xsl:variable name="Toc-level-n">#424242</xsl:variable>
    <xsl:variable name="Toc-pagenumber">#212142</xsl:variable>

    <xsl:variable name="Figure-titleTopCaption">#212143</xsl:variable>
    <xsl:variable name="Figure-titleTopText">#104081</xsl:variable>
    <xsl:variable name="Figure-titleBottomCaption">#010102</xsl:variable>
    <xsl:variable name="Figure-titleBottomText">#010101</xsl:variable>

  <xsl:variable name="generate-front-cover" select="true()"/>
  <xsl:variable name="generate-back-cover" select="false()"/>
  <xsl:variable name="generate-toc" select="true()"/>

    <xsl:variable name="Task-title">#000003</xsl:variable>
    <xsl:variable name="Task-prereq">#212142</xsl:variable>
    <xsl:variable name="Task-context">#000002</xsl:variable>
    <xsl:variable name="Task-content">black</xsl:variable>
    <xsl:variable name="Task-result">#212142</xsl:variable>
    <xsl:variable name="Task-example">#212142</xsl:variable>
    <xsl:variable name="Task-postreq">#212142</xsl:variable>
    <xsl:variable name="Task-stepLabel">#212142</xsl:variable>
    <xsl:variable name="Task-substepLabel">#212142</xsl:variable>

    <xsl:variable name="Backmatter-copyright">#212142</xsl:variable>
    <xsl:variable name="Backmatter-item">#212142</xsl:variable>

    <xsl:variable name="Section-title">#212142</xsl:variable>
    <xsl:variable name="marginaliaFont">black</xsl:variable>

    <xsl:variable name="Footnote-callout">#212142</xsl:variable>
    <xsl:variable name="Note-label">#212142</xsl:variable>
    <xsl:variable name="Shortdesc-inline">#020001</xsl:variable>
    <xsl:variable name="Shortdesc-asBlock">#010002</xsl:variable>

    <xsl:variable name="Index-pageLink">#128AFE</xsl:variable>
    <xsl:variable name="Index-letterGroup">#212142</xsl:variable>

    <!--HSX header text color -->
    <xsl:variable name="Header-heading">#202080</xsl:variable>
    <xsl:variable name="Header-ruler">#808080</xsl:variable>

    <xsl:variable name="Footer-heading">#808082</xsl:variable>
    <xsl:variable name="Footer-pagenum">#000001</xsl:variable>
    <xsl:variable name="Footer-ruler">#808080</xsl:variable>

    <xsl:variable name="TestGreen">#00FF80</xsl:variable>

    <!-- specifiy space-before list entries -->
    <xsl:variable name="advance-entry">12pt</xsl:variable>
    <xsl:variable name="advance-default">6pt</xsl:variable>
    <xsl:variable name="advance-compact">0pt</xsl:variable>

    <xsl:variable name="upShiftHead-1">24pt</xsl:variable>
    <xsl:variable name="upShiftHead-2">20pt</xsl:variable>
    <xsl:variable name="upShiftHead-3">18pt</xsl:variable>
    <xsl:variable name="upShiftHead-4">16pt</xsl:variable>
    <xsl:variable name="upShiftHead-5">14pt</xsl:variable>
    <xsl:variable name="upShiftHead-6">14pt</xsl:variable>

    <xsl:variable name="Debug-markField">#F0F0FF</xsl:variable>


</xsl:stylesheet>
