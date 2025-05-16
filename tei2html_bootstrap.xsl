<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema" exclude-result-prefixes="tei xs" version="2.0">
<xsl:strip-space elements="*"/>
<xsl:preserve-space elements="tei:ab"/>
<xsl:output method="html" indent="yes" encoding="UTF-8"/>
<!--  Normalize text outside of edition  -->
<xsl:template match="text()">
<xsl:value-of select="normalize-space(.)"/>
</xsl:template>
<!--  Render words with trailing space  -->
<xsl:template match="tei:w">
<xsl:apply-templates select="node()"/>
<xsl:text> </xsl:text>
</xsl:template>
<!--  Choices with chevrons  -->
<xsl:template match="tei:choice">
<span class="choice">
⸢
<xsl:apply-templates select="tei:corr"/>
⸣
</span>
</xsl:template>
<xsl:template match="tei:corr">
<xsl:apply-templates/>
</xsl:template>
<!--  Inline notes  -->
<xsl:template match="tei:note">
<xsl:apply-templates/>
<xsl:text> </xsl:text>
</xsl:template>
<!--  Abbreviations expanded  -->
<xsl:template match="tei:expan">
<xsl:apply-templates select="tei:abbr"/>
<xsl:text>(</xsl:text>
<xsl:apply-templates select="tei:ex"/>
<xsl:text>)</xsl:text>
</xsl:template>
<!--  Names, places, dates, foreign  -->
<xsl:template match="tei:persName">
<span class="persName">
<xsl:apply-templates/>
</span>
</xsl:template>
<xsl:template match="tei:placeName">
<span class="placeName">
<xsl:apply-templates/>
</span>
</xsl:template>
<xsl:template match="tei:date">
<span class="date">
<xsl:if test="@when">
<xsl:value-of select="@when"/>
</xsl:if>
<xsl:apply-templates/>
</span>
</xsl:template>
<xsl:template match="tei:foreign">
<span class="foreign">
<xsl:apply-templates/>
</span>
</xsl:template>
<!--  Structural markers  -->
<xsl:template match="tei:seg">
<span class="seg">
<xsl:apply-templates/>
</span>
</xsl:template>
<xsl:template match="tei:pb">
<span class="pb">¶</span>
</xsl:template>
<xsl:template match="tei:fw">
<span class="fw">
<xsl:apply-templates/>
</span>
</xsl:template>
<!--  Damaged/unclear  -->
<xsl:template match="tei:unclear">
<xsl:for-each select="string-to-codepoints(string(.))">
<xsl:value-of select="codepoints-to-string(.)"/>
<xsl:text>̣</xsl:text>
</xsl:for-each>
</xsl:template>
<xsl:template match="tei:gap">
<xsl:choose>
<xsl:when test="@reason='ellipsis'">
<xsl:text>...</xsl:text>
</xsl:when>
<xsl:otherwise>
<xsl:choose>
<xsl:when test="@unit='character'">
<xsl:text>[</xsl:text>
<xsl:choose>
<xsl:when test="@extent='unknown'">
<xsl:text>.?</xsl:text>
</xsl:when>
<xsl:when test="@precision='low'">
<xsl:text>.</xsl:text>
<xsl:value-of select="@quantity"/>
</xsl:when>
<xsl:otherwise>
<xsl:for-each select="1 to xs:integer(@quantity)">
<xsl:text>.</xsl:text>
</xsl:for-each>
</xsl:otherwise>
</xsl:choose>
<xsl:text>]</xsl:text>
</xsl:when>
<xsl:when test="@unit='line'">
<xsl:text>(Lines: </xsl:text>
<xsl:choose>
<xsl:when test="@extent='unknown'">? non transcribed)</xsl:when>
<xsl:otherwise><xsl:value-of select="@quantity"/> non transcribed)</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<!--  Deletions, corrections  -->
<xsl:template match="tei:del">
<xsl:choose>
<xsl:when test="@rend='erasure'">
<xsl:text>〚</xsl:text>
<xsl:apply-templates/>
<xsl:text>〛</xsl:text>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<xsl:template match="tei:sic">
<span class="sic">
<xsl:apply-templates/>
</span>
</xsl:template>
<xsl:template match="tei:subst">
<span class="subst">
<xsl:apply-templates/>
</span>
</xsl:template>
<!--  Additions above/below  -->
<xsl:template match="tei:add[@place='above']">
<span class="add-above">
\
<xsl:apply-templates/>
/
</span>
</xsl:template>
<xsl:template match="tei:add[@place='below']">
<span class="add-below">
/
<xsl:apply-templates/>
\
</span>
</xsl:template>
<xsl:template match="tei:add">
<xsl:variable name="inner"><xsl:value-of select="."/></xsl:variable>
<xsl:choose>
<xsl:when test="@place='overstrike'">
<xsl:text>《</xsl:text>
<xsl:value-of select="$inner"/>
<xsl:text>》</xsl:text>
</xsl:when>
<xsl:when test="@place='above'">
<xsl:text>`</xsl:text>
<xsl:value-of select="$inner"/>
<xsl:text>´</xsl:text>
</xsl:when>
<xsl:when test="@place='below'">
<xsl:text>/</xsl:text>
<xsl:value-of select="$inner"/>
<xsl:text>\</xsl:text>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$inner"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<!--  References  -->
<xsl:template match="tei:ref">
<a class="ref">
<xsl:apply-templates/>
</a>
</xsl:template>
<!--  Suppress internals  -->
<xsl:template match="tei:encodingDesc|tei:revisionDesc"/>
<!--  Root TEI to HTML  -->
<xsl:template match="/tei:TEI">
<html lang="en">
<head>
<meta charset="UTF-8"/>
<title>
<xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
</title>
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.0.2/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-EVSTQN3/azprG1Anm3QDgpJLIm9Nao0Yz1ztcQTwFspd3yD65VohhpuuCOmLASjC" crossorigin="anonymous"/>
</head>
<body class="container py-5">
<!--  Document Header  -->
<header class="mb-5">
<h1 class="display-4 fw-bold mb-4">
<xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
</h1>
<!--  Metadata card  -->
<div class="card mb-5">
<div class="card-body">
<dl class="row mb-0">
<div class="col-md-4 mb-3">
<dt class="text-muted">Publisher</dt>
<dd class="fw-semibold mb-0">
<xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:authority"/>
</dd>
</div>
<div class="col-md-4 mb-3">
<dt class="text-muted">Published</dt>
<dd class="fw-semibold mb-0">
<xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:date"/>
</dd>
</div>
<div class="col-md-4 mb-3">
<dt class="text-muted">Monument ID</dt>
<dd class="fw-semibold mb-0">
<xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='filename']"/>
</dd>
</div>
</dl>
</div>
</div>
</header>
<!--  Metadata aside  -->
<aside class="card bg-light mb-5">
<div class="card-body">
<h2 class="h4 mb-4">Metadata</h2>
<dl class="row">
<div class="col-md-6 mb-3">
<dt class="fw-medium">Editor(s)</dt>
<dd class="mb-0">
<xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor/tei:persName"/>
</dd>
</div>
<div class="col-md-6 mb-3">
<dt class="fw-medium">Type of monument</dt>
<dd class="mb-0">
<xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:objectType"/>
</dd>
</div>
<div class="col-md-6 mb-3">
<dt class="fw-medium">Material</dt>
<dd class="mb-0">
<xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:material"/>
</dd>
</div>
<div class="col-md-6 mb-3">
<dt class="fw-medium">Find place</dt>
<dd class="mb-0">
<xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:provenance[@type='found']/tei:seg"/>
</dd>
</div>
<div class="col-md-6 mb-3">
<dt class="fw-medium">Origin</dt>
<dd class="mb-0">
<xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/tei:origPlace/tei:seg"/>
</dd>
</div>
<div class="col-md-6 mb-3">
<dt class="fw-medium">Observed in</dt>
<dd class="mb-0">
<xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:provenance[@type='observed']/tei:seg"/>
</dd>
</div>
<div class="col-md-6 mb-3">                <dt class="fw-medium">Institution &amp; inventory</dt>
<dd class="mb-0">
<xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msIdentifier/tei:altIdentifier/tei:repository/tei:seg"/>
<br/>
<small>
No
<xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msIdentifier/tei:altIdentifier/tei:idno"/>
</small>
</dd>
</div>
<div class="col-md-6 mb-3">
<dt class="fw-medium">Dimensions</dt>
<dd class="mb-0">
height
<xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:dimensions/tei:height"/>
cm, width
<xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:dimensions/tei:width"/>
cm, depth
<xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:dimensions/tei:depth"/>
cm
</dd>
</div>
<div class="col-md-6 mb-3">
<dt class="fw-medium">Letter size</dt>
<dd class="mb-0">
<xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:handDesc/tei:handNote/tei:height"/>
cm
</dd>
</div>
<div class="col-md-6 mb-3">
<dt class="fw-medium">Layout description</dt>
<dd class="mb-0">
<xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:layoutDesc/tei:layout"/>
</dd>
</div>
<div class="col-md-6 mb-3">
<dt class="fw-medium">Decoration description</dt>
<dd class="mb-0">
<!--  none  -->
</dd>
</div>
<div class="col-md-6 mb-3">
<dt class="fw-medium">Category of inscription</dt>
<dd class="mb-0">
<xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msContents/tei:summary/tei:seg"/>
</dd>
</div>
<div class="col-md-6 mb-3">
<dt class="fw-medium">Date</dt>
<dd class="mb-0">
<xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/tei:origDate/tei:seg"/>
</dd>
</div>
<div class="col-md-6 mb-3">
<dt class="fw-medium">Dating criteria</dt>
<dd class="mb-0">
<xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/tei:origDate/@evidence"/>
</dd>
</div>
<div class="col-12 mb-3">
<dt class="fw-medium">Images</dt>
<dd class="mb-0">
<!--  thumbnails below  -->
</dd>
</div>
</dl>
</div>
</aside>
<!--  Facsimiles  -->
<section class="mb-5">
<h2 class="h4 mb-3">Facsimiles</h2>
<div class="row row-cols-2 row-cols-sm-3 row-cols-md-4 g-3">
<xsl:for-each select="tei:facsimile/tei:graphic">
<div class="col">
<a href="{@url}" target="_blank" class="d-block overflow-hidden rounded shadow-sm">
<img src="{@url}" alt="Facsimile thumbnail" class="img-fluid"/>
</a>
</div>
</xsl:for-each>
</div>
</section>
<!--  Main content  -->
<main>
<xsl:apply-templates select="tei:text/tei:body/tei:div[not(@type='bibliography')]"/>
</main>
<!--  Bibliography  -->
<footer class="mt-5">
<h2 class="h4 mb-3">Bibliography</h2>
<ul class="list-unstyled ms-3">
<xsl:for-each select="tei:text/tei:body/tei:div[@type='bibliography']/tei:listBibl/tei:bibl">
<li class="mb-1">
<xsl:value-of select="."/>
</li>
</xsl:for-each>
</ul>
</footer>
</body>
</html>
</xsl:template>
<!--  Edition: preserve spacing, hyphens & newlines  -->
<xsl:template match="tei:div[@type='edition']">
<section class="mb-5">
<h2 class="h4 mb-3">Edition</h2>
<pre class="mb-4" xml:space="preserve">
<xsl:apply-templates select="tei:ab/node()[not(self::tei:lb and position()=1)]"/>
</pre>
</section>
</xsl:template>
<!--  Line breaks within edition  -->
<xsl:template match="tei:lb">
<xsl:if test="@break='no'"><xsl:text>-</xsl:text></xsl:if>
<xsl:text>
</xsl:text>
</xsl:template>
<!--  Apparatus  -->
<xsl:template match="tei:div[@type='apparatus']">
<section class="mb-5">
<h2 class="h4 mb-3">Apparatus</h2>
<ul class="list-unstyled ms-4">
<xsl:for-each select="tei:listApp/tei:app/tei:note">
<li class="mb-1">
<xsl:value-of select="."/>
</li>
</xsl:for-each>
</ul>
</section>
</xsl:template>
<!--  Translation  -->
<xsl:template match="tei:div[@type='translation']">
<section class="mb-5">
<h2 class="h4 mb-3">Translation</h2>
<xsl:for-each select="tei:p/tei:seg">
<p class="mb-2">
<xsl:value-of select="."/>
</p>
</xsl:for-each>
</section>
</xsl:template>
<!--  Commentary  -->
<xsl:template match="tei:div[@type='commentary']">
<section class="mb-5">
<h2 class="h4 mb-3">Commentary</h2>
<xsl:for-each select="tei:p/tei:seg">
<p class="mb-2">
<xsl:value-of select="."/>
</p>
</xsl:for-each>
</section>
</xsl:template>
<!-- Text divisions -->
<xsl:template match="tei:div[@type='textpart']">
<xsl:text>&lt;D=.</xsl:text>
<xsl:value-of select="@n"/>
<xsl:text> </xsl:text>
<xsl:apply-templates/>
<xsl:text> =D&gt;</xsl:text>
</xsl:template>
<!-- Original letters -->
<xsl:template match="tei:orig">
<xsl:text>=</xsl:text>
<xsl:value-of select="."/>
<xsl:text>=</xsl:text>
</xsl:template>
<!-- Supplied text -->
<xsl:template match="tei:supplied">
<xsl:choose>
<xsl:when test="@reason='lost'">
<xsl:text>[</xsl:text>
<xsl:value-of select="."/>
<xsl:if test="@cert='low'">?</xsl:if>
<xsl:text>]</xsl:text>
</xsl:when>
<xsl:when test="@reason='undefined'">
<xsl:text>_[</xsl:text>
<xsl:value-of select="."/>
<xsl:text>]_</xsl:text>
</xsl:when>
<xsl:when test="@reason='omitted'">
<xsl:text>&lt;</xsl:text>
<xsl:value-of select="."/>
<xsl:text>&gt;</xsl:text>
</xsl:when>
<xsl:when test="@reason='subaudible'">
<xsl:text>(</xsl:text>
<xsl:value-of select="."/>
<xsl:text>)</xsl:text>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="."/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<!-- Choices (corrections and regularizations) -->
<xsl:template match="tei:choice">
<xsl:choose>
<xsl:when test="tei:corr and tei:sic">
<xsl:text>&lt;</xsl:text>
<xsl:value-of select="tei:corr"/>
<xsl:text>|corr|</xsl:text>
<xsl:value-of select="tei:sic"/>
<xsl:text>&gt;</xsl:text>
</xsl:when>
<xsl:when test="tei:reg and tei:orig">
<xsl:text>&lt;</xsl:text>
<xsl:value-of select="tei:orig"/>
<xsl:text>|reg|</xsl:text>
<xsl:value-of select="tei:reg"/>
<xsl:text>&gt;</xsl:text>
</xsl:when>
<xsl:otherwise>
<xsl:apply-templates/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<!-- Highlighting -->
<xsl:template match="tei:hi">
<xsl:variable name="inner"><xsl:value-of select="."/></xsl:variable>
<xsl:choose>
<xsl:when test="@rend='apex'">
<xsl:value-of select="$inner"/>
<xsl:text>(΄)</xsl:text>
</xsl:when>
<xsl:when test="@rend='supraline'">
<xsl:value-of select="$inner"/>
<xsl:text>¯</xsl:text>
</xsl:when>
<xsl:when test="@rend='ligature'">
<xsl:value-of select="$inner"/>
<xsl:text>̲</xsl:text>
</xsl:when>
<xsl:otherwise>
<xsl:value-of select="$inner"/>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<!-- Abbreviation expansions -->
<xsl:template match="tei:expan">
<xsl:if test="tei:abbr">
<xsl:value-of select="tei:abbr"/>
</xsl:if>
<xsl:if test="tei:ex">
<xsl:text>(</xsl:text>
<xsl:value-of select="tei:ex"/>
<xsl:if test="tei:ex/@cert='low'">?</xsl:if>
<xsl:text>)</xsl:text>
</xsl:if>
</xsl:template>
<!-- Symbols -->
<xsl:template match="tei:g">
<xsl:if test="@type">
<xsl:text>*</xsl:text>
<xsl:value-of select="@type"/>
<xsl:text>*</xsl:text>
</xsl:if>
</xsl:template>
<!-- Surplus -->
<xsl:template match="tei:surplus">
<xsl:text>{</xsl:text>
<xsl:value-of select="."/>
<xsl:text>}</xsl:text>
</xsl:template>
<!-- Notes -->
<xsl:template match="tei:note">
<xsl:variable name="note"><xsl:value-of select="."/></xsl:variable>
<xsl:choose>
<xsl:when test="$note='!' or $note='sic' or $note='e.g.'">
<xsl:text>/*</xsl:text>
<xsl:value-of select="$note"/>
<xsl:text>*/</xsl:text>
</xsl:when>
<xsl:otherwise>
<xsl:text>(</xsl:text>
<xsl:value-of select="$note"/>
<xsl:text>)</xsl:text>
</xsl:otherwise>
</xsl:choose>
</xsl:template>
<!-- Spaces -->
<xsl:template match="tei:space">
<xsl:choose>
<xsl:when test="@unit='character'">
<xsl:choose>
<xsl:when test="@extent='unknown'">vac.?</xsl:when>
<xsl:otherwise>vac.<xsl:value-of select="@quantity"/></xsl:otherwise>
</xsl:choose>
</xsl:when>
<xsl:when test="@unit='line'">
<xsl:choose>
<xsl:when test="@extent='unknown'">vac.?lin</xsl:when>
<xsl:otherwise>vac.<xsl:value-of select="@quantity"/>lin</xsl:otherwise>
</xsl:choose>
</xsl:when>
</xsl:choose>
</xsl:template>
</xsl:stylesheet>
