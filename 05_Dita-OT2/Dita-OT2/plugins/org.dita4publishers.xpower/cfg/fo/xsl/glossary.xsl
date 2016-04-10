<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder" extension-element-prefixes="ot-placeholder" version="2.0">

    <xsl:template match="ot-placeholder:glossarylist" name="createGlossary">
        <fo:page-sequence master-reference="glossary-sequence" xsl:use-attribute-sets="page-sequence.glossary">
            <xsl:call-template name="insertGlossaryStaticContents"/>
            <fo:flow flow-name="xsl-region-body">
                <fo:marker marker-class-name="current-header">
                    <xsl:call-template name="getGlossaryTitle"/>
                </fo:marker>
                <!--HSX print "GLOSSARY" only if desired -->
                <xsl:choose>
                    <xsl:when test="contains($mainTitles, 'mainGlossary')">
                        <fo:block>
                            <xsl:attribute name="id" select="glossgroup/@id"/>
                        </fo:block>
                        <fo:block xsl:use-attribute-sets="__glossary__label __chapter__frontmatter__name__container" id="{$id.glossary}">
                            <xsl:call-template name="getGlossaryTitle"/>
                        </fo:block>
                    </xsl:when>
                    <!-- create empty block to let the previous marker live -->
                    <xsl:otherwise>
                        <fo:block id="{$id.glossary}"/>
                    </xsl:otherwise>
                </xsl:choose>
                <xsl:apply-templates/>
            </fo:flow>
        </fo:page-sequence>
    </xsl:template>

    <xsl:template name="getGlossaryTitle">
        <xsl:choose>
            <xsl:when test="contains($GlossaryTitle, 'default')">
                <xsl:call-template name="getVariable">
                    <xsl:with-param name="id" select="'Glossary'"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:when test="contains($GlossaryTitle, 'target')">
                <xsl:apply-templates select="glossgroup/*[contains(@class, ' topic/title ')]" mode="getNonumTitle"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:apply-templates select="glossgroup/*[contains(@class, ' topic/title ')]" mode="getNonumTitle"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!--
    <xsl:template match="ot-placeholder:glossarylist//*[contains(@class, ' glossentry/glossentry ')]">
        <fo:block>
            <xsl:call-template name="commonattributes"/>
            <fo:block>
                <xsl:attribute name="id">
                    <xsl:call-template name="generate-toc-id"/>
                </xsl:attribute>
                <fo:block xsl:use-attribute-sets="__glossary__term" >
                    <xsl:attribute name="id" select="@id"/>

                    <xsl:apply-templates select="*[contains(@class, ' glossentry/glossterm ')]/node()"/>
                </fo:block>
                <fo:inline-container xsl:use-attribute-sets="__glossary__def">
                    <fo:block>
                        <xsl:apply-templates select="*[contains(@class, ' glossentry/glossdef ')]/node()"/>
                    </fo:block>
                </fo:inline-container>
            </fo:block>
        </fo:block>
    </xsl:template>

    -->
    <!--HSX match glossterm only if we are child of bookmap, otherwise
            we come from commons.xsl template match="*" mode="commonTopicProcessing"
            and glossterm is seen as a specialization of title (it contains class concept/title)
    -->
    <xsl:template match="*[contains(@class, ' glossentry/glossterm ') and ($mapType = 'bookmap')]">
        <xsl:call-template name="commonattributes"/>
        <xsl:apply-templates/>
    </xsl:template>


    <xsl:template match="ot-placeholder:glossarylist//*[contains(@class, ' glossentry/glossentry ')]">
        <xsl:choose>
            <xsl:when test="contains(../@class, 'glossgroup')">
                <fo:table>
                    <fo:table-body xsl:use-attribute-sets="__glossary__list">
                        <fo:table-row xsl:use-attribute-sets="__glossary__entry">
                            <fo:table-cell xsl:use-attribute-sets="__glossary__term_cell">
                                <xsl:attribute name="id" select="@id"/>
                                <fo:block xsl:use-attribute-sets="__glossary__term">
                                    <xsl:apply-templates select="*[contains(@class, ' glossentry/glossterm ')]"/>
                                </fo:block>
                            </fo:table-cell>
                            <fo:table-cell xsl:use-attribute-sets="__glossary__def_cell">
                                <xsl:attribute name="id" select="glossdef/@id"/>
                                <fo:block xsl:use-attribute-sets="__glossary__def">
                                    <xsl:apply-templates select="*[contains(@class, ' glossentry/glossdef ')]/node()"/>
                                </fo:block>
                            </fo:table-cell>
                        </fo:table-row>
                    </fo:table-body>
                </fo:table>
            </xsl:when>
            <xsl:otherwise>
                <fo:block>
                    <xsl:call-template name="commonattributes"/>
                    <fo:block xsl:use-attribute-sets="__glossary__term">
                        <xsl:attribute name="id">
                            <xsl:call-template name="generate-toc-id"/>
                        </xsl:attribute>
                        <fo:table>
                            <fo:table-body xsl:use-attribute-sets="__glossary__list">
                                <fo:table-row xsl:use-attribute-sets="__glossary__entry">
                                    <fo:table-cell xsl:use-attribute-sets="__glossary__term_cell">
                                        <fo:block xsl:use-attribute-sets="__glossary__term">
                                            <xsl:apply-templates select="*[contains(@class, ' glossentry/glossterm ')]"/>
                                        </fo:block>
                                    </fo:table-cell>
                                    <fo:table-cell xsl:use-attribute-sets="__glossary__def_cell">
                                        <fo:block xsl:use-attribute-sets="__glossary__def">
                                            <xsl:apply-templates select="*[contains(@class, ' glossentry/glossdef ')]/node()"/>
                                        </fo:block>
                                    </fo:table-cell>
                                </fo:table-row>
                            </fo:table-body>
                        </fo:table>
                    </fo:block>
                </fo:block>
                <!--
                    <fo:block xsl:use-attribute-sets="__glossary__term" >
                        <xsl:attribute name="id" select="@id"/>
    
                        <xsl:apply-templates select="*[contains(@class, ' glossentry/glossterm ')]/node()"/>
                    </fo:block>
                    <fo:inline-container xsl:use-attribute-sets="__glossary__def">
                        <fo:block>
                            <xsl:apply-templates select="*[contains(@class, ' glossentry/glossdef ')]/node()"/>
                        </fo:block>
                    </fo:inline-container>
                    -->
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

</xsl:stylesheet>
