<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="#all">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    

    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="partials/tabulator_dl_buttons.xsl"/>
    <xsl:import href="partials/tabulator_js.xsl"/>

    <xsl:template match="/">
        <xsl:variable name="doc_title">
            <xsl:value-of select='$project_title'/>
        </xsl:variable>

    
        <html>
    
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
            </head>            
            <body class="d-flex flex-column">
                <xsl:call-template name="nav_bar"/>
                <xsl:variable name="files-present" select="collection('../data/editions/present/?select=*.xml')"/>
                <xsl:variable name="files-legacy" select="collection('../data/editions/legacy/?select=*.xml')"/>
                <xsl:variable name="years" select="distinct-values($files-legacy//tei:TEI/@xml:id)"/>
                <main>
                    <div class="container mw-100">
                        
                        <div class="grid-overview-header">
                            <div class="input-group mb-3">
                                <select class="custom-select" id="grid-select-year">
                                    <option value="*" selected="selected">Jahr auswählen</option>
                                    <xsl:for-each select="$years">
                                        <xsl:sort select="tokenize(replace(., 'edoc_wd_', ''), '-')[1]"/>
                                        <xsl:variable name="year" select="tokenize(replace(., 'edoc_wd_', ''), '-')[1]"/>
                                        <option value=".d-{$year}"><xsl:value-of select="$year"/></option>
                                    </xsl:for-each>
                                </select>
                            </div>
                            <!--<div class="button-group filter-button-group">
                                
                                <button data-filter="*">alles anzeigen</button>
                                <button data-filter=".metal">metal</button>
                                <button data-filter=".transition">transition</button>
                                <button data-filter=".alkali, .alkaline-earth">alkali alkaline-earth</button>
                                <button data-filter=":not(.transition)">not transition</button>
                                <button data-filter=".metal:not(.transition)">metal but not transition</button>
                            </div>-->
                        </div>
                        <div class="grid-overview m-4 text-center">
                            <div class="grid-overview-sizer"></div>
                            <xsl:for-each select="$files-present//tei:TEI">
                                <xsl:variable name="title" select=".//tei:titleStmt/tei:title[@level='a']"/>
                                <xsl:if test="position() lt 1000">
                                <xsl:variable name="doc-id" select="replace(@xml:id, '.xml', '')"/>
                                <xsl:variable name="date" select="tokenize($doc-id, '_')[last()]"/>
                                <div class="grid-overview-item m-2 p-2 border border-1 rounded d-{tokenize($date, '-')[1]}"
                                    data-category="present"
                                    data-date="{$date}">
                                    <div class="grid-overview-item-header p-1 font-weight-bold">
                                        <xsl:value-of select="$title"/>
                                    </div>
                                    <div class="grid-overview-item-content p-1">
                                        <xsl:variable name="img" select=".//tei:surface[1]/tei:graphic[starts-with(@url, 'http')]/@url"/>
                                        <img src="{$img}" aria-label="Titelblatt von: {$title}"></img>
                                    </div>
                                    <div class="grid-overview-item-footer p-1">
                                        <span class="badge-item">
                                            <xsl:value-of select="count(.//tei:body/tei:div)"/>
                                        </span>
                                    </div>
                                </div>
                                </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="$files-legacy//tei:TEI">
                                <xsl:variable name="title" select=".//tei:titleStmt/tei:title[@type='num']"/>
                                <xsl:if test="position() lt 1000">
                                    <!--<xsl:variable name="doc-id" select="replace(@xml:id, '.xml', '')"/>-->
                                    <xsl:variable name="date" select="replace(replace(@xml:id, '.xml', ''), 'edoc_wd_', '')"/>
                                    <div class="grid-overview-item m-2 p-2 border border-1 rounded d-{tokenize($date, '-')[1]}"
                                        data-category="legacy"
                                        data-date="{$date}">
                                        <div class="grid-overview-item-header p-1 font-weight-bold">
                                            <xsl:value-of select="$title"/>
                                        </div>
                                        <div class="grid-overview-item-content p-1">
                                            <xsl:variable name="img-url" select="'https://diarium-images.acdh-dev.oeaw.ac.at/'"/>
                                            <xsl:variable name="img-fn" select="replace(.//tei:surface[1]/tei:graphic[1]/@url, 'anno:', '')"/>
                                            <xsl:variable name="img-1" select="replace(tokenize($img-fn, '_')[last()], '.png', '')"/>
                                            <xsl:variable name="img-dir1" select="tokenize($img-1, '-')[1]"/>
                                            <xsl:variable name="img-dir-year" select="tokenize($date, '-')[1]"/>
                                            <xsl:variable name="img-dir-month" select="tokenize($date, '-')[2]"/>
                                            <xsl:variable name="img-dir-day" select="tokenize($date, '-')[3]"/>
                                            <xsl:variable name="img-dir-yearx" select="concat(substring($img-dir-year, 1, 3), 'x')"/>
                                            <xsl:variable name="img" select="concat($img-url, $img-dir-yearx, '/', $img-dir-year, '/', $img-dir-month, '/', $img-dir1, '/', $img-1, '/full/200,/0/default.jpg')"/>
                                            <img src="{$img}" aria-label="Titelblatt von: {$title}"></img>
                                        </div>
                                        <div class="grid-overview-item-footer p-1">
                                            <span class="badge-item">
                                                <xsl:value-of select="count(.//tei:body/tei:div)"/>
                                            </span>
                                        </div>
                                    </div>
                                </xsl:if>
                            </xsl:for-each>
                        </div>

                    </div>
                </main>
                <xsl:call-template name="html_footer"/>
                <script src="https://npmcdn.com/isotope-layout@3/dist/isotope.pkgd.js"></script>
                <script src="https://npmcdn.com/imagesloaded@4/imagesloaded.pkgd.js"></script>
                <script src="js/isotope-app-overview.js"></script>
            </body>
        </html>
    </xsl:template>

</xsl:stylesheet>