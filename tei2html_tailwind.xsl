<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    exclude-result-prefixes="tei xs"
    version="2.0">

  <!-- Strip ignorable whitespace, but preserve inside edition blocks -->
  <xsl:strip-space elements="*"/>
  <xsl:preserve-space elements="tei:ab"/>

  <!-- Output as pretty‐printed HTML5 -->
  <xsl:output method="html" indent="yes" encoding="UTF-8"/>

  <!-- Normalize text outside of edition -->
  <xsl:template match="text()">
    <xsl:value-of select="normalize-space(.)"/>
  </xsl:template>

  <!-- Render words with trailing space -->
  <xsl:template match="tei:w">
    <xsl:apply-templates select="node()"/>
    <xsl:text> </xsl:text>
  </xsl:template>

  <!-- Text divisions -->
  <xsl:template match="tei:div[@type='textpart']">
    <xsl:text>&lt;D=.</xsl:text>
    <xsl:value-of select="@n"/>
    <xsl:text> </xsl:text>
    <xsl:apply-templates/>
    <xsl:text> =D&gt;</xsl:text>
  </xsl:template>

  <!-- Unclear letters -->
  <xsl:template match="tei:unclear">
    <xsl:for-each select="string-to-codepoints(string(.))">
      <xsl:value-of select="codepoints-to-string(.)"/>
      <xsl:text>̣</xsl:text>
    </xsl:for-each>
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

  <!-- Gaps -->
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

  <!-- Deletions -->
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

  <!-- Additions -->
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
  <!-- Names, places, dates, foreign -->
  <xsl:template match="tei:persName">
    <span class="persName"><xsl:apply-templates/></span>
  </xsl:template>
  <xsl:template match="tei:placeName">
    <span class="placeName"><xsl:apply-templates/></span>
  </xsl:template>
  <xsl:template match="tei:date">
    <span class="date">
      <xsl:if test="@when"><xsl:value-of select="@when"/> </xsl:if>
      <xsl:apply-templates/>
    </span>
  </xsl:template>
  <xsl:template match="tei:foreign">
    <span class="foreign"><xsl:apply-templates/></span>
  </xsl:template>

  <!-- Structural markers -->
  <xsl:template match="tei:seg">
    <span class="seg"><xsl:apply-templates/></span>
  </xsl:template>
  <xsl:template match="tei:pb">
    <span class="pb">¶</span>
  </xsl:template>
  <xsl:template match="tei:fw">
    <span class="fw"><xsl:apply-templates/></span>
  </xsl:template>
  <!-- Names and types -->
  <xsl:template match="tei:sic">
    <span class="sic"><xsl:apply-templates/></span>
  </xsl:template>
  <xsl:template match="tei:subst">
    <span class="subst"><xsl:apply-templates/></span>
  </xsl:template>

  <!-- References -->
  <xsl:template match="tei:ref">
    <a class="ref"><xsl:apply-templates/></a>
  </xsl:template>

  <!-- Suppress internals -->
  <xsl:template match="tei:encodingDesc|tei:revisionDesc"/>

  <!-- Root TEI to HTML -->
  <xsl:template match="/tei:TEI">
    <html lang="en">
      <head>
        <meta charset="UTF-8"/>
        <title>
          <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
        </title>
        <script src="https://cdn.tailwindcss.com"></script>
        <link
    href="https://fonts.googleapis.com/css2?family=Roboto:wght@300;400;500;700&amp;display=swap"
    rel="stylesheet"/>
      </head>
      <body class="prose lg:prose-xl mx-auto p-8">

        <!-- Document Header -->
<header class="mb-8">
  <!-- Title -->
  <h1 class="text-4xl font-extrabold mb-6">
    <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:title"/>
  </h1>

  <!-- Metadata box -->
  <div class="bg-white rounded-2xl shadow-md p-6 inline-block space-y-4">
    <dl class="grid grid-cols-1 sm:grid-cols-3 gap-x-8 gap-y-4">
      <!-- Publisher -->
      <div>
        <dt class="text-sm font-semibold text-gray-500">Publisher</dt>
        <dd class="mt-1 text-lg text-gray-900">
          <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:authority"/>
        </dd>
      </div>

      <!-- Published Date -->
      <div>
        <dt class="text-sm font-semibold text-gray-500">Published</dt>
        <dd class="mt-1 text-lg text-gray-900">
          <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:date"/>
        </dd>
      </div>

      <!-- Monument ID -->
      <div>
        <dt class="text-sm font-semibold text-gray-500">Monument ID</dt>
        <dd class="mt-1 text-lg text-gray-900">
          <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:publicationStmt/tei:idno[@type='filename']"/>
        </dd>
      </div>
    </dl>
  </div>
</header>

        <!-- Metadata -->
        <aside class="metadata bg-gray-50 rounded-lg p-6 shadow mb-12">
          <h2 class="text-2xl font-semibold mb-4">Metadata</h2>
          <dl class="grid grid-cols-1 md:grid-cols-2 gap-6">
            <div>
              <dt class="font-medium text-gray-700">Editor(s)</dt>
              <dd class="mt-1">
                <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:titleStmt/tei:editor/tei:persName"/>
              </dd>
            </div>
            <div>
              <dt class="font-medium text-gray-700">Type of monument</dt>
              <dd class="mt-1">
                <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:objectType"/>
              </dd>
            </div>
            <div>
              <dt class="font-medium text-gray-700">Material</dt>
              <dd class="mt-1">
                <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:material"/>
              </dd>
            </div>
            <div>
              <dt class="font-medium text-gray-700">Find place</dt>
              <dd class="mt-1">
                <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:provenance[@type='found']/tei:seg"/>
              </dd>
            </div>
            <div>
              <dt class="font-medium text-gray-700">Origin</dt>
              <dd class="mt-1">
                <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/tei:origPlace/tei:seg"/>
              </dd>
            </div>
            <div>
              <dt class="font-medium text-gray-700">Observed in</dt>
              <dd class="mt-1">
                <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:provenance[@type='observed']/tei:seg"/>
              </dd>
            </div>
            <div>
              <dt class="font-medium text-gray-700">Institution and inventory</dt>
              <dd class="mt-1">
                <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msIdentifier/tei:altIdentifier/tei:repository/tei:seg"/>
                <br/>
                <span>No <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msIdentifier/tei:altIdentifier/tei:idno"/></span>
              </dd>
            </div>
            <div>
              <dt class="font-medium text-gray-700">Dimensions</dt>
              <dd class="mt-1">
                height <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:dimensions/tei:height"/> cm,
                width <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:dimensions/tei:width"/> cm,
                depth <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:supportDesc/tei:support/tei:dimensions/tei:depth"/> cm
              </dd>
            </div>
            <div>
              <dt class="font-medium text-gray-700">Letter size</dt>
              <dd class="mt-1">
                <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:handDesc/tei:handNote/tei:height"/> cm
              </dd>
            </div>
            <div>
              <dt class="font-medium text-gray-700">Layout description</dt>
              <dd class="mt-1">
                <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:physDesc/tei:objectDesc/tei:layoutDesc/tei:layout"/>
              </dd>
            </div>
            <div>
              <dt class="font-medium text-gray-700">Decoration description</dt>
              <dd class="mt-1"><!-- none --></dd>
            </div>
            <div>
              <dt class="font-medium text-gray-700">Category of inscription</dt>
              <dd class="mt-1">
                <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:msContents/tei:summary/tei:seg"/>
              </dd>
            </div>
            <div>
              <dt class="font-medium text-gray-700">Date</dt>
              <dd class="mt-1">
                <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/tei:origDate/tei:seg"/>
              </dd>
            </div>
            <div>
              <dt class="font-medium text-gray-700">Dating criteria</dt>
              <dd class="mt-1">
                <xsl:value-of select="tei:teiHeader/tei:fileDesc/tei:sourceDesc/tei:msDesc/tei:history/tei:origin/tei:origDate/@evidence"/>
              </dd>
            </div>
            <div>
              <dt class="font-medium text-gray-700">Images</dt>
              <dd class="mt-1"><!-- thumbnails below --></dd>
            </div>
          </dl>
        </aside>

        <!-- Facsimiles -->
        <section class="facsimiles mb-12">
          <h2 class="text-2xl font-semibold mb-4">Facsimiles</h2>
          <div class="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 gap-4">
            <xsl:for-each select="tei:facsimile/tei:graphic">
              <a href="{@url}" target="_blank" class="block overflow-hidden rounded shadow hover:scale-105 transition-transform">
                <img src="{@url}" alt="Facsimile thumbnail" class="w-full h-32 object-cover"/>
              </a>
            </xsl:for-each>
          </div>
        </section>

        <!-- Main content -->
        <main>
          <xsl:apply-templates select="tei:text/tei:body/tei:div[not(@type='bibliography')]"/>
        </main>

        <!-- Bibliography -->
        <footer class="mt-12">
          <h2 class="text-2xl font-semibold mb-4">Bibliography</h2>
          <ul class="list-disc list-inside space-y-2">
            <xsl:for-each select="tei:text/tei:body/tei:div[@type='bibliography']/tei:listBibl/tei:bibl">
              <li><xsl:value-of select="."/></li>
            </xsl:for-each>
          </ul>
        </footer>

      </body>
    </html>
  </xsl:template>

  <!-- Edition: preserve spacing, hyphens & newlines -->
  <xsl:template match="tei:div[@type='edition']">
    <section class="mb-12">
      <h2 class="text-2xl font-semibold mb-4">Edition</h2>
      <pre class="whitespace-pre-line leading-relaxed mb-4" xml:space="preserve">
<xsl:apply-templates select="tei:ab/node()[not(self::tei:lb and position()=1)]"/>
      </pre>
    </section>
  </xsl:template>
  <!-- Line breaks within edition -->
  <xsl:template match="tei:lb">
    <xsl:if test="@break='no'">-</xsl:if>
    <xsl:text>&#10;</xsl:text>
  </xsl:template>

  <!-- Apparatus -->
  <xsl:template match="tei:div[@type='apparatus']">
    <section class="mb-12">
      <h2 class="text-2xl font-semibold mb-4">Apparatus</h2>
      <ul class="list-disc list-inside ml-4 space-y-1">
        <xsl:for-each select="tei:listApp/tei:app/tei:note">
          <li><xsl:value-of select="."/></li>
        </xsl:for-each>
      </ul>
    </section>
  </xsl:template>

  <!-- Translation -->
  <xsl:template match="tei:div[@type='translation']">
    <section class="mb-12">
      <h2 class="text-2xl font-semibold mb-4">Translation</h2>
      <xsl:for-each select="tei:p/tei:seg">
        <p class="mb-2"><xsl:value-of select="."/></p>
      </xsl:for-each>
    </section>
  </xsl:template>

  <!-- Commentary -->
  <xsl:template match="tei:div[@type='commentary']">
    <section class="mb-12">
      <h2 class="text-2xl font-semibold mb-4">Commentary</h2>
      <xsl:for-each select="tei:p/tei:seg">
        <p class="mb-2"><xsl:value-of select="."/></p>
      </xsl:for-each>
    </section>
  </xsl:template>

</xsl:stylesheet>
