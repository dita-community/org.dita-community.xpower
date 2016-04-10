<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fs="java.io.File" xmlns:fn="http://www.w3.org/2005/xpath-functions" exclude-result-prefixes="xsl fn xs fs"
    version="2.0">

    <xsl:variable name="folderURI" select="resolve-uri('.', base-uri())"/>

    <xsl:template match="/">
        <!-- WORKING !, but only accepts XML files -->
        <xsl:choose>
            <xsl:when test="document(concat($folderURI, 'ignore.xml'))"> The file exists! </xsl:when>
            <xsl:otherwise> Can't find the file... </xsl:otherwise>
        </xsl:choose>

        <xsl:call-template name="filexx">
            <xsl:with-param name="filename" select="concat($folderURI, 'ignore.xml')"/>
        </xsl:call-template>
        <xsl:call-template name="filexx">
            <xsl:with-param name="filename" select="'FileExists.xsl'"/>
        </xsl:call-template>
        <xsl:call-template name="check_directory">
            <xsl:with-param name="filename" select="$folderURI"/>
        </xsl:call-template>
    </xsl:template>
    
    <!-- not working, file will not be found -->
    <xsl:template name="filex">
        <xsl:text>&#xA;filex&#xA;</xsl:text>
        <xsl:choose>
            <xsl:when test="fs:exists(fs:new(concat($folderURI, 'ignore.xml')))">
                <xsl:text>file[</xsl:text>
                <xsl:value-of select="concat($folderURI, 'Ignore.xml')"/>
                <xsl:text>] exists!</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>file[</xsl:text>
                <xsl:value-of select="concat($folderURI, 'Ignore.xml')"/>
                <xsl:text>] does not exist!</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <!-- not working, file will not be found -->
    <xsl:template name="filexx">
        <xsl:param name="filename" as="xs:string"/>

        <xsl:text>&#xA;filexx&#xA;</xsl:text>
        <xsl:choose>
            <xsl:when test="fs:exists(fs:new($filename))">
                <xsl:text>--</xsl:text>
                <xsl:value-of select="$filename"/>
                <xsl:text> exists!</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>--</xsl:text>
                <xsl:value-of select="$filename"/>
                <xsl:text> does not exist!</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template name="check_directory" xmlns:file="java.io.File">
        <xsl:param name="filename" as="xs:string"/>
        <xsl:text>&#xA;CHECKDIR&#xA;</xsl:text>
        <xsl:variable name="directory"
            select="file:new(file:getParent(file:new($filename)))" />
        <xsl:choose>
            <xsl:when test="not(file:exists($directory))">
                <xsl:text>dbg1</xsl:text>
                <xsl:choose>
                    <xsl:when test="file:mkdirs($directory)">
                        <xsl:message>
                            <xsl:text>Creating directory `</xsl:text>
                            <xsl:value-of select="file:getPath($directory)" />
                            <xsl:text>'</xsl:text>
                        </xsl:message>
                    </xsl:when>
                    <xsl:otherwise>
                        <xsl:message>
                            <xsl:text>WARNING : unable to create directory `</xsl:text>
                            <xsl:value-of select="file:getPath($directory)" />
                            <xsl:text>'.</xsl:text>
                        </xsl:message>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>Directory EXISTS</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template> <!-- name="file_util_check_directory" -->
    


</xsl:stylesheet>
