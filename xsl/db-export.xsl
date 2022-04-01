<?xml version='1.0'?>

<!--**********************************************************
Copyright 2022  All Rights Reserved
Robert A. Beezer
***********************************************************-->

<!-- Ad-hoc conversion of project entries for import into  -->
<!-- a Maria DB, based on documentation at                 -->
<!--                                                       -->
<!-- https://github.com/trshemanske/ptx-catalog            -->
<!--                                                       -->
<!-- at 2022-03-27 commit                                  -->
<!--                                                       -->
<!-- afd7b97d375267831145d452a923eefb34246d85              -->

<!-- exsl for RTF to nodes, and file write -->
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
    xmlns:exsl="http://exslt.org/common"
    extension-element-prefixes="exsl"
    >

<!-- Run with xinclude switch! -->

<xsl:template match="/">
    <xsl:apply-templates select="register/project"/>
</xsl:template>


<xsl:template match="project">
    <!-- pairs of dbkeys and dbvalues -->
    <xsl:variable name="project-rtf">
        <!-- PROJECT -->
        <xsl:apply-templates select="." mode="project-xml-id"/>
        <xsl:apply-templates select="." mode="project-title"/>
        <xsl:apply-templates select="." mode="project-subtitle"/>
        <!-- LICENSE -->
        <xsl:apply-templates select="license" mode="license-code"/>
        <xsl:apply-templates select="license" mode="license-variant"/>
        <xsl:apply-templates select="license" mode="license-version"/>
        <xsl:apply-templates select="license" mode="license-pubyear"/>
        <xsl:apply-templates select="license" mode="license-currency"/>
        <xsl:apply-templates select="license" mode="license-amount"/>
        <!-- CHARACTER -->
        <xsl:apply-templates select="character" mode="character-subject"/>
        <xsl:apply-templates select="character" mode="character-level"/>
        <xsl:apply-templates select="character" mode="character-phase"/>
        <!-- SITES -->
        <xsl:apply-templates select="sites" mode="sites-landing"/>
        <xsl:apply-templates select="sites" mode="sites-source"/>
        <xsl:apply-templates select="sites" mode="sites-html"/>
        <xsl:apply-templates select="sites" mode="sites-pdf"/>
        <xsl:apply-templates select="sites" mode="sites-print"/>
        <!-- DESCRIPTION -->
        <xsl:apply-templates select="." mode="one-sentence"/>
        <xsl:apply-templates select="." mode="full-description"/>
        <!-- FEATURES -->
        <xsl:apply-templates select="features" mode="features"/>
        <!-- RECOGNITION -->
        <xsl:apply-templates select="." mode="recognition"/>
    </xsl:variable>
    <!-- and as a node-set for production -->
    <xsl:variable name="project-db" select="exsl:node-set($project-rtf)"/>

    <xsl:variable name="author-rtf">
        <xsl:for-each select="author">
            <coauthor>
                <xsl:apply-templates select="." mode="author-project-id"/>
                <xsl:apply-templates select="." mode="author-displayname"/>
                <xsl:apply-templates select="." mode="author-url"/>
                <xsl:apply-templates select="." mode="author-email"/>
                <xsl:apply-templates select="." mode="author-affiliations"/>
            </coauthor>
        </xsl:for-each>
    </xsl:variable>
    <!-- and as a node-set for production -->
    <xsl:variable name="author-db" select="exsl:node-set($author-rtf)"/>

    <!-- write out a file of dbkeys and then dbvalues -->
    <!-- as text, but serialize HTML stuff            -->
    <exsl:document href="{@xml:id}.txt" method="text" encoding="UTF-8">

        <!-- list/tuple of keys -->
        <xsl:text>INSERT into projects&#xa;</xsl:text>
        <xsl:text>(&#xa;</xsl:text>
        <xsl:for-each select="$project-db/dbkey">
            <xsl:value-of select="."/>
            <xsl:if test="following-sibling::dbkey">
                <xsl:text>,</xsl:text>
            </xsl:if>
            <xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
        <xsl:text>)&#xa;</xsl:text>
    
        <!-- list/tuple of values -->
        <xsl:text>VALUES&#xa;</xsl:text>
        <xsl:text>(&#xa;</xsl:text>
        <xsl:for-each select="$project-db/dbvalue">
            <xsl:value-of select="."/>
            <xsl:if test="following-sibling::dbvalue">
                <xsl:text>,</xsl:text>
            </xsl:if>
            <xsl:text>&#xa;</xsl:text>
        </xsl:for-each>
        <!-- NB semi-colon -->
        <xsl:text>);&#xa;</xsl:text>

        <!-- AUTHORS -->

        <xsl:for-each select="$author-db/coauthor">
            <!-- list/tuple of keys -->
            <xsl:text>INSERT into coauthors&#xa;</xsl:text>
            <xsl:text>(&#xa;</xsl:text>
            <xsl:for-each select="./dbkey">
                <xsl:value-of select="."/>
                <xsl:if test="following-sibling::dbkey">
                    <xsl:text>,</xsl:text>
                </xsl:if>
                <xsl:text>&#xa;</xsl:text>
            </xsl:for-each>
            <xsl:text>)&#xa;</xsl:text>

            <!-- list/tuple of values -->
            <xsl:text>VALUES&#xa;</xsl:text>
            <xsl:text>(&#xa;</xsl:text>
            <xsl:for-each select="./dbvalue">
                <xsl:value-of select="."/>
                <xsl:if test="following-sibling::dbvalue">
                    <xsl:text>,</xsl:text>
                </xsl:if>
                <xsl:text>&#xa;</xsl:text>
            </xsl:for-each>
            <!-- NB semi-colon -->
            <xsl:text>);&#xa;</xsl:text>
        </xsl:for-each>

    </exsl:document>
</xsl:template>

<!-- PROJECT -->

<!-- string, mandatory -->
<xsl:template match="project" mode="project-xml-id">
    <dbkey>project_xml_id</dbkey>
    <dbvalue>
        <xsl:text>'</xsl:text>
        <xsl:value-of select="@xml:id"/>
        <xsl:text>'</xsl:text>
    </dbvalue>
</xsl:template>

<!-- string, mandatory -->
<xsl:template match="project" mode="project-title">
    <dbkey>project_title</dbkey>
    <dbvalue>
        <xsl:text>'</xsl:text>
        <xsl:value-of select="title"/>
        <xsl:text>'</xsl:text>
    </dbvalue>
</xsl:template>

<!-- string, optional -->
<xsl:template match="project" mode="project-subtitle">
    <dbkey>project_subtitle</dbkey>
    <dbvalue>
        <xsl:choose>
            <xsl:when test="subtitle">
                <xsl:text>'</xsl:text>
                <xsl:value-of select="subtitle"/>
                <xsl:text>'</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>NULL</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </dbvalue>
</xsl:template>

<!-- LICENSE -->

<!-- string, mandatory -->
<xsl:template match="license" mode="license-code">
    <dbkey>project_license_code</dbkey>
    <dbvalue>
        <xsl:text>'</xsl:text>
        <xsl:value-of select="@code"/>
        <xsl:text>'</xsl:text>
    </dbvalue>
</xsl:template>

<!-- string, optional -->
<xsl:template match="license" mode="license-variant">
    <dbkey>project_license_variant</dbkey>
    <dbvalue>
        <xsl:choose>
            <xsl:when test="@variant">
                <xsl:text>'</xsl:text>
                <xsl:value-of select="@variant"/>
                <xsl:text>'</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>NULL</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </dbvalue>
</xsl:template>

<!-- string, optional -->
<xsl:template match="license" mode="license-version">
    <dbkey>project_license_version</dbkey>
    <dbvalue>
        <xsl:choose>
            <xsl:when test="@version">
                <xsl:text>'</xsl:text>
                <xsl:value-of select="@version"/>
                <xsl:text>'</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>NULL</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </dbvalue>
</xsl:template>

<!-- number, optional -->
<xsl:template match="license" mode="license-pubyear">
    <dbkey>project_publication_year</dbkey>
    <dbvalue>
        <xsl:choose>
            <xsl:when test="@pub-year">
                <xsl:value-of select="@pub-year"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>NULL</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </dbvalue>
</xsl:template>

<!-- string, optional -->
<xsl:template match="license" mode="license-currency">
    <dbkey>project_price_currency</dbkey>
    <dbvalue>
        <xsl:choose>
            <xsl:when test="@price = ''">
                <xsl:text>NULL</xsl:text>
            </xsl:when>
            <xsl:when test="@price">
                <xsl:text>'</xsl:text>
                <xsl:value-of select="substring(@price, 1, 1)"/>
                <xsl:text>'</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>NULL</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </dbvalue>
</xsl:template>

<!-- number, optional -->
<xsl:template match="license" mode="license-amount">
    <dbkey>project_price_amount</dbkey>
    <dbvalue>
        <xsl:choose>
            <xsl:when test="@price = ''">
                <xsl:text>NULL</xsl:text>
            </xsl:when>
            <xsl:when test="@price">
                <xsl:value-of select="substring(@price, 2)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>NULL</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </dbvalue>
</xsl:template>

<!-- CHARACTER -->

<xsl:template match="character" mode="character-subject">
    <dbkey>project_subject_id</dbkey>
    <dbvalue>
        <xsl:choose>
            <xsl:when test="@subject = 'math'">
                <xsl:text>'1'</xsl:text>
            </xsl:when>
            <xsl:when test="@subject = 'cs'">
                <xsl:text>'2'</xsl:text>
            </xsl:when>
            <xsl:when test="@subject = 'physics'">
                <xsl:text>'3'</xsl:text>
            </xsl:when>
            <xsl:when test="@subject = 'engr'">
                <xsl:text>'4'</xsl:text>
            </xsl:when>
            <xsl:when test="@subject = 'expository'">
                <xsl:text>'5'</xsl:text>
            </xsl:when>
            <xsl:when test="@subject = 'doc'">
                <xsl:text>'6'</xsl:text>
            </xsl:when>
            <xsl:when test="@subject = 'misc'">
                <xsl:text>'7'</xsl:text>
            </xsl:when>
            <xsl:when test="@subject = 'writing'">
                <xsl:text>'8'</xsl:text>
            </xsl:when>
            <xsl:when test="@subject = 'music'">
                <xsl:text>'9'</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>NULL</xsl:text>
                <xsl:message>Ooops, character/@subject not coded for <xsl:value-of select="../@xml:id"/>.</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </dbvalue>
</xsl:template>

<xsl:template match="character" mode="character-level">
    <dbkey>project_target_level_id</dbkey>
    <dbvalue>
        <xsl:choose>
            <xsl:when test="@level = 'primary'">
                <xsl:text>'1'</xsl:text>
            </xsl:when>
            <xsl:when test="@level = 'secondary'">
                <xsl:text>'2'</xsl:text>
            </xsl:when>
            <xsl:when test="@level = 'ugld'">
                <xsl:text>'3'</xsl:text>
            </xsl:when>
            <xsl:when test="@level = 'ugud'">
                <xsl:text>'4'</xsl:text>
            </xsl:when>
            <xsl:when test="@level = 'grad'">
                <xsl:text>'5'</xsl:text>
            </xsl:when>
            <xsl:when test="@level = 'research'">
                <xsl:text>'6'</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>NULL</xsl:text>
                <xsl:message>Ooops, character/@level not coded for <xsl:value-of select="../@xml:id"/>.</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </dbvalue>
</xsl:template>

<xsl:template match="character" mode="character-phase">
    <dbkey>project_phase_id</dbkey>
    <dbvalue>
        <xsl:choose>
            <xsl:when test="@phase = 'develop'">
                <xsl:text>'1'</xsl:text>
            </xsl:when>
            <xsl:when test="@phase = 'ready'">
                <xsl:text>'2'</xsl:text>
            </xsl:when>
            <xsl:when test="@phase = 'mature'">
                <xsl:text>'3'</xsl:text>
            </xsl:when>
            <xsl:when test="@phase = 'converting'">
                <xsl:text>'4'</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>NULL</xsl:text>
                <xsl:message>Ooops, character/@phase not coded for <xsl:value-of select="../@xml:id"/>.</xsl:message>
            </xsl:otherwise>
        </xsl:choose>
    </dbvalue>
</xsl:template>

 <!-- SITES -->

<!-- string, optional -->
<xsl:template match="sites" mode="sites-landing">
    <dbkey>project_landing_URL</dbkey>
    <dbvalue>
        <xsl:choose>
            <xsl:when test="@landing">
                <xsl:text>'</xsl:text>
                <xsl:value-of select="@landing"/>
                <xsl:text>'</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>NULL</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </dbvalue>
</xsl:template>

<!-- string, optional -->
<xsl:template match="sites" mode="sites-source">
    <dbkey>project_source_URL</dbkey>
    <dbvalue>
        <xsl:choose>
            <xsl:when test="@source">
                <xsl:text>'</xsl:text>
                <xsl:value-of select="@source"/>
                <xsl:text>'</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>NULL</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </dbvalue>
</xsl:template>

<!-- string, optional -->
<xsl:template match="sites" mode="sites-html">
    <dbkey>project_html_URL</dbkey>
    <dbvalue>
        <xsl:choose>
            <xsl:when test="@html">
                <xsl:text>'</xsl:text>
                <xsl:value-of select="@html"/>
                <xsl:text>'</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>NULL</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </dbvalue>
</xsl:template>

<!-- string, optional -->
<xsl:template match="sites" mode="sites-pdf">
    <dbkey>project_pdf_URL</dbkey>
    <dbvalue>
        <xsl:choose>
            <xsl:when test="@pdf">
                <xsl:text>'</xsl:text>
                <xsl:value-of select="@pdf"/>
                <xsl:text>'</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>NULL</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </dbvalue>
</xsl:template>

<!-- string, optional -->
<xsl:template match="sites" mode="sites-print">
    <dbkey>project_print_URL</dbkey>
    <dbvalue>
        <xsl:choose>
            <xsl:when test="@print">
                <xsl:text>'</xsl:text>
                <xsl:value-of select="@print"/>
                <xsl:text>'</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>NULL</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </dbvalue>
</xsl:template>

<!-- DESCRIPTION -->

<!-- HTML text, required -->
<xsl:template match="project" mode="one-sentence">
    <dbkey>project_description_onesentence</dbkey>
    <dbvalue>
        <xsl:variable name="raw-text">
            <!-- no overall element, thus node() -->
            <xsl:apply-templates select="onesentence/node()" mode="serialize"/>
        </xsl:variable>
        <xsl:text>'</xsl:text>
            <!-- defend from non-tight authored elements -->
            <xsl:value-of select="normalize-space($raw-text)"/>
        <xsl:text>'</xsl:text>
    </dbvalue>
</xsl:template>

<!-- HTML text, optional -->
<xsl:template match="project" mode="full-description">
    <dbkey>project_description_full</dbkey>
    <dbvalue>
        <xsl:text>'</xsl:text>
        <!-- structured by "p", etc, thus * -->
        <xsl:apply-templates select="description/*" mode="serialize"/>
        <xsl:text>'</xsl:text>
    </dbvalue>
</xsl:template>

<!-- FEATURES -->

<!-- bit string -->
<xsl:template match="features" mode="features">
    <dbkey>project_features</dbkey>
    <dbvalue>
        <xsl:text>'</xsl:text>
        <!-- bit 1 -->
        <xsl:choose>
            <xsl:when test="@hints = 'yes'">1</xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
        <!-- bit 2 -->
        <xsl:choose>
            <xsl:when test="@answers = 'yes'">1</xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
        <!-- bit 3 -->
        <xsl:choose>
            <xsl:when test="@solutions = 'yes'">1</xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
        <!-- bit 4 -->
        <xsl:choose>
            <xsl:when test="@reading-questions = 'yes'">1</xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
        <!-- bit 5 -->
        <xsl:choose>
            <xsl:when test="@webwork = 'yes'">1</xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
        <!-- bit 6 -->
        <xsl:choose>
            <xsl:when test="@videos = 'yes'">1</xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
        <!-- bit 7 -->
        <xsl:choose>
            <xsl:when test="@worksheets = 'yes'">1</xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
        <!-- bit 8 -->
        <xsl:choose>
            <xsl:when test="@projects = 'yes'">1</xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
        <!-- bit 9 -->
        <xsl:choose>
            <xsl:when test="@accessible = 'yes'">1</xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
        <!-- bit 10 -->
        <xsl:choose>
            <xsl:when test="@self-study = 'yes'">1</xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
        <!-- bit 11 -->
        <xsl:choose>
            <xsl:when test="@instructor-solutions = 'yes'">1</xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
        <!-- bit 12 -->
        <xsl:choose>
            <xsl:when test="@instructor-guide = 'yes'">1</xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
        <!-- bit 13 -->
        <xsl:choose>
            <xsl:when test="@test-bank = 'yes'">1</xsl:when>
            <xsl:otherwise>0</xsl:otherwise>
        </xsl:choose>
        <xsl:text>'</xsl:text>
    </dbvalue>
</xsl:template>

<!-- RECOGNITION -->

<xsl:template match="project" mode="recognition">
    <dbkey>project_recognition_code</dbkey>
    <dbvalue>
        <xsl:choose>
            <xsl:when test="recognition/@aim = 'yes'">
                <xsl:text>'AIM'</xsl:text>
            </xsl:when>
            <!--  -->
            <xsl:otherwise>
                <xsl:text>NULL</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </dbvalue>
</xsl:template>

<!-- AUTHORS -->

<!-- string, mandatory -->
<xsl:template match="author" mode="author-project-id">
    <dbkey>coauthors_project_id</dbkey>
    <dbvalue>
        <xsl:text>'</xsl:text>
        <xsl:value-of select="../@xml:id"/>
        <xsl:text>'</xsl:text>
    </dbvalue>
</xsl:template>

<!-- string, mandatory -->
<xsl:template match="author" mode="author-displayname">
    <dbkey>coauthors_displayname</dbkey>
    <dbvalue>
        <xsl:text>'</xsl:text>
        <xsl:value-of select="displayname"/>
        <xsl:text>'</xsl:text>
    </dbvalue>
</xsl:template>

<!-- string, optional -->
<xsl:template match="author" mode="author-url">
    <dbkey>coauthors_url</dbkey>
    <dbvalue>
        <xsl:choose>
            <xsl:when test="substring(@url, 1, 4) = 'http'">
                <xsl:text>'</xsl:text>
                <xsl:value-of select="@url"/>
                <xsl:text>'</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>NULL</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </dbvalue>
</xsl:template>

<!-- string, optional -->
<xsl:template match="author" mode="author-email">
    <dbkey>coauthors_email</dbkey>
    <dbvalue>
        <xsl:choose>
            <xsl:when test="substring(@url, 1, 7) = 'mailto:'">
                <xsl:text>'</xsl:text>
                <xsl:value-of select="substring(@url, 8)"/>
                <xsl:text>'</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>NULL</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </dbvalue>
</xsl:template>

<!-- string, optional -->
<xsl:template match="author" mode="author-affiliations">
    <dbkey>coauthors_affiliation</dbkey>
    <dbvalue>
        <xsl:choose>
            <!-- overall trumps just author -->
            <xsl:when test="not(normalize-space(../affiliation) = '')">
                <xsl:text>'</xsl:text>
                <xsl:value-of select="normalize-space(../affiliation)"/>
                <xsl:text>'</xsl:text>
            </xsl:when>
            <!-- per-author -->
            <xsl:when test="not(normalize-space(affiliation) = '')">
                <xsl:text>'</xsl:text>
                <xsl:value-of select="normalize-space(affiliation)"/>
                <xsl:text>'</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text>NULL</xsl:text>
            </xsl:otherwise>
        </xsl:choose>
    </dbvalue>
    <!-- not employed by XML catalog -->
    <dbkey>coauthors_affiliation_2</dbkey>
    <dbvalue>NULL</dbvalue>
</xsl:template>

<!-- NB: following copied verbatim from PreTeXt's -->
<!--   xsl/pretext-common.xsl/                    -->
<!-- on 2022-03-30 (which is quite stable)        -->

<!-- ############# -->
<!-- Serialization -->
<!-- ############# -->

<!-- Convert a node (perhaps the root of a node-set       -->
<!-- built from an RTF) into its string representation.   -->
<!-- Used initially for conversion of PreTeXt markup to   -->
<!-- the JSON format of a Jupyter notebook.  Identical to -->
<!-- https://stackoverflow.com/questions/6696382 at       -->
<!-- comment https://stackoverflow.com/a/15783514         -->
<!--                                                      -->
<!-- Comment on original solution says:  "The above       -->
<!-- serializer templates do not handle e.g. attributes,  -->
<!-- namespaces, or reserved characters in text nodes..." -->
<!-- This serves our purposes, but perhaps needs          -->
<!-- improvements to be fully general.                    -->
<!-- (See https://stackoverflow.com/a/6698849)            -->


<xsl:template match="*" mode="serialize">
    <xsl:text>&lt;</xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:apply-templates select="." mode="serialize-namespace" />
    <xsl:apply-templates select="@*" mode="serialize" />
    <xsl:choose>
        <xsl:when test="node()">
            <xsl:text>&gt;</xsl:text>
            <xsl:apply-templates mode="serialize" />
            <xsl:text>&lt;/</xsl:text>
            <xsl:value-of select="name()"/>
            <xsl:text>&gt;</xsl:text>
        </xsl:when>
        <xsl:otherwise>
            <xsl:text> /&gt;</xsl:text>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="@*" mode="serialize">
    <xsl:text> </xsl:text>
    <xsl:value-of select="name()"/>
    <xsl:text>="</xsl:text>
    <xsl:value-of select="."/>
    <xsl:text>"</xsl:text>
</xsl:template>

<!-- A namespace "attribute" is not really an attribute, and not captured by @* above.   -->
<!-- There seems to be no way to separate an element's actual namespaces from those that -->
<!-- are explicitly written where the element was created. Here, we loop through all the -->
<!-- element's namespaces, discarding some that can be safley assumed to not be in the   -->
<!-- original element declaration. And then serialize what is left.                      -->
<xsl:template match="*" mode="serialize-namespace">
    <xsl:for-each select="./namespace::*">
        <!-- test taken from http://lenzconsulting.com/namespace-normalizer/normalize-namespaces.xsl -->
        <xsl:if test="name()!='xml' and not(.=../preceding::*/namespace::* or .=ancestor::*[position()>1]/namespace::*)">
            <xsl:text> xmlns</xsl:text>
            <xsl:if test="not(name(current())='')">
                <xsl:text>:</xsl:text>
                <xsl:value-of select="name(current())"/>
            </xsl:if>
            <xsl:text>="</xsl:text>
            <xsl:value-of select="current()"/>
            <xsl:text>"</xsl:text>
        </xsl:if>
    </xsl:for-each>
</xsl:template>

<xsl:template match="text()" mode="serialize">
    <xsl:value-of select="."/>
</xsl:template>

</xsl:stylesheet>
