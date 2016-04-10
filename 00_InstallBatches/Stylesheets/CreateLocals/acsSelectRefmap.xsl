<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xmp="http://ns.adobe.com/xap/1.0/" xmlns:pdf="http://ns.adobe.com/pdf/1.3/"
    xmlns:xmpMM="http://ns.adobe.com/xap/1.0/mm/" xmlns:dc="http://purl.org/dc/elements/1.1/"
    xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#" xmlns:x="adobe:ns:meta/" xmlns:exslt="http://exslt.org/common"
    xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:fox="http://www.w3.org/1999/XSL/Formatx" xmlns:my="my:my"
    xmlns:ditaarch="http://dita.oasis-open.org/" exclude-result-prefixes="xsl x fox fn xs xml ditaarch dc pdf xlink xmpMM xmp my rdf"
    version="2.0">
    <!--<xsl:output method="xml" use-character-maps="sample"/>-->

    <xsl:output method="text" indent="no" use-character-maps="sample" name="text"/>
    <xsl:output method="xml" indent="no" use-character-maps="sample" name="xml"/>

    <xsl:param name="MasterPathName" required="no" select="'/F:/scherzer/RefDita/MasterLists/McGlossary.dita'" as="xs:string"/>
    <xsl:param name="FirstRun" required="no" select="''" as="xs:string"/>
    <!-- We shall know where to place the target -->
    <xsl:param name="DitaToken" required="yes" as="xs:string"/>
    
    <xsl:character-map name="sample">
        <!--    <xsl:output-character character="&#x3C;" string="&lt;"/>
        <xsl:output-character character="&#x3E;" string="&gt;"/>-->
        <xsl:output-character character="⊕" string="&amp;#x2295;"/>
        <xsl:output-character character="“" string='"'/>
        <xsl:output-character character="”" string='"'/>
        <!--<xsl:output-character character="&#x26;" string='&amp;'/>-->
    </xsl:character-map>
    <xsl:variable name="unittest" select="''"/>
    <!-- chkgloss -->

    <!-- get entry position either from simple position or from its colname -->
    <!-- acting on 'entry' -->

    <!-- Variables which import the Glossary table -->
    <xsl:variable name="ProductNameFN" select="'Local'"/>

    <!--
    <xsl:variable name="acName" select="concat('REF_acs_', $ProductNameFN, '.dita')"/>
    -->
    <xsl:variable name="acName" select="'Acronyms.dita'"/>
    <!-- opmode = [local | conref]  ONLY local IS ALLOWED for acronyms -->
    <xsl:variable name="opMode" select="'local'"/>

    <xsl:variable name="McGlossary">
        <!--<xsl:copy-of select="document('src/test.dita')//glossentry" copy-namespaces="no"/>-->
        <xsl:copy-of select="document(concat('/', $MasterPathName))//glossentry" copy-namespaces="no"/>
        <!-- checking if file name is broken and we get I/O error
        <xsl:variable name="chk1">
            <xsl:value-of select="concat('/', $MasterPathName)"/>
        </xsl:variable>
        <xsl:variable name="chk2">
            <xsl:value-of select="'/F:/scherzer/RefDita/MasterLists/McGlossary_Tachograph.dita'"/>
        </xsl:variable>
        <xsl:copy-of select="document($chk1)//glossentry" copy-namespaces="no"/>
        <xsl:message>
            <xsl:text>chk1:</xsl:text>
            <xsl:value-of select="$chk1"/>
            <xsl:text>&#xA;chk2:</xsl:text>
            <xsl:value-of select="$chk2"/>
        </xsl:message>
        -->
    </xsl:variable>

    <!--<xsl:template match="/">
        <xsl:variable name="newacs">
            <xsl:call-template name="createAcronyms"/>
        </xsl:variable>
        <xsl:apply-templates select="$newacs" mode="copy"/>
    </xsl:template>-->

    <!-- Deep copy template with cleanup of unwanted attributes
        
        I had to delete the restriction 
          [not(contains(name(), 'class'))]
        because it didn't let through @output'class'
    -->
    <xsl:template match="node() | @*" mode="copy">
        <xsl:copy copy-namespaces="no">
            <!-- copy all attributes -->
            <xsl:apply-templates mode="copy"
                select="
                    @*
                    [not(contains(name(), 'DITAArchVersion'))]
                    [not(contains(local-name(), 'DITAArchVersion'))]
                    [not(contains(name(), 'domains'))]"/>
            <!-- copy all children -->
            <xsl:apply-templates mode="copy"/>
        </xsl:copy>
    </xsl:template>


    <!-- extract the basename (e.g. APDU) from the actual @keyref = acs/acs_APDU_1 -->
    <xsl:template name="getAcroRef">
        <xsl:param name="myNode" select="." as="node()*"/>
        <xsl:analyze-string select="$myNode/@keyref" regex="{'.*acs/acs_(.*)_?.*'}">
            <xsl:matching-substring>
                <xsl:value-of select="regex-group(1)"/>
            </xsl:matching-substring>
        </xsl:analyze-string>
    </xsl:template>

    <xsl:template name="normalizeName">
        <xsl:param name="myName"/>
        <xsl:value-of select="translate(normalize-space($myName), '_:=@+`/#() &amp;', '..eapps_xy-')"/>
    </xsl:template>

    <!-- Create Acronyms with only those entries that are present in file -->
    <xsl:template name="createAcronyms">
        <xsl:message>
            <xsl:text>MasterFile = </xsl:text>
            <xsl:value-of select="$MasterPathName"/>
        </xsl:message>

        <!-- Plan the production in TcMap.xsl -->
        <xsl:element name="concept">
            <xsl:attribute name="id" select="'acs'"/>
            <!-- did not use @anchor -->
            <!-- We create an EMPTY TITLE which allows us to add the generated content
                 to the .ditamap adjacent to the introductory chapter heading etc.
            -->
            <xsl:element name="title">
                <xsl:attribute name="id" select="'_acs'"/>
            </xsl:element>
            <xsl:element name="conbody">
                <xsl:element name="p">
                    <xsl:element name="table">
                        <xsl:attribute name="frame" select="'none'"/>
                        <xsl:attribute name="id" select="'tblAcronyms'"/>
                        <xsl:attribute name="pgwide" select="0"/>
                        <xsl:attribute name="outputclass" select="'rowcolor=white'"/>
                        <xsl:element name="tgroup">
                            <xsl:attribute name="cols" select="2"/>
                            <xsl:element name="colspec">
                                <xsl:attribute name="colname" select="'c1'"/>
                                <xsl:attribute name="colnum" select="'1'"/>
                                <xsl:attribute name="colwidth" select="'30mm'"/>
                                <xsl:attribute name="rowsep" select="0"/>
                            </xsl:element>
                            <xsl:element name="colspec">
                                <xsl:attribute name="colname" select="'c2'"/>
                                <xsl:attribute name="colnum" select="'2'"/>
                                <xsl:attribute name="colwidth" select="'1.0*'"/>
                                <xsl:attribute name="rowsep" select="0"/>
                            </xsl:element>
                            <xsl:element name="tbody">
                                <xsl:call-template name="selectAcronym"/>
                            </xsl:element>
                        </xsl:element>
                    </xsl:element>
                </xsl:element>
            </xsl:element>
        </xsl:element>
        <!--</xsl:result-document>-->
    </xsl:template>

    <!-- called on conbody level -->
    <xsl:template name="selectAcronym">
        <!-- create unique values but unsorted -->
        <!--
        <xsl:message>
            <xsl:for-each select="/Doc//*[name()='Ref.Glossary']">
                <xsl:value-of select="."/>
            </xsl:for-each>
        </xsl:message>
        -->

        <!-- remove duplicates -->
        <!-- The "group-by" picks the first of all similar entries -->
        <xsl:variable name="acsref">
            <xsl:for-each-group select="//xref[starts-with(@keyref, 'refacs/acs_') or starts-with(@keyref, 'acs/acs_')]" group-by="@keyref">
                <!-- acselect shall contain the actual reference like "APDU" from "acs/acs_APDU" -->
                <xsl:variable name="acselect">
                    <xsl:call-template name="getAcroRef"/>
                </xsl:variable>

                <xsl:if test="contains($unittest, 'chkgloss')">
                    <xsl:message>
                        <xsl:text>Catching:</xsl:text>
                        <xsl:value-of select="$acselect"/>
                    </xsl:message>
                </xsl:if>
                <!-- Copy the entire xref topic -->
                <xsl:element name="acsref">
                    <xsl:copy-of select="." copy-namespaces="no"/>
                    <!-- find the target term and entry - if our xref is empty
                     then we can only correctly sort if we know the actual
                     content of the referenced glossterm -->
                    <xsl:element name="TargetTerm">
                        <xsl:call-template name="getTargetTerm"/>
                    </xsl:element>

                    <!-- check potential audience tag -->
                    <xsl:if test="ancestor-or-self::*[@audience]">

                        <xsl:element name="Audience">
                            <xsl:value-of select="(ancestor-or-self::*[@audience])[1]/@audience"/>
                        </xsl:element>
                    </xsl:if>
                </xsl:element>
            </xsl:for-each-group>
        </xsl:variable>

        <!-- create sorted list  -->
        <xsl:variable name="acssort">
            <xsl:for-each select="$acsref/acsref">
                <!--<xsl:sort select="upper-case(.)" order="ascending"/>-->
                <!-- we sort after the TargetTerm which is the following sibling -->
                <xsl:sort select="upper-case(TargetTerm)" order="ascending"/>
                <xsl:if test="contains($unittest, 'chktarget')">
                    <xsl:message>
                        <xsl:text>TARGETNAME[</xsl:text>
                        <xsl:value-of select="xref/@keyref"/>
                        <xsl:text>]=</xsl:text>
                        <xsl:value-of select="Audience"/>
                    </xsl:message>
                    <!--<xsl:message>
                    <xsl:text>SHOW[</xsl:text>
                    <xsl:value-of select="$myPos"/>
                    <xsl:text>]:</xsl:text>
                    <xsl:copy-of select="($acsref/Audience)[$myPos]"/>
                    <xsl:text>&#x0A;</xsl:text>
                </xsl:message>-->
                </xsl:if>
                <xsl:element name="acssort">
                    <xsl:copy-of select="child::*" copy-namespaces="no"/>
                </xsl:element>
            </xsl:for-each>
        </xsl:variable>

        <xsl:if test="contains($unittest, 'chkgloss')">
            <xsl:message>
                <xsl:for-each select="($acsref/xref)">
                    <xsl:sort select="."/>
                    <xsl:text>&#xA;</xsl:text>
                    <xsl:value-of select="."/>
                </xsl:for-each>
            </xsl:message>
        </xsl:if>


        <!--<xsl:message>
            <xsl:text>acsref:</xsl:text>
            <xsl:value-of select="count($acsref/acsref)"/>
        </xsl:message>-->

        <!--<xsl:message>
            <xsl:text>acssort:</xsl:text>
            <xsl:value-of select="count($acssort/acssort)"/>
        </xsl:message>-->

        <!--<xsl:message>
            <xsl:text>&#xA;ACSSORT:</xsl:text>
            <xsl:for-each select="$acssort">
                <xsl:text>&#xA;</xsl:text>
                <xsl:copy-of select="."/>
            </xsl:for-each>
        </xsl:message>-->

        <!-- create entries  -->
        <xsl:for-each select="$acssort/acssort">
            <xsl:variable name="myPos" select="position()"/>

            <xsl:variable name="acselect">
                <xsl:call-template name="getAcroRef">
                    <xsl:with-param name="myNode" select="xref"/>
                </xsl:call-template>
            </xsl:variable>

            <xsl:variable name="basename">
                <xsl:call-template name="normalizeName">
                    <xsl:with-param name="myName" select="$acselect"/>
                </xsl:call-template>
            </xsl:variable>

            <xsl:if test="contains($unittest, 'chkgloss')">
                <xsl:message>
                    <xsl:text>Create Entries:</xsl:text>
                    <xsl:value-of select="@keyref"/>
                    <xsl:text>:</xsl:text>
                    <xsl:value-of select="$basename"/>
                </xsl:message>
            </xsl:if>

            <xsl:if test="0">
                <xsl:message>
                    <xsl:text>ShitFOUND[</xsl:text>
                    <xsl:value-of select="$myPos"/>
                    <xsl:text>]:</xsl:text>
                    <xsl:value-of select="count($acssort/acssort)"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="xref/@keyref"/>
                    <xsl:text> </xsl:text>
                    <xsl:value-of select="Audience"/>
                    <xsl:text> ====== </xsl:text>
                    <xsl:value-of select="$basename"/>
                </xsl:message>
            </xsl:if>


            <xsl:if test="string-length($basename) > 0">
                <xsl:variable name="aceID" select="concat('ace_', $basename)"/>
                <xsl:choose>
                    <!-- check if our id is unique in McSpecification -->
                    <xsl:when test="count($McGlossary//glossterm[contains(@id, concat('acs_', $basename, '_'))]) > 0">
                        <!-- we did find the entry, but it was ambigious
                         1. report that as comment - it is not possible to find the correct target since the Ref.Glossary
                            does not 
                         -->
                        <xsl:message>
                            <xsl:text>Ambigous Tag found:</xsl:text>
                            <xsl:value-of select="xref/@keyref"/>
                        </xsl:message>
                        <xsl:element name="row" inherit-namespaces="no">
                            <xsl:attribute name="id" select="concat($aceID, '_1')"/>

                            <xsl:if test="string-length(Audience) > 0">
                                <xsl:attribute name="audience" select="string(Audience)"/>
                            </xsl:if>

                            <xsl:element name="entry">
                                <xsl:attribute name="id" select="concat('acs_', $basename, '_1')"/>
                                <xsl:attribute name="outputclass" select="'left:0pt'"/>
                                <xsl:apply-templates/>
                            </xsl:element>

                            <xsl:element name="entry">
                                <xsl:attribute name="id" select="concat('acc_', $basename, '_1')"/>
                                <xsl:apply-templates mode="copy"
                                    select="$McGlossary//glossentry[glossterm/@id = concat('acs_', $basename)]/*"/>

                                <xsl:call-template name="processTodo">
                                    <xsl:with-param name="cmtText" select="'Fix Glossary Master File!'"/>
                                    <xsl:with-param name="cmtContent"
                                        select="concat('Ambigous glossary reference to ''', string(Glossary.Term), '''')"/>
                                </xsl:call-template>
                            </xsl:element>
                        </xsl:element>
                    </xsl:when>

                    <!-- unique entry to find -->
                    <xsl:when test="count($McGlossary//glossterm[@id = concat('acs_', $basename)]) > 0">
                        <!-- we could find a unique glossary entry -->
                        <xsl:if test="contains($unittest, 'chkgloss')">
                            <xsl:message>
                                <xsl:text>Found unique entry:</xsl:text>
                                <xsl:value-of select="$McGlossary//glossentry[glossterm/@id = concat('acs_', $basename)]/@id"/>
                            </xsl:message>
                        </xsl:if>
                        <xsl:choose>
                            <xsl:when test="$opMode = 'local'">
                                <xsl:element name="row" inherit-namespaces="no">
                                    <!--
                                    <xsl:call-template name="putAttrs">
                                        <xsl:with-param name="myNode"
                                            select="$McGlossary//glossentry[glossterm/@id = concat('acs_', $basename)]"/>
                                    </xsl:call-template>
                                    <xsl:if test="string-length(Audience) > 0">
                                        <xsl:attribute name="audience" select="string(Audience)"/>
                                    </xsl:if>
                                    -->
                                    <xsl:element name="entry">
                                        <xsl:attribute name="id" select="concat('acs_', $basename)"/>
                                        <xsl:attribute name="outputclass" select="'left:0pt'"/>
                                        <xsl:element name="b">
                                            <xsl:apply-templates select="$McGlossary//glossentry/glossterm[@id = concat('acs_', $basename)]"
                                            />
                                        </xsl:element>
                                    </xsl:element>
                                    <xsl:element name="entry">
                                        <xsl:attribute name="id" select="concat('acc_', $basename)"/>
                                        <xsl:apply-templates
                                            select="$McGlossary//glossentry[glossterm/@id = concat('acs_', $basename)]/glossdef"/>
                                    </xsl:element>
                                </xsl:element>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:message>INVALID opMode, only 'local' is supported for acronyms because we translate from glossary items</xsl:message>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>

                    <!-- we could not find our entry in the master list -->
                    <xsl:otherwise>
                        <xsl:message>
                            <xsl:text>Could not locate:</xsl:text>
                            <xsl:value-of select="@id"/>
                            <xsl:value-of select="$aceID"/>
                        </xsl:message>

                        <xsl:element name="row" inherit-namespaces="no">
                            <xsl:if test="Audience">
                                <xsl:attribute name="audience" select="Audience"/>
                            </xsl:if>
                            <xsl:variable name="identry">
                                <xsl:value-of select="replace(xref/@keyref, '(.*acs/acs_)(.*)', '$2')"/>
                            </xsl:variable>
                            <xsl:element name="entry">
                                <xsl:attribute name="id" select="concat('acs_', $identry)"/>
                                <xsl:value-of select="upper-case($identry)"/>
                            </xsl:element>
                            <xsl:element name="entry">
                                <xsl:attribute name="id" select="concat('acc_', $identry)"/>
                                <xsl:call-template name="processTodo">
                                    <xsl:with-param name="cmtText" select="'Add term to Glossary(Acronyms) Master File!'"/>
                                    <xsl:with-param name="cmtContent" select="concat('Could not find acronym entry ''', string(.), '''')"/>
                                </xsl:call-template>
                            </xsl:element>
                        </xsl:element>
                    </xsl:otherwise>
                </xsl:choose>
            </xsl:if>
        </xsl:for-each>
    </xsl:template>

    <!-- getTargetTerm works on a xref topic (for-each 'xref') and
        returns the master list's glossterm text to be sorted in the next stop
        This is important because our xref might have an empty text (to glossary)
        which feeds itself from the target. Hence we cannot sort the entries
        by content unless we get the content frorm the target too.
   -->
    <xsl:template name="getTargetTerm">
        <xsl:variable name="acselect">
            <xsl:call-template name="getAcroRef"/>
        </xsl:variable>

        <xsl:variable name="basename">
            <xsl:call-template name="normalizeName">
                <xsl:with-param name="myName" select="$acselect"/>
            </xsl:call-template>
        </xsl:variable>

        <xsl:choose>
            <xsl:when test="string-length($basename) > 0">
                <!-- not required as defined before
                <xsl:variable name="aceID" select="concat('ace_', $basename)"/>
                -->

                <xsl:choose>
                    <!-- ambigous entry in McGlossary -->
                    <xsl:when test="count($McGlossary//glossterm[contains(@id, concat('acs_', $basename, '_'))]) > 0">
                        <xsl:value-of select="concat('000-ambigous:', $basename)"/>
                    </xsl:when>

                    <!-- we could find a unique glossary entry -->
                    <xsl:when test="count($McGlossary//glossterm[@id = concat('acs_', $basename)]) > 0">
                        <xsl:value-of select="$McGlossary//glossentry[glossterm/@id = concat('acs_', $basename)]/glossterm"/>
                    </xsl:when>
                </xsl:choose>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="'000-empty'"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="concept | topic | task | reference">
        <xsl:choose>
            <xsl:when test="contains(name(), 'topic')">
                <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
                <xsl:text>&lt;&#x21;DOCTYPE topic PUBLIC "-//OASIS//DTD DITA Topic//EN" "topic.dtd"</xsl:text>
                <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                <xsl:text>&#xA;</xsl:text>
            </xsl:when>
            <xsl:when test="contains(name(), 'concept')">
                <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
                <xsl:text>&#x21;DOCTYPE concept PUBLIC "-//OASIS//DTD DITA Concept//EN" "concept.dtd"</xsl:text>
                <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                <xsl:text>&#xA;</xsl:text>
            </xsl:when>
            <xsl:when test="contains(name(), 'task')">
                <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
                <xsl:text>&#x21;DOCTYPE task PUBLIC "-//OASIS//DTD DITA Task//EN" "task.dtd"</xsl:text>
                <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                <xsl:text>&#xA;</xsl:text>
            </xsl:when>
            <xsl:when test="contains(name(), 'reference')">
                <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
                <xsl:text>&#x21;DOCTYPE reference PUBLIC "-//OASIS//DTD DITA Reference//EN" "reference.dtd"</xsl:text>
                <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                <xsl:text>&#xA;</xsl:text>
            </xsl:when>
            <xsl:when test="contains(name(), 'glossary')">
                <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
                <xsl:text>&#x21;DOCTYPE glossary PUBLIC "-//OASIS//DTD DITA Glossary//EN" "glossary.dtd"</xsl:text>
                <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                <xsl:text>&#xA;</xsl:text>
            </xsl:when>
            <xsl:when test="contains(name(), 'glossgroup')">
                <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
                <xsl:text>&#x21;DOCTYPE glossgroup PUBLIC "-//OASIS//DTD DITA Glossary Group//EN" "glossgroup.dtd"</xsl:text>
                <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
                <xsl:text>&#xA;</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:message>
                    <xsl:text>doctype not found</xsl:text>
                    <xsl:value-of select="@doctype"/>
                </xsl:message>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:call-template name="putXML"/>
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
                    [not(name() = 'class')]
                    [not(contains(name(), 'ditaarch'))]
                    [not(contains(name(), 'domains'))]">
                <xsl:message>
                    <xsl:text>Copying attr:</xsl:text>
                    <xsl:value-of select="name()"/>
                </xsl:message>
                <xsl:copy inherit-namespaces="no"/>
            </xsl:for-each>
            <xsl:apply-templates select="* | text() | comment() | processing-instruction()" mode="#default"/>
        </xsl:element>
    </xsl:template>

    <xsl:template name="putAttrs">
        <xsl:param name="myNode" select="." as="node()*"/>
        <xsl:for-each
            select="
                $myNode/@*
                [not(name() = 'class')]
                [not(contains(name(), 'ditaarch'))]
                [not(contains(name(), 'domains'))]">
            <xsl:message>
                <xsl:text>Copying NODEATTR:</xsl:text>
                <xsl:value-of select="name()"/>
            </xsl:message>
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

    <xsl:template match="glossterm">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="glossdef">
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="*">
        <xsl:call-template name="putXML"/>
    </xsl:template>

    <xsl:template match="processing-instruction()">
        <xsl:copy/>
    </xsl:template>

</xsl:stylesheet>
