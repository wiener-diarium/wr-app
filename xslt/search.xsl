<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="xhtml" version="1.0" indent="yes" omit-xml-declaration="yes"/>
    
    
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Wie[n]nerisches Diarium'"/>
        <html  class="h-100">
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
            </head>
            
            <body class="d-flex flex-column h-100">
                <xsl:call-template name="nav_bar"/>
                <div class="container">
                    
                    <div class="text-center">
                        <h1>
                            Suchportal <xsl:value-of select="$doc_title"/>
                        </h1>
                        <h2>Volltext meets Gestrich Index</h2>
                        <p>hier ist ein Platz für eine kurze Beschreibung</p>
                        <p><a href="https://github.com/wiener-diarium/wr-app"><i class="bi bi-github"></i></a></p>
                    </div>

                    <div class="row">
                        <div class="col-md-3">
                            <div id="stats-container"></div>
                            <h2 class="pt-2">Volltextsuche</h2>
                            <div id="searchbox"></div>
                            <div id="current-refinements"></div>
                            <div id="clear-refinements"></div>
                            <h3 class="pt-2">Volltext vorhanden</h3>
                            <div id="has-fulltext"></div>
                            <h3 class="pt-2">Ausgabe im Digitarium</h3>
                            <div id="digitarium-issue"></div>
                            <h3 class="pt-2">Verschlagworted</h3>
                            <div id="gestrich"></div>
                            <h3 class="pt-2">Orte</h3>
                            <div id="refinement-list-places"></div>
                            <h3 class="pt-2">Schlagworte</h3>
                            <div id="refinement-list-keywords"></div>
                            <h3 class="pt-2">Enstehungsjahr</h3>
                            <div id="refinement-range-year"></div>
                            <h3 class="pt-2">Artikel pro Seite</h3>
                            <div id="refinement-article_count"></div>
                            <h3 class="pt-2">Sortierung</h3>
                            <div id="sort-by"></div>
                        </div>
                        <div class="col">
                            <div id="hits"></div>
                            <div id="pagination"></div>
                        </div>
                    </div>
                </div>
                <xsl:call-template name="html_footer"/>
                <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/instantsearch.css@7/themes/algolia-min.css" />
                <script src="https://cdn.jsdelivr.net/npm/instantsearch.js@4.46.0"></script>
                <script
                    src="https://cdn.jsdelivr.net/npm/typesense-instantsearch-adapter@2/dist/typesense-instantsearch-adapter.min.js"></script>
                <script src="js/search.js"></script>       
            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>