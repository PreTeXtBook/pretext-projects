<?xml version='1.0'?>
<!--**********************************************************
Copyright 2019  All Rights Reserved
Robert A. Beezer, David W. Farmer, Alex Jordan

This file is used by the PreTeXt project to track projects
authored and distributed with PreTeXt.  By contributing edits,
or new project files, you agree to transfer your copyright
interest to the individuals named above.
***********************************************************-->

<!-- Produce a single page with Gallery and Catalog sections.      -->
<!-- Output is an HTML file with Pelican metadata in the head,     -->
<!-- so Pelican's HTMLReader wraps it with the site theme template. -->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0"
                xmlns:exsl="http://exslt.org/common"
                extension-element-prefixes="exsl"
>

<!-- ######################## -->
<!-- Gallery Exemplar Entries -->
<!-- ######################## -->

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

   <exemplar ref="boelkins-ACS" best-url="landing" poster="https://activecalculus.org/wp-content/uploads/2025/12/ACS2E-cover.png">
        <onesentence>Calculus through active learning.</onesentence>
    </exemplar>
    <!--  -->
   <exemplar ref="yoshiwara-mfg" best-url="landing" poster="https://yoshiwarabooks.org/mfg/external/images/cover.png">
        <onesentence>Comprehensive treatment of college algebra organized around modeling, functions, and graphs.</onesentence>
    </exemplar>
    <!--  -->
   <exemplar ref="pcc-ORCAA" best-url="landing" poster="https://spot.pcc.edu/math/orcca/ed2/html/images/ORCCAbrandlogo.png">
        <onesentence>7,000 exercises, with 5,600 implemented in WeBWorK.</onesentence>
    </exemplar>
    <!--  -->
   <exemplar ref="judson-AATA" best-url="landing" poster="https://judsonbooks.org/aata-files/aata-html/external/cover/cover_aata_2022.png">
        <onesentence>Traditional abstract algebra with a heavy dose of modern Sage computational cells.</onesentence>
    </exemplar>
    <!-- Keep "Story of 8" in location 8 ;-) -->
   <exemplar ref="hitchman-eight" best-url="html" poster="https://mphitchman.com/images/surface8.svg">
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


<!-- ############### -->
<!-- Entry Template  -->
<!-- ############### -->

<xsl:template match="/">
    <xsl:apply-templates/>
</xsl:template>

<!-- Main construction: combined Gallery and Catalog page        -->
<!-- Pelican's HTMLReader extracts the body content and wraps it  -->
<!-- with the site theme template (header, nav, footer, CSS/JS). -->
<!-- The site's base template already loads jQuery, knowl.js,    -->
<!-- and catalog.css, so we do not include them here.            -->
<xsl:template match="register">
    <!-- we need the register context for gallery project look-ups -->
    <xsl:variable name="register" select="."/>
    <html>
        <head>
            <title>Gallery and Catalog of PreTeXt Projects</title>
            <meta name="save_as" content="gallery.html" />
            <meta name="url" content="" />
            <meta name="slug" content="gallery" />
        </head>
        <body>

            <!-- ======= -->
            <!-- Gallery  -->
            <!-- ======= -->
            <h3>Gallery</h3>
            <p>Ten exemplary textbooks authored with PreTeXt.</p>

            <div class="gallery">
                <div class="posters">
                    <xsl:for-each select="$gallery">
                        <!-- select "register" context for project look-ups -->
                        <!-- context switch via for-each is an "exemplar"   -->
                        <xsl:apply-templates select="$register" mode="gallery-image">
                            <xsl:with-param name="exemplar" select="."/>
                        </xsl:apply-templates>
                    </xsl:for-each>
                </div>
                <div class="projects">
                    <xsl:for-each select="$gallery">
                        <xsl:apply-templates select="$register" mode="gallery-info">
                            <xsl:with-param name="exemplar" select="."/>
                        </xsl:apply-templates>
                    </xsl:for-each>
                </div>
            </div>

            <!-- ======= -->
            <!-- Catalog  -->
            <!-- ======= -->
            <h3 id="catalog">Catalog</h3>
            <p>Many books authored in PreTeXt, as contributed by their authors.</p>

            <div class="catalog">
                <div class="projects">
                    <xsl:apply-templates select="." mode="subject-level">
                        <xsl:with-param name="heading" select="'Mathematics, Primary'"/>
                        <xsl:with-param name="subject" select="'math'"/>
                        <xsl:with-param name="level"   select="'primary'"/>
                    </xsl:apply-templates>
                    <xsl:apply-templates select="." mode="subject-level">
                        <xsl:with-param name="heading" select="'Mathematics, Lower Division'"/>
                        <xsl:with-param name="subject" select="'math'"/>
                        <xsl:with-param name="level"   select="'ugld'"/>
                    </xsl:apply-templates>
                    <xsl:apply-templates select="." mode="subject-level">
                        <xsl:with-param name="heading" select="'Mathematics, Upper Division'"/>
                        <xsl:with-param name="subject" select="'math'"/>
                        <xsl:with-param name="level"   select="'ugud'"/>
                    </xsl:apply-templates>
                    <xsl:apply-templates select="." mode="subject-level">
                        <xsl:with-param name="heading" select="'Mathematics, Graduate'"/>
                        <xsl:with-param name="subject" select="'math'"/>
                        <xsl:with-param name="level"   select="'grad'"/>
                    </xsl:apply-templates>
                    <xsl:apply-templates select="." mode="subject-level">
                        <xsl:with-param name="heading" select="'Computer Science'"/>
                        <xsl:with-param name="subject" select="'cs'"/>
                    </xsl:apply-templates>
                    <xsl:apply-templates select="." mode="subject-level">
                        <xsl:with-param name="heading" select="'Engineering'"/>
                        <xsl:with-param name="subject" select="'engr'"/>
                    </xsl:apply-templates>
                    <xsl:apply-templates select="." mode="subject-level">
                        <xsl:with-param name="heading" select="'Expository'"/>
                        <xsl:with-param name="subject" select="'expository'"/>
                    </xsl:apply-templates>
                    <xsl:apply-templates select="." mode="subject-level">
                        <xsl:with-param name="heading" select="'Documentation'"/>
                        <xsl:with-param name="subject" select="'doc'"/>
                    </xsl:apply-templates>
                    <xsl:apply-templates select="." mode="subject-level">
                        <xsl:with-param name="heading" select="'Miscellaneous'"/>
                        <xsl:with-param name="subject" select="'misc'"/>
                    </xsl:apply-templates>
                    <!-- all "music" are under development -->
                    <!--
                    <xsl:apply-templates select="." mode="subject-level">
                        <xsl:with-param name="heading" select="'Music'"/>
                        <xsl:with-param name="subject" select="'music'"/>
                    </xsl:apply-templates>
                     -->
                    <xsl:apply-templates select="." mode="subject-level">
                        <xsl:with-param name="heading" select="'Writing'"/>
                        <xsl:with-param name="subject" select="'writing'"/>
                    </xsl:apply-templates>
                    <!-- All texts being converted, lumped together -->
                     <xsl:apply-templates select="." mode="phase">
                        <xsl:with-param name="heading" select="'Mature, Converting to PreTeXt'"/>
                        <xsl:with-param name="phase" select="'converting'"/>
                    </xsl:apply-templates>
                    <!-- All texts under development, lumped together -->
                     <xsl:apply-templates select="." mode="phase">
                        <xsl:with-param name="heading" select="'In Development'"/>
                        <xsl:with-param name="phase" select="'develop'"/>
                    </xsl:apply-templates>
                 </div>
                <xsl:apply-templates select="." mode="summary-stats"/>
            </div>

        </body>
    </html>
</xsl:template>

<!-- ######################### -->
<!-- Category Sections/Filters -->
<!-- ######################### -->

<!-- Create multiple  div.category  holding multiple projects each -->

<!-- Restricted to character/@phase = 'ready' | 'mature' -->
<!-- in order to exclude 'develop' & 'converting'        -->
<xsl:template match="register" mode="subject-level">
    <xsl:param name="heading"/>
    <xsl:param name="subject"/>
    <xsl:param name="level" select="''"/>

    <div class="category">
        <span class="title">
            <xsl:value-of select="$heading"/>
        </span>
        <xsl:for-each select="project[(character/@subject = $subject) and
                                      ((character/@level = $level) or ($level = '')) and
                                      ((character/@phase = 'ready') or (character/@phase = 'mature'))
                                      ]">
            <xsl:sort select="title"/>
            <xsl:apply-templates select="."/>
        </xsl:for-each>
    </div>
</xsl:template>

<!-- *Everything* with character/@phase = $phase -->
<!-- Meant for 'develop' and 'converting'        -->
<!-- So no $subject or $level parameters         -->
<xsl:template match="register" mode="phase">
    <xsl:param name="heading"/>
    <xsl:param name="phase"/>

    <div class="category">
        <span class="title">
            <xsl:value-of select="$heading"/>
        </span>
        <xsl:for-each select="project[character/@phase = $phase]">
            <xsl:sort select="title"/>
            <xsl:apply-templates select="."/>
        </xsl:for-each>
    </div>
</xsl:template>


<!-- ############### -->
<!-- Single Projects -->
<!-- ############### -->

<!-- Each project is a  div.book-summary -->

<xsl:template match="project">
    <!-- Create complete title.  Documentation suggests no markup, -->
    <!-- but we do our best to capture and reproduce any HTML      -->
    <xsl:variable name="project-title">
        <xsl:copy-of select="title/node()"/>
        <xsl:if test ="subtitle/node()">
            <xsl:text>: </xsl:text>
            <xsl:copy-of select="subtitle/node()"/>
        </xsl:if>
    </xsl:variable>
    <!-- Determine a good link for title, in preference -->
    <!-- @landing, @html, @pdf, @print, null            -->
    <xsl:variable name="best-project-url">
        <xsl:choose>
            <xsl:when test="not(normalize-space(sites/@landing) = '')">
                <xsl:value-of select="normalize-space(sites/@landing)"/>
            </xsl:when>
            <xsl:when test="not(normalize-space(sites/@html) = '')">
                <xsl:value-of select="normalize-space(sites/@html)"/>
            </xsl:when>
            <xsl:when test="not(normalize-space(sites/@pdf) = '')">
                <xsl:value-of select="normalize-space(sites/@pdf)"/>
            </xsl:when>
            <xsl:when test="not(normalize-space(sites/@print) = '')">
                <xsl:value-of select="normalize-space(sites/@print)"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:text/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:variable>
    <!-- project's div -->
    <div class="book-summary" id="{@xml:id}">
        <div class="biblio">
            <!-- Title as hyperlink if there is -->
            <!-- a rational URL, else plain     -->
            <xsl:choose>
                <xsl:when test="not($best-project-url = '')">
                    <a href="{$best-project-url}" class="title" target="_blank">
                        <xsl:copy-of select="$project-title"/>
                    </a>
                </xsl:when>
                <xsl:otherwise>
                    <span class="title">
                        <xsl:copy-of select="$project-title"/>
                    </span>
                </xsl:otherwise>
            </xsl:choose>
            <xsl:text>, </xsl:text>
            <span class="authors">
                <xsl:apply-templates select="author"/>
            </span>
        </div>
        <!-- "onesentence" is required, once enforced can drop test on "description" -->
        <xsl:if test="onesentence|description">
            <div class="blurb">
                <p>
                    <xsl:copy-of select="onesentence/node()"/>
                    <!-- no optional"description",                 -->
                    <!-- then next template won't match            -->
                    <!-- "description" hidden as "Read more" knowl -->
                    <xsl:apply-templates select="description"/>
                </p>
            </div>
        </xsl:if>
        <div class="badges">
            <xsl:apply-templates select="recognition"/>
            <xsl:apply-templates select="features"/>
            <xsl:apply-templates select="license"/>
        </div>
    </div>
</xsl:template>

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


<!-- ################# -->
<!-- Badges, In Groups -->
<!-- ################# -->

<xsl:template match="recognition">
    <xsl:if test="@aim = 'yes'">
        <img class="badge award" title="AIM Approved" src="https://pretextbook.org/badges/aim.png"/>
    </xsl:if>
</xsl:template>

<xsl:template match="features">
    <!--  -->
    <xsl:if test="@printed-book = 'yes'">
        <img class="badge" title="Printed book" src="https://pretextbook.org/badges/printed-book.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@pdf = 'yes'">
        <img class="badge" title="PDF available" src="https://pretextbook.org/badges/redPDFadobe.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@videos = 'yes'">
        <img class="badge" title="Videos" src="https://pretextbook.org/badges/videos.jpg"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@webwork = 'yes'">
        <img class="badge" title="WeBWorK" src="https://pretextbook.org/badges/webwork.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@desmos = 'yes'">
        <img class="badge" title="Desmos" src="https://pretextbook.org/badges/desmos.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@geogebra = 'yes'">
        <img class="badge" title="Geogebra" src="https://pretextbook.org/badges/geogebra.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@reading-questions = 'yes'">
        <img class="badge" title="Reading Questions" src="https://pretextbook.org/badges/reading-questions.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@worksheets = 'yes'">
        <img class="badge" title="Worksheets" src="https://pretextbook.org/badges/worksheets.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@projects = 'yes'">
        <img class="badge" title="Projects" src="https://pretextbook.org/badges/projects.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@hints = 'yes'">
        <img class="badge" title="Hints" src="https://pretextbook.org/badges/hints.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@answers = 'yes'">
        <img class="badge" title="Student Answers" src="https://pretextbook.org/badges/answers.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@solutions = 'yes'">
        <img class="badge" title="Student Solutions" src="https://pretextbook.org/badges/solutions.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@accessible = 'yes'">
        <img class="badge" title="Accessible" src="https://pretextbook.org/badges/accessible.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@self-study = 'yes'">
        <img class="badge" title="Self Study" src="https://pretextbook.org/badges/self-study.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@group-activities = 'yes'">
        <img class="badge" title="Group Activities" src="https://pretextbook.org/badges/group-activities.jpg"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@instructor-solutions = 'yes'">
        <img class="badge" title="Instructor Solutions" src="https://pretextbook.org/badges/instructor-solutions.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@instructor-guide = 'yes'">
        <img class="badge" title="Instructor Guide" src="https://pretextbook.org/badges/instructor-guide.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@test-bank = 'yes'">
        <img class="badge" title="Test Bank" src="https://pretextbook.org/badges/test-bank.png"/>
    </xsl:if>
    <!--  -->
</xsl:template>

<xsl:template match="license">
    <!-- TODO: Presumes just one now.  To expand, fence @code, -->
    <!-- and adjust tests to be "contains()" fenced versions   -->
    <!--  -->
    <xsl:if test="@code = 'CC'">
        <img class="badge license" title="Creative Commons License" src="https://pretextbook.org/badges/cc.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@code = 'GFDL'">
        <img class="badge license" title="GNU Free Documentation License" src="https://pretextbook.org/badges/gfdl.png"/>
    </xsl:if>
    <xsl:if test="@code = 'MIT'">
        <img class="badge license" title="MIT Open Source License" src="https://pretextbook.org/badges/MiT_opensource.png"/>
    </xsl:if>
    <!--  -->
    <!-- 'undecided displays as traditional copyright -->
    <xsl:if test="(@code = 'all-rights') or (@code = 'undecided')">
        <img class="badge license" title="All Rights Reserved" src="https://pretextbook.org/badges/copyright.jpg"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@code = 'public'">
        <img class="badge license" title="Public Domain" src="https://pretextbook.org/badges/public.png"/>
    </xsl:if>
    <!--  -->
    <!-- No specification is traditional copyright, source should be 'undecided' -->
    <xsl:if test="normalize-space(@code) = ''">
        <img class="badge license" title="All Rights Reserved" src="https://pretextbook.org/badges/copyright.jpg"/>
    </xsl:if>
    <!--  -->
</xsl:template>


<!-- ############# -->
<!-- Knowled Items -->
<!-- ############# -->

<xsl:template match="description">
    <xsl:variable name="id">
        <xsl:value-of select="../@xml:id"/>
        <xsl:text>-description</xsl:text>
    </xsl:variable>
    <a data-knowl="" class="id-ref" data-refid="hk-{$id}" title="Description">
        <!-- space after "onesentence" could be controlled by CSS -->
        <xsl:text> </xsl:text>
        <xsl:text>Read more</xsl:text>
    </a>
    <div class="description-knowl" id="hk-{$id}">
        <article class="description">
            <xsl:copy-of select="*"/>
        </article>
    </div>
</xsl:template>

<xsl:template match="awards">
    <xsl:variable name="id">
        <xsl:value-of select="../@xml:id"/>
        <xsl:text>-awards</xsl:text>
    </xsl:variable>
    <a data-knowl="" class="id-ref" data-refid="hk-{$id}" title="awards">
        <!-- space after "onesentence" could be controlled by CSS -->
        <xsl:text> </xsl:text>
        <xsl:text>Awards</xsl:text>
    </a>
    <div class="awards-knowl" id="hk-{$id}">
        <article class="awards">
            <xsl:copy-of select="*"/>
        </article>
    </div>
</xsl:template>


<!-- ################## -->
<!-- Summary Statistics -->
<!-- ################## -->

<xsl:template match="register" mode="summary-stats">
    <xsl:variable name="total" select="count(project)"/>
    <!-- Total Projects -->
    <p>
        <xsl:value-of select="$total"/>
        <xsl:text> projects:</xsl:text>
    </p>
    <table>
        <tr>
            <!-- Subjects -->
            <td style="vertical-align:top;padding-right:20px;">
                <xsl:text>Mathematics: </xsl:text>
                <xsl:value-of select="count(project/character[@subject='math'])"/>
                <br/>
                <xsl:text>Computer Science: </xsl:text>
                <xsl:value-of select="count(project/character[@subject='cs'])"/>
                <br/>
                <xsl:text>Engineering: </xsl:text>
                <xsl:value-of select="count(project/character[@subject='engr'])"/>
                <br/>
                <xsl:text>Music: </xsl:text>
                <xsl:value-of select="count(project/character[@subject='music'])"/>
                <br/>
                <xsl:text>Writing: </xsl:text>
                <xsl:value-of select="count(project/character[@subject='writing'])"/>
                <br/>
                <xsl:text>Documentation: </xsl:text>
                <xsl:value-of select="count(project/character[@subject='doc'])"/>
                <br/>
                <xsl:text>Expository: </xsl:text>
                <xsl:value-of select="count(project/character[@subject='expository'])"/>
                <br/>
                <xsl:text>Miscellaneous: </xsl:text>
                <xsl:value-of select="count(project/character[@subject='misc'])"/>
                <br/>
            </td>
            <!-- Licenses -->
            <td style="vertical-align:top;padding-right:20px;">
                <xsl:text>CC License: </xsl:text>
                <xsl:value-of select="count(project/license[@code='CC'])"/>
                <br/>
                <xsl:text>GFDL License: </xsl:text>
                <xsl:value-of select="count(project/license[@code='GFDL'])"/>
                <br/>
                <xsl:text>MIT License: </xsl:text>
                <xsl:value-of select="count(project/license[@code='MIT'])"/>
                <br/>
                <xsl:text>All Rights Reserved: </xsl:text>
                <xsl:value-of select="count(project/license[@code='all-rights'])"/>
                <br/>
                <xsl:text>Public Domain: </xsl:text>
                <xsl:value-of select="count(project/license[@code='public'])"/>
                <br/>
                <xsl:text>Undecided/In-Progress: </xsl:text>
                <xsl:value-of select="count(project/license[@code='undecided']|project/license[normalize-space(@code)=''])"/>
                <br/>
            </td>
            <!-- Level -->
            <td style="vertical-align:top;">
                <xsl:text>Primary: </xsl:text>
                <xsl:value-of select="count(project/character[@level='primary'])"/>
                <br/>
                <xsl:text>Secondary: </xsl:text>
                <xsl:value-of select="count(project/character[@level='secondary'])"/>
                <br/>
                <xsl:text>Undergraduate, Lower-Division: </xsl:text>
                <xsl:value-of select="count(project/character[@level='ugld'])"/>
                <br/>
                <xsl:text>Undergraduate, Upper-Division: </xsl:text>
                <xsl:value-of select="count(project/character[@level='ugud'])"/>
                <br/>
                <xsl:text>Graduate: </xsl:text>
                <xsl:value-of select="count(project/character[@level='grad'])"/>
                <br/>
                <xsl:text>Research: </xsl:text>
                <xsl:value-of select="count(project/character[@level='research'])"/>
                <br/>
                <xsl:text>Not stated: </xsl:text>
                <xsl:value-of select="$total - count(project/character/@level)"/>
                <br/>
            </td>
        </tr>
    </table>
</xsl:template>


<!-- ######################### -->
<!-- Gallery: Single Projects  -->
<!-- ######################### -->

<!-- Generate poster image for a gallery exemplar -->
<xsl:template match="register" mode="gallery-image">
    <xsl:param name="exemplar"/>

    <!-- lookup project entry in the main database of projects -->
    <xsl:variable name="project" select="id($exemplar/@ref)"/>

    <!-- URL as link from image -->
    <xsl:variable name="best-project-url">
        <xsl:apply-templates select="$project" mode="gallery-best-url">
            <xsl:with-param name="exemplar" select="$exemplar"/>
        </xsl:apply-templates>
    </xsl:variable>
    <div class="posterbox">
    <a href="{$best-project-url}" target="_blank">
        <img class="poster" src="{$exemplar/@poster}"/>
    </a>
</div>
</xsl:template>

<!-- Generate simple list entry for a gallery exemplar -->
<xsl:template match="register" mode="gallery-info">
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
        <xsl:apply-templates select="$project" mode="gallery-best-url">
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

<!-- URL preference for gallery exemplar -->
<xsl:template match="project" mode="gallery-best-url">
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
