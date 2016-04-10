<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:util="something" xmlns:java-file="java:java.io.File"
    xmlns:java-uri="java:java.net.URI" xmlns:java-imageicon="java:javax.swing.ImageIcon">

    <xsl:variable name="myfile1" select="'F:/scherzer/RefDita/Stylesheets/SvgFixVisio/m1.gif'" as="xs:string"/>
    <xsl:variable name="myfile2" select="'F:/hs/test.svg'" as="xs:string"/>
    <!-- doesn't work of course -->

    <xsl:template match="/">
        <xsl:value-of select="util:file-exists('file:/F:/Gnd/DocuDesign/Dita/Docu/MyDita/Book/src/gfx/lusrmgr03.png')"/>
        <xsl:text>&#xA;URI[</xsl:text>
        <xsl:value-of select="java-uri:new('file:/F:/scherzer/RefDita/Stylesheets/SvgFixVisio/m1.gif')"/>
        <xsl:text>]&#xA;Size[</xsl:text>
        <xsl:value-of select="util:image-width($myfile1)"/>
        <xsl:text>]</xsl:text>
        <!-- 534x591 -->

        <xsl:call-template name="roundUnit">
            <xsl:with-param name="val" select="700" as="xs:double"/>
        </xsl:call-template>

    </xsl:template>

    <!--HSX roundUnit determines the best increment value that is a multiple of 10**n -->
    <xsl:template name="roundUnit">
        <xsl:param name="val" select="rawVal" as="xs:double"/>
        
        <xsl:variable name="lg10">
            <xsl:value-of select="string-length(string(round(1000*$val)))"/>
        </xsl:variable>
        <xsl:variable name="tox">
            <xsl:value-of select="$lg10"/>
        </xsl:variable>

        <xsl:variable name="fc" as="xs:integer">
            <xsl:variable name="sq0">
                <xsl:for-each
                    select="
                        for $i in 2 to $tox
                        return
                            $i">
                    <xsl:value-of select="'0'"/>
                </xsl:for-each>
            </xsl:variable>
            <xsl:value-of select="number(concat('1', string($sq0)))"/>
        </xsl:variable>
        
        <xsl:variable name="dtm" as="xs:double">
            <xsl:value-of select="1000*$val div $fc"/>
        </xsl:variable>
        
        <xsl:value-of select="$dtm"/>
        
        <xsl:text>&#xA;</xsl:text>
        <xsl:variable name="incr">
            <xsl:choose>
                <xsl:when test="$dtm &gt; 7.5">
                    <xsl:value-of select="10"/>
                </xsl:when>
                <xsl:when test="$dtm &gt; 3.5">
                    <xsl:value-of select="5"/>
                </xsl:when>
                <xsl:when test="$dtm &gt; 1.5">
                    <xsl:value-of select="2"/>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:value-of select="1"/>
                </xsl:otherwise>            
            </xsl:choose>
        </xsl:variable>
        <xsl:value-of select="$incr * $fc div 1000"/>
    </xsl:template>


    <!--HSX http://blog.expedimentum.com/2010/java-in-xslt-verwenden/ -->

    <!--HSX The invokation with string(..) is necessary to call the string constructor.
            If we don't use string(...) then the $-sign of the variable makes the
            function think to expect a byte instead of a string
    -->

    <xsl:function name="util:file-exists" as="xs:boolean">
        <xsl:param name="fileURL" as="xs:string"/>
        <xsl:sequence select="java-file:exists(java-file:new(java-uri:new(string($fileURL))))"/>
    </xsl:function>

    <xsl:function name="util:image-width">
        <xsl:param name="fileURL" as="xs:string"/>
        <xsl:variable name="myfile" select="java-imageicon:new($fileURL)"/>
        <xsl:value-of select="java-imageicon:getIconWidth(java-imageicon:new(string($fileURL)))"/>
    </xsl:function>

    <xsl:function name="util:image-height" as="xs:integer">
        <xsl:param name="fileURL" as="xs:string"/>
        <xsl:value-of select="java-imageicon:getIconHeight(java-imageicon:new(string($fileURL)))"/>
    </xsl:function>

</xsl:stylesheet>
