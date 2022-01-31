<?xml version='1.0'?>
<!--**********************************************************
Copyright 2019  All Rights Reserved
Robert A. Beezer, David W. Farmer, Alex Jordan

This file is used by the PreTeXt project to track projects
authored and distributed with PreTeXt.  By contributing edits,
or new project files, you agree to transfer your copyright
interest to the individuals named above.
***********************************************************-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:exsl="http://exslt.org/common"
                extension-element-prefixes="exsl"
>

<!-- This variable holds extra information for each gallery entry. -->
<!-- But with a pointer back to the project entry, we can mine all that. -->
<xsl:variable name="gallery-rtf">
    <!--  -->
    <exemplar ref="FRY-CLP1" best-url="landing" poster="http://www.math.ubc.ca/~CLP/images/clp1-cover.svg">
        <onesentence>First of four volumes of traditional calculus from the University of British Columbia.</onesentence>
     </exemplar>

    <exemplar ref="levin-DMOI" best-url="landing" poster="http://discrete.openmathbooks.org/assets/images/cover.png">
        <onesentence>An example of applying style to content.</onesentence>
    </exemplar>
    <!--  -->
    <exemplar ref="austin-ula" best-url="html" poster="https://davidaustinm.github.io/ula/cover.jpg">
        <onesentence>Applied linear algebra with custom interactive explorations.</onesentence>
    </exemplar>

   <exemplar ref="boelkins-ACS" best-url="landing" poster="https://activecalculus.org/images/ACScover2018-updated.jpg">
        <onesentence>Calculus through active learning.</onesentence>
    </exemplar>
    <!--  -->
   <exemplar ref="yoshiwara-mfg" best-url="landing" poster="https://yoshiwarabooks.org/mfg/images/cover.png">
        <onesentence>Comprehensive treatment of college algebra organized around modeling, functions, and graphs.</onesentence>
    </exemplar>
    <!--  -->
   <exemplar ref="pcc-ORCAA" best-url="landing" poster="https://spot.pcc.edu/math/orcca/ed2/html/images/ORCCAbrandlogo.png">
        <onesentence>7,000 exercises, with 5,600 implemented in WeBWorK.</onesentence>
    </exemplar>
    <!--  -->
   <exemplar ref="judson-AATA" best-url="landing" poster="http://abstract.ups.edu/graphics/cover_aata_2019.png">
        <onesentence>Traditional abstract algebra with a heavy dose of modern Sage computational cells.</onesentence>
    </exemplar>
    <!-- Keep "Story of 8" in location 8 ;-) -->
   <exemplar ref="hitchman-eight" best-url="html" poster="http://mphitchman.com/eight/images/8.jpg">
        <onesentence>Expository writing, with tongue in cheek.</onesentence>
    </exemplar>
    <!--  -->
   <exemplar ref="hutchinson-mt21c" best-url="html" poster="http://musictheory.pugetsound.edu/mt21c/images/unit6/enh-mod-waltz-of-flowers-all.svg">
        <onesentence>PreTeXt is not just for STEM.</onesentence>
    </exemplar>
    <!--  -->
   <exemplar ref="bogart-CTGD" best-url="landing" poster="https://bogart.openmathbooks.org/assets/images/cover.png">
        <onesentence>Lost, found, converted, edited, and modernized.</onesentence>
    </exemplar>
    <!--  -->
</xsl:variable>

<!-- And converted to a node set of "exemplar" -->
<xsl:variable name="gallery" select="exsl:node-set($gallery-rtf)/exemplar" />

<!-- Entry template -->
<xsl:template match="/">
    <xsl:apply-templates/>
</xsl:template>

<!-- Main construction -->
<xsl:template match="register">
    <!-- we need the register context for project look-ups -->
    <xsl:variable name="register" select="."/>
    <html>
        <head>
            <script src="https://pretextbook.org/js/lib/jquery.min.js"/>
            <script src="https://pretextbook.org/js/lib/knowl.js"/>
            <link rel="stylesheet" type="text/css" href="https://pretextbook.org/css/0.31/catalog.css"/>
            <style>
                <xsl:text>.posters {padding-bottom:30px;}&#xa;</xsl:text>
                <xsl:text>.posterbox {height:180px; width:150px; display:inline-block; text-align:center;}&#xa;</xsl:text>
                <xsl:text>.poster {height:100%; width:auto;}&#xa;</xsl:text>
            </style>
        </head>
        
        <body>

            <div class="posters">
                <xsl:for-each select="$gallery">
                    <!-- select "register" context for project look-ups -->
                    <!-- context switch via for-each is an "exemplar"   -->
                    <xsl:apply-templates select="$register" mode="images">
                        <xsl:with-param name="exemplar" select="."/>
                    </xsl:apply-templates>
                </xsl:for-each>
            </div>
            <div class="projects">
                <xsl:for-each select="$gallery">
                    <!-- select "register" context for project look-ups -->
                    <!-- context switch via for-each is an "exemplar"   -->
                    <xsl:apply-templates select="$register" mode="info">
                        <xsl:with-param name="exemplar" select="."/>
                    </xsl:apply-templates>
                </xsl:for-each>
            </div>

        </body>
    </html>
</xsl:template>

<!-- ############### -->
<!-- Single Projects -->
<!-- ############### -->

<!-- Generate images -->
<xsl:template match="register" mode="images">
    <xsl:param name="exemplar"/>

    <!-- lookup project entry in the main database of projects -->
    <xsl:variable name="project" select="id($exemplar/@ref)"/>

    <!-- URL as link from image -->
    <xsl:variable name="best-project-url">
        <xsl:apply-templates select="$project" mode="best-url">
            <xsl:with-param name="exemplar" select="$exemplar"/>
        </xsl:apply-templates>
    </xsl:variable>
    <div class="posterbox">
    <a href="{$best-project-url}" target="_blank">
        <img class="poster" src="{$exemplar/@poster}"/>
    </a>
</div>
</xsl:template>

<!-- Generate simple list -->
<xsl:template match="register" mode="info">
    <xsl:param name="exemplar"/>

    <!-- lookup project entry in the main database of projects -->
    <xsl:variable name="project" select="id($exemplar/@ref)"/>

    <!-- Create complete title.  Documentation suggests no markup, -->
    <!-- but we do our best to capture and reproduce any HTML      -->
    <xsl:variable name="project-title">
        <xsl:copy-of select="$project/title/node()"/>
        <xsl:if test ="$project/subtitle/node()">
            <xsl:text>: </xsl:text>
            <xsl:copy-of select="$project/subtitle/node()"/>
        </xsl:if>
    </xsl:variable>
    <!-- URL as link from title -->
    <xsl:variable name="best-project-url">
        <xsl:apply-templates select="$project" mode="best-url">
            <xsl:with-param name="exemplar" select="$exemplar"/>
        </xsl:apply-templates>
    </xsl:variable>
    <!-- project's div -->
    <div class="book-summary">
        <div class="biblio">
            <!-- Title as hyperlink, always a good URL -->
            <a href="{$best-project-url}" class="title" target="_blank">
                <xsl:copy-of select="$project-title"/>
            </a>
            <xsl:text>, </xsl:text>
            <span class="authors">
                <xsl:apply-templates select="$project/author"/>
            </span>
        </div>
        <!-- "onesentence" is from gallery info -->
        <span class="blurb">
            <xsl:copy-of select="$exemplar/onesentence/node()"/>
        </span>
    </div>
</xsl:template>

<!-- Utilities -->

<xsl:template match="author">
    <!-- issue newline for multiple author case -->
    <xsl:if test="preceding-sibling::author">
        <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:choose>
        <!-- hyperlinked -->
        <xsl:when test="not(normalize-space(@url) = '')">
            <a href="{@url}" target="_blank">
                <xsl:apply-templates select="displayname"/>
            </a>
        </xsl:when>
        <!-- plain -->
        <xsl:otherwise>
            <xsl:apply-templates select="displayname"/>
        </xsl:otherwise>
    </xsl:choose>
</xsl:template>

<xsl:template match="project" mode="best-url">
    <xsl:param name="exemplar"/>

    <!-- Consult $exemplar for choice of @landing or @html -->
    <xsl:choose>
        <xsl:when test="$exemplar/@best-url = 'landing'">
            <xsl:value-of select="normalize-space(sites/@landing)"/>
        </xsl:when>
        <xsl:when test="$exemplar/@best-url = 'html'">
            <xsl:value-of select="normalize-space(sites/@html)"/>
        </xsl:when>
    </xsl:choose>
</xsl:template>

</xsl:stylesheet>
