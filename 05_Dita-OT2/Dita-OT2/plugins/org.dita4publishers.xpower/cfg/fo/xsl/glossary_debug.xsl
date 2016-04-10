<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:fo="http://www.w3.org/1999/XSL/Format"
    xmlns:ot-placeholder="http://suite-sol.com/namespaces/ot-placeholder"
    extension-element-prefixes="ot-placeholder"
    version="2.0">


<!--
__chapter__frontmatter__name__container_1

-->

    <xsl:template match="ot-placeholder:glossarylist" name="createGlossary">
        <fo:page-sequence master-reference="glossary-sequence" xsl:use-attribute-sets="__force__page__count">
            <xsl:call-template name="insertGlossaryStaticContents"/>
            <fo:flow flow-name="xsl-region-body">
                <fo:marker marker-class-name="current-header">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'Glossary'"/>
                    </xsl:call-template>
                </fo:marker>
                <fo:block xsl:use-attribute-sets="__glossary__label __chapter__frontmatter__name__container" id="{$id.glossary}">
                    <xsl:call-template name="getVariable">
                        <xsl:with-param name="id" select="'Glossary'"/>
                    </xsl:call-template>
                </fo:block>
                <xsl:apply-templates/>
            </fo:flow>
        </fo:page-sequence>
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
    <xsl:template name="showId">
        <xsl:message>
            <xsl:text>&#xA;Id = [</xsl:text>
            <xsl:value-of select="@id"/>
            <xsl:text>]</xsl:text>
            <xsl:text>[</xsl:text>
            <xsl:value-of select="../@id"/>
            <xsl:text>]&#xA;</xsl:text>
        </xsl:message>
    </xsl:template>

    <xsl:template match="glossterm">
        <xsl:call-template name="commonattributes"/>
        <xsl:message>
            <xsl:text>&#xA;NodeName:</xsl:text>
            <xsl:value-of select="name()"/>
            <xsl:text>&#xA;NodeID  :</xsl:text>
            <xsl:value-of select="@id"/>
        </xsl:message>
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="ot-placeholder:glossarylist//*[contains(@class, ' glossentry/glossentry ')]">
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
    </xsl:template>

</xsl:stylesheet>

