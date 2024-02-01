<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet 
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:tei="http://www.tei-c.org/ns/1.0"
    xmlns:xs="http://www.w3.org/2001/XMLSchema"
    xmlns:local="http://dse-static.foo.bar"
    version="2.0" exclude-result-prefixes="#all">
    
    <xsl:output encoding="UTF-8" media-type="text/html" method="html" version="5.0" indent="yes" omit-xml-declaration="yes"/>
    
    
    <xsl:import href="./partials/shared.xsl"/>
    <xsl:import href="./partials/html_navbar.xsl"/>
    <xsl:import href="./partials/html_head.xsl"/>
    <xsl:import href="./partials/html_footer.xsl"/>
    <xsl:import href="./partials/aot-options.xsl"/>

    <xsl:variable name="prev">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@prev), '/')[last()], '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="next">
        <xsl:value-of select="replace(tokenize(data(tei:TEI/@next), '/')[last()], '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="teiSource">
        <xsl:value-of select="data(tei:TEI/@xml:id)"/>
    </xsl:variable>
    <xsl:variable name="link">
        <xsl:value-of select="replace($teiSource, '.xml', '.html')"/>
    </xsl:variable>
    <xsl:variable name="doc_title">
        <xsl:value-of select=".//tei:titleStmt/tei:title[1]/text()"/>
    </xsl:variable>


    <xsl:template match="/">

    
        <html>
    
            <head>
                <xsl:call-template name="html_head">
                    <xsl:with-param name="html_title" select="$doc_title"></xsl:with-param>
                </xsl:call-template>
            </head>
            <body class="d-flex flex-column">
                <xsl:call-template name="nav_bar"/>
                <main class="flex-shrink-0">
                    <div class="container" style="max-width: 100%;">
                        <div id="editor-widget">
                            <xsl:call-template name="annotation-options"></xsl:call-template>
                        </div>
                        <div class="page-content">
                            <!--<xsl:apply-templates select=".//tei:body"/>-->
                            <div class="row">
                                <div class="col-md-6 section px-4">
                                    <div class="title-page py-4">
                                        <xsl:apply-templates select=".//tei:front"/>
                                    </div>
                                    <xsl:for-each-group select=".//tei:body" group-starting-with="tei:pb">
                                        <xsl:for-each select="current-group()">
                                            <div class="grid">
                                                <div class="grid-sizer"></div>
                                                <xsl:apply-templates/>
                                            </div>
                                        </xsl:for-each>
                                    </xsl:for-each-group>
                                </div>
                                <div class="col-md-6 facsimiles">
                                    <div id="viewer-1" class="sticky">
                                        <!--<div id="spinner_1" class="text-center">
                                            <div class="loader"></div>
                                        </div>-->
                                        <div id="container_facs_1" style="padding:.5em;margin-top:2em;">
                                            <!-- image container accessed by OSD script -->                               
                                        </div>  
                                    </div>
                                </div>
                            </div>
                            <p id="{local:makeId(.)}" style="text-align:center;">
                                <xsl:for-each select=".//tei:note[not(./tei:p)]">
                                    <div class="footnotes" id="{local:makeId(.)}">
                                        <xsl:element name="a">
                                            <xsl:attribute name="name">
                                                <xsl:text>fn</xsl:text>
                                                <xsl:number level="any" format="1" count="tei:note"/>
                                            </xsl:attribute>
                                            <a>
                                                <xsl:attribute name="href">
                                                    <xsl:text>#fna_</xsl:text>
                                                    <xsl:number level="any" format="1" count="tei:note"/>
                                                </xsl:attribute>
                                                <span style="font-size:7pt;vertical-align:super; margin-right: 0.4em">
                                                    <xsl:number level="any" format="1" count="tei:note"/>
                                                </span>
                                            </a>
                                        </xsl:element>
                                        <xsl:apply-templates/>
                                    </div>
                                </xsl:for-each>
                            </p>
                        </div>
                    </div>
                    <xsl:for-each select="//tei:back">
                        <div class="tei-back">
                            <xsl:apply-templates/>
                        </div>
                    </xsl:for-each>
                </main>
                <xsl:call-template name="html_footer"/>
                <script src="https://unpkg.com/de-micro-editor@0.3.1/dist/de-editor.min.js"></script>
                <script src="https://cdnjs.cloudflare.com/ajax/libs/openseadragon/4.0.0/openseadragon.min.js"></script>
                <script type="text/javascript" src="js/run.js"></script>
                <script type="text/javascript" src="js/osd_scroll.js"></script>
                <script type="text/javascript" src="js/masonry.js"></script>
                
            </body>
        </html>
    </xsl:template>
    
    <xsl:template match="//text()[parent::tei:p[ancestor::tei:body]]|
                        //text()[parent::tei:ab[ancestor::tei:body]]|
                        //text()[parent::tei:head[ancestor::tei:body]]">
        <xsl:choose>
            <xsl:when test="following-sibling::tei:*[1]/@break='no'">
                <xsl:value-of select="replace(., '\s+$', '')"/>
            </xsl:when>
            <xsl:when test="matches(., '=$', 'm')">
                <xsl:value-of select="replace(., '\s+$', '')"/>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="."/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:titlePart">
        <xsl:choose>
            <xsl:when test="@type='count-date-normalized' or @type='num'">
                <h5 id="{local:makeId(.)}" class="yes-index text-center py-2"><xsl:apply-templates/></h5>
            </xsl:when>
            <xsl:when test="@type='main-title' or @type='main'">
                <h4 id="{local:makeId(.)}" class="yes-index text-center py-2"><xsl:apply-templates/></h4>
            </xsl:when>
            <xsl:when test="@type='imprint'">
                <p id="{local:makeId(.)}" class="yes-index italic text-center py-2"><xsl:apply-templates/></p>
            </xsl:when>
        </xsl:choose>
    </xsl:template>
    
    <xsl:template match="tei:imprimatur">
        <p id="{local:makeId(.)}" class="grid-item yes-index"><xsl:apply-templates/></p>
    </xsl:template>
    
    <xsl:template match="tei:head">
        
        
    </xsl:template>
    
    <xsl:template match="tei:lb">
        <xsl:if test="@break">
            <span class="linebreak"><xsl:text>=</xsl:text></span>
        </xsl:if>
        <br class="linebreak"/>
    </xsl:template>
    
    <xsl:template match="tei:w">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:pc">
        <xsl:apply-templates/>
    </xsl:template>
    
    <xsl:template match="tei:ab">
        
        <xsl:choose>
            <xsl:when test="@type='list'">
                <div id="{local:makeId(.)}" class="grid-item">
                <ul>
                    <xsl:for-each-group select="node()" group-starting-with="tei:lb">
                        <xsl:if test="position() > 1">
                        <li class="yes-index"
                            data-zone="{current-group()/self::tei:lb/@facs}"
                            data-num="{current-group()/self::tei:lb/@n}">
                            <xsl:value-of select="current-group()/self::text()"/>
                        </li>
                        </xsl:if>
                    </xsl:for-each-group>
                </ul>
                </div>
            </xsl:when>
            <xsl:when test="@type='catch-word'">
                <div id="{local:makeId(.)}" class="grid-item grid-item--width2 text-end">
                <span id="{local:makeId(.)}" class="yes-index catch-word">
                    <xsl:apply-templates/>
                </span>
                </div>
            </xsl:when>
            <xsl:when test="@type='imprint' and not(contains(@facs, 'facs_1_'))">
                <div id="{local:makeId(.)}" class="grid-item">
                <span id="{local:makeId(.)}" class="italic yes-index catch-word">
                    <xsl:apply-templates/>
                </span>
                </div>
            </xsl:when>
            <xsl:when test="@type='count-date' and not(contains(@facs, 'facs_1_'))">
                <div id="{local:makeId(.)}" class="grid-item">
                <h4 id="{local:makeId(.)}" class="yes-index count-date">
                    <xsl:apply-templates/>
                </h4>
                </div>
            </xsl:when>
            <xsl:otherwise>
                <div id="{local:makeId(.)}" class="grid-item">
                <span id="{local:makeId(.)}" class="yes-index">
                    <xsl:apply-templates/>
                </span>
                </div>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="tei:p">
        <div class="grid-item">
            <xsl:if test="preceding-sibling::*[1]/name() = 'head'">
                <xsl:for-each select="preceding-sibling::*[1]">
                    <h5 id="{local:makeId(.)}" class="yes-index text-center">
                    <xsl:apply-templates/>
                    </h5>
                </xsl:for-each>
            </xsl:if>
            <p id="{local:makeId(.)}" class="yes-index">
                <xsl:apply-templates/>
                <!--<xsl:if test="following-sibling::tei:p[@prev]">
                    <xsl:if test="following-sibling::*[1]/name() = 'pb'">
                        <xsl:for-each select="following-sibling::*[1]">
                            <span class="anchor-pb"></span>
                            <span class="pb lightgrey" source="{@facs}">[<xsl:value-of select="./@n"/>]</span>
                        </xsl:for-each>
                    </xsl:if>
                    <xsl:for-each select="following-sibling::tei:p[@prev]">
                        <xsl:apply-templates/>
                    </xsl:for-each>
                </xsl:if>-->
            </p>
        </div>
    </xsl:template>
    
    <!--<xsl:template match="tei:p[@prev]"/>-->
    
    <!--<xsl:template match="tei:pb[following-sibling::tei:p[@prev]]"/>-->
    
<!--    <xsl:template match="tei:div">
        <!-\-<div id="{local:makeId(.)}">
            <xsl:apply-templates/>
        </div>-\->
        <xsl:apply-templates/>
    </xsl:template>  -->
</xsl:stylesheet>
