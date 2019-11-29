<?xml version='1.0'?>
<!--**********************************************************
Copyright 2019  All Rights Reserved
Robert A. Beezer, David W. Farmer, Alex Jordan

This file is used by the PreTeXt project to track projects
authored and distributed with PreTeXt.  By contributing edits,
or new project files, you agree to transfer your copyright
interest to the individuals named above.
***********************************************************-->

<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template match="/">
    <xsl:apply-templates/>
</xsl:template>

<xsl:template match="register">
    <html>
        <head>
            <script src="https://pretextbook.org/js/lib/jquery.min.js"/>
            <script src="https://pretextbook.org/js/lib/knowl.js"/>
            <link rel="stylesheet" type="text/css" href="https://pretextbook.org/css/0.31/catalog.css"/>
        </head>
        <body>
            <div class="projects">
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
                    <xsl:with-param name="heading" select="'Documentation'"/>
                    <xsl:with-param name="subject" select="'doc'"/>
                </xsl:apply-templates>
                <!-- all "music" are under development -->
                <!-- 
                <xsl:apply-templates select="." mode="subject-level">
                    <xsl:with-param name="heading" select="'Music'"/>
                    <xsl:with-param name="subject" select="'music'"/>
                </xsl:apply-templates>
                 -->
                <!-- all "writing" are under development -->
                <!-- 
                <xsl:apply-templates select="." mode="subject-level">
                    <xsl:with-param name="heading" select="'Writing'"/>
                    <xsl:with-param name="subject" select="'writing'"/>
                </xsl:apply-templates>
                 -->
                <xsl:apply-templates select="." mode="subject-level">
                    <xsl:with-param name="heading" select="'Humor'"/>
                    <xsl:with-param name="subject" select="'misc'"/>
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
    <!-- A string to match knowl-clickable to content -->
    <xsl:variable name="id">
        <xsl:value-of select="@xml:id"/>
        <xsl:text>-fact-sheet</xsl:text>
    </xsl:variable>
    <!-- project's div -->
    <div class="book-summary">
        <div class="biblio">
            <!-- project title as knowl to "fact sheet" -->
            <a data-knowl="" class="id-ref title" data-refid="hk-{$id}" title="Fact Sheet">
                <xsl:apply-templates select="title"/>
            </a>
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
                    <!-- no optional"description",            -->
                    <!-- then next template won't match       -->
                    <!-- "description" hidden as "More" knowl -->
                    <xsl:apply-templates select="description"/>
                </p>
            </div>
        </xsl:if>
        <div class="badges">
            <xsl:apply-templates select="recognition"/>
            <xsl:apply-templates select="features"/>
            <xsl:apply-templates select="license"/>
        </div>
        <!-- knowl-content as trailing div      -->
        <!-- simple one-row "table" from before -->
        <!-- This should change radically       -->
        <div class="fact-sheet-knowl" id="hk-{$id}">
            <table class="fact-sheet">
                <tr>
                    <xsl:apply-templates select="." mode="author-cell"/>
                    <xsl:apply-templates select="." mode="title-cell"/>
                    <xsl:apply-templates select="." mode="character-cell"/>
                    <xsl:apply-templates select="." mode="legal-cell"/>
                </tr>
            </table>
        </div>
    </div>
</xsl:template>

<xsl:template match="author">
    <!-- issue newline for multiple author case -->
    <xsl:if test="preceding-sibling::author">
        <xsl:text>, </xsl:text>
    </xsl:if>
    <xsl:apply-templates select="displayname"/>
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
    <xsl:if test="@hints = 'yes'">
        <img class="badge" title="Hints" src="images/hints.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@answers = 'yes'">
        <img class="badge" title="Answers" src="images/answers.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@solutions = 'yes'">
        <img class="badge" title="Solutions" src="images/solutions.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@reading-questions = 'yes'">
        <img class="badge" title="Reading Questions" src="images/reading-questions.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@videos = 'yes'">
        <img class="badge" title="Videos" src="images/videos.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@webwork = 'yes'">
        <img class="badge" title="WeBWorK" src="images/webwork.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@worksheets = 'yes'">
        <img class="badge" title="Worksheets" src="images/worksheets.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@projects = 'yes'">
        <img class="badge" title="Projects" src="images/projects.jpg"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@accessible = 'yes'">
        <img class="badge" title="Accessible" src="images/accessible.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@self-study = 'yes'">
        <img class="badge" title="Self Study" src="images/self-study.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@instructor-solutions = 'yes'">
        <img class="badge" title="Instructor Solutions" src="images/instructor-solutions.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@instructor-guide = 'yes'">
        <img class="badge" title="Instructor Guide" src="images/instructor-guide.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@test-bank = 'yes'">
        <img class="badge" title="Test Bank" src="images/test-bank.png"/>
    </xsl:if>
    <!--  -->
</xsl:template>

<xsl:template match="license">
    <!--  -->
    <xsl:if test="@code = 'CC'">
        <img class="badge license" title="Creative Commons License" src="https://pretextbook.org/badges/cc.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@code = 'GFDL'">
        <img class="badge license" title="GNU Free Documentation License" src="https://pretextbook.org/badges/gfdl.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@code = 'all-rights'">
        <img class="badge" title="All Rights Reserved" src="images/all-rights.png"/>
    </xsl:if>
    <!--  -->
    <xsl:if test="@code = 'public'">
        <img class="badge" title="Public Domain" src="images/public.png"/>
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
        <xsl:text>More</xsl:text>
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
        <xsl:text> projects.</xsl:text>
    </p>
    <!-- Subjects -->
    <p>
        <xsl:text>Mathematics: </xsl:text>
        <xsl:value-of select="count(project/character[@subject='math'])"/>
        <br/>
        <xsl:text>Computer Science: </xsl:text>
        <xsl:value-of select="count(project/character[@subject='cs'])"/>
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
        <xsl:text>Miscellaneous: </xsl:text>
        <xsl:value-of select="count(project/character[@subject='misc'])"/>
        <br/>
    </p>
    <!-- Licenses -->
    <p>
        <xsl:text>CC License: </xsl:text>
        <xsl:value-of select="count(project/license[@code='CC'])"/>
        <br/>
        <xsl:text>GFDL License: </xsl:text>
        <xsl:value-of select="count(project/license[@code='GFDL'])"/>
        <br/>
        <xsl:text>All Rights Reserved: </xsl:text>
        <xsl:value-of select="count(project/license[@code='all-rights'])"/>
        <br/>
        <xsl:text>Not stated: </xsl:text>
        <xsl:value-of select="$total - count(project/license/@code)"/>
        <br/>
    </p>
    <!-- Level -->
    <p>
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
    </p>
</xsl:template>


<!-- ############################### -->
<!-- Obsolete, to Support Fact Sheet -->
<!-- ############################### -->

<xsl:template match="project" mode="author-cell">
    <td class="authors">
        <xsl:apply-templates select="author" mode="author-cell"/>
        <!-- overall affiliation, presumes no individual affiliations -->
        <xsl:if test="normalize-space(affiliation)">
            <xsl:apply-templates select="affiliation"/>
        </xsl:if>
    </td>
</xsl:template>

<xsl:template match="author" mode="author-cell">
    <!-- issue newline for multiple author case -->
    <xsl:if test="preceding-sibling::author">
        <br/>
    </xsl:if>
    <!-- single author, optionally linked to @url -->
    <xsl:choose>
        <xsl:when test="@url">
            <a href="{@url}">
                <xsl:apply-templates select="displayname"/>
            </a>
        </xsl:when>
        <xsl:otherwise>
            <xsl:apply-templates select="displayname"/>
        </xsl:otherwise>
    </xsl:choose>
    <!-- affiliation is option, no-op is OK -->
    <xsl:apply-templates select="affiliation"/>
</xsl:template>

<!-- *always* onto a newline -->
<xsl:template match="affiliation">
    <br/>
    <xsl:text>(</xsl:text>
    <xsl:apply-templates/>
    <xsl:text>)</xsl:text>
</xsl:template>

<xsl:template match="project" mode="title-cell">
    <td class="title">
        <!-- title of the project, optionally linked  -->
        <!-- to overall project landing page          -->
        <xsl:choose>
            <xsl:when test="sites/@landing">
                <a href="{sites/@landing}">
                    <i>
                        <xsl:apply-templates select="title"/>
                    </i>
                </a>
            </xsl:when>
            <xsl:otherwise>
                <i>
                    <xsl:apply-templates select="title"/>
                </i>
            </xsl:otherwise>
        </xsl:choose>
        <xsl:apply-templates select="." mode="site-list"/>
        <!-- Awards blurb on same line as description -->
        <xsl:if test="awards">
            <p>
                <xsl:apply-templates select="awards"/>
            </p>
        </xsl:if>
        <!-- Line of binary recognitions, such as AIM Approved Textbooks -->
        <xsl:if test="recognition">
            <br/>
            <!-- AIM Approved Textbooks -->
            <xsl:if test="recognition/@aim = 'yes'">
                <span title="American Institute of Mathematics Approved Textbooks">AIM</span>
                <xsl:text> </xsl:text>
            </xsl:if>
        </xsl:if>
    </td>
</xsl:template>

<xsl:template match="project" mode="site-list">
    <xsl:if test="sites/@source|sites/@html|sites/@pdf|sites/@print|sites/@ancillary1">
        <br/>
        <xsl:if test="sites/@html">
            <a href="{sites/@html}">
                <xsl:text>Online</xsl:text>
            </a>
            <xsl:text>&#xa0;</xsl:text>
        </xsl:if>
        <xsl:if test="sites/@pdf">
            <a href="{sites/@pdf}">
                <xsl:text>PDF</xsl:text>
            </a>
            <xsl:text>&#xa0;</xsl:text>
        </xsl:if>
        <xsl:if test="sites/@print">
            <a href="{sites/@print}">
                <xsl:text>Print</xsl:text>
            </a>
            <xsl:text>&#xa0;</xsl:text>
        </xsl:if>
        <xsl:if test="sites/@ancillary1">
            <a href="{sites/@ancillary1}">
                <xsl:text>Ancillary</xsl:text>
            </a>
            <xsl:text>&#xa0;</xsl:text>
        </xsl:if>
        <xsl:if test="sites/@source">
            <a href="{sites/@source}">
                <xsl:text>Source</xsl:text>
            </a>
            <xsl:text>&#xa0;</xsl:text>
        </xsl:if>
    </xsl:if>
</xsl:template>

<xsl:template match="project" mode="character-cell">
    <td class="character">
        <!-- Subject first -->
        <xsl:if test="character/@subject">
            <xsl:choose>
                <xsl:when test="character/@subject='math'">
                    <xsl:text>Mathematics</xsl:text>
                </xsl:when>
                <xsl:when test="character/@subject='cs'">
                    <xsl:text>Computer Science</xsl:text>
                </xsl:when>
                <xsl:when test="character/@subject='physics'">
                    <xsl:text>Physics</xsl:text>
                </xsl:when>
                <xsl:when test="character/@subject='engr'">
                    <xsl:text>Engineering</xsl:text>
                </xsl:when>
                <xsl:when test="character/@subject='writing'">
                    <xsl:text>Writing</xsl:text>
                </xsl:when>
                <xsl:when test="character/@subject='music'">
                    <xsl:text>Music</xsl:text>
                </xsl:when>
                <xsl:when test="character/@subject='doc'">
                    <xsl:text>Documentation</xsl:text>
                </xsl:when>
                <xsl:when test="character/@subject='misc'">
                    <xsl:text>Miscellaneous</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message>Subject code not recognized (<xsl:value-of select="character/@subject"/>)</xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <!-- Audience level next -->
        <xsl:if test="character/@level">
            <xsl:if test="character/@subject">
                <br/>
            </xsl:if>
            <!--   @level: secondary, ugld, ugud, grad, research -->
            <xsl:choose>
                <xsl:when test="character/@level='secondary'">
                    <xsl:text>Secondary</xsl:text>
                </xsl:when>
                <xsl:when test="character/@level='ugld'">
                    <xsl:text>Undergrad (Lower)</xsl:text>
                </xsl:when>
                <xsl:when test="character/@level='ugud'">
                    <xsl:text>Undergrad (Upper)</xsl:text>
                </xsl:when>
                <xsl:when test="character/@level='grad'">
                    <xsl:text>Graduate</xsl:text>
                </xsl:when>
                <xsl:when test="character/@level='research'">
                    <xsl:text>Research</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message>Level code not recognized (<xsl:value-of select="character/@level"/>)</xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <!-- Development phase -->
        <xsl:if test="character/@phase">
            <xsl:if test="character/@subject|character/@level">
                <br/>
            </xsl:if>
            <xsl:choose>
                <xsl:when test="character/@phase='develop'">
                    <xsl:text>Developing</xsl:text>
                </xsl:when>
                <xsl:when test="character/@phase='converting'">
                    <xsl:text>Mature, Converting</xsl:text>
                </xsl:when>
                <xsl:when test="character/@phase='ready'">
                    <xsl:text>Complete, Evolving</xsl:text>
                </xsl:when>
                <xsl:when test="character/@phase='mature'">
                    <xsl:text>Mature</xsl:text>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message>Phase code not recognized (<xsl:value-of select="character/@phase"/>)</xsl:message>
                </xsl:otherwise>
            </xsl:choose>
        </xsl:if>
        <!-- Features -->
        <!-- Line of abbreviations, tool tips will decode -->
        <xsl:if test="features">
            <xsl:if test="character/@subject|character/@level|character/@phase">
                <br/>
            </xsl:if>
            <!-- Hints -->
            <xsl:if test="features/@hints= 'yes'">
                <span title="Hints to exercises">H</span>
                <xsl:text> </xsl:text>
            </xsl:if>
            <!-- Answers -->
            <xsl:if test="features/@answers = 'yes'">
                <span title="Answers to exercises">A</span>
                <xsl:text> </xsl:text>
            </xsl:if>
            <!-- Solutions -->
            <xsl:if test="features/@solutions = 'yes'">
                <span title="Solutions to exercises">S</span>
                <xsl:text> </xsl:text>
            </xsl:if>
            <!-- Reading Questions -->
            <xsl:if test="features/@reading-questions = 'yes'">
                <span title="Reading Questions">RQ</span>
                <xsl:text> </xsl:text>
            </xsl:if>
            <!-- WeBWorK -->
            <xsl:if test="features/@webwork = 'yes'">
                <span title="WeBWorK">WW</span>
                <xsl:text> </xsl:text>
            </xsl:if>
            <!-- Videos -->
            <xsl:if test="features/@videos = 'yes'">
                <span title="Videos">V</span>
                <xsl:text> </xsl:text>
            </xsl:if>
            <!-- Worksheets -->
            <xsl:if test="features/@worksheets = 'yes'">
                <span title="Worksheets">W</span>
                <xsl:text> </xsl:text>
            </xsl:if>
            <!-- Projects -->
            <xsl:if test="features/@projects = 'yes'">
                <span title="Projects">P</span>
                <xsl:text> </xsl:text>
            </xsl:if>
            <!-- Self-Study -->
            <xsl:if test="features/@self-study = 'yes'">
                <span title="Self Study">SS</span>
                <xsl:text> </xsl:text>
            </xsl:if>
            <!-- Accessible -->
            <xsl:if test="features/@accessible = 'yes'">
                <span title="Accessible">AC</span>
                <xsl:text> </xsl:text>
            </xsl:if>
            <!-- Instructor Solutions -->
            <xsl:if test="features/@instructor-solutions = 'yes'">
                <span title="Instructor Solutions">IS</span>
                <xsl:text> </xsl:text>
            </xsl:if>
            <!-- Instructor Guide -->
            <xsl:if test="features/@instructor-guide = 'yes'">
                <span title="Instructor Guide">IG</span>
                <xsl:text> </xsl:text>
            </xsl:if>
            <!-- Test Bank -->
            <xsl:if test="features/@test-bank = 'yes'">
                <span title="Test Bank">TB</span>
                <xsl:text> </xsl:text>
            </xsl:if>
        </xsl:if>
    </td>
</xsl:template>

<xsl:template match="project" mode="legal-cell">
    <td class="legal">
        <xsl:if test="license">
            <xsl:choose>
                <xsl:when test="license/@code='all-rights'">
                    <xsl:text>&#xa9; Rights Reserved</xsl:text>
                </xsl:when>
                <xsl:when test="license/@code='GFDL'">
                    <xsl:value-of select="license/@code"/>
                </xsl:when>
                <xsl:when test="license/@code='CC'">
                    <xsl:value-of select="license/@code"/>
                    <xsl:if test="normalize-space(license/@variant)">
                        <xsl:text>-</xsl:text>
                        <xsl:value-of select="license/@variant"/>
                    </xsl:if>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:message>License code not recognized (<xsl:value-of select="license/@code"/>)</xsl:message>
                </xsl:otherwise>
            </xsl:choose>
            <!-- perhaps modified by a version -->
            <xsl:if test="normalize-space(license/@version)">
                <xsl:text> v</xsl:text>
                <xsl:value-of select="license/@version"/>
            </xsl:if>
            <!-- Publication year -->
            <xsl:if test="license/@pub-year">
                <!-- presume a license line always -->
                <br/>
                <xsl:text>(</xsl:text>
                <xsl:value-of select="license/@pub-year"/>
                <xsl:text>)</xsl:text>
            </xsl:if>

            <xsl:if test="license/@price">
                <!-- presume a license line always -->
                <br/>
                <xsl:text>Print: </xsl:text>
                <xsl:value-of select="license/@price"/>
            </xsl:if>

        </xsl:if>
    </td>
</xsl:template>

</xsl:stylesheet>
