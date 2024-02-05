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
                <main>
                    <div class="container mw-100">
                        
                        <div class="grid-overview-header m-2">
                            <div class="form-group my-2 w-25">
                                <label for="grid-select-year">Jahr auswählen</label>
                                <select class="form-control" id="grid-select-year">
                                    <option value="*" selected="selected">Alle Jahre anzeigen</option>
                                    <xsl:for-each-group select="$files-legacy//tei:TEI" group-by="tokenize(replace(@xml:id, 'edoc_wd_', ''), '-')[1]">
                                        <xsl:sort select="current-grouping-key()"/>
                                        <option value=".d-{current-grouping-key()}"><xsl:value-of select="current-grouping-key()"/></option>
                                    </xsl:for-each-group>
                                </select>
                            </div>
                            <div class="btn-group button-group filter-button-group my-2" id="filter-button-group1">
                                <button type="button" class="button btn btn-outline-dark" data-filter="*">alles anzeigen</button>
                                <button type="button" class="button btn btn-outline-dark" data-filter=".legacy">legacy</button>
                                <button type="button" class="button btn btn-outline-dark" data-filter=".present">present</button>
                                <button type="button" class="button btn btn-outline-dark corr3" data-filter=".corr3">Automatisch erstellter Text, mehrmals korrigiert</button>
                                <button type="button" class="button btn btn-outline-dark corr2" data-filter=".corr2">Automatisch erstellter Text, zweimal korrigiert</button>
                                <button type="button" class="button btn btn-outline-dark corr1" data-filter=".corr1">Automatisch erstellter Text, einmal korrigiert</button>
                                <button type="button" class="button btn btn-outline-dark corr0" data-filter=".corr0">Automatisch erstellter Text, unkorrigiert</button>
                                <hr></hr>
                                <button type="button" class="button btn btn-outline-dark" data-filter="decate1">1700-1709</button>
                                <button type="button" class="button btn btn-outline-dark" data-filter="decate2">1710-1719</button>
                                <button type="button" class="button btn btn-outline-dark" data-filter="decate3">1720-1729</button>
                                <button type="button" class="button btn btn-outline-dark" data-filter="decate4">1730-1739</button>
                                <button type="button" class="button btn btn-outline-dark" data-filter="decate5">1740-1749</button>
                                <button type="button" class="button btn btn-outline-dark" data-filter="decate6">1750-1759</button>
                                <button type="button" class="button btn btn-outline-dark" data-filter="decate7">1760-1769</button>
                                <button type="button" class="button btn btn-outline-dark" data-filter="decate8">1770-1779</button>
                                <button type="button" class="button btn btn-outline-dark" data-filter="decate9">1780-1789</button>
                                <button type="button" class="button btn btn-outline-dark" data-filter="decate10">1790-1799</button>
                            </div>
                        </div>
                        <div class="grid-overview text-center m-2">
                            <div class="grid-overview-sizer"></div>
                            <xsl:for-each select="$files-present//tei:TEI">
                                <xsl:variable name="title" select=".//tei:titleStmt/tei:title[@level='a']"/>
                                <xsl:if test="position() lt 1000">
                                <xsl:variable name="doc-id" select="replace(@xml:id, '.xml', '')"/>
                                <xsl:variable name="date" select="replace($doc-id, 'wr_', '')"/>
                                <div class="grid-overview-item present my-2 p-2 border border-1 rounded d-{tokenize($date, '-')[1]} corr0"
                                    data-category="present"
                                    data-date="{$date}">
                                    <a href="{$doc-id}.html" aria-label="Link zu Dokument {$title}">
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
                                    </a>
                                </div>
                                </xsl:if>
                            </xsl:for-each>
                            <xsl:for-each select="$files-legacy//tei:TEI">
                                <xsl:variable name="title" select=".//tei:titleStmt/tei:title[@type='num']"/>
                                <xsl:if test="position() lt 1000">
                                    <xsl:variable name="doc-id" select="replace(@xml:id, '.xml', '')"/>
                                    <xsl:variable name="date" select="replace($doc-id, 'edoc_wd_', '')"/>
                                    <xsl:variable name="correction" select="count(.//tei:revisionDesc/tei:list/tei:item)"/>
                                    <xsl:variable name="color" select="
                                        if($correction = 3) then('corr3')
                                        else if ($correction = 2) then('corr2')
                                        else if ($correction = 1) then('corr1')
                                        else ('corr0')"/>
                                    <div class="grid-overview-item legacy my-2 p-2 border border-1 rounded d-{tokenize($date, '-')[1]} {$color}"
                                        data-category="legacy"
                                        data-date="{$date}">
                                        <a href="{$date}.html" aria-label="Link zu Dokument {$title}">
                                            <div class="grid-overview-item-header p-1 font-weight-bold">
                                                <xsl:value-of select="$title"/>
                                            </div>
                                            <div class="grid-overview-item-content p-1">
                                                <xsl:variable name="img-url" select="'https://diarium-images.acdh-dev.oeaw.ac.at/'"/>
                                                <xsl:variable name="img-fn" select="substring-after(.//tei:facsimile[1]/tei:surface[1]/tei:graphic/@url, 'anno:')"/>
                                                <xsl:variable name="img-1" select="replace(replace(tokenize($img-fn, '_')[last()], '.jpg', ''), '.png', '')"/>
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
                                        </a>
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