<?xml version="1.0"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:fn="http://www.w3.org/2005/xpath-functions" xmlns:xmp="http://ns.adobe.com/xap/1.0/"
    xmlns:pdf="http://ns.adobe.com/pdf/1.3/" xmlns:xmpMM="http://ns.adobe.com/xap/1.0/mm/"
    xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:rdf="http://www.w3.org/1999/02/22-rdf-syntax-ns#"
    xmlns:x="adobe:ns:meta/" xmlns:exslt="http://exslt.org/common" xmlns:xlink="http://www.w3.org/1999/xlink"
    xmlns:fox="http://www.w3.org/1999/XSL/Formatx" xmlns:my="my:my" xmlns:ditaarch="http://dita.oasis-open.org/"
    exclude-result-prefixes="xsl x fox fn xs dc pdf ditaarch xlink xmpMM xmp my rdf" version="2.0">

    <xsl:output method="text" indent="no" use-character-maps="sample" name="text"/>
    <xsl:output method="xml" indent="no" use-character-maps="sample" name="xml"/>

    <xsl:param name="MasterPathName" required="no"
        select="'/F:/scherzer/RefDita/Stylesheets/CreateLocals/VcfContacts.xml'" as="xs:string"/>

    <xsl:character-map name="sample">
        <!--    <xsl:output-character character="&#x3C;" string="&lt;"/>
        <xsl:output-character character="&#x3E;" string="&gt;"/>-->
        <xsl:output-character character="⊕" string="&amp;#x2295;"/>
        <xsl:output-character character="“" string='"'/>
        <xsl:output-character character="”" string='"'/>
        <!--<xsl:output-character character="&#x26;" string='&amp;'/>-->
    </xsl:character-map>

    <!--
        This stylesheet creates three files
        ContactsAddr.dita   in the folder of the document
        ContactsImg.dita
        getimg.bat
        
        It takes input from a file (e.g. meeting.dita) which contains a
        unsorted list with CSV delimited entries of the meeting participants.
            e.g. li: Scherzer, Helmut
                 li: Cook, Tim, Peter
                 li: <lastname> [,<firstname>] [,<middlename>]
                 
        It feeds VCF information from a master file e.g. VcfContacts.xml
        which is not a DITA file but an XML file generated from a AllContacts.vcf
        file that was UTF-8 exported from Lotus-Notes and processed with the
        vcf.exe by Helmut Scherzer
        
            F:\work>vcf /r <png picture root> AllContacts-UTF8.vcf
            
            where picture root expects a subdir "png" to find the png pictures
 
    -->

    <xsl:key name="kycontacts" match="contact" use="person/lastname"/>

    <xsl:variable name="contacts" select="document($MasterPathName)/vcfrecords"/>

    <xsl:variable name="selectedContacts" as="node()*">
        <xsl:text>&#xA;</xsl:text>
        <xsl:element name="s_contacts">
            <xsl:for-each select="//ul/li">
                <xsl:text>&#xA;    </xsl:text>
                <xsl:element name="s_contact">
                    <xsl:variable name="tokens" select="tokenize(., ',')"/>
                    <xsl:text>&#xA;        </xsl:text>
                    <xsl:element name="s_last">
                        <!--
                        <xsl:message>
                            <xsl:text>&#xA;START:</xsl:text>
                            <xsl:value-of select="normalize-space($tokens[1])"/>
                        </xsl:message>
                        -->
                        <xsl:value-of select="normalize-space($tokens[1])"/>
                    </xsl:element>
                    <xsl:text>&#xA;        </xsl:text>
                    <xsl:element name="s_first">
                        <!--
                        <xsl:message>
                            <xsl:text>&#xA;FIRST:</xsl:text>
                            <xsl:value-of select="normalize-space($tokens[2])"/>
                        </xsl:message>
                        -->
                        <xsl:value-of select="normalize-space($tokens[2])"/>
                    </xsl:element>
                    <xsl:text>&#xA;        </xsl:text>
                    <xsl:element name="s_mid">
                        <xsl:value-of select="normalize-space($tokens[3])"/>
                    </xsl:element>
                    <xsl:text>&#xA;    </xsl:text>
                </xsl:element>
            </xsl:for-each>
            <xsl:text>&#xA;</xsl:text>
        </xsl:element>
    </xsl:variable>

    <!-- $selFull contains all selected records from the master contacts
             which were selected. They come in sorted order by company,lastname,firstname
             
             All fields are available, so we can now generate the concept file(s)
             The output files are
                ContactsAddr.dita
                ContactsImg.dita
                getImg.bat
    -->

    <xsl:variable name="selFull">
        <xsl:variable name="rawvcf">
            <xsl:element name="contacts">
                <xsl:for-each select="$selectedContacts/s_contact">
                    <xsl:apply-templates select="$contacts" mode="contact">
                        <xsl:with-param name="lastN" select="s_last"/>
                        <xsl:with-param name="firstN" select="s_first"/>
                    </xsl:apply-templates>
                </xsl:for-each>
            </xsl:element>
        </xsl:variable>
        <xsl:element name="contacts">
            <xsl:call-template name="vcfsort">
                <xsl:with-param name="vcfs" select="$rawvcf"/>
            </xsl:call-template>
        </xsl:element>
    </xsl:variable>

    <!-- ===================================================================
         ================== MAIN EXECUTION TEMPLATE ========================
         ===================================================================
         gets current document as concept - paragraphs in the CSV delimited form
         Scherzer, Helmut
         Scherzer, Kurt
         who are the meeting participants.
         
         The VCF converted XML file is UTF-8 coded and is determined by $MasterPathName
         which is an input parameter to the stylesheet - located in $contacts
    -->
    <xsl:variable name="folderURI" select="resolve-uri('.', base-uri())"/>

    <xsl:template match="/">
        <xsl:result-document href="{concat($folderURI, 'ContactsImg.dita')}" format="xml">
            <xsl:message>
                <xsl:value-of select="concat($folderURI, 'ContactsImg.dita')"/>
            </xsl:message>

            <xsl:text>&#xA;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
            <xsl:text>&#x21;DOCTYPE concept PUBLIC "-//OASIS//DTD DITA Concept//EN" "concept.dtd"</xsl:text>
            <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
            <xsl:text>&#xA;</xsl:text>

            <!-- Interprete our raw document and pickup all names of the participants from
             the paragraphs, they are comma-separated using lastname, firstname, middlename 
        -->
            <xsl:element name="concept">
                <xsl:attribute name="id" select="'members'"/>
                <xsl:text>&#xA;    </xsl:text>
                <xsl:element name="title">
                    <xsl:text>Participants(Img)</xsl:text>
                </xsl:element>
                <xsl:text>&#xA;    </xsl:text>
                <xsl:element name="shortdesc"/>
                <xsl:text>&#xA;    </xsl:text>
                <xsl:element name="conbody">
                    <xsl:text>&#xA;        </xsl:text>
                    <xsl:element name="p">
                        <xsl:text>The following participants were attending the meeting:</xsl:text>
                    </xsl:element>

                    <xsl:call-template name="CreatePictureTable"/>
                </xsl:element>
                <xsl:text>&#xA;</xsl:text>
            </xsl:element>
        </xsl:result-document>

        <!--  =================== CREATE THE CONSERVATIVE ADDRESS TABLE ======================= -->
        <xsl:result-document href="{concat($folderURI, 'ContactsAddr.dita')}" format="xml">
            <xsl:message>
                <xsl:value-of select="concat($folderURI, 'ContactsAddr.dita')"/>
            </xsl:message>

            <xsl:text>&#xA;</xsl:text>
            <xsl:text disable-output-escaping="yes">&lt;</xsl:text>
            <xsl:text>&#x21;DOCTYPE concept PUBLIC "-//OASIS//DTD DITA Concept//EN" "concept.dtd"</xsl:text>
            <xsl:text disable-output-escaping="yes">&gt;</xsl:text>
            <xsl:text>&#xA;</xsl:text>

            <!-- Interprete our raw document and pickup all names of the participants from
             the paragraphs, they are comma-separated using lastname, firstname, middlename 
        -->
            <xsl:element name="concept">
                <xsl:attribute name="id" select="'members'"/>
                <xsl:text>&#xA;    </xsl:text>
                <xsl:element name="title">
                    <xsl:text>Participants(Addr)</xsl:text>
                </xsl:element>
                <xsl:text>&#xA;    </xsl:text>
                <xsl:element name="shortdesc"/>
                <xsl:text>&#xA;    </xsl:text>
                <xsl:element name="conbody">
                    <xsl:text>&#xA;        </xsl:text>
                    <xsl:element name="p">
                        <xsl:text>The following participants were attending the meeting:</xsl:text>
                    </xsl:element>

                    <xsl:call-template name="CreateAddressTable"/>
                </xsl:element>
                <xsl:text>&#xA;</xsl:text>
            </xsl:element>
        </xsl:result-document>

        <xsl:call-template name="CreateBatch">
            <xsl:with-param name="selc" select="$selFull"/>
        </xsl:call-template>

    </xsl:template>

    <!-- TEMPLATE to pick the contacts from the master file
         The template delivers a node with those records that have been found as a match for the
         driver file's paragraphs. The records are sorted by company - lastname - firstname
    -->
    <xsl:template match="*" mode="contact">
        <xsl:param name="lastN"/>
        <xsl:param name="firstN"/>
        <xsl:choose>
            <xsl:when test="string-length($firstN) &gt; 0">
                <xsl:copy-of select="contact/person/key('kycontacts', $lastN)[person/firstname = $firstN]"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:copy-of select="contact/person/key('kycontacts', $lastN)"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template name="vcfsort">
        <xsl:param name="vcfs"/>
        <!-- $chkC also delivers empty 'contact' if not found, we eliminate those by further check
            At the same time, we do the sort, the  key() has already sorted, but we cannot be sure
            whether the second index would be the firstname, therefore we need to re-sort.
            As Lotus Notes already comes with sorted input, we cannot see this here but our sort
            will repair nevertheless.
            
            At least ... we can add another sort, e.g. by company, this would be most helpful perhaps
        -->
        <xsl:for-each select="$vcfs/contacts/contact">
            <xsl:sort select="business/addr/company"/>
            <xsl:sort select="person/lastname"/>
            <xsl:sort select="person/firstname"/>
            <!-- choose allows to create a dummy record for non found records
                 on this ... we can use $lastN and $firstN to get more info in the dummy record
                <xsl:message>
                    <xsl:text>SORTED:</xsl:text>
                    <xsl:value-of select="person/firstname"/>
                </xsl:message>
            -->
            <xsl:choose>
                <xsl:when test="exists(person)">
                    <xsl:copy-of select="."/>
                    <xsl:text>&#xA;    </xsl:text>
                </xsl:when>
            </xsl:choose>
        </xsl:for-each>
    </xsl:template>

    <!-- =============== CREATE PICTURE TABLE =====================
         generates the table with images
    -->
    <xsl:template name="CreatePictureTable">
        <xsl:text>&#xA;        </xsl:text>
        <xsl:element name="table">
            <xsl:attribute name="id" select="'tblParticipants'"/>
            <xsl:attribute name="frame" select="'none'"/>
            <xsl:attribute name="pgwide" select="1"/>
            <xsl:attribute name="outputclass" select="'rowcolor=white'"/>
            <xsl:text>&#xA;            </xsl:text>
            <xsl:element name="tgroup">
                <xsl:attribute name="cols" select="5"/>
                <xsl:text>&#xA;                </xsl:text>
                <xsl:element name="colspec">
                    <xsl:attribute name="colname" select="'c1'"/>
                    <xsl:attribute name="colnum" select="1"/>
                    <xsl:attribute name="colwidth" select="'12mm'"/>
                    <xsl:attribute name="rowsep" select="1"/>
                </xsl:element>
                <xsl:text>&#xA;                </xsl:text>
                <xsl:element name="colspec">
                    <xsl:attribute name="colname" select="'c2'"/>
                    <xsl:attribute name="colnum" select="2"/>
                    <xsl:attribute name="colwidth" select="'*'"/>
                    <xsl:attribute name="rowsep" select="1"/>
                </xsl:element>
                <xsl:text>&#xA;                </xsl:text>
                <xsl:element name="colspec">
                    <xsl:attribute name="colname" select="'c3'"/>
                    <xsl:attribute name="colnum" select="3"/>
                    <xsl:attribute name="colwidth" select="'55mm'"/>
                    <xsl:attribute name="rowsep" select="1"/>
                </xsl:element>
                <xsl:text>&#xA;                </xsl:text>
                <xsl:element name="colspec">
                    <xsl:attribute name="colname" select="'c4'"/>
                    <xsl:attribute name="colnum" select="4"/>
                    <xsl:attribute name="colwidth" select="'17mm'"/>
                    <xsl:attribute name="rowsep" select="1"/>
                </xsl:element>
                <xsl:text>&#xA;                </xsl:text>
                <xsl:element name="colspec">
                    <xsl:attribute name="colname" select="'c5'"/>
                    <xsl:attribute name="colnum" select="5"/>
                    <xsl:attribute name="colwidth" select="'50mm'"/>
                    <xsl:attribute name="rowsep" select="1"/>
                </xsl:element>
                <xsl:text>&#xA;                </xsl:text>
                <xsl:element name="thead">
                    <xsl:text>&#xA;                    </xsl:text>
                    <xsl:element name="row">
                        <xsl:attribute name="rowsep" select="0"/>
                        <xsl:attribute name="outputclass" select="compact"/>
                        <xsl:text>&#xA;                        </xsl:text>
                        <xsl:element name="entry"/>
                        <xsl:text>&#xA;                        </xsl:text>
                        <xsl:element name="entry">
                            <xsl:text>Person</xsl:text>
                        </xsl:element>
                        <xsl:text>&#xA;                        </xsl:text>
                        <xsl:element name="entry">
                            <xsl:text>Dept.</xsl:text>
                        </xsl:element>
                        <xsl:text>&#xA;                        </xsl:text>
                        <xsl:element name="entry">
                            <xsl:attribute name="namest" select="'c4'"/>
                            <xsl:attribute name="nameend" select="'c5'"/>
                            <xsl:text>Connect</xsl:text>
                        </xsl:element>
                        <xsl:text>&#xA;                    </xsl:text>
                    </xsl:element>
                    <!-- row -->
                    <xsl:text>&#xA;                </xsl:text>
                </xsl:element>
                <!-- thead -->
                <xsl:text>&#xA;                </xsl:text>
                <xsl:element name="tbody">
                    <xsl:call-template name="addPictureRows">
                        <xsl:with-param name="selc" select="$selFull"/>
                    </xsl:call-template>
                    <xsl:text>&#xA;                </xsl:text>
                </xsl:element>
                <xsl:text>&#xA;            </xsl:text>
            </xsl:element>
            <!-- tgroup -->
            <xsl:text>&#xA;        </xsl:text>
        </xsl:element>
        <xsl:text>&#xA;    </xsl:text>
        <!-- table -->
    </xsl:template>

    <!-- TEMPLATE to create the participants records 
    -->
    <xsl:template name="addPictureRows">
        <xsl:param name="selc"/>
        <xsl:for-each select="$selc/contacts/contact">
            <xsl:text>&#xA;                    </xsl:text>
            <xsl:element name="row">
                <xsl:attribute name="rowsep" select="0"/>
                <xsl:attribute name="outputclass" select="'compact'"/>
                <xsl:text>&#xA;                        </xsl:text>
                <xsl:element name="entry">
                    <xsl:attribute name="morerows" select="2"/>
                    <xsl:attribute name="outputclass" select="'left:0pt'"/>
                    <xsl:attribute name="rowsep" select="1"/>
                    <xsl:choose>
                        <xsl:when test="exists(person/imgpath)">
                            <xsl:text>&#xA;                            </xsl:text>
                            <xsl:element name="image">
                                <xsl:attribute name="id"
                                    select="translate(tokenize(replace(person/imgpath, '\\', '/'), '/')[last()], '.', '_')"/>
                                <xsl:attribute name="placement" select="'inline'"/>
                                <xsl:attribute name="href"
                                    select="concat('../gfx/', tokenize(person/imgpath, '\\')[last()])"/>
                                <xsl:attribute name="width" select="'12mm'"/>
                                <!-- just playing to show the path
                                <xsl:attribute name="path" select="substring-before(person/imgpath, tokenize(person/imgpath, '\\')[last()])"/>
                                -->
                            </xsl:element>
                        </xsl:when>
                    </xsl:choose>
                    <xsl:text>&#xA;                        </xsl:text>
                </xsl:element>

                <xsl:text>&#xA;                        </xsl:text>
                <xsl:element name="entry">
                    <xsl:attribute name="morerows" select="2"/>
                    <xsl:attribute name="rowsep" select="1"/>
                    <xsl:element name="b">
                        <xsl:value-of
                            select="replace(concat(person/firstname, ' ', person/middlename, ' ', person/lastname), '  ', ' ')"
                        />
                    </xsl:element>
                    <xsl:element name="p">
                        <xsl:attribute name="outputclass" select="'compact'"/>
                        <xsl:element name="i">
                            <xsl:value-of select="business/addr/jobtitle"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:text>&#xA;                            </xsl:text>
                    <xsl:element name="p">
                        <xsl:attribute name="outputclass" select="'compact'"/>
                        <xsl:value-of select="business/addr/dept"/>
                    </xsl:element>
                    <xsl:text>&#xA;                        </xsl:text>
                </xsl:element>

                <xsl:text>&#xA;                        </xsl:text>
                <xsl:element name="entry">
                    <xsl:attribute name="morerows" select="2"/>
                    <xsl:attribute name="rowsep" select="1"/>
                    <xsl:value-of select="business/addr/company"/>
                    <xsl:element name="p">
                        <xsl:attribute name="outputclass" select="'compact'"/>
                        <xsl:value-of select="business/addr/street"/>
                    </xsl:element>
                    <xsl:element name="p">
                        <xsl:attribute name="outputclass" select="'compact'"/>
                        <xsl:choose>
                            <xsl:when test="string-length(business/addr/state)">
                                <xsl:value-of select="concat(business/addr/postalcode, ' ', business/addr/city, ', ', business/addr/state)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat(business/addr/postalcode, ' ', business/addr/city)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                    <xsl:element name="p">
                        <xsl:attribute name="outputclass" select="'compact'"/>
                        <xsl:value-of select="business/addr/countryregion"/>
                    </xsl:element>
                </xsl:element>
                <xsl:text>&#xA;                        </xsl:text>
                <xsl:element name="entry">
                    <xsl:value-of select="'Phone:'"/>
                </xsl:element>
                <xsl:text>&#xA;                        </xsl:text>
                <xsl:element name="entry">
                    <xsl:value-of select="business/connect/phone"/>
                </xsl:element>
                <!-- entry -->
                <xsl:text>&#xA;                    </xsl:text>
            </xsl:element>
            <!-- row -->

            <xsl:text>&#xA;                    </xsl:text>
            <xsl:element name="row">
                <xsl:attribute name="rowsep" select="0"/>
                <xsl:attribute name="outputclass" select="'compact'"/>
                <xsl:text>&#xA;                        </xsl:text>
                <xsl:element name="entry">
                    <xsl:value-of select="'Mobile:'"/>
                </xsl:element>
                <xsl:text>&#xA;                        </xsl:text>
                <xsl:element name="entry">
                    <xsl:value-of select="home/connect/mobile"/>
                </xsl:element>
                <!-- entry -->
                <xsl:text>&#xA;                    </xsl:text>
            </xsl:element>
            <!-- row -->

            <xsl:text>&#xA;                    </xsl:text>
            <xsl:element name="row">
                <xsl:attribute name="rowsep" select="0"/>
                <xsl:attribute name="outputclass" select="'compact'"/>
                <xsl:text>&#xA;                        </xsl:text>
                <xsl:element name="entry">
                    <xsl:attribute name="rowsep" select="1"/>
                    <xsl:value-of select="'eMail:'"/>
                </xsl:element>
                <xsl:text>&#xA;                        </xsl:text>
                <xsl:element name="entry">
                    <xsl:attribute name="rowsep" select="1"/>
                    <xsl:value-of select="business/connect/email"/>
                </xsl:element>
                <!-- entry -->
                <xsl:text>&#xA;                    </xsl:text>
            </xsl:element>
            <!-- row -->
        </xsl:for-each>
        <xsl:text>&#xA;                    </xsl:text>
        <xsl:element name="row">
            <xsl:attribute name="rowsep" select="1"/>
            <xsl:text>&#xA;                        </xsl:text>
            <xsl:element name="entry"/>
            <xsl:text>&#xA;                        </xsl:text>
            <xsl:element name="entry"/>
            <xsl:text>&#xA;                        </xsl:text>
            <xsl:element name="entry"/>
            <xsl:text>&#xA;                        </xsl:text>
            <xsl:element name="entry"/>
            <xsl:text>&#xA;                        </xsl:text>
            <xsl:element name="entry"/>
            <xsl:text>&#xA;                    </xsl:text>
        </xsl:element>
        <!-- row -->

    </xsl:template>

    <!-- =============== CREATE ADDRESS TABLE =====================
         generates the table with addresses only - the conservative approach
    -->
    <xsl:template name="CreateAddressTable">
        <xsl:text>&#xA;        </xsl:text>
        <xsl:element name="table">
            <xsl:attribute name="id" select="'tblAddress'"/>
            <xsl:attribute name="frame" select="'none'"/>
            <xsl:attribute name="pgwide" select="1"/>
            <xsl:attribute name="outputclass" select="'rowcolor=white'"/>
            <xsl:text>&#xA;            </xsl:text>
            <xsl:element name="tgroup">
                <xsl:attribute name="cols" select="4"/>
                <xsl:text>&#xA;                </xsl:text>
                <xsl:element name="colspec">
                    <xsl:attribute name="colname" select="'c1'"/>
                    <xsl:attribute name="colnum" select="1"/>
                    <xsl:attribute name="colwidth" select="'*'"/>
                    <xsl:attribute name="rowsep" select="1"/>
                </xsl:element>
                <xsl:text>&#xA;                </xsl:text>
                <xsl:element name="colspec">
                    <xsl:attribute name="colname" select="'c2'"/>
                    <xsl:attribute name="colnum" select="2"/>
                    <xsl:attribute name="colwidth" select="'60mm'"/>
                    <xsl:attribute name="rowsep" select="1"/>
                </xsl:element>
                <xsl:text>&#xA;                </xsl:text>
                <xsl:element name="colspec">
                    <xsl:attribute name="colname" select="'c3'"/>
                    <xsl:attribute name="colnum" select="3"/>
                    <xsl:attribute name="colwidth" select="'17mm'"/>
                    <xsl:attribute name="rowsep" select="1"/>
                </xsl:element>
                <xsl:text>&#xA;                </xsl:text>
                <xsl:element name="colspec">
                    <xsl:attribute name="colname" select="'c4'"/>
                    <xsl:attribute name="colnum" select="4"/>
                    <xsl:attribute name="colwidth" select="'55mm'"/>
                    <xsl:attribute name="rowsep" select="1"/>
                </xsl:element>
                <xsl:text>&#xA;                </xsl:text>
                <xsl:element name="thead">
                    <xsl:text>&#xA;                    </xsl:text>
                    <xsl:element name="row">
                        <xsl:attribute name="rowsep" select="0"/>
                        <xsl:attribute name="outputclass" select="compact"/>
                        <xsl:text>&#xA;                        </xsl:text>
                        <xsl:element name="entry">
                            <xsl:text>Person</xsl:text>
                        </xsl:element>
                        <xsl:text>&#xA;                        </xsl:text>
                        <xsl:element name="entry">
                            <xsl:text>Dept.</xsl:text>
                        </xsl:element>
                        <xsl:text>&#xA;                        </xsl:text>
                        <xsl:element name="entry">
                            <xsl:attribute name="namest" select="'c3'"/>
                            <xsl:attribute name="nameend" select="'c4'"/>
                            <xsl:text>Connect</xsl:text>
                        </xsl:element>
                        <xsl:text>&#xA;                    </xsl:text>
                    </xsl:element>
                    <!-- row -->
                    <xsl:text>&#xA;                </xsl:text>
                </xsl:element>
                <!-- thead -->
                <xsl:text>&#xA;                </xsl:text>
                <xsl:element name="tbody">
                    <xsl:call-template name="addContactRows">
                        <xsl:with-param name="selc" select="$selFull"/>
                    </xsl:call-template>
                    <xsl:text>&#xA;                </xsl:text>
                </xsl:element>
                <xsl:text>&#xA;            </xsl:text>
            </xsl:element>
            <!-- tgroup -->
            <xsl:text>&#xA;        </xsl:text>
        </xsl:element>
        <xsl:text>&#xA;    </xsl:text>
        <!-- table -->
    </xsl:template>

    <!-- TEMPLATE to create the participants records 
    -->
    <xsl:template name="addContactRows">
        <xsl:param name="selc"/>
        <xsl:for-each select="$selc/contacts/contact">
            <xsl:text>&#xA;                    </xsl:text>
            <xsl:element name="row">
                <xsl:attribute name="rowsep" select="0"/>
                <xsl:attribute name="outputclass" select="'compact'"/>
                <xsl:text>&#xA;                        </xsl:text>
                <xsl:element name="entry">
                    <xsl:attribute name="morerows" select="2"/>
                    <xsl:attribute name="rowsep" select="1"/>
                    <xsl:element name="b">
                        <xsl:value-of
                            select="replace(concat(person/firstname, ' ', person/middlename, ' ', person/lastname), '  ', ' ')"
                        />
                    </xsl:element>
                    <xsl:element name="p">
                        <xsl:attribute name="outputclass" select="'compact'"/>
                        <xsl:element name="i">
                            <xsl:value-of select="business/addr/jobtitle"/>
                        </xsl:element>
                    </xsl:element>
                    <xsl:text>&#xA;                            </xsl:text>
                    <xsl:element name="p">
                        <xsl:attribute name="outputclass" select="'compact'"/>
                        <xsl:value-of select="business/addr/dept"/>
                    </xsl:element>
                    <xsl:text>&#xA;                        </xsl:text>
                </xsl:element>

                <xsl:text>&#xA;                        </xsl:text>
                <xsl:element name="entry">
                    <xsl:attribute name="morerows" select="2"/>
                    <xsl:attribute name="rowsep" select="1"/>
                    <xsl:value-of select="business/addr/company"/>
                    <xsl:element name="p">
                        <xsl:attribute name="outputclass" select="'compact'"/>
                        <xsl:value-of select="business/addr/street"/>
                    </xsl:element>
                    <xsl:element name="p">
                        <xsl:attribute name="outputclass" select="'compact'"/>
                        <xsl:choose>
                            <xsl:when test="string-length(business/addr/state)">
                                <xsl:value-of select="concat(business/addr/postalcode, ' ', business/addr/city, ', ', business/addr/state)"/>
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="concat(business/addr/postalcode, ' ', business/addr/city)"/>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:element>
                    <xsl:element name="p">
                        <xsl:attribute name="outputclass" select="'compact'"/>
                        <xsl:value-of select="business/addr/countryregion"/>
                    </xsl:element>
                </xsl:element>
                <xsl:text>&#xA;                        </xsl:text>
                <xsl:element name="entry">
                    <xsl:value-of select="'Phone:'"/>
                </xsl:element>
                <xsl:text>&#xA;                        </xsl:text>
                <xsl:element name="entry">
                    <xsl:value-of select="business/connect/phone"/>
                </xsl:element>
                <!-- entry -->
                <xsl:text>&#xA;                    </xsl:text>
            </xsl:element>
            <!-- row -->

            <xsl:text>&#xA;                    </xsl:text>
            <xsl:element name="row">
                <xsl:attribute name="rowsep" select="0"/>
                <xsl:attribute name="outputclass" select="'compact'"/>
                <xsl:text>&#xA;                        </xsl:text>
                <xsl:element name="entry">
                    <xsl:value-of select="'Mobile:'"/>
                </xsl:element>
                <xsl:text>&#xA;                        </xsl:text>
                <xsl:element name="entry">
                    <xsl:value-of select="home/connect/mobile"/>
                </xsl:element>
                <!-- entry -->
                <xsl:text>&#xA;                    </xsl:text>
            </xsl:element>
            <!-- row -->

            <xsl:text>&#xA;                    </xsl:text>
            <xsl:element name="row">
                <xsl:attribute name="rowsep" select="0"/>
                <xsl:attribute name="outputclass" select="'compact'"/>
                <xsl:text>&#xA;                        </xsl:text>
                <xsl:element name="entry">
                    <xsl:attribute name="rowsep" select="1"/>
                    <xsl:value-of select="'eMail:'"/>
                </xsl:element>
                <xsl:text>&#xA;                        </xsl:text>
                <xsl:element name="entry">
                    <xsl:attribute name="rowsep" select="1"/>
                    <xsl:value-of select="business/connect/email"/>
                </xsl:element>
                <!-- entry -->
                <xsl:text>&#xA;                    </xsl:text>
            </xsl:element>
            <!-- row -->
        </xsl:for-each>
        <xsl:text>&#xA;                    </xsl:text>
        <xsl:element name="row">
            <xsl:attribute name="rowsep" select="1"/>
            <xsl:text>&#xA;                        </xsl:text>
            <xsl:element name="entry"/>
            <xsl:text>&#xA;                        </xsl:text>
            <xsl:element name="entry"/>
            <xsl:text>&#xA;                        </xsl:text>
            <xsl:element name="entry"/>
            <xsl:text>&#xA;                        </xsl:text>
            <xsl:element name="entry"/>
            <xsl:text>&#xA;                    </xsl:text>
        </xsl:element>
        <!-- row -->

    </xsl:template>

    <xsl:template name="CreateBatch">
        <xsl:param name="selc"/>
        <xsl:message>
            <xsl:value-of select="concat($folderURI, '../../', 'getimg.bat')"/>
        </xsl:message>
        
        <xsl:result-document href="{concat($folderURI, '../../', 'getimg.bat')}" format="text">
            
        <xsl:for-each select="$selc/contacts/contact">
            <xsl:variable name="imgpath">
                <xsl:value-of select="replace(person/imgpath, ', ', '\\')"/>
            </xsl:variable>
            <xsl:if test="string-length($imgpath)">
                <xsl:value-of select="concat('call xcopy ', $imgpath, ' src\gfx\ /y')"/>
            </xsl:if>
            <xsl:text>&#xA;</xsl:text>
        </xsl:for-each>
        </xsl:result-document>
    </xsl:template>

</xsl:stylesheet>
