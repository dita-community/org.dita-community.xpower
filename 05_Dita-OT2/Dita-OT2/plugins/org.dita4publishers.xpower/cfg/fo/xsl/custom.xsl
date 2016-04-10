<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    version="2.0">

    <xsl:import href="commons.xsl"/>
    <xsl:import href="root-processing.xsl"/>
    <xsl:import href="root-processing_axf.xsl"/>
    <xsl:import href="static-content.xsl"/>
    <xsl:import href="lists.xsl"/>
    <xsl:import href="tables.xsl"/>
    <xsl:import href="front-matter.xsl"/>
    <xsl:import href="back-matter.xsl"/>
    <xsl:import href="hi-domain.xsl"/>
    <xsl:import href="pr-domain.xsl"/>
    <xsl:import href="sw-domain.xsl"/>
    <xsl:import href="task-elements.xsl"/>
    <xsl:import href="links.xsl"/>
    <xsl:import href="abbrev-domain.xsl"/>
    <xsl:import href="ui-domain.xsl"/>
    <xsl:import href="ut-domain.xsl"/>
    <xsl:import href="index.xsl"/>
    <xsl:import href="index_axf.xsl"/>
    <xsl:import href="bookmarks.xsl"/>
    <xsl:import href="toc.xsl"/>
    <xsl:import href="preface.xsl"/>
    <xsl:import href="glossary.xsl"/>
    <xsl:import href="lot-lof.xsl"/>
    <xsl:import href="topic2fo.xsl"/>
    <xsl:import href="svgScale.xsl"/>
    <xsl:import href="equations.xsl"/>
    <xsl:import href="annot_axf.xsl"/>

    <xsl:import href="../layout-masters.xsl"/>
    <!--HSX used to dispatch shiftUpHead attributes -->
    <xsl:import href="../attr-set-reflection.xsl"/>

    <!--HSX topicmerge fixes xrefs to glossterms

    Until now ... I did not succeed to customize topicmerge because
    transform.fo2pdf.ah.nooption:
    reports AHF error if we compile it from the custom plugin

    <xsl:import href="../topicmerge.xsl"/>
    <xsl:import href="../topicmergeImpl.xsl"/>
    <xsl:import href="../topicmerge_template.xsl"/>
    -->
    <!-- [DtPrt#13.11] allows placing the table title below the table
    The trick here is, that the following template is processed prior to any other template.
    Therefore it captures the default which places the title above  -->
    <!-- blocking the title on top of table .... -->
    <xsl:template match="*[contains(@class,' topic/table ')]/*[contains(@class,' topic/title ')]">
        <xsl:if test="contains($TitlePosition, 'table_titleAbove')">
            <xsl:call-template name="titleAbove"/>
        </xsl:if>
    </xsl:template>

    <!-- Add chapter, appendix or part numbers to table titles, page numbers etc. -->
    <!-- [DtPrt#13.12] This template donated by Kyle Schwamkrug, from the dita-users Yahoo group.-->
    <xsl:template name="getChapterPrefix">
        <xsl:variable name="topicType">
            <xsl:call-template name="determineTopicType"/>
        </xsl:variable>
        <!-- Looks back up the document tree to find which top-level topic I'm nested in. -->
        <xsl:variable name="containingChapter" select="ancestor-or-self::*[contains(@class, ' topic/topic')][position()=last()]"/>
        <!-- And get the id of that chapter. I'll need it later. -->
        <xsl:variable name="id" select="$containingChapter/@id"/>
        <!-- Get the chapters and appendixes from the merged map because, at this point, I don't
        know whether the topic I'm in is inside a chapter or an appendix or a part. -->
        <xsl:variable name="topicChapters">
            <xsl:copy-of select="$map//*[contains(@class, ' bookmap/chapter')]"/>
        </xsl:variable>
        <xsl:variable name="topicAppendices">
            <xsl:copy-of select="$map//*[contains(@class, ' bookmap/appendix')]"/>
        </xsl:variable>
        <xsl:variable name="topicParts">
            <xsl:copy-of select="$map//*[contains(@class, ' bookmap/part')]"/>
        </xsl:variable>
        <!-- Figure out the chapter number. -->
        <xsl:variable name="chapterNumber">
            <xsl:choose>
                <!-- If there's something in $topicChapters with an id that matches the id of the
                context node, then I'm inside a chapter. [string-length(normalize-space(./title/text())) &gt; 0] -->
                <xsl:when test="$topicChapters/*[@id = $id]">
                    <xsl:number format="1" value="count($topicChapters/*[@id = $id]/preceding-sibling::*) + 1"/>
                </xsl:when>
                <!-- If there's something in $topicAppendices with an id that matches the id of
                the context node, then I'm inside an appendix. -->
                <xsl:when test="$topicAppendices/*[@id = $id]">
                    <xsl:number format="A" value="count($topicAppendices/*[@id = $id]/preceding-sibling::*) + 1"/>
                </xsl:when>
                <!-- If there's something in $topicParts with an id that matches the id of the context node,
                then I'm inside a part. -->
                <xsl:when test="$topicParts/*[@id = $id]">
                    <xsl:number format="I" value="count($topicParts/*[@id = $id]/preceding-sibling::*) + 1"/>
                </xsl:when>
                <xsl:otherwise></xsl:otherwise>
            </xsl:choose>
        </xsl:variable>
        <!-- If $chapterNumber is defined, return it.-->

        <xsl:choose>
            <!--HSX2:emptyTitle avoids printing chapter number of empty titles
            this choice creates the chapter number prefix for the page numbers in the toc
            e.g.  ..... 5-42 where 5 is the chapter number and 42 the page
            -->
            <xsl:when test="$chapterNumber != ''">
                <xsl:value-of select="$chapterNumber"/>
            </xsl:when>
            <!--
            <xsl:otherwise>
            <xsl:value-of select="$topicType"/>
            </xsl:otherwise>
            -->
        </xsl:choose>
    </xsl:template>
    
</xsl:stylesheet>
