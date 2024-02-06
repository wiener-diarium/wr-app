<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0" xmlns:xs="http://www.w3.org/2001/XMLSchema"
    version="2.0" exclude-result-prefixes="xsl tei xs">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    
    
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="partials/html_footer.xsl"/>
    <xsl:template match="/">
        <xsl:variable name="doc_title" select="'Wienerisches Diarium'"/>
        <html>
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
            </head>
            
            <body class="d-flex flex-column">
                <xsl:call-template name="nav_bar"/>
                <div class="container mw-100">
                    <div class="row m-2">
                        <div class="col-md-12 bg-diarium-menu py-4">
                            <div class="row px-5">
                                <div class="col-md-12 px-4 text-center justify-content-center">
                                    <div id="stats-container"></div>
                                    <h4 class="pt-2">Volltextsuche</h4>
                                    <div id="searchbox" class="w-50" style="margin: 0 auto;"></div>
                                    <div id="current-refinements"></div>
                                    <div id="clear-refinements"></div>
                                </div>
                                <div class="col-md-6 p-4 d-flex justify-content-end">
                                    <h5 class="px-2">Enstehungsjahr</h5>
                                    <div id="refinement-range-year"></div>
                                </div>
                                <div class="col-md-6 p-4 d-flex justify-content-start">
                                    <h5 class="px-2">Artikel pro Seite</h5>
                                    <div id="refinement-article_count"></div>
                                </div>
                            </div>
                        </div>
                        <div class="col-md-2 py-2 bg-diarium-search">
                            <h5 class="pt-2">Edition wählen</h5>
                            <div id="menu-edition"></div>
                            <div class="py-2"></div>
                            <h5 class="pt-2">Volltext vorhanden</h5>
                            <div id="has-fulltext"></div>
                            <h5 class="pt-2">Korrekturstatus</h5>
                            <div id="corrections"></div>
                            <h5 class="pt-2">Ausgabe im Digitarium</h5>
                            <div id="digitarium-issue"></div>
                            <h5 class="pt-2">Verschlagworted</h5>
                            <div id="gestrich"></div>
                            <h5 class="pt-2">Orte</h5>
                            <div id="refinement-list-places"></div>
                            <h5 class="pt-2">Schlagworte</h5>
                            <div id="refinement-list-keywords"></div>
                        </div>
                        <div class="col-md-10">
                            <h5 class="pt-2">Sortierung</h5>
                            <div id="sort-by"></div>
                            <div id="pagination0"></div>
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