<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0"
                xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xmlns:book="http://cocoaneheads.github.io/iPhone/book.xsd">
  <xsl:output method="html" doctype-public="-//W3C//DTD XHTML 1.0 Strict//EN" media-type="application/html+xml" encoding="UTF-8" indent="yes"/>
  <xsl:template match="/book:book">
    <html>
    <head>
      <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
      <meta http-equiv="X-UA-Compatible" content="chrome=1" />
      <title><xsl:value-of select="book:title" /> (<xsl:value-of select="@issue"/>. Ausgabe)</title>

      <link rel="stylesheet" href="stylesheets/styles.css" />
      <link rel="stylesheet" href="stylesheets/pygment_trac.css" />
      <meta name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" />
    </head>
      <body>
        <div class="wrapper">
          <header>
            <h1><xsl:value-of select="book:title" /></h1>
            <p><xsl:value-of select="@issue"/>. Ausgabe (<xsl:value-of select="@year"/>)<br />
            Erschienen bei <a href="http://www.galileocomputing.de" target="_blank">Galileo Computing</a></p>
            <p>
              <xsl:choose>
                <xsl:when test="book:openbook">
                  <xsl:element name="a">
                    <xsl:attribute name="href"><xsl:value-of select="book:openbook"/></xsl:attribute>
                    <xsl:attribute name="target">_blank</xsl:attribute>
                    Auch als &lt;openbook&gt; verfügbar
                  </xsl:element>
                </xsl:when>
                <xsl:otherwise>
                  Kein &lt;openbook&gt; verfügbar
                </xsl:otherwise>
              </xsl:choose>
            </p>
            <p class="view">
              <a href="https://github.com/Cocoaneheads/iPhone">Projektseite auf GitHub<small>Cocoaneheads/iPhone</small></a>
            </p>

            <h2>Der Code zur <xsl:value-of select="@issue"/>. Ausgabe</h2>
            <ul>
              <xsl:call-template name="github-links">
                <xsl:with-param name="branch" select="book:branch"/>
              </xsl:call-template>
            </ul>
          </header>
          <section>
            <p><xsl:element name="img">
              <xsl:attribute name="src">cover<xsl:value-of select="@issue"/>.jpg</xsl:attribute>
              <xsl:attribute name="alt">Cover</xsl:attribute>
            </xsl:element></p>

            <hr />
            <h3>Fehler im Buch</h3>
            <p>Trotz sorgfältiger Prüfung haben sich einige Fehler eingeschlichen,
              die wir auf dieser Seite zusammengetragen haben. Bei Problemen mit den Listings empfiehlt
              sich auch immer ein Blick in den Sourcecode im Git.</p>

            <xsl:choose>
              <xsl:when test="book:errors">
                <xsl:apply-templates select="book:errors/book:error" />
              </xsl:when>
              <xsl:otherwise><p><em>In Arbeit</em></p></xsl:otherwise>
            </xsl:choose>

            <h3>Kontakt &amp; Impressum</h3>
            <p>Autoren: Clemens Wagner, Klaus Rodewig: <a href="mailto:dingdong@cocoaneheads.de">dingdong@cocoaneheads.de</a></p>

            <p><a href="http://www.galileocomputing.de/hilfe/Impressum">Impressum Verlag</a></p>
          </section>
          <footer>
            <p>This project is maintained by <a href="https://github.com/Cocoaneheads">Cocoaneheads</a></p>
            <p><small>Hosted on GitHub Pages - Theme by <a href="https://github.com/orderedlist">orderedlist</a></small></p>
          </footer>
        </div>
        <script src="javascripts/scale.fix.js"></script>
      </body>
    </html>
  </xsl:template>
  <xsl:template match="book:error">
    <h4>Seite <xsl:value-of select="@pages"/></h4>
    <p><xsl:apply-templates select="book:text" />
      <xsl:if test="book:credits"><em>Danke, <xsl:value-of select="book:credits"/></em></xsl:if>
    </p>
  </xsl:template>
  <xsl:template match="book:text">
    <xsl:copy-of select="."/>
  </xsl:template>
  <xsl:template name="github-links">
    <xsl:param name="branch" />
    <xsl:element name="li">
      <xsl:element name="a">
        <xsl:attribute name="href">https://github.com/Cocoaneheads/iPhone/archive/<xsl:value-of select="$branch"/>.zip</xsl:attribute>
        Download <strong>ZIP File</strong>
      </xsl:element>
    </xsl:element>
    <xsl:element name="li">
      <xsl:element name="a">
        <xsl:attribute name="href">https://github.com/Cocoaneheads/iPhone/archive/<xsl:value-of select="$branch"/>.tar.gz</xsl:attribute>
        Download <strong>TAR Ball</strong>
      </xsl:element>
    </xsl:element>
    <xsl:element name="li">
      <xsl:element name="a">
        <xsl:attribute name="href">https://github.com/Cocoaneheads/iPhone/tree/<xsl:value-of select="$branch"/></xsl:attribute>
        <xsl:attribute name="target">_blank</xsl:attribute>
        View On <strong>GitHub</strong>
      </xsl:element>
    </xsl:element>
  </xsl:template>
</xsl:stylesheet>